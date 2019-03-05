(function(){
	//夜间模式cookid key
	var NIGHT_COOKIE_KEY = "night-mode";
	var NIGHT_COOKIE_VAL = "night";
	// 模板
	String.prototype.temp = function(obj) {
		return this.replace(/\[\w+\]?/g, function(match) {
			var ret = obj[match.replace(/\[|\]/g, "")];
			return (ret + "") == "undefined" ? "" : ret;
		})
	};
	
	$(document).ready(function(){
		toggleDarkMode(!!isDarkMode());
	})
	var host = "http://"+location.host +"/blog/"+serverId+"/images/";
	var url = host +"my_wxapp_code.jpg";
	var dayIcon = {
			url:'http://www.ajie18.top/images/fresh.jpg',
			text: "白天模式",
			css: {},
			callback:function(panel){
				toggleDarkMode(false);
				panel.setIcon(darkIcon , 3);
				panel.hidePanel();
			}
		}
	var darkIcon = {
			url:'http://www.ajie18.top/images/dark.jpg',
			text: "夜间模式",
			css: {},
			callback:function(panel){
				toggleDarkMode(true);
				panel.setIcon(dayIcon , 3);
			}
		}
	var icon = isDarkMode() ? dayIcon  : darkIcon;
	//悬浮菜单
	var icons = [{
		url:'http://www.ajie18.top/images/fresh.jpg',
		text: "刷新",
		css: {},
		tapHide: true,
		callback:function(){
			var panel = arguments[0];
			location.reload();
		}
	},{
		url:'http://www.ajie18.top/images/gotoTop.jpg',
		text: "顶部",
		css: {},
		callback:function(panel) {
			$('html,body').animate({scrollTop:0},'fast');
		}
	},{
		url:'http://www.ajie18.top/images/logging.jpg',
		text: "日志",
		css: {},
		callback:function(){
			alert("日志");
		}
	},icon
	,{
		url:'http://www.ajie18.top/images/manager.jpg',
		text: "后台",
		css: {},
		callback:function(panel){
			location.href = "manager.do";
		}
	},{
		url:'http://www.ajie18.top/images/wxapp.jpg',
		text: "小程序",
		css: {},
		callback:function(panel){
			//全屏查看图片
			wx.previewImage({
				current: url, // 当前显示图片的http链接
				urls: url // 需要预览的图片http链接列表
			});
		}
	},]
	var options = {
		tapHide: false,
		icons: icons
	}
	$.createSuspendBtn(options);
	
	//true切换夜间，false切换白天
	function toggleDarkMode(bool){
		var toggle = typeof bool === 'boolean' ? bool : false;
		//随便找一个节点看看是不是夜间模式
		var isDark = $("#iSlider").hasClass("darkModeActive");
		if(isDark == toggle){
			return;
		}
		toggle ? $(".darkMode").addClass("darkModeActive") :$(".darkMode").removeClass("darkModeActive");
		//保存设置
		if(toggle){
			//开启
			$.Cookie.set(NIGHT_COOKIE_KEY,NIGHT_COOKIE_VAL);
		}else{ //关闭
			//删除cookie
			$.Cookie.remove(NIGHT_COOKIE_KEY);
		}
	}
	
	/**
	 * 检查是否为夜间模式
	 * 
	 * @returns {Boolean}
	 */
	function isDarkMode(){
		var nightMode = $.Cookie.get(NIGHT_COOKIE_KEY);
		if($.isEmptyObject(nightMode)){
			return false;
		}
		return !!nightMode;
	}
	
	var tempstr = $("#iBlogTemp").html();
	var cacheTags = null;
	loadblogs();
	function loadblogs(){
		var loading = $.showloading("加载中")
		$.ajax({
			type: 'post',
			data:{},
			url: 'loadblogs.do',
			success: function(data){
				if(data.code == 200){
					var blogs = data.data ||[];
					var sb = [];
					for(let i=0;i<blogs.length;i++){
						var blog = blogs[i];
						var labelsStr = blog.labels;
						if(labelsStr){
							var labels = labelsStr.split(",");
							//标签处理一下
							var lab = [];
							for(let i=0;i<labels.length;i++){
								lab.push("<span class='label'>"+labels[i]+"</span>");
							}
							blog["labels"] = lab.join("");
						}
						sb.push(tempstr.temp(blog));
						
					}
					$("#iBlogs").html(sb.join(""));
				}
				loading.hide();
				loadtags();
			},
			fail: function(e){
				$.showToast(e)
			},
			complete: function(){
				//在文档加载时已经判断了是不是夜间模式，但是异步加载的节点比较慢，所以需要手动再判断一下是不是夜间
				if(isDarkMode()){
					$("#iBlogs").find(".darkMode").addClass("darkModeActive");
				}
			}
			
		})
	}
	
	function loadtags(){
		if(cacheTags){
			return;
		}
		$.ajax({
			type: 'post',
			data:{},
			url: 'loadtags.do',
			success: function(data){
				if(data.code == 200){
					var tags = data.data ||[];
					var sb = [];
					sb.push("<div class='title'>标签分类</div>")
					for(let i=0;i<tags.length;i++){
						var tag = tags[i];
						sb.push("<div>"+tag.name+"（"+tag.blogCount+"）</div>");
						if(i == 9){
							//显示10个
							sb.push("<div class='moreTags'>更多标签</div>");
							break;
						}
					}
					$("#iTags").find(".list-group").html(sb.join(""));
					cacheTags = tags;
				}
			},
			fail: function(e){
				$.showToast(e)
			},
			complete: function(){
			}
			
		})
	}
	
	$("#iBlogs").on("click" , "section" , function(e){
		e.stopPropagation(); //禁止冒泡
		var id = $(this).attr("data-id");
		location.href = "blog.do?id="+id;
		//window.open("blog.do?id="+id);
	})
	
	$("#iListTags").on("click","div",function(e){
		e.stopPropagation(); //禁止冒泡
		var _this = $(this);
		if(_this.hasClass("moreTags")){
			window.open("moretags.do");
		}
	})
	
	var tags = $("#iTags");
	//点击标签 只有移动设备才有标签按钮，所以可以直接监听touchstart,方便做收起操作
	$("#iSlider").on("touchstart",function(e){
			var e = e || window.event;
			e.stopPropagation(); //禁止冒泡
			var classes = iTags.classList;
			if(tags.hasClass("active")){
				tags.removeClass("active");
			}else{
				tags.addClass("active");
			}
		});
	//移动端移动收起标签
	$(document).on("touchstart",function(e){
		if (!tags.hasClass("active")) {
			return;
		}
		if (tags[0] != e.target && tags.has(e.target).length == 0) {
			tags.removeClass("active");
		}
	})
	
})()