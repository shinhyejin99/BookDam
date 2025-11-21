
<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@page import="kr.or.ddit.dam.mem.service.MemServiceImpl"%>
<%@page import="kr.or.ddit.dam.mem.service.IMemService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>검색 결과</title>
  
   <script src="../js/jquery-3.7.1.js"></script>
   <script src="../js/jquery.serializejson.min.js"></script>
   <script src="../js/bookSearch.js"></script>
  
   <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookSearchCss2.css">

  <style>
	.logo {
	  display: flex;
	  align-items: center;
	}
	
	.logo img {
	  height: 120px;   /* 또는 원하는 크기로 조절 */
	  width: auto;  /* 필요하면 고정 width 설정도 가능 */
	  margin-left: -33px;  
	}

  </style>

  <script>
  	
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

currentPage = 1;
memMail = null;

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
  		
  		// ** 새로고침 해도 이전 상태가 유지될 수 있도록 **
  		// 페이지 로드시 URL에서 검색 상태 복원 - 새로고침 해도 이전에 검색했던 요소들이 남아있도록
  		const urlParams = new URLSearchParams(window.location.search);
  		const urlStype = urlParams.get('stype');
  		const urlSword = urlParams.get('sword');
  		const urlSortType = urlParams.get('sortType');
  		const urlPage = urlParams.get('currentPage');
  		
  		console.log("url: " + urlStype + " " + urlSword + " " + urlSortType + " " + urlPage); 
  		
  		// 멤버 정보 먼저 가져오고(마일리지) 검색 결과 리스트 가져오기 (가영)
  		if (logUser != null) {
	  		(async () => {
	  			await getMemInfo();
		  		bookSearchListBasic(urlStype, urlSword, urlSortType);
	  		})();
  		} else {
  			memGrade = "비회원";
  			bookSearchListBasic(urlStype, urlSword, urlSortType);
  		}
  		

  		// URL에 검색 파라미터가 있으면 복원하고 검색 실행
  		if (urlSword) { // 여름 검색했으면 이전 값들을 가져와서 
  			$('#stype').val(urlStype || 'all');
  			$('#sword').val(urlSword);
  			$('#sword-result').text(urlSword || '전체');

 	   		currentSortType = urlSortType || 'popularity';
  			$('#sortType').val(currentSortType);

  			currentPage = parseInt(urlPage) || 1;
  			// 검색 결과 영역 표시하고 검색 실행
  			$('#searchResults').show();
  			
  			bookSearchListBasic(urlStype, urlSword, currentSortType); // 검색 실행
  		} else {
  			$('#sword-result').text('전체');
  		}

  		// 페이지네이션-----------------------------
    	// script 함수 호출 - bookSearch.js 실행
    	//bookSearchList();

  	  	// 페이지네이션 설정 - 애니메이션 추가!
  	  	$(document).on('click', '.page-btn[data-page]', function() {
		    const page = $(this).data('page');
		    
		    if(page === 'prev') {
		        currentPage = parseInt($('.page-number').first().text()) - 1;
		    } else if(page === 'next') {
		        currentPage = parseInt($('.page-number').last().text()) + 1;
		    } else {
		        currentPage = parseInt(page);
		    }
		    
		    bookSearchListBasic(urlStype, urlSword, currentSortType);
		});
  	 	
  		// 정렬 옵션 변경 이벤트 추가 - 책 검색할 때 정렬
  	   $('#sortType').on('change', function() {
  	    	currentSortType = $(this).val();
  	    	currentPage = 1; // 정렬 변경시 첫 페이지로
  	    	
  	    	console.log("currentSortType: " + currentSortType)
  	        bookSearchListBasic(urlStype, urlSword, currentSortType); // 다시 검색 실행
  	    });
  		
  		// 검색 버튼 클릭 이벤트
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
  	
  	

  </script>
</head>
  
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
					  <img style="width: 182px; height: 88px;" src="<%= request.getContextPath() %>/images/logo/멍2.png" alt="BookDam 로고">
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
   
    
    <!-- 메인 컨테이너 -->
    <div class="main-container">

        <div id="searchResults" style="display: none;">
            <!-- 도서 검색 결과 헤더 -->
            <div class="result-word">
                    <span id="sword-result">0</span>에 대한 검색 결과
            </div>
            <div class="result-header">
	            <div class="result-count">
	                전체 <span id="totalCount">0</span>권
	            </div>
	            <div class="sort-section">
	                <span class="sort-label">정렬:</span>
	                <select class="sort-select" id="sortType">
	                    <option value="popularity">판매인기순</option>
	                    <option value="latest">최신순</option>
	                    <option value="reviewCount">리뷰수</option>
	                </select>
	            </div>
        	</div>

        	<!-- 도서 검색 결과 영역 -->
        	<div id="result"></div>
            
        	<br><br>
            
        	<!-- 페이지네이션 -->
        	<div id="pagelist"></div>
        </div>

        <!-- 로딩 상태 -->
        <div class="loading" id="loading" style="display: none;">
            <p>검색 중입니다...</p>
        </div>

        <!-- 검색 결과 없음 -->
        <div class="no-results" id="noResults" style="display: none;">
            <h3>검색 결과가 없습니다</h3>
            <p>다른 검색어로 다시 시도해보세요.</p>
        </div>
    </div> <!-- 메인 컨테이너 끝남 -->
       
</body>
</html>