<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/execDaumPostcode.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-eOJMYsd53ii+scO/bJGFsiCZc+5NDVN2yr8+0RDqr0Ql0h+rP48ckxlpbzKgwra6" crossorigin="anonymous">
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/header.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/resources/css/header.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/resources/css/common.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/resources/css/footer.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/resources/css/mateReadContentPage.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/resources/css/leftSide.css">
<link href="https://fonts.googleapis.com/css2?family=Source+Sans+Pro&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Nanum+Pen+Script&display=swap" rel="stylesheet">
<script type="text/javascript">
	var sessionMemberNo = null;
	var mate_freeboard_no = ${oneMateContent.mateFreeboardVO.mate_freeboard_no};
	var apply_modal = null;
	var wishlist_toast = null;
	var toast_container = null;
	
	function redirectLoginPage(){
		location.href="${pageContext.request.contextPath }/member/loginPage.do";
	}
	
	function getSessionMemberNo() {
		//AJAX ??????.....
		var xmlhttp = new XMLHttpRequest();
		
		//?????? ??? ?????? ????????????... ?????? ??????....
		xmlhttp.onreadystatechange = function(){
			if(xmlhttp.readyState==4 && xmlhttp.status == 200){
				var obj = JSON.parse(xmlhttp.responseText);
				
				sessionMemberNo = obj.member_no;
			}
		};
		
		xmlhttp.open("get","${pageContext.request.contextPath}/member/getSessionMemberNo.do" , true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send();	
	}
	
	//?????? ???????????? ??????
	function getApplyGroupCount() {
		//AJAX ??????.....
		var xmlhttp = new XMLHttpRequest();
		
		//?????? ??? ?????? ????????????... ?????? ??????....
		xmlhttp.onreadystatechange = function(){
			if(xmlhttp.readyState==4 && xmlhttp.status == 200){
				var obj = JSON.parse(xmlhttp.responseText);
				
				var apply_count = document.getElementById("apply_count");
				
				apply_count.innerText = obj.applyGroupCount;
			}
		};
		
		xmlhttp.open("get","${pageContext.request.contextPath}/mate/getApplyGroupCount.do?mate_freeboard_no=" + mate_freeboard_no, true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send();	
	}
	
	//-------------------------- ????????? ????????? ????????? ?????? - ?????? -----------------------------
	//????????? ????????? ???????????? ?????? - ??????
	function doMateFreeboardToWishListProcess() {
		if (sessionMemberNo == null) {
			alert("???????????? ????????? ?????????????????????.");
			return;
		}
		
		if(sessionMemberNo == "${oneMateContent.mateFreeboardVO.member_no}"){
			alert("????????? ?????? ???????????? ????????? ??? ????????????");
			return;
		}
		
		//AJAX ??????.....
		var xmlhttp = new XMLHttpRequest();
		
		//?????? ??? ?????? ????????????... ?????? ??????....
		xmlhttp.onreadystatechange = function(){
			if(xmlhttp.readyState==4 && xmlhttp.status == 200){
				var obj = JSON.parse(xmlhttp.responseText);
				
				var toast_boay_span = document.getElementById("toast_boay_span");
				
				if (obj.doWishListCount == 0) {
					toast_boay_span.innerText = "??????????????? ?????????????????????.";
					showToastAfterInsertWishList();
				} else {
					toast_boay_span.innerText = "???????????? ?????????????????????.";
					showToastAfterInsertWishList();
				}
				
				refreshWishListData();
			}
		};
		
		xmlhttp.open("get","${pageContext.request.contextPath}/mate/doMateFreeboardToWishListProcess.do?mate_freeboard_no=" + mate_freeboard_no, true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send();	
	}
	
	//???????????? ??????/?????? ??? Toast??????
	function showToastAfterInsertWishList() {
		wishlist_toast = new bootstrap.Toast(document.getElementById('liveToast'));
		//var wishlist_toast = document.getElementById('liveToast');
		//var toast_container = document.getElementById('toast_container');
		//toast_container.appendChild(wishlist_toast);
		
		//var aaa = new bootstrap.Toast(toast_container);
		//aaa.show();
		wishlist_toast.show();
	}
	
	
	function refreshWishListData() {
		//AJAX ??????.....
		var xmlhttp = new XMLHttpRequest();
		
		//?????? ??? ?????? ????????????... ?????? ??????....
		xmlhttp.onreadystatechange = function(){
			if(xmlhttp.readyState==4 && xmlhttp.status == 200){
				var obj = JSON.parse(xmlhttp.responseText);
				
				var wishlist_btn = document.getElementById("wishlist_btn");
				if(obj.chkInsertWishList > 0){
					wishlist_btn.setAttribute("class", "bi bi-star-fill fs-3 text-warning");
				} else {
					wishlist_btn.setAttribute("class", "bi bi-star fs-3 text-warning");
				}
			}
		};
		
		xmlhttp.open("get","${pageContext.request.contextPath}/mate/getWishListData.do?mate_freeboard_no=" + mate_freeboard_no, true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send();	
	}
	
	//------------------------------ ????????? ????????? ????????? ??? -----------------------------------
	
	//??????
	function doRecommend() {
		
		if (sessionMemberNo == null) {
			alert("???????????? ????????? ?????????????????????.");
			return;
		}
		
		//AJAX ??????.....
		var xmlhttp = new XMLHttpRequest();
		
		//?????? ??? ?????? ????????????... ?????? ??????....
		xmlhttp.onreadystatechange = function(){
			if(xmlhttp.readyState==4 && xmlhttp.status == 200){
				//var obj = JSON.parse(xmlhttp.responseText);
				refreshRecommendData();
			}
		};
		
		xmlhttp.open("get","${pageContext.request.contextPath}/mate/doRecommend.do?mate_freeboard_no=" + mate_freeboard_no, true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send();	
	}
	
	function refreshRecommendData(){
		//AJAX ??????.....
		var xmlhttp = new XMLHttpRequest();
		
		//?????? ??? ?????? ????????????... ?????? ??????....
		xmlhttp.onreadystatechange = function(){
			if(xmlhttp.readyState==4 && xmlhttp.status == 200){
				var obj = JSON.parse(xmlhttp.responseText);
				
				var recommend_btn = document.getElementById("recommend_btn");
				if(obj.chkDoRecommend > 0){
					recommend_btn.setAttribute("class", "bi bi-hand-thumbs-up-fill fs-3 ms-2 text-primary");
				} else {
					recommend_btn.setAttribute("class", "bi bi-hand-thumbs-up fs-3 ms-2 text-primary");
				}
				
				var recommendCountBox = document.getElementById("recommendCountBox");
				recommendCountBox.innerText = obj.recommedCount;
			}
		};
		
		xmlhttp.open("get","${pageContext.request.contextPath}/mate/getRecommendData.do?mate_freeboard_no=" + mate_freeboard_no, true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send();	
	}
	
	//?????? ??????
	function mateWriteComment(){
		if (sessionMemberNo == null) {
			alert("???????????? ????????? ?????????????????????.");
			return;
		}
		
		var mate_comment_content = document.getElementById("mate_comment_content");
		if(mate_comment_content.value == ""){
			alert("????????? ??????????????????.");
			mate_comment_content.focus();
			return;
		}
		
		//AJAX ??????.....
		var xmlhttp = new XMLHttpRequest();
		
		//?????? ??? ?????? ????????????... ?????? ??????....
		xmlhttp.onreadystatechange = function(){
			if(xmlhttp.readyState==4 && xmlhttp.status == 200){
				//var obj = JSON.parse(xmlhttp.responseText);
				
				refreshMateCommentData();
			}
		};
		
		xmlhttp.open("post","${pageContext.request.contextPath}/mate/mateWriteCommentProcess.do", true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send("mate_freeboard_no=" + mate_freeboard_no + "&mate_comment_content=" + mate_comment_content.value);	
	}
	
	//?????? ??????
	function mateDeleteComment(mate_comment_no) {
		 if (confirm("????????? ?????????????????????????")) {
			//AJAX ??????.....
			var xmlhttp = new XMLHttpRequest();
			
			//?????? ??? ?????? ????????????... ?????? ??????....
			xmlhttp.onreadystatechange = function(){
				if(xmlhttp.readyState==4 && xmlhttp.status == 200){
					//var obj = JSON.parse(xmlhttp.responseText);
					
					refreshMateCommentData();
				}
			};
			
			xmlhttp.open("post","${pageContext.request.contextPath}/mate/mateDeleteCommentProcess.do", true);
			xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
			xmlhttp.send("mate_comment_no=" + mate_comment_no);
		} else {
			return;
		}
	}
	
	//?????? ?????? ????????? ????????????
	function mateUpdateComment(mate_comment_no, commentRowBox) {
		//AJAX ??????.....
		var xmlhttp = new XMLHttpRequest();
		
		var comment_updateContent_area = document.getElementById("comment_updateContent_area");
		if(comment_updateContent_area){
			console.log("???");
			comment_updateContent_area.previousSibling.children[0].children[2].children[0].removeAttribute("disabled");
			comment_updateContent_area.remove();
		}
		
		var parentLiBox = commentRowBox.parentElement.parentElement.parentElement;
		commentRowBox.setAttribute("disabled", "disabled");
		
		//?????? ??? ?????? ????????????... ?????? ??????....
		xmlhttp.onreadystatechange = function(){
			if(xmlhttp.readyState==4 && xmlhttp.status == 200){
				var obj = JSON.parse(xmlhttp.responseText);
				
				var comment_list_update_frm = document.getElementById("comment_list_update_frm");
				var commet_update_box = comment_list_update_frm.cloneNode(true);
				commet_update_box.removeAttribute("class");
				commet_update_box.setAttribute("class", "list-group-item");
				commet_update_box.setAttribute("id", "comment_updateContent_area");
				commet_update_box.firstElementChild.children[1].children[0].innerText = obj.mateFreeboardCommentVO.mate_comment_content;
				
				//?????? ??????
				commet_update_box.firstElementChild.children[2].children[0].setAttribute("id", "comment_update_btn");
				commet_update_box.firstElementChild.children[2].children[0].setAttribute("onclick", "mateUpdateCommentProcess(" + obj.mateFreeboardCommentVO.mate_comment_no + ")");
				
				//?????? ??????
				commet_update_box.firstElementChild.children[3].children[0].setAttribute("onclick", "mateUpdateCommentCancel()");
				
				parentLiBox.after(commet_update_box);
			}
		};
		
		xmlhttp.open("get","${pageContext.request.contextPath}/mate/getMateOneCommentData.do?mate_comment_no=" + mate_comment_no, true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send();
	}
	
	//?????? ?????? ????????? ??????(?????? ??????) - ??????
	function mateUpdateCommentCancel() {
		//AJAX ??????.....
		var xmlhttp = new XMLHttpRequest();
		
		//?????? ??? ?????? ????????????... ?????? ??????....
		xmlhttp.onreadystatechange = function(){
			if(xmlhttp.readyState==4 && xmlhttp.status == 200){
				//var obj = JSON.parse(xmlhttp.responseText);
				
				refreshMateCommentData();
			}
		};
		
		xmlhttp.open("get","#", true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send();
	}
	
	//?????? ?????? - ??????
	function mateUpdateCommentProcess(mate_comment_no) {
		
		var mate_comment_updateContent = document.getElementById("mate_comment_updateContent").value;
		var comment_update_btn = document.getElementById("comment_update_btn");
		comment_update_btn.removeAttribute("disabled");
		
		//AJAX ??????.....
		var xmlhttp = new XMLHttpRequest();
		
		//?????? ??? ?????? ????????????... ?????? ??????....
		xmlhttp.onreadystatechange = function(){
			if(xmlhttp.readyState==4 && xmlhttp.status == 200){
				//var obj = JSON.parse(xmlhttp.responseText);
				
				refreshMateCommentData();
			}
		};
		
		xmlhttp.open("post","${pageContext.request.contextPath}/mate/mateUpdateCommentProcess.do", true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send("mate_comment_no=" + mate_comment_no + "&mate_comment_content=" + mate_comment_updateContent);
	}
	
	
	//?????? ????????????
	function refreshMateCommentData() {
		
		var comment_count = document.getElementById("comment_count");
		var mate_comment_content = document.getElementById("mate_comment_content");
		if(sessionMemberNo != null){
			mate_comment_content.value = "";
		}
		
		//AJAX ??????.....
		var xmlhttp = new XMLHttpRequest();
		
		//?????? ??? ?????? ????????????... ?????? ??????....
		xmlhttp.onreadystatechange = function(){
			if(xmlhttp.readyState==4 && xmlhttp.status == 200){
				var obj = JSON.parse(xmlhttp.responseText);
				
				comment_count.innerText = "??????(" + obj.commentCount + ")";
				var comment_list = document.getElementById("comment_list");
				comment_list.innerText = "";
				
				var comment_list_first = document.getElementById("comment_list_first");
				var commentLi = comment_list_first.cloneNode(true);
				commentLi.removeAttribute("class");
				commentLi.setAttribute("class", "list-group-item");
				comment_list.appendChild(commentLi);
				
				for(var commentList of obj.mateCommentList){
					
					var commentLi = document.createElement("li");
					commentLi.setAttribute("class", "list-group-item");
					
					var commentRowBox = document.createElement("div");
					commentRowBox.setAttribute("class", "row");
					
					//?????? ????????? ??????
					var commentMemberColBox = document.createElement("div");
					var commentMemberSpanBox = document.createElement("span");
					var commentDateSmallBox = document.createElement("small");
					commentMemberColBox.setAttribute("class", "col-2 pe-2 border-end border-1");
					commentMemberSpanBox.innerText = commentList.member_nick + "\n";
					var commentWriteDate = new Date(commentList.mateFreeboardCommentVO.mate_comment_writedate);
					commentDateSmallBox.innerText = "(" + 
							(commentWriteDate.getFullYear()).toString().substr(2, 4) + "." + 
							(commentWriteDate.getMonth()+1 > 9 ? commentWriteDate.getMonth()+1 : "0" + (commentWriteDate.getMonth()+1)) + "." + 
							(commentWriteDate.getDate() > 9 ? commentWriteDate.getDate() : "0" + commentWriteDate.getDate())
							+ " " + commentWriteDate.getHours() + ":" + commentWriteDate.getMinutes() + 
							")";
					commentMemberSpanBox.appendChild(commentDateSmallBox);
					commentMemberColBox.appendChild(commentMemberSpanBox);
					commentRowBox.appendChild(commentMemberColBox);
					
					//?????? ?????? ??????
					var commentContentColBox = document.createElement("div");
					var commentContentSpanBox = document.createElement("span");
					commentContentColBox.setAttribute("class", "col-8 pe-2 border-end border-1");
					commentContentSpanBox.innerText = commentList.mateFreeboardCommentVO.mate_comment_content;
					commentContentColBox.appendChild(commentContentSpanBox);
					commentRowBox.appendChild(commentContentColBox);
					
					//?????? ?????? ?????? ??????
					var commentUpdateColBox = document.createElement("div");
					commentUpdateColBox.setAttribute("class", "col-1 text-center position-relative");
					if(sessionMemberNo == commentList.mateFreeboardCommentVO.member_no){
						var commentUpdateButton = document.createElement("button");
						commentUpdateButton.setAttribute("class", "btn btn-outline-primary btn-sm position-absolute start-50 top-50 translate-middle");
						commentUpdateButton.setAttribute("onclick", "mateUpdateComment(" + commentList.mateFreeboardCommentVO.mate_comment_no + ", this)");
						commentUpdateButton.innerText = "??????";
						commentUpdateColBox.appendChild(commentUpdateButton);
					}
					commentRowBox.appendChild(commentUpdateColBox);
					
					var commentDeleteColBox = document.createElement("div");
					commentDeleteColBox.setAttribute("class", "col-1 text-center position-relative");
					if(sessionMemberNo == commentList.mateFreeboardCommentVO.member_no){
						var commentDeleteButton = document.createElement("button");
						commentDeleteButton.setAttribute("class", "btn btn-outline-danger btn-sm position-absolute start-50 top-50 translate-middle");
						commentDeleteButton.setAttribute("onclick", "mateDeleteComment(" + commentList.mateFreeboardCommentVO.mate_comment_no + ")");
						commentDeleteButton.innerText = "??????";
						commentDeleteColBox.appendChild(commentDeleteButton);
					}
					commentRowBox.appendChild(commentDeleteColBox);
					
					commentLi.appendChild(commentRowBox);
					comment_list.appendChild(commentLi);
				}
				
			}
		};
		
		xmlhttp.open("get","${pageContext.request.contextPath}/mate/getMateCommentData.do?mate_freeboard_no=" + mate_freeboard_no, true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send();
	}
	
	//????????? ?????? - ??????
	function deleteMateContentProcess() {
		if (confirm("?????? ?????????????????????????")) {
			var content_delete_frm = document.getElementById("content_delete_frm");
			content_delete_frm.submit();
		} else {
			return;
		}
	}
	
	//????????? ?????? Modal ?????? - ??????
	function openApplyModal() {
		apply_modal = new bootstrap.Modal(document.getElementById("applyModal"));
		apply_modal.show();
	}
	
	//????????? ???????????? - ??????
	function mateApplyGroupProcess() {
		//AJAX ??????.....
		var xmlhttp = new XMLHttpRequest();
		
		//?????? ??? ?????? ????????????... ?????? ??????....
		xmlhttp.onreadystatechange = function(){
			if(xmlhttp.readyState==4 && xmlhttp.status == 200){
				//var obj = JSON.parse(xmlhttp.responseText);
				
				var mate_apply_btn = document.getElementById("mate_apply_btn");
				var mate_content = document.getElementById("mate_content");
				
				mate_apply_btn.setAttribute("disabled", "disabled");
				mate_apply_btn.innerText = "????????????";
				
				apply_modal.hide();
			}
		};
		
		xmlhttp.open("post","${pageContext.request.contextPath}/mate/mateApplyGroupProcess.do", true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send("mate_content=" + mate_content.value + "&mate_freeboard_no=" + mate_freeboard_no);	
	}
	
	function init() {
		getSessionMemberNo();
		refreshRecommendData();
		refreshMateCommentData();
		getApplyGroupCount();
		refreshWishListData();
	}
	
</script>
</head>
<body onload="init()">

	<div style="width: 1200px; margin: 0 auto;" >
		<!-- ?????? -->
		<jsp:include page="/WEB-INF/views/commons/header.jsp" />
		<!-- ?????? ??? -->
		
		<!-- ????????? ????????? ?????? -->
		<div class="container-fluid mb-5">
			<div class="row">
				<div class="col border-end border-1">
					<!-- ????????? ?????? -->
						<jsp:include page="/WEB-INF/views/commons/leftSide.jsp" />
					<!-- ????????? ??? -->
				</div>
				<div class="col-10">
					<div class="row my-4">
						<div class="col-1"></div>
						<div class="col-7 border-bottom border-2">
							<p class="h2 pb-2 ps-2 mt-2">${oneMateContent.mateFreeboardVO.mate_freeboard_title }</p>
						</div>
						<div class="col border-bottom border-2 position-relative">
							<span class="position-absolute top-50 end-0 translate-middle-y">
							<small>
								<b>${oneMateContent.memberVO.member_nick }</b>&nbsp;&nbsp;|&nbsp;
								?????????&nbsp;${oneMateContent.mateFreeboardVO.mate_freeboard_readcount }&nbsp;&nbsp;|&nbsp;
								&nbsp;?????????&nbsp;<span id="recommendCountBox"></span>&nbsp;&nbsp;|&nbsp;
								<fmt:formatDate pattern="yyyy-MM-dd" value="${oneMateContent.mateFreeboardVO.mate_freeboard_writedate }"/>
							</small>
							</span>
						</div>
					</div>
					<div class="row">
						<div class="col-1"></div>
						<div class="col-8 p-3 border border-1 me-1 text-center">
							<div id="carouselExampleIndicators" class="carousel slide" data-bs-ride="carousel">
								<div class="carousel-indicators">
									<c:forEach items="${oneMateContent.mateFreeboardImageVOList }" var="images" varStatus="status">
										<button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="${status.index }" class="active" aria-current="true" aria-label="Slide 1"></button>
									</c:forEach>
								</div>
								<div class="carousel-inner">
									<c:forEach items="${oneMateContent.mateFreeboardImageVOList }" var="images" varStatus="status">
										<c:choose>
											<c:when test="${status.index == 0 }">
												<div class="carousel-item active mt-4">
													<img id="mate_read_thumnail" src="/upload_files/${images.image_location }" class="d-block w-100">
												</div>
											</c:when>
											<c:otherwise>
												<div class="carousel-item mt-4">
													<img id="mate_read_thumnail" src="/upload_files/${images.image_location }" class="d-block w-100">
												</div>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</div>
								<button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
									<span class="carousel-control-prev-icon" aria-hidden="true"></span>
									<span class="visually-hidden">Previous</span>
								</button>
								<button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
									<span class="carousel-control-next-icon" aria-hidden="true"></span>
									<span class="visually-hidden">Next</span>
								</button>
							</div>
						</div>
						<div class="col py-3 px-0 border border-1">
							<ul class="list-group list-group-flush border-bottom border-1">
								<li class="list-group-item">
									???????????? - ${oneMateContent.confirmGroupCount }/${oneMateContent.mateFreeboardVO.mate_freeboard_maxnumber }???<br>
									<small>
										(?????? ???????????? <span id="apply_count"></span>???)
									</small>
								</li>
								<li class="list-group-item">
									???????????? - ${oneMateContent.fishingCategoryVO.fishing_category_name }
								</li>
								<li class="list-group-item">
									????????? ?????? - <br>
									<small>
										(?????????)<br>
										${oneMateContent.mateFreeboardVO.mate_freeboard_roadAddress }
										${oneMateContent.mateFreeboardVO.mate_freeboard_detailAddress }
										${oneMateContent.mateFreeboardVO.mate_freeboard_extraAddress }<br>
									</small>
								</li>
								<li class="list-group-item">
									<small>
										(??????)<br>
										${oneMateContent.mateFreeboardVO.mate_freeboard_jibunAddress }
										${oneMateContent.mateFreeboardVO.mate_freeboard_detailAddress }
										${oneMateContent.mateFreeboardVO.mate_freeboard_extraAddress }
									</small>
								</li>
								<li class="list-group-item">
									?????? ??????<br>
									<fmt:formatDate pattern="yyyy-MM-dd" value="${oneMateContent.mateFreeboardVO.mate_freeboard_startdate}"/> ~ 
									<fmt:formatDate pattern="yyyy-MM-dd" value="${oneMateContent.mateFreeboardVO.mate_freeboard_enddate}"/>
								</li>
							</ul>
							<div class="row d-flex flex-column align-items-end">
								<div class="col">
									<span class="mt-2 py-2 d-grid">
										<c:choose>
											<c:when test="${oneMateContent.mateCategoryVO.mate_category_no == 3 }">
												<button type="button" class="btn btn-lg btn-outline-danger d-grid" disabled>
													${oneMateContent.mateCategoryVO.mate_category_name }
												</button>
											</c:when>
											<c:otherwise>
												<button type="button" class="btn btn-lg btn-outline-primary d-grid" disabled>
													${oneMateContent.mateCategoryVO.mate_category_name }
												</button>
											</c:otherwise>
										</c:choose>
									</span>
								</div>
								<div class="col">
									<span class="mt-2 d-grid">
										<c:choose>
											<c:when test="${!empty sessionUser && sessionUser.member_no == oneMateContent.memberVO.member_no && oneMateContent.mateCategoryVO.mate_category_no == 1 }">
												<a class="btn btn-primary btn-lg d-grid" href="${pageContext.request.contextPath }/mate/mateConfirmGroupPageByLeader.do?mate_freeboard_no=${oneMateContent.mateFreeboardVO.mate_freeboard_no}">
													????????????
												</a>
											</c:when>
											<c:when test="${!empty sessionUser && !empty oneMateContent.mate_confirm_no && oneMateContent.mateCategoryVO.mate_category_no == 2}">
												<a class="btn btn-primary btn-lg d-grid" href="${pageContext.request.contextPath }/mate/mateConfirmGroupPage.do?mate_freeboard_no=${oneMateContent.mateFreeboardVO.mate_freeboard_no}">
													?????? ??????
												</a>
											</c:when>
											<c:when test="${oneMateContent.mateCategoryVO.mate_category_no == 2 }">
												<button class="btn btn-primary btn-lg d-grid" disabled>??????</button>
											</c:when>
											<c:when test="${oneMateContent.mateCategoryVO.mate_category_no == 3 }">
												<button class="btn btn-primary btn-lg d-grid" disabled>??????</button>
											</c:when>
											<c:when test="${!empty sessionUser && chkApplyGroup eq 0 }">
												<button type="button" id="mate_apply_btn" class="btn btn-primary btn-lg d-grid" onclick="openApplyModal()">??????</button>
											</c:when>
											<c:when test="${!empty sessionUser && chkApplyGroup ne 0 }">
												<button class="btn btn-primary btn-lg d-grid" disabled>????????????</button>
											</c:when>
											<c:otherwise>
												<button class="btn btn-primary btn-lg d-grid" disabled>????????? ??? ?????? ??????</button>
											</c:otherwise>
										</c:choose>
									</span>
								</div>
							</div>
						</div> 
					</div>
					<div class="row mt-2">
						<div class="col-1"></div>
						<div class="col border border-1 py-3">
							<p id="mate_read_content">
								${oneMateContent.mateFreeboardVO.mate_freeboard_content }
							</p>
						</div>
					</div>
					<div class="row mt-4 pb-2 align-items-end">
						<div class="col-1"></div>
						<div class="col border-bottom border-1"></div>
						<div class="col-2 border-bottom border-1 text-end p-0">
							<i id="wishlist_btn" onclick="doMateFreeboardToWishListProcess()"></i>
							<i id="recommend_btn" onclick="doRecommend()"></i>
						</div>
					</div>
					<div class="row mt-3">
						<div class="col-1"></div>
						<div class="col ps-0">
							<span id="comment_count" class="h6 fw-bold"></span>
						</div>
					</div>
					<div id="mate_comment_form" class="row mt-2 pb-2">
						<div class="col-1"></div>
						<div class="col px-0 d-grid border-bottom border-1 pb-2">
							<c:choose>
								<c:when test="${empty sessionUser }">
									<div class="row px-0">
										<div class="col d-grid">
											<textarea class="form-control resize-none" name="mate_comment_content" placeholder="????????? ??? ?????? ???????????????" disabled></textarea>
										</div>
										<div class="col-2 d-grid">
											<button class="btn btn-primary align-middle" onclick="redirectLoginPage()">?????????</button>
										</div>
									</div>
								</c:when>
								<c:otherwise>
									<div class="row">
										<div class="col d-grid">
											<textarea class="form-control" id="mate_comment_content" name="mate_comment_content" placeholder="????????? ???????????????"></textarea>
										</div>
										<div class="col-2 d-grid">
											<button class="btn btn-primary" onclick="mateWriteComment()">??????</button>
										</div>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
					<div class="row">
						<div class="col-1"></div>
						<div class="col border-bottom border-1 p-0">
							<ul id="comment_list" class="list-group list-group-flush"></ul>
						</div>
					</div>
					<div class="row mt-4 pt-3">
						<div class="col-1"></div>
						<div class="col border-top border-2"></div>
						<c:if test="${!empty sessionUser && sessionUser.member_no == oneMateContent.mateFreeboardVO.member_no }">
							<div class="col-1 d-grid p-0 border-top border-2">
								<a class="btn btn-primary mt-2" href="${pageContext.request.contextPath }/mate/mateUpdateContentPage.do?mate_freeboard_no=${oneMateContent.mateFreeboardVO.mate_freeboard_no}">??????</a>
							</div>
							<div class="col-1 p-0 border-top border-2">
								<form id="content_delete_frm" class="p-0 d-grid" action="${pageContext.request.contextPath }/mate/deleteContentProcess.do" method="post">
									<input type="hidden" value="${oneMateContent.mateFreeboardVO.mate_freeboard_no }" name="mate_freeboard_no">
									<button class="btn btn-outline-danger ms-2 mt-2" onclick="deleteMateContentProcess()">??????</button>
								</form>
							</div>
						</c:if>
						<div class="col-1 d-grid p-0 border-top border-2">
							<a class="btn btn-outline-primary ms-2 mt-2" href="${pageContext.request.contextPath }/mate/matePage.do">??????</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	
	<!--============================ UI ????????? / hidden ?????? =========================================-->
	<!--  -->
	<li id="comment_list_first" class="list-group-item visually-hidden">
		<div class="row">
			<div class="col-2 pe-2 border-end border-1">
				<span class="fw-bold">?????????</span>
			</div>
			<div class="col pe-2 border-end border-1">
				<span class="fw-bold">??????</span>
			</div>
			<div class="col-1 text-center">
			</div>
			<div class="col-1 text-center">
			</div>
		</div>
	</li>
	
	<!-- ?????? ?????? ?????? ??? -->
	<li id="comment_list_update_frm" class="list-group-item visually-hidden">
		<div class="row">
			<div class="col-2 pe-2 border-end border-1"></div>
			<div class="col pe-2 border-end border-1">
				<textarea id="mate_comment_updateContent" name="mate_comment_content" class="form-control"></textarea>
			</div>
			<div class="col-1 text-center position-relative">
				<button class="btn btn-primary btn-sm position-absolute start-50 top-50 translate-middle">??????</button>
			</div>
			<div class="col-1 text-center position-relative">
				<button class="btn btn-outline-danger btn-sm position-absolute start-50 top-50 translate-middle">??????</button>
			</div>
		</div>
	</li>
	
	
	<!--============================ UI ????????? / hidden ??? =========================================-->
	<!--============================ Toast =========================================-->
	<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 5">
		<div id="liveToast" class="toast hide" role="alert" aria-live="assertive" aria-atomic="true">
			<div class="toast-header">
				<i class="bi bi-star-fill fs-6 me-2 text-warning"></i>
				<strong class="me-auto">?????????</strong>
				<small></small>
				<button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
			</div>
			<div class="toast-body">
				<span id="toast_boay_span"></span>
			</div>
		</div>
	</div>
	
	<div id="toast_container" class="toast-container">
	</div>
	<!--============================ Toast ??? =========================================-->
	<!--============================ Modal =========================================-->
	<div class="modal fade" id="applyModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-xl">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">????????? ??????</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div class="row mt-2 pb-2 border-bottom border-1">
						<div id="mate_read_content_form" class="col-9 border border-1 py-3 me-1">
							<p id="mate_read_content">
								${oneMateContent.mateFreeboardVO.mate_freeboard_content }
							</p>
						</div>
						<div class="col py-3 px-0 border border-1">
							<ul class="list-group list-group-flush">
								<li class="list-group-item">
									???????????? - ${oneMateContent.fishingCategoryVO.fishing_category_name }
								</li>
								<li class="list-group-item">
									????????? ?????? - <br>
									<small>
										(?????????)<br>
										${oneMateContent.mateFreeboardVO.mate_freeboard_roadAddress }
										${oneMateContent.mateFreeboardVO.mate_freeboard_detailAddress }
										${oneMateContent.mateFreeboardVO.mate_freeboard_extraAddress }<br>
									</small>
								</li>
								<li class="list-group-item">
									<small>
										(??????)<br>
										${oneMateContent.mateFreeboardVO.mate_freeboard_jibunAddress }
										${oneMateContent.mateFreeboardVO.mate_freeboard_detailAddress }
										${oneMateContent.mateFreeboardVO.mate_freeboard_extraAddress }
									</small>
								</li>
								<li class="list-group-item">
									?????? ??????<br>
									<fmt:formatDate pattern="yyyy-MM-dd" value="${oneMateContent.mateFreeboardVO.mate_freeboard_startdate}"/> ~ 
									<fmt:formatDate pattern="yyyy-MM-dd" value="${oneMateContent.mateFreeboardVO.mate_freeboard_enddate}"/>
								</li>
							</ul>
						</div>
						<div id="mate_content_form" class="row mt-3 pb-2">
							<div class="row px-0 d-grid">
								<div class="col d-grid text-center ms-3">
									<textarea class="form-control" id="mate_content" name="mate_content" placeholder="??????????????? ????????? ??????????????? ???????????????"></textarea>
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" onclick="mateApplyGroupProcess()">??????</button>
						<button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">??????</button>
					</div>
				</div>
			</div>
		</div>
	</div>



	<!--============================ Modal ??? =========================================-->

	<div style="width: 100%; margin: 0 auto;">
		<!-- ?????? -->
		<jsp:include page="/WEB-INF/views/commons/footer.jsp" />
		<!-- ?????? ??? -->
	</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/js/bootstrap.bundle.min.js" integrity="sha384-JEW9xMcG8R+pH31jmWH6WWP0WintQrMb4s7ZOdauHnUtxwoG2vI5DkLtS3qm9Ekf" crossorigin="anonymous"></script>
</body>
</html>