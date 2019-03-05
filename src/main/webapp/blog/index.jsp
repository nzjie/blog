<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html class="darkMode">
<head >
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width , initial-scale=1,maximum-scale=1.0, user-scalable=0">
<title>首页</title>
 <link href="${ pageContext.request.contextPath }/${serverId}/common/common.css" rel="stylesheet" type="text/css">
 <link href="${ pageContext.request.contextPath }/${serverId}/css/global.css" rel="stylesheet" type="text/css">
<link href="${ pageContext.request.contextPath }/${serverId}/blog/css/index.css?d=20190305" rel="stylesheet" type="text/css">
<link href="${ pageContext.request.contextPath }/${serverId}/plugin/suspend-btn.css" rel="stylesheet" type="text/css">

<style type="text/css">
</style>

<script type="text/javascript">
window.addEventListener("error" , function(e){
	console.log("监听到错误");
	console.log(e);
	alert(e.error +" \r\n  "+e.error.stack);
})

</script>
</head>
<body class="darkMode ">
	<div class="main ">
		<div id="iSlider" class="tag-btn darkMode">
			<span class="bar-icon"></span>
			<span class="bar-icon"></span>
			<span class="bar-icon"></span>
			<span class="bar-icon"></span>
		</div>
		<div class="header-navi darkMode">
			<div onclick="javascript:location.href='addblog.do'" class="addblog">写博客</div>
			<div class="user-header">
				<c:choose>
					<c:when test="${not empty userid }">
						<img onclick="navigatorTo(this)" data-id="${userid }" data-type="userinfo" data-uri="sso/userinfo.do" src="${userheader }" />
					</c:when>
					<c:otherwise>
						<div class="login-btn" onclick="navigatorTo(this)" data-type="login" data-uri="sso/login.do">登录/注册</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<div class="container">
			<div id="iTags" class="tags-block darkMode">
				<div class="list-group " id="iListTags">
		    	</div>
			</div>
			<div class="blogs" id="iBlogs">
			</div>
			<div class="qr-code">
				<div>关注公众号和小程序，获取获取最新状态</div>
				<div>
					<img src="${ pageContext.request.contextPath }/${serverId}/images/my_wxgz_qrcode.jpg" />
				</div>
				<div>
					<img src="${ pageContext.request.contextPath }/${serverId}/images/my_wxapp_code.jpg" />
				</div>
			</div>
		</div>
	</div>
	
<!-- 	<div class="operating">
		<div class="operating-more">更多</div>
	</div>
	
	<div class="operating-mask">
		<div class="operating-menu">
		
		</div>
	</div> -->
	
	<jsp:include page="/footer.jsp"></jsp:include>
	<script type="text/temp"  id="iBlogTemp">
		<section class='darkMode'  data-id='[id]' >
			<div class="title">[title]</div>
			<div class="abstract-content">[abstractContent]</div>
			<div class="extract-list">
				<div class="list-left flex">
					<img src="[userHeader]">
					<div>[user]</div>
					<div>[createDate]</div>
				</div>
				<div class="list-right flex">
					<div>阅读 [readNum]</div>
					<div>评论 [commentNum]</div>
				</div>
			</div>
		</section>
	</script>
	<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.4.0.js"></script>
	<script type="text/javascript">
		var serverId = '${serverId}';
		var config = {};
		var configstr = '${config}';
		if(configstr && configstr.length){
			config = JSON.parse(configstr);
		}
		wx.config(config);
	</script>
	<!-- <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.4.0.js"></script> -->
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId}/js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId}/plugin/suspend-btn.js"></script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId}/common/common.js?d=2019"></script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId}/blog/js/index.js?d=2019"></script>
	<script type="text/javascript">
	/*  wx.config({
	    debug: true, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
	    appId: 'wx207d32dbbf52e1c1', // 必填，公众号的唯一标识
	    timestamp: 1551168970069, // 必填，生成签名的时间戳
	    nonceStr: 'fad3e0e9-40a1-4116-aa87-40e5adf521bd', // 必填，生成签名的随机串
	    signature: '433bc34eed5863ce379ac6673c75c9583696c5a6',// 必填，签名
	    jsApiList: ["updateTimelineShareData","updateAppMessageShareData"] // 必填，需要使用的JS接口列表
	});
	wx.error(function(res){
		console.log(res);
		alert(res)
	});
	wx.ready(function () {      //需在用户可能点击分享按钮前就先调用
	    wx.updateTimelineShareData({ 
	        title: '博客234234', // 分享标题
	        link: 'http://www.ajie18.top/ajie/index.do', // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
	        imgUrl: 'http://www.ajie18.top/images/view.jpg', // 分享图标
	        success: function () {
	          alert("分享成功");
	        }
	    });
	
	    wx.updateAppMessageShareData({
	    	title: 'haha', // 分享标题
	    	desc: 'zheshihaha', // 分享描述
	    	link: 'http://www.ajie18.top/ajie/index.do', // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
	    	imgUrl: 'http://www.ajie18.top/images/view.jpg', // 分享图标
	    	type: 'link', // 分享类型,music、video或link，不填默认为link
	    	success: function (res) {
	    		alert(res)
	    	}
	    	});
	});  */
	
	function navigatorTo(ele){
		var _this = $(ele);
		var type = _this.attr("data-type")
		var uri = _this.attr("data-uri");
		var host = location.host+"/";
		var url = "";
		if(host.indexOf("localhost") > -1 ||host.indexOf("127.0") > -1 || host.indexOf("10.8") > -1){
			url = 'http://localhost:8081/'+uri;
		}else{
			url = "http://"+host+uri;
		}
		if("login" == type){
			url += "?ref="+location.href
		}else if("userinfo" == type){
			url += "?id="+_this.attr("data-id");
		}
		
		location.href = url;
	}
	
	
</script>
	
</body>
</html>