<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@page import="kr.or.ddit.dam.vo.EventVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    EventVO vo = (EventVO) request.getAttribute("event");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문화/행사 상세</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookSearchCss.css">
  	<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.js"></script>
   <script src="${pageContext.request.contextPath}/js/jquery.serializejson.min.js"></script>
   <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/main/main.css">
<style>
	/* 폰트 재설정 */
  	body {
    	font-family: initial !important;
	 }
	 
    .detail-container {
        display: flex;
        gap: 40px;
        align-items: flex-start;
        margin-top: 40px;
    }

    .event-image {
        width: 400px;
        display: block;
        border-radius: 8px;
        border: 1px solid #ddd;
        flex-shrink: 0;
    }

    .event-info {
        flex: 1;
        font-size: 16px;
    }

    .info-title {
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 20px;
    }

    .divider {
        border-top: 1px solid #ccc;
        margin: 20px 0;
    }

    .info-label {
        font-weight: bold;
        margin-bottom: 8px;
        display: block;
    }

    .info-content {
        white-space: pre-line;
    }

    .btn-back {
        margin-top: 30px;
    }
    
    footer {
    	margin-top: 100px;
    }
    
</style>
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



// 로그인 확인용 콘솔창
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
////////////////다른 페이지에도 필수로 넣어야 하는 이벤트 //////////////////
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
</script>    
</head>
<body>

	<%-- <!-- ✅ 헤더 영역 -->
    <header class="header">
        <div class="header-content">
        	<div class="mypage-header">
        		<% if(mvo == null){ %>
                	<a href="<%= request.getContextPath()%>/log/login.jsp" onclick="alert('로그인으로 이동')">로그인</a>
           		<%}else{ %>
           			<a href="javascript:void(0);" onclick="logout()">로그아웃</a>
           		<% } %>
           		<a href="#" onclick="alert('마이페이지로 이동')">마이페이지</a>
        	</div>
        	<div class="top-header">

	            <!-- 검색 영역 -->
		        <section class="search-section">
		        	<div class="search-container">
		        	<div class="logo">📚 북담</div>
			            <form class="search-form" onsubmit="handleSearch(event)">
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
			                <button onclick="location.href= mypath + '/order/order_list.jsp'" class="icon-btn" title="찜목록">❤️</button>
			              	<!--<button class="icon-btn" title="장바구니">🛒</button>-->
			                <a href="#" onclick="location.href= mypath + '/cart/cart_page.jsp'" class="icon-btn" title="장바구니" >🛒</a>
			             </div>
		             </div>
		        </section> 
        	</div>
        	
        </div>
    </header>
        	<!-- 네비게이션 메뉴 -->
            <nav class="nav-menu">
                <a href="#" onclick="alert('서점이용안내 페이지로 이동')">서점이용안내</a>
                <a href="#" onclick="alert('베스트셀러 페이지로 이동')">베스트셀러</a>
                <a href="#" onclick="alert('문화/행사 페이지로 이동')">문화/행사</a>
                <a href="#" onclick="alert('공지사항 페이지로 이동')">공지사항</a>
                <a href="<%=request.getContextPath() %>/QnaList.do" onclick="alert('고객센터 페이지로 이동')">고객센터</a> 
            </nav> --%>
            
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
        	<!-- 네비게이션 메뉴 -->
            <nav class="nav-menu">
                <a href= '<%=request.getContextPath() %>/main/map.jsp'>서점이용안내</a>
                <a href= '<%=request.getContextPath() %>/bookSearch/bookBestseller.jsp'>베스트셀러</a>
                <a href= '<%=request.getContextPath() %>/EventList.do'>문화/행사</a>
                <a href= '<%=request.getContextPath() %>/NoticeList.do'>공지사항</a>
                <a href= '<%=request.getContextPath() %>/QnaList.do'>고객센터</a> 
            </nav>
        
    <hr id="nav-bottom">

<%-- <div class="container mt-5" style="max-width: 1100px; min-height: 750px;">
    <a href="<%= request.getContextPath() %>/EventList.do" class="btn btn-link">&lt; 행사 안내</a>

    <div class="detail-container">
        <!-- 왼쪽: 이미지 -->
        <img class="event-image" src="<%= request.getContextPath() %>/images/event/<%= vo.getEventType() %>" alt="행사 이미지">

        <!-- 오른쪽: 제목 / 등록일 / 내용 -->
        <div class="event-info">
            <div class="info-title"><%= vo.getEventTitle() %></div>
            <div class="divider"></div>

            <div>
                <span class="info-label">등록일</span>
                <div class="info-content"><%= vo.getEventDate().substring(0, 10) %></div>
            </div>
            <div class="divider"></div>

            <div>
                <span class="info-label">내용</span>
                <div class="info-content"><%= vo.getEventContent() %></div>
            </div>
        </div>
    </div>
</div> --%>
<div class="container mt-5" style="max-width: 1000px;">
  <a href="<%= request.getContextPath() %>/EventList.do" class="text-decoration-none text-muted mb-4 d-inline-block">&lt; 행사 안내</a>

  <div class="d-flex gap-5 align-items-start mt-3">
    <!-- 이미지 -->
    <img src="<%= request.getContextPath() %>/images/event/<%= vo.getEventType() %>"
         alt="행사 이미지" style="width: 380px; border-radius: 10px; border: 1px solid #ccc;" />

    <!-- 텍스트 정보 -->
    <div style="flex:1;">
      <h2 class="fw-bold mb-3" style="font-size: 24px;"><%= vo.getEventTitle() %></h2>

      <div class="mb-4 text-muted" style="font-size: 14px;">등록일: <%= vo.getEventDate().substring(0,10) %></div>

      <div style="white-space: pre-line; font-size: 16px; line-height: 1.7; color: #333;">
        <%= vo.getEventContent() %>
      </div>
    </div>
  </div>
</div>


  <!-- ✅ 푸터 -->
<footer>
  <div>
	  대전광역시 중구 계룡로 846, 3-4층 406호 (우)34035 <br>
	  도서 데이터 제공: 알라딘 API & 도서관 정보나루 <br>
	  &copy; 2025 BookDam. All rights reserved.
  </div>
</footer>  
</body>
</html>