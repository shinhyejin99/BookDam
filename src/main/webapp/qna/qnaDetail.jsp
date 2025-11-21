<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의 상세</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookSearchCss.css">
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/main/main.css">
  	<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.js"></script>
   <script src="${pageContext.request.contextPath}/js/jquery.serializejson.min.js"></script>
   
   <style>
   /* 폰트 재설정 */
  	body {
    	font-family: initial !important;
	}

   </style>
</head>

<script>
  	
  	
  	currentPage = 1;
  	memMail = null;
  	
//////////////////다른 페이지에도 필수로 넣어야 하는 이벤트 //////////////////
<%
	// 세션에서 loginOk 값을 가져와 로그인 여부 확인
	MemVO mvo = (MemVO) session.getAttribute("loginOk");
	
	String user = null;
	Gson gson = new Gson();
	// 만약 loginOk 값이 있다면 mvo 객체를 user에 대입
	if (mvo != null) user = gson.toJson(mvo);
%>

// BookDam (프로젝트 이름)
mypath = '<%= request.getContextPath()%>';  
// 로그인 유저 객체
logUser = <%= user == null ? "null" : user %>;

//로그인 확인용 콘솔창
if(logUser != null) {
	console.log("현재 로그인ID :" + logUser.mem_mail);
	memMail = logUser.mem_mail;
} else {
	console.log("로그인 상태 : 비회원");
	memMail = null;
}

// 로그아웃 클릭시...
const logout = async () =>{
	
	try{
		response = await fetch('/BookDam/Logout.do');
		if(!response.ok){
			throw new Error('서버오류:' + response.status);
		}
		result = await response.json();
		
		if(result&& result.flag === 'ok') {
			alert("로그아웃 되었습니다.");
			sessionStorage.removeItem('cartArr');
			window.location.href = `\${mypath}/BestBook.do`;
		} else {
			alert("로그아웃 실패");
		}
	}catch(error){
		console.error("로그아웃 요청 실패 : " , error);
		alert("오류발생")
	}
}

// 마이페이지 클릭시... (회원 & 비회원)
const goMypage = () => {
	if (logUser != null) {
		location.href= mypath + '/myPage/mypage.jsp'
	} else {
		location.href= `\${mypath}/log/login.jsp`	
	}
}

////////////////////////////////////////////////////////////////////

 $(function() {
	//////////////// 다른 페이지에도 필수로 넣어야 하는 이벤트 //////////////////
  	// 검색 버튼 클릭시...
    $('#search-btn').on('click', function() {  
	  
    	const stype = $('#stype').val();
		const sword = $('#sword').val().trim();
		$('#sword-result').text(sword || '전체');
		
		console.log(stype, sword);
	    
	    currentPage = 1;
	    console.log("검색버튼 클릭");
	    location.href = `<%=request.getContextPath()%>/bookSearch/bookSearchRes.jsp?stype=\${stype}&sword=\${sword}&sortType=popularity&currentPage=1`;
 	});
 	
    $('#sword').on('keydown', function(e) {
		if(e.keyCode == 13 || e.which == 13) {
	        e.preventDefault(); // 기본 동작 방지
	        $('#search-btn').click();
	    }
	});
	////////////////////////////////////////////////////////////////////
 })
 
  // 카테고리 버튼 영역 추가함
  function openCategoryMenu() {
      document.getElementById('categoryOverlay').classList.add('active');
      document.body.style.overflow = 'hidden'; // 스크롤 방지
  }

  function closeCategoryMenu() {
      document.getElementById('categoryOverlay').classList.remove('active');
      document.body.style.overflow = 'auto'; // 스크롤 복원
  }
  
  function goToBookList(category) {
  	  console.log('클릭한 카테고리:', category);
  	  console.log('인코딩된 카테고리:', encodeURIComponent(category)); 
  	  /* alert("선택된 카테고리:"+ category); */
      closeCategoryMenu();
      
      window.location.href = '<%=request.getContextPath()%>/bookSearch/bookCategoryList.jsp?category=' + encodeURIComponent(category);
  }

</script>

<body>

