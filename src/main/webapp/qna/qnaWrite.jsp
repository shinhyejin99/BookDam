<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의 작성</title>
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
	 
	footer {
		margin-top: 70px;
	}
	.custom-qna-title {
    font-size: 25px;      /* 조금 작게 */
    font-weight: bold;    /* 굵게 */
    margin-bottom: 20px;
    border-bottom: 1px solid #ccc;
    padding-bottom: 10px;
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
		location.href= `\${mypath}/log/login.jsp`;	
	}
}

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
})

////////////////////////////////////////////////////////////////////
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
			                <button onclick="location.href= mypath + '/attendance/attendance.jsp'" class="icon-btn" title="출석체크">❤️</button>
			              	<!--<button class="icon-btn" title="장바구니">🛒</button>-->
			                <button onclick="location.href= mypath + '/cart/cart_page.jsp'" class="icon-btn" title="장바구니" >🛒</button>
			             </div>
		             </div>
		        </section> 
        	</div>
        	
        </div>
    </header>
        	<!-- 네비게이션 메뉴 -->
            <nav class="nav-menu">
                <a href= '<%=request.getContextPath() %>/main/map.jsp'>서점이용안내</a>
                <a href= '<%=request.getContextPath() %>/bookSearch/bookBestseller.jsp'>베스트셀러</a>
                <a href= '<%=request.getContextPath() %>/EventList.do'>문화/행사</a>
                <a href= '<%=request.getContextPath() %>/NoticeList.do'>공지사항</a>
                <a href= '<%=request.getContextPath() %>/QnaList.do'>고객센터</a> 
            </nav>
        
    <hr id="nav-bottom">
 
<div class="container mt-5" style="max-width: 700px; min-height: 600px;">
    <h2 class="custom-qna-title">1:1 문의 작성</h2>

     <!-- enctype="multipart/form-data" 이게 있으면 getParameter를 받지를 못함-->
    <%-- <form action="<%=request.getContextPath() %>/QnaWrite.do" method="post" enctype="multipart/form-data"> --%>
    <%-- <form action="<%=request.getContextPath() %>/QnaWrite.do" method="post"> --%>
    <form action="<%=request.getContextPath() %>/QnaWrite.do" method="post" enctype="multipart/form-data"
      onsubmit="return confirm('문의사항 답변완료시 이메일로 안내드리겠습니다. 감사합니다😊');">
        
        <div class="mb-3">
            <label for="title" class="form-label">제목</label>
            <input type="text" name="title" id="title" class="form-control" placeholder="문의 제목을 입력하세요" required>
        </div>

        <div class="mb-3">
            <label for="qnaType" class="form-label">문의 유형</label>
            <select name="qnaType" id="qnaType" class="form-select" required>
                <option value="">문의 유형을 선택하세요</option>
                <option value="주문">주문</option>
                <option value="환불">환불</option>
                <option value="상품문의">상품문의</option>
                <option value="기타">기타</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="content" class="form-label">문의 내용</label>
            <textarea name="content" id="content" class="form-control" rows="6" placeholder="문의하실 내용을 상세히 작성해 주세요." required></textarea>
        </div>

        <div class="mb-3">
            <label for="uploadFile" class="form-label">파일 첨부</label>
            <input type="file" name="uploadFile" id="uploadFile" class="form-control" multiple="multiple">
        </div>

        <div class="d-grid">
            <button type="submit" class="btn btn-primary btn-lg">문의 등록</button>
        </div>
    </form>
</div>
<footer>
  <div>
	  대전광역시 중구 계룡로 846, 3-4층 406호 (우)34035 <br>
	  도서 데이터 제공: 알라딘 API & 도서관 정보나루 <br>
	  &copy; 2025 BookDam. All rights reserved.
  </div>
</footer>  
<script>


</script>



</body>
</html>