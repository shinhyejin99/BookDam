
<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@page import="kr.or.ddit.dam.mem.service.MemServiceImpl"%>
<%@page import="kr.or.ddit.dam.mem.service.IMemService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>BookDam</title>
  
   <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.js"></script>
   <script src="${pageContext.request.contextPath}/js/jquery.serializejson.min.js"></script>
   <script src="${pageContext.request.contextPath}/js/bookSearch.js"></script>
<%--    <li><a href="<%=request.getContextPath()%>/BestBook.do"></a></li> --%>
<%--    <ul class="no-dot">	
	<li><a href="<%=request.getContextPath()%>/BestBook.do"></a></li>
    <li><a href="<%=request.getContextPath()%>/BookDetail.do"></a></li>
   </ul> --%>
   <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookSearchCss.css">
   <link rel="stylesheet" href="${pageContext.request.contextPath}/main/main.css" />
	
	
	<style>
	.main-container-banner {
		margin: 0 auto;
		width: 95%;
		height: 450px;
		border-radius: 20px;
		border: 2px solid pink;
		background-color: pink;
		padding-left: 28px;
    	padding-right: 28px;
	}
	
	
	
	/* 헤더 영역 */
        .header-container {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 15px 20px;
            background: white;
            border-bottom: 1px solid #eee;
        }
        
        /* 햄버거 버튼 + 네비게이션 헤더 */
		.header-container-ham {
		    display: flex;
		    align-items: center;
		    gap: 20px;
		    margin-left: 29px; /* 핑크색 구역과 같은 margin */
		    padding-left: 28px; /* 핑크색 구역과 같은 padding */
		    padding-right: 28px;
		}


        /* 햄버거 메뉴 버튼 */
        .hamburger-btn {
            width: 50px;
            height: 50px;
            border: 2px solid #ddd;
            border-radius: 8px;
            background: white;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: all 0.2s;
        }

        .hamburger-btn:hover {
            background-color: #f8f8f8;
            border-color: #ccc;
        }

        .hamburger-icon {
            width: 20px;
            height: 15px;
            position: relative;
        }

        .hamburger-icon span {
            display: block;
            width: 100%;
            height: 2px;
            background-color: #333;
            margin: 3px 0;
            border-radius: 1px;
        }

        /* 기존 네비게이션 메뉴 - 여기 달라짐 */
        .nav-menu {
            display: flex;
            align-items: center;
    		gap: 20px;
    		/* 햄버거 버튼을 핑크색 구역 왼쪽 끝에 맞추기 */
        }

        .nav-menu a {
            text-decoration: none;
            color: #333;
            font-size: 16px;
            padding: 8px 12px;
            border-radius: 4px;
            transition: all 0.2s;
            line-height: 1; /* 모든 요소의 라인 높이 통일 */
    		vertical-align: middle;
        }
        
        /* 전체화면 카테고리 오버레이 */
        .category-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0,0,0,0.8);
            z-index: 9999;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }

        .category-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        /* 카테고리 팝업 컨테이너 */
        .category-popup {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) scale(0.9);
            width: 90%;
            max-width: 800px;
            height: 80vh;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        .category-overlay.active .category-popup {
            transform: translate(-50%, -50%) scale(1);
        }

        /* 팝업 헤더 */
        .popup-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 25px;
            border-bottom: 1px solid #eee;
            background: #f8f9fa;
        }

        .popup-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }

        .close-btn {
            width: 40px;
            height: 40px;
            border: none;
            background: #333;
            border-radius: 50%;
            color: white;
            font-size: 18px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .close-btn:hover {
            background: #555;
        }

        /* 탭 메뉴 */
        .tab-menu {
            display: flex;
            border-bottom: 1px solid #eee;
            background: white;
        }

        .tab-btn {
            flex: 1;
            padding: 15px;
            border: none;
            background: none;
            font-size: 14px;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            transition: all 0.2s;
        }

        .tab-btn.active {
            border-bottom-color: #00c73c;
            color: #00c73c;
            font-weight: bold;
        }

        .tab-btn:hover {
            background-color: #f8f8f8;
        }

        /* 카테고리 컨텐츠 */
        .category-content {
            height: calc(80vh - 120px);
            overflow-y: auto;
            padding: 20px;
        }

        .category-grid {
            display: grid;
            grid-template-columns: 200px 1fr;
            gap: 30px;
            height: 100%;
        }

        /* 메인 카테고리 */
        .main-categories {
            border-right: 1px solid #eee;
            padding-right: 20px;
        }

        .main-category {
            display: block;
            width: 100%;
            padding: 12px 15px;
            border: none;
            background: none;
            text-align: left;
            font-size: 14px;
            cursor: pointer;
            border-radius: 6px;
            margin-bottom: 5px;
            transition: all 0.2s;
        }

        .main-category:hover {
            background-color: #f0f8ff;
            color: #0066cc;
        }

        .main-category.active {
            background-color: #e8f4fd;
            color: #0066cc;
            font-weight: bold;
        }

        /* 서브 카테고리 */
        .sub-categories {
            padding-left: 20px;
        }

        .sub-category-section {
            display: none;
        }

        .sub-category-section.active {
            display: block;
        }

        .sub-category-title {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #00c73c;
        }

        .sub-category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 15px;
        }

        .sub-category-item {
            padding: 10px 15px;
            background: #f8f9fa;
            border-radius: 6px;
            text-decoration: none;
            color: #333;
            font-size: 13px;
            transition: all 0.2s;
            text-align: center;
        }

        .sub-category-item:hover {
            background-color: #e8f4fd;
            color: #0066cc;
        }

        .demo-content {
            padding: 40px 20px;
            background: white;
            margin: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
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

 		/* // 정렬 옵션 변경 이벤트 추가 - 책 검색할 때 정렬
 	    $('#sortType').on('change', function() {
 	    	currentSortType = $(this).val();
 	    	currentPage = 1; // 정렬 변경시 첫 페이지로
 	        bookSearchList(); // 다시 검색 실행
 	    }); */
 	}) // function() 끝
 	
 	/////////////////////////////
 	// test 중
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
    	alert("선택된 카테고리:"+ category);
        closeCategoryMenu();
        
        window.location.href = '<%=request.getContextPath()%>/bookSearch/bookCategoryList.jsp?category=' + encodeURIComponent(category);
    }
    
 	
 	
 	
 	
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
		        	<div class="logo">📚 북담</div>
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

    <!-- 헤더 영역 -->
    <div class="header-container-ham">
    	<!-- 햄버거 메뉴 버튼 -->
        <button class="hamburger-btn" onclick="openCategoryMenu()">
            <div class="hamburger-icon">
                <span></span>
                <span></span>
                <span></span>
            </div>
        </button>
    	
        <!-- 네비게이션 메뉴 -->
        <nav class="nav-menu">
            <a href= "#" onclick="alert('서점이용안내는 준비 중입니다.')">서점이용안내</a>
            <a href= '<%=request.getContextPath() %>/bookSearch/bookBestseller.jsp'>베스트셀러</a>
            <a href= '<%=request.getContextPath() %>/EventList.do'>문화/행사</a>
            <a href= '<%=request.getContextPath() %>/NoticeList.do'>공지사항</a>
            <a href= '<%=request.getContextPath() %>/QnaList.do'>고객센터</a> 
        </nav>
    </div>


    <hr id="nav-bottom">
    
    <!-- 전체화면 카테고리 오버레이 -->
    <div class="category-overlay" id="categoryOverlay" onclick="closeCategoryMenu()">
        <div class="category-popup" onclick="event.stopPropagation()">
            <!-- 팝업 헤더 -->
            <div class="popup-header">
                <div class="popup-title">카테고리 전체보기</div>
                <button class="close-btn" onclick="closeCategoryMenu()">×</button>
            </div>

            <!-- 탭 메뉴 -->
            <!-- <div class="tab-menu">
                <button class="tab-btn active">교보문고</button>
                <button class="tab-btn">eBook</button>
                <button class="tab-btn">sam</button>
                <button class="tab-btn">핫트랙스</button>
            </div> -->

            <!-- 카테고리 컨텐츠 -->
            <div class="category-content">
                <div class="category-grid">
                    <!-- 메인 카테고리 -->
                    <!-- <div class="main-categories">
                        <button class="main-category active" onclick="showSubCategory('novel')">국내도서</button>
                        <button class="main-category" onclick="showSubCategory('foreign')">서양도서</button>
                        <button class="main-category" onclick="showSubCategory('japanese')">일본도서</button>
                        <button class="main-category" onclick="showSubCategory('textbook')">교보Only</button>
                    </div> -->

                    <!-- 서브 카테고리 -->
                    <!-- <div class="sub-categories"> -->
                        <!-- 국내도서 -->
                        <div class="sub-category-section active" id="novel">
                            <div class="sub-category-title">국내도서</div>
                            <div class="sub-category-grid">
                                <a href="#" class="sub-category-item" onclick="goToBookList('소설')">소설</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('시/에세이')">시/에세이</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('인문')">인문</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('가정/육아')">가정/육아</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('요리')">요리</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('건강')">건강</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('어린이')">어린이</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('경제경영')">경제경영</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('자기계발')">자기계발</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('정치/사회')">정치/사회</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('역사')">역사</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('종교/역학')">종교/역학</a>
                            </div>
                        </div>

                        <!-- 
                        <div class="sub-category-section" id="foreign">
                            <div class="sub-category-title">서양도서</div>
                            <div class="sub-category-grid">
                                <a href="#" class="sub-category-item" onclick="goToBookList('Fiction')">Fiction</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('Non-Fiction')">Non-Fiction</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('Business')">Business</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('Science')">Science</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('History')">History</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('Biography')">Biography</a>
                            </div>
                        </div>

                        일본도서
                        <div class="sub-category-section" id="japanese">
                            <div class="sub-category-title">일본도서</div>
                            <div class="sub-category-grid">
                                <a href="#" class="sub-category-item" onclick="goToBookList('일본소설')">소설</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('일본만화')">만화</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('일본라이트노벨')">라이트노벨</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('일본잡지')">잡지</a>
                            </div>
                        </div>

                        교보Only
                        <div class="sub-category-section" id="textbook">
                            <div class="sub-category-title">교보Only</div>
                            <div class="sub-category-grid">
                                <a href="#" class="sub-category-item" onclick="goToBookList('교과서')">교과서</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('참고서')">참고서</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('수험서')">수험서</a>
                                <a href="#" class="sub-category-item" onclick="goToBookList('어학')">어학</a>
                            </div>
                        </div> -->
                    </div>
                </div>
            </div>
        </div>


    <!-- 메인 컨테이너 -->
     <div class="main-container"> 
		<div class="main-container-banner">
		
		
		
		</div>
		
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
	</div>
	

 <!-- ✅ 푸터 -->
<footer>
  &copy; 2025 BookDam. All rights reserved.
</footer>    
</body>
</html>