<!-- 상단바 -->
<header class="header">
    <div class="header-content">
    	<div class="mypage-header">
    		<% if(mvo == null){ %>
            	<a href="<%= request.getContextPath() %>/log/login.jsp">로그인</a>
       		<%}else{ %>
       			<a href="javascript:void(0);" onclick="logout()">로그아웃</a>
       		<% } %>
       		<a href="#" onclick="goMypage()">마이페이지</a>
    	</div>
    	<div class="top-header">

         <!-- 검색 영역 -->
      <section class="search-section">
      	<div class="search-container">
      	<!-- <div class="logo">📚 북담</div> -->
      	<a href="<%= request.getContextPath() %>/BestBook.do" class="logo">
	  <img src="<%= request.getContextPath() %>/images/logo/아.png" alt="BookDam 로고">
	</a>
           <form class="search-form">
               <select class="search-category" id="stype">
                   <option value="all">전체</option>
                   <option value="title">도서명</option>
                   <option value="author">저자</option>
                   <option value="publisher">출판사</option>
               </select>
               <input type="text" class="search-input" id="sword"
                      placeholder="검색할 도서명 또는 저자 또는 출판사를 입력하세요" required>
               <button id="search-btn" type="button" class="search-btn">🔍</button>
            </form>
           
            <!-- 헤더 아이콘들 -->
            <div class="header-icons">
               <button onclick="location.href= mypath + '/attendance/attendance.jsp'" class="icon-btn" title="출석체크">📆</button>
             	<!--<button class="icon-btn" title="장바구니">🛒</button>-->
               <button onclick="location.href= mypath + '/cart/cart_page.jsp'" class="icon-btn" title="장바구니" >🛒</button>
            </div>
           </div>
      </section> 
    	</div>
    </div>
</header>

<div class="header-container-ham">
   	<!-- 네비게이션 메뉴 -->
    <nav class="nav-menu">
    	<!-- 햄버거 메뉴 버튼 -->
    	<button class="hamburger-btn" onclick="openCategoryMenu()">
        	<div class="hamburger-icon">
            	<span></span>
             	<span></span>
             	<span></span>
         	</div>
     	</button>
		<a href= '<%=request.getContextPath() %>/main/map.jsp'>서점이용안내</a>
		<a href= '<%=request.getContextPath() %>/bookSearch/bookBestseller.jsp'>베스트셀러</a>
		<a href= '<%=request.getContextPath() %>/EventList.do'>문화/행사</a>
		<a href= '<%=request.getContextPath() %>/NoticeList.do'>공지사항</a>
		<a href= '<%=request.getContextPath() %>/QnaList.do'>고객센터</a> 
	</nav>
</div>

<hr id="nav-bottom">

<div class="container mt-3" style="max-width: 900px; min-height: 650px;">

    <!-- <h2 class="mb-4 border-bottom pb-2">1:1 문의 상세</h2> -->
    <h2 class="mb-4 border-bottom pb-2" style="font-size: 25px; font-weight: 600;">1:1 문의 상세</h2>


    <div class="mb-3">
        <label class="form-label fw-bold">제목</label>
        <div class="border rounded p-2 bg-light">${qna.qnaTitle}</div>
    </div>

    <div class="mb-3">
        <label class="form-label fw-bold">문의 유형</label>
        <div class="border rounded p-2">${qna.qnaType}</div>
    </div>

    <div class="mb-3">
        <label class="form-label fw-bold">문의 내용</label>
        <div class="border rounded p-3" style="min-height:150px;">${qna.qnaContent}</div>
    </div>

    <div class="mb-3">
        <label class="form-label fw-bold">등록일</label>
        <div>${qna.qnaDate}</div>
    </div>

	<div class="mb-3">
	    <label class="form-label fw-bold">상태</label>
	    <c:choose>
	        <c:when test="${fn:trim(qna.qnaStatus) == '답변완료'}">
	            <span class="badge bg-success">답변완료</span>
	        </c:when>
	        <c:when test="${fn:trim(qna.qnaStatus) == '답변대기'}">
	            <span class="badge bg-secondary">답변대기</span>
	        </c:when>
	        <c:otherwise>
	            <span class="badge bg-secondary">${fn:trim(qna.qnaStatus)}</span>
	        </c:otherwise>
	    </c:choose>
	</div>
		<div class="mb-3">
		  <label class="form-label fw-bold">첨부파일</label>
		  <div class="d-flex flex-column gap-2">
		    <c:forEach var="file" items="${qna.atchFileVO.atchFileDetailList}">
<%-- 		    <div>
    		<b>qna.atchFileVO.atchFileId:</b> ${file.atchFileId}
    		<b>qna.atchFileVO.fileSn:</b> ${file.fileSn}
			</div> --%>
		      <div>
		        <a href="${pageContext.request.contextPath}/qna/download.do?atchFileId=${file.atchFileId}&fileSn=${file.fileSn}">
		            ${file.orignlFileNm}
		        </a>
		      </div>
		    </c:forEach>
		  </div>
		</div>
<%-- 		<!-- 디버그용 임시 출력 -->
<c:out value="${qna.atchFileVO}" />
<c:out value="${qna.atchFileVO.atchFileDetailList}" /> --%>
<%-- <h3>디버그 체크</h3>

