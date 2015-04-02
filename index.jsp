<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%
	request.setCharacterEncoding("UTF-8");
	String postid = request.getParameter("postid");
	int limit = 1000;
	if(postid !=null && !postid.equals("")){
%>
<!doctype html>
<html>
<head>
 <meta charset="UTF-8">
 		<meta property="og:title" content="facebook 粉絲團按讚po文列表" />
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
		<meta name="description" content="Extract facebook postid to excel">
		<meta name="keywords" content="Extract facebook postid to excel" />
		<meta name="google-site-verification" content="v-yNd2u5KPjFM1uQk2L2ntXc_5O4HXTqkBSDDZ85-4M" />
		<meta property="og:type" content="website" />
<meta name="viewport" content="width=device-width, initial-scale=1">
 <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
	<script type="text/javascript" src="js/tableExport.js"></script>
	<script type="text/javascript" src="js/jquery.base64.js"></script>
	<script type="text/javascript" src="js/html2canvas.js"></script>
	<script type="text/javascript" src="js/jspdf/libs/sprintf.js"></script>
	<script type="text/javascript" src="js/jspdf/jspdf.js"></script>
	<script type="text/javascript" src="js/jspdf/libs/base64.js"></script>
<style type="text/css">
#sp-choice{background:rgba(0, 0, 0, 0.7);position:absolute;top:0;left:0;bottom:0;right:0;z-index:999;}

.loading{width:220px;height:19px;margin:100px auto 50px;}
.choice-loading{width:320px;padding:38px;margin:0 auto;min-width:260px;text-align:center;position:absolute;background: white ;background-size:cover;max-width:320px;top:50%;left:50%;margin-left:-198px;margin-top:-122.5px;}
</style>

<script type="text/javascript"
	src="http://connect.facebook.net/zh_TW/all.js"></script>

<script language="javascript" type="text/javascript">
	$(document)
			.ready(
					function() {
						var html = "<div><img src='icons/xls.png' style='cursor:pointer' onClick =\"$('#fbpost').tableExport({type:'excel',escape:'false'});\"></img> </div><table id='fbpost' >";
						var tdhtml = "";
						var totalcount = 0;
						var url = "http://www.f5yo.com/query/";
						var appid = "341729779321789";
						var postid = "<%=postid%>";
						var limit = <%=limit%>;
						var fanid = "";
						//初始化
						FB.init({
							appId : appid,
							status : true,
							cookie : true,
							xfbml : true,
							channelURL : 'http://www.f5yo.com/query/',
							oauth : true,
							version    : 'v2.3'

						});

						//檢查登入狀態
						FB
								.getLoginStatus(function(response) {
									if (response.authResponse) {
										var accessToken = response.authResponse.accessToken;
										//取得按讚的使用者資料，第一頁取得1000筆資料
										GetLikeUser(postid, "", "");
										
									} else {
										//取得授權
										window.top.location.href = "http://www.facebook.com/connect/uiserver.php?app_id="
												+ encodeURIComponent(appid)
												+ "&next="
												+ encodeURIComponent(url)
												+
												"&display=popup&perms=email,user_birthday,user_likes&fbconnect=1&method=permissions.request";

									}

								});

						//取得按讚的使用者資料
						function GetLikeUser(postid, before, after) {
							
							var u = '/likes?fields=id,name,link,pic_small&limit='+ limit;
							if (before != "") {
								u += '&before=' + before;
							}

							if (after != "") {
								u += '&after=' + after;
							}
						console.log(postid + u);
							FB.api(
											postid + u,
											function(res) {
												console.log(res);
												if (typeof (res.data) !== "undefined" && typeof (res.paging) !== "undefined" ){
												totalcount += res.data.length;
														
												for ( var key in res.data) {
													var id = res.data[key].id;
													var name = res.data[key].name;
													var link = res.data[key].link;
													var pic_small = res.data[key].pic_small;

													//取得資料後自己看要怎麼用!!!
													tdhtml += "<tr>";
													//tdhtml += "<td><img src=" + pic_small + " ></td>";
													tdhtml += "<td>'" + id + "</td>";
													tdhtml += "<td>" + name + "</td>";
													tdhtml += "<td><a href='" + link + "'>" + link + "</a></td>";
													tdhtml += "</tr>";
													//.......................................
													//console.log(id);
													//console.log(name);
													//console.log(link);
													//console.log(pic_large);

												}
												
												
												//做一下上一頁 + 下一頁的連結

													if (typeof (res.paging.next) !== "undefined") {
														
														//alert(res.paging.next);
														//console.log(res.paging.next);
														//console.log(res.paging.cursors.after);
														FB.getLoginStatus(function(
																response) {
															if (response.authResponse) {
																//就呼叫下一頁的資料
																//alert("next");
															
																GetLikeUser(
																		postid,
																		"",
																		res.paging.cursors.after);
																
															} 
														});
													}else{
														html += "<tr><td colspan='5'>facebook postid=<%=postid%> 按讚名單       總筆數:" + totalcount + "</td>";
														html +="</tr><tr>";
														//html +="<th>pic_small</th>";
														html +="<td>id</td>";
														html +="<td>name</td>";
														html +="<td>link</td>";
														html +="</tr>";
														html += tdhtml;
														html += "</table>";
														$( "#main" ).html(html);
														$('#sp-choice').fadeOut(300);
													}
												}else{
													$('#sp-choice').fadeOut(300);
												}
												
											});

							
											
							
						}
						

					});
</script>
</head>
<body>
 <div id="sp-choice" class="cl">
		<div class="choice-loading">
			<h2>資料處理中請稍後...</h2>
            <div class="loading">
            	<img src="images/loadingbar.gif" width="220" height="19" border="0">
            </div>
		</div>
	</div>
<div id="main"></div>
</body>
</html>
<%} %>
