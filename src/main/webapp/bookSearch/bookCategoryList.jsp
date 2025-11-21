<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>카테고리 리스트</title>
  
  <script src="<%= request.getContextPath()%>/js/jquery-3.7.1.js"></script>
  <script src="<%= request.getContextPath()%>/js/jquery.serializejson.min.js"></script>
  <script src="<%= request.getContextPath()%>/js/bookCategoryList.js"></script> <!-- js 넣기 -->
  
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookSearchCss.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/main/main.css" />
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
  currentSortType = 'popularity'; // 기본값 추가

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
	  
  		
    const category = new URLSearchParams(window.location.search).get('category');
    
    // 카테고리
    if (category) {
        $('#category-title').text(category + ' 도서 목록');
          
       	// 🔥 결과 영역 표시
        $('#searchResults').show();
        $('#noResults').hide();
        $('#loading').hide();
          
        // 카테고리명을 검색 결과 헤더에도 표시
        $('#sword-result').text(decodeURIComponent(category));

        loadCategoryList(category, currentPage, currentSortType);
          
        // 카테고리용 페이지네이션 이벤트 등록
        $(document).on('click', '.page-btn[data-page]', function() {
        	
            const page = $(this).data('page');
              
            if(page === 'prev') {
                currentPage = parseInt($('.page-number').first().text()) - 1;
            } else if(page === 'next') {
                currentPage = parseInt($('.page-number').last().text()) + 1;
            } else {
                currentPage = parseInt(page);
            }
              
            // 카테고리 페이지네이션은 loadCategoryList 호출
            loadCategoryList(category, currentPage, currentSortType);
        });
          
        // 카테고리용 정렬 이벤트
        $('#sortType').on('change', function() {
            currentSortType = $(this).val();
            currentPage = 1;
            loadCategoryList(category, currentPage, currentSortType);
        });

      // 검색 이벤트 할 때
      } else {
    	  
      	  // ** 새로고침 해도 이전 상태가 유지될 수 있도록 **
  		  // 페이지 로드시 URL에서 검색 상태 복원 - 새로고침 해도 이전에 검색했던 요소들이 남아있도록
  		  const urlParams = new URLSearchParams(window.location.search);
  		  const urlStype = urlParams.get('stype');
  		  const urlSword = urlParams.get('sword');
  		  const urlSortType = urlParams.get('sortType');
  		  const urlPage = urlParams.get('currentPage');
  		
  		  console.log("url: " + urlStype + " " + urlSword + " " + urlSortType + " " + urlPage); 
  		
  		  bookSearchListBasic(urlStype, urlSword, urlSortType);

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
      } // 카테고리 if-else문 끝
          
      
      //-------공통 이벤트 부분      
      // 정렬 옵션 변경 이벤트 추가 - 책 검색할 때 정렬
   	  $('#sortType').on('change', function() {
   	       currentSortType = $(this).val();
   	       currentPage = 1; // 정렬 변경시 첫 페이지로
   	    	
   	       console.log("currentSortType: " + currentSortType)
   	       bookSearchListBasic(urlStype, urlSword, currentSortType); // 다시 검색 실행
   	  });
   		
   	  // 검색 버튼 클릭 이벤트 - 카테고리 페이지에서 수정
 	  $('#search-btn').on('click', function() {  
 		  
 	       const stype = $('#stype').val();
 		   const sword = $('#sword').val().trim();
 			
 		   // 카테고리 페이지가 아닐 때만 sword-result 업데이트
 		   const category = new URLSearchParams(window.location.search).get('category');
 		   if (!category) {
 		       $('#sword-result').text(sword || '전체');
 		   }

 		   console.log(stype, sword);
 		    
 		   currentPage = 1;
 		   bookSearchListBasic('', sword, 'popularity'); // 검색 실행
 		   console.log("검색버튼 클릭");

 		   location.href = `<%=request.getContextPath()%>/bookSearch/bookSearchRes.jsp?stype=\${stype}&sword=\${sword}&sortType=popularity&currentPage=1`;
 	    
 	  });
   	
 	  $('#sword').on('keydown', function(e) {
 		  
 		  if(e.keyCode == 13 || e.which == 13) {
 			  
 		      e.preventDefault(); // 기본 동작 방지
 		      $('#search-btn').click();
 		  }
 	  });
 	  
		///////////////////////////////////////////////////////////////
		//************** 바로 구매 & 장바구니 버튼 이벤트(가영) ***************//
		///////////////////////////////////////////////////////////////
		
		// 바로 구매 버튼 클릭 이벤트 생성
		  $(document).on('click', '.btn.btn-buy', function(e) {  
			e.stopPropagation();
			alert("구매 페이지로 이동합니다.");
			
			console.log(this);
			
			bookNo = $(this).parents('.book-item').data('bookno');
			/*const categoryBook = $(this).closest('.book-item')[0];
			console.log(categoryBook.getAttribute('data-bookno')) */
			
			// 세션 추가 및 세션 객체 접근
			const sessionStorage = window.sessionStorage;
			// sendArr 배열에 도서 번호와 수량 담고 / 세션에 저장 후, 구매 페이지에서 꺼낼 예정
			const sendArr = []; 
			
			// 현재 상품의 도서 번호와 수량 가져와서 세션에 저장
			// let currentValue = parseInt($('.qty-input').val());
			sendArr.push({book_no : bookNo, cart_qty : 1});
			
			// 배열을 JSON 문자열로 변환하여 세션 스토리지에 저장 (세션 스토리지는 문자열 데이터만 저장 가능, 문자열로 변환하여 전송)
			sessionStorage.setItem('sendArr', JSON.stringify(sendArr));
			
			// 사은품 페이지(구매 페이지)로 이동
			window.location.href=mypath+"/order/gift_page.jsp";
	
		  })   
		  
		  // 장바구니 버튼 클릭 이벤트 생성
		  $(document).on('click', '.btn.btn-cart', function(e) {
			 bookNo = $(this).parents('.book-item').data('bookno');
			 
			// 회원이라면, DB에 장바구니 정보 저장
			if (memMail != null && memMail != "") {
				
				/* let currentValue = parseInt($('.qty-input').val()); */
				const sendInsertData = {
					cust_id : memMail,
					book_no : bookNo,
					cart_qty : 1
				};
				
				insertCart(sendInsertData);
				
			// 비회원이라면, 세션에 장바구니 정보 저장
			} else {
				// 세션 추가 및 세션 객체 접근
				const sessionStorage = window.sessionStorage;
				// 비회원 장바구니 값 가져오기
				let cartArr = JSON.parse(sessionStorage.getItem("cartArr"));
				// 만약 비어있다면 도서 번호와 수량을 담을 cartArr 배열 생성
				if (cartArr == null) {
					cartArr = [];
				}
				
				// 비회원 장바구니에 중복으로 담을 수 없게 하는 로직
				let dupl = false;
				// 비회원 장바구니의 모든 도서 번호 조회
				$.each(cartArr, function(index, item) {
					// 장바구니에 이미 도서가 있다면 true
					if (item.book_no == bookNo) {
						dupl = true;
					}			
				})
				
				if (dupl) {
					alert("장바구니에 이미 상품이 있습니다."); 
				} else {
					// 현재 상품의 도서 번호와 수량 가져와서 세션에 저장
					/* let currentValue = parseInt($('.qty-input').val()); */
					cartArr.push({book_no : bookNo, cart_qty : 1});
					
					// 배열을 JSON 문자열로 변환하여 세션 스토리지에 저장 (세션 스토리지는 문자열 데이터만 저장 가능, 문자열로 변환하여 전송)
					sessionStorage.setItem('cartArr', JSON.stringify(cartArr));
						
					 e.stopPropagation();
					let result = confirm("장바구니에 추가 되었습니다. (비회원)\n장바구니로 이동할까요?");
					
					if (result) {
						window.location.href=mypath+"/cart/cart_page.jsp";
					}
				}
			}
		 })
		  
		////////////////////////////////////////////////////////////////
		//************************** 끝(가영) **************************//
		////////////////////////////////////////////////////////////////

  }) // $(function(){}) 끝
  
  
  //카테고리 버튼 영역 추가함 
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
    
    <!-- 헤더 영역 -->
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

    <!-- 메인 컨테이너 -->
    <div class="main-container">

        <div id="searchResults" style="display: none;">
            <!-- 도서 검색 결과 헤더 -->
            <div class="result-word">
                    카테고리 <span id="sword-result">0</span>
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