<!-- 1. qna 전체 출력 -->
<div>
    <b>qna:</b> ${qna}
</div>

<!-- 2. 첨부파일 VO 출력 -->
<div>
    <b>qna.atchFileVO:</b> ${qna.atchFileVO}
</div>

<!-- 3. 첨부파일 DetailList 출력 -->
<div>
    <b>qna.atchFileVO.atchFileDetailList:</b> ${qna.atchFileVO.atchFileDetailList}
</div> --%>

	<!-- 페이지 제일 아래 부분 -->
	<div class="d-flex justify-content-end mt-4">
	    <a href="<%=request.getContextPath() %>/QnaEdit.do?qnaQid=${qna.qnaQid}" class="btn btn-primary btn me-2">수정</a>
	    <%-- <p>QNA ID: ${qna.qnaQid}</p> --%>
	    <form action="<%=request.getContextPath() %>/QnaDelete.do" method="post" style="display:inline;" 
	           onsubmit="return confirm('정말 삭제하시겠습니까?');">
	        <input type="hidden" name="qnaQid" value="${qna.qnaQid}">
	        <button type="submit" class="btn btn-danger btn">삭제</button>
	    </form>
	</div>
	
	<!-- 상태 아래에 구분선 -->
<%-- 	<hr style="border-top: 1px solid #dee2e6; margin-top: 0.5rem; margin-bottom: 1.5rem;">
	
	    <c:if test="${not empty file}">
	        <div class="mb-3">
	            <label class="form-label fw-bold">첨부파일</label>
	            <div><a href="fileDownload.do?fileId=${file.fileId}" class="text-decoration-none">${file.originalName}</a></div>
	        </div>
	    </c:if> --%>
<%--  			<c:if test="${not empty qna.atchFileVO}">
			    <div class="mb-3">
			        <label class="form-label fw-bold">첨부파일</label>
			        <ul>
			            <c:forEach var="file" items="${qna.atchFileVO.atchFileDetailList}">
			                <li>
			                    <a href="${pageContext.request.contextPath}/download?atchFileId=${file.atchFileId}&fileSn=${file.fileSn}">
			                        ${file.orignlFileNm}
			                    </a>
			                </li>
			            </c:forEach>
			        </ul>
			    </div>
			</c:if>  --%>

	<c:if test="${fn:trim(qna.qnaStatus) == '답변완료'}">
	    <h4 class="mt-5 border-top pt-3">[관리자 답변]</h4>
	    <div class="border rounded p-3 mb-2 bg-light">
	        ${answer.qnaContent}
	    </div>
	    <div><small class="text-muted">답변일: ${answer.qnaAnswerDate}</small></div>
	</c:if>

</div>
<br><br>
<br><br>

<!-- 전체화면 카테고리 오버레이 -->
<div class="category-overlay" id="categoryOverlay" onclick="closeCategoryMenu()">
    <div class="category-popup" onclick="event.stopPropagation()">
        <!-- 팝업 헤더 -->
        <div class="popup-header">
            <div class="popup-title">카테고리 전체보기</div>
            <button class="close-btn" onclick="closeCategoryMenu()">×</button>
        </div>
        <!-- 카테고리 컨텐츠 -->
        <div class="category-content">
            <div class="category-grid">

                <!-- 국내도서 -->
                <div class="sub-category-section active" id="novel">
                    <div class="sub-category-title"></div>
                    <div class="sub-category-grid">
                        <a href="#" class="sub-category-item" onclick="goToBookList('소설')">소설</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('에세이')">에세이</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('인문학')">인문학</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('사회과학')">사회과학</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('과학')">과학</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('자기계발')">자기계발</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('경제경영')">경제경영</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('만화')">만화</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('어린이')">어린이</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('유아')">유아</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('종교')">종교</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('역사')">역사</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('예술')">예술</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('청소년')">청소년</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('요리')">요리</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('좋은부모')">좋은부모</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('잡지')">잡지</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('건강')">건강</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('성공')">성공</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('컴퓨터')">컴퓨터</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('수험서')">수험서</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('중학교참고서')">중학교참고서</a>
                        <a href="#" class="sub-category-item" onclick="goToBookList('대학교재')">대학교재</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<footer>
  <div>
	  대전광역시 중구 계룡로 846, 3-4층 406호 (우)34035 <br>
	  도서 데이터 제공: 알라딘 API & 도서관 정보나루 <br>
	  &copy; 2025 BookDam. All rights reserved.
  </div>
</footer> 

</body>
</html>