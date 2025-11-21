<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@page import="com.google.gson.Gson"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <title>Bookdam 메인</title>
    <li><a href="<%=request.getContextPath()%>/BestBook.do"></a></li>
    <li><a href="<%=request.getContextPath()%>/BookDetail.do"></a></li>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/main/main.css" />
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookSearchCss.css">
   <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.js"></script>
   <script src="${pageContext.request.contextPath}/js/jquery.serializejson.min.js"></script>


<script>
  	
  	currentPage = 1;
  	memMail = null;
  	
 <%
	MemVO mvo = (MemVO) session.getAttribute("loginOk");
	
	String user = null;
	Gson gson = new Gson();
	if (mvo != null) user = gson.toJson(mvo);
%>

	logUser = <%= user == null ? "null" : user %>;

	//로그인 확인용 콘솔창
	if(logUser != null) {
		console.log("현재 로그인ID :" + logUser.mem_mail);
		memMail = logUser.mem_mail;
	} else {
		console.log("로그인 상태 : 비회원");
		memMail = null;
	}

	// 로그아웃
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

 
	<%--mypath = '<%= request.getContextPath()%>'; --%>
  	// mypath = BookDam
	
  	$(function() {
  	    // 검색 버튼 클릭 이벤트
  	    $('#search-btn').on('click', function() {  
  		  
  		    searchWord = $('#sword').val().trim();
  		    $('#sword-result').text(searchWord || '전체');
  		  
  		    currentSortType = 'popularity'; // 전역변수 리셋 -> 다시 검색할 때마다 판매인기순으로 정렬하기 위함!!
  		    $('#sortType').val('popularity'); // 옵션도 판매인기순(디폴트)으로 보이도록
  		    
  		    currentPage = 1;
  		    bookSearchList();
  	 	})
  	 	
  	 	// Enter 키 이벤트 = 검색 버튼 클릭
		$('#sword').on('keydown', function(e) {
			if(e.keyCode == 13 || e.which == 13) {
		        e.preventDefault(); // 기본 동작 방지
		        $('#search-btn').click();
		    }
		});
  	 	
  		// 정렬 옵션 변경 이벤트 추가 - 책 검색할 때 정렬
  	    $('#sortType').on('change', function() {
  	    	currentSortType = $(this).val();
  	    	currentPage = 1; // 정렬 변경시 첫 페이지로
  	        bookSearchList(); // 다시 검색 실행
  	    });
  	})
  	
  	// 선택한 도서 상세보기 페이지로 이동
	const goToBookDetail = (bookNo) => {
		console.log("도서 번호:", bookNo); // 이게 잘 찍히는지 확인
		window.location.href = `<%= request.getContextPath()%>/BookDetail.do?bookNo=\${bookNo}`;
	}
  
</script>

<body>

<!-- ✅ 헤더 영역 -->
    <header class="header">
        <div class="header-content">
        	<div class="mypage-header">
        		<% if(mvo == null){ %>
                	<a href="../log/login.jsp" onclick="alert('로그인으로 이동')">로그인</a>
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
                <a href='<%=request.getContextPath() %>/main/map.jsp'>서점이용안내</a>
                <a href="<%= request.getContextPath()%>/bookSearch/bookBestseller.jsp">베스트셀러</a>
                <a href="#" onclick="alert('문화/행사 페이지로 이동')">문화/행사</a>
                <a href= '<%=request.getContextPath() %>/NoticeList.do'>공지사항</a>
                <a href="<%=request.getContextPath() %>/QnaList.do" onclick="alert('고객센터 페이지로 이동')">고객센터</a> 
            </nav>
 
	
	<!-- 🔥 베스트셀러 -->
	<section class="book-section">
	  <h2>🔥 베스트셀러</h2>
	  <div class="book-grid">
	    <c:forEach var="i" begin="0" end="4">
	      <c:choose>
	        <c:when test="${i < fn:length(bestList)}">
	          <c:set var="book" value="${bestList[i]}" />
	          <div class="book-card" onclick="goToBookDetail('${book.bookNo}')">
	            <img src="${book.coverImg}" alt="${book.bookTitle}" />
	            <div class="title">${book.bookTitle}</div>
	            <div class="price">₩${book.bookPrice}</div>
	          </div>
	        </c:when>
	        <c:otherwise>
	          <div class="book-card empty"></div>
	        </c:otherwise>
	      </c:choose>
	    </c:forEach>
	  </div>
	</section>
	
	<!-- 📚 20대 인기도서 -->
	<section class="book-section">
	  <h2>📚 20대 인기도서</h2>
	  <div class="book-grid" >
	    <c:forEach var="i" begin="0" end="4">
	      <c:choose>
	        <c:when test="${i < fn:length(ageList)}">
	          <c:set var="book" value="${ageList[i]}" />
	          <div class="book-card" onclick="goToBookDetail(${book.bookNo})">
	            <img src="${book.coverImg}" alt="${book.bookTitle}" />
	            <div class="title">${book.bookTitle}</div>
	            <div class="price">₩${book.bookPrice}</div>
	          </div>
	        </c:when>
	        <c:otherwise>
	          <div class="book-card empty"></div>
	        </c:otherwise>
	      </c:choose>
	    </c:forEach>
	  </div>
	</section>
	
	<!-- 📖 카테고리별 인기 도서 -->
	<section class="book-section">
	  <h2>📖 ${topCategory} 인기 도서</h2>
	  <div class="book-grid">
	    <c:forEach var="i" begin="0" end="4">
	      <c:choose>
	        <c:when test="${i < fn:length(categoryList)}">
	          <c:set var="book" value="${categoryList[i]}" />
	          <div class="book-card" onclick="goToBookDetail('${book.bookNo}')">
	            <img src="${book.coverImg}" alt="${book.bookTitle}" />
	            <div class="title">${book.bookTitle}</div>
	            <div class="price">₩${book.bookPrice}</div>
	          </div>
	        </c:when>
	        <c:otherwise>
	          <div class="book-card empty"></div>
	        </c:otherwise>
	      </c:choose>
	    </c:forEach>
	  </div>
	</section>

<!-- ✅ 푸터 -->
<footer>
  &copy; 2025 Bookly. All rights reserved.
</footer>
</head>
</body>
</html>