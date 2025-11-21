<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>   
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Insert title here</title>
  <script src="<%=request.getContextPath() %>/js/jquery-3.7.1.js"></script>
  
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookSearchCss.css">
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookDetailCss.css">
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/main/main.css">
  <title>도서 상세</title>

  <script src="<%=request.getContextPath() %>/js/bookDetail.js"></script>
  <!-- <script src="../js/review.js"></script> -->
  
  <style>
  footer : 60px;
  }

  </style>
  
  <script>
  
  
//////////////////다른 페이지에도 필수로 넣어야 하는 이벤트 //////////////////  
<%
	MemVO mvo = (MemVO) session.getAttribute("loginOk");
	
	String user = null;
	Gson gson = new Gson();
	
	//////////////// bookDetail.jsp만 새로 추가 ///////////////// 
	// 회원 등급별 마일리지 적립률 표시하기 위해 추가함
	if (mvo != null) {
		user = gson.toJson(mvo);
		/* memGrade = mvo.getMem_grade();
		
		if("일반등급".equals(memGrade)) mileageRate = 0.05;
		else if("실버".equals(memGrade)) mileageRate = 0.07;
		else if("골드".equals(memGrade)) mileageRate = 0.08;
		else if("다이아몬드".equals(memGrade)) mileageRate = 0.1; */
	}
	/////////////////////////////////////////////////////////
%>

// BookDam (프로젝트 이름)
mypath = '<%= request.getContextPath()%>';  
// 로그인 유저 객체
logUser = <%= user == null ? "null" : user %>;
  
/////////////////////////// bookDetail.jsp만 새로 추가 //////////////////////////// 
bookNo = '${book.book_no}';  // 서버에서 전달받은 도서번호 - review 서버로 보낼 때 사용한다!!
memMail = '${sessionScope.loginOk.mem_mail}'// 회원 이메일 - 서버로 보낼 때 변수 사용!!!
currentReviewPage  = 1; // 리뷰 시작페이지 1
currentTab = 'all'; // 탭 기본은 전체로 변경!
currentSort = 'likes'; // 기본 정렬은 좋아요 순!

// 추가
memGrade = '비회원';
mileageRate = 0;
bookPrice = '${book.book_price}';
///////////////////////////////////////////////////////////////////////////////
  
//로그인 확인용 콘솔창
if(logUser != null) {
	console.log("현재 로그인ID :" + logUser.mem_mail);
	memMail = logUser.mem_mail;
	
} else {
	console.log("로그인 상태 : 비회원");
	memMail = null;
}

//로그아웃 클릭시...
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
	  // 도서정보섹션 : 회원 등급 출력
	  updateMileageInfo();
	  
	  // 도서정보섹션에 있는 별점 부분 div 클릭하면 하단의 리뷰섹션으로 이동
	  scrollReview();
	  
	  // 베스트셀러 스티커 표시
	  let bestRank = ${bestRank != null ? bestRank : 0};
	  let rankDisplay = '';
	  
	  if (bestRank && bestRank > 0) { // 10위 밖인 애들!
	    
		  //rankDisplay = bestRank + '위';
	    	
	      if (bestRank <= 10) { // 1~10위인 애들	
	    	  //rankDisplay += ' <button title="best">베스트셀러</button>';
	    	  rankDisplay += ' <img id="rank-sticker" src="/BookDam/images/베스트아이콘.png" alt="/BookDam/images/베스트아이콘.png">';
	      } 
	  }
	  $('#best-rank-display').html(rankDisplay);
	  
	  ////////////////////다른 페이지에도 필수로 넣어야 하는 이벤트 //////////////////////
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
	  ////////////////////////////////////////////////////////////////////////

	  // 리뷰 정렬 옵션 변경 이벤트
	  $('.sort-select').on('change', function() {
		  currentSort = $(this).val();
		  currentReviewPage = 1; // 정렬 변경시 첫 페이지로
		  reviewListPrint(); // 다시 검색 실행
	  });
	  
	  // 탭 부분 강제? 스타일 적용
	  $('.nav-link').css('color', '#000000');
	  $('.nav-link.active').css('color', '#0000CD');
	  
	  // 가격 포맷 (천단위 콤마)
	  let bprice = ${book.book_price != null ? book.book_price : 0};
	  let formattedPrice = bprice.toLocaleString();
	  $('#book-price').text(formattedPrice + '원');
	  
	  
	///////////////////////////////////////////////////////////////
	//************** 바로 구매 & 장바구니 버튼 이벤트(가영) ***************//
	///////////////////////////////////////////////////////////////
	
	// 바로 구매 버튼 클릭 이벤트 생성
	  $('.btn.btn-buy').on('click', function() {  
		alert("구매 페이지로 이동합니다.");
		
		// 세션 추가 및 세션 객체 접근
		const sessionStorage = window.sessionStorage;
		// sendArr 배열에 도서 번호와 수량 담고 / 세션에 저장 후, 구매 페이지에서 꺼낼 예정
		const sendArr = []; 
		
		// 현재 상품의 도서 번호와 수량 가져와서 세션에 저장
		let currentValue = parseInt($('.qty-input').val());
		sendArr.push({book_no : bookNo, cart_qty : currentValue});
		
		// 배열을 JSON 문자열로 변환하여 세션 스토리지에 저장 (세션 스토리지는 문자열 데이터만 저장 가능, 문자열로 변환하여 전송)
		sessionStorage.setItem('sendArr', JSON.stringify(sendArr));
		
		// 사은품 페이지(구매 페이지)로 이동
		window.location.href=mypath+"/order/gift_page.jsp";

	  })   
	  
	  // 장바구니 버튼 클릭 이벤트 생성
	  $('.btn.btn-cart').on('click', function() {
		  
		// 회원이라면, DB에 장바구니 정보 저장
		if (memMail != null && memMail != "") {
			
			let currentValue = parseInt($('.qty-input').val());
			const sendInsertData = {
				cust_id : memMail,
				book_no : bookNo,
				cart_qty : currentValue
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
				let currentValue = parseInt($('.qty-input').val());
				cartArr.push({book_no : bookNo, cart_qty : currentValue});
				
				// 배열을 JSON 문자열로 변환하여 세션 스토리지에 저장 (세션 스토리지는 문자열 데이터만 저장 가능, 문자열로 변환하여 전송)
				sessionStorage.setItem('cartArr', JSON.stringify(cartArr));
					
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


	  // 수량 조절 버튼
	  // 빼기 버튼
	  $('#qty-minus').on('click', function() {
		  let currentValue = parseInt($('.qty-input').val()); // 현재 값(수량) 가져오기
		  if(currentValue > 1) {
			  $('.qty-input').val(currentValue - 1);
		  } else {
			  $('.qty-input').val(1);
		  }
	  })
	  
	  // 더하기 버튼
	  $('#qty-plus').on('click', function() {
		  let currentValue = parseInt($('.qty-input').val()); // 현재 값(수량) 가져오기
		  $('.qty-input').val(currentValue + 1);
	  })
	  
	  
	  // 리뷰 작성
	  reviewInsert();

	  // 처음 탭을 전체로 할 때는 이것만 호출해도 됨
	  reviewListPrint();   // 최종 : 구매자 리뷰 목록 출력
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

  <div class="container">
    <!-- 상단: 도서 정보 -->
    <div class="book-detail-section">
        <div class="book-image-container">
            <img src="${book.cover_img}" alt="${book.book_title}" class="book-image">
        </div>
        <div class="book-info">
        	<div class="book-bestRank"><span id="best-rank-display"></span></div>
            <h1 class="book-title">${book.book_title}</h1>
            <div class="book-meta">
                <div class="book-author">${book.book_author}</div>
                <div class="book-publisher">${book.publisher} ㆍ ${book.book_pubdate}</div>
            </div>
            <div id="info-average-rating"></div>
            
            <div id="book-price">${book.book_price}원</div>
            <div id="memMileage">적립/혜택</div>
            
            <div class="bottom-row">
            	<div>무료배송</div>
	            <div class="action-buttons">
	            	<input type="button" class="btn" disabled value="재고ㆍ${book.stock_qty}">
	            	<div class="qty-control">
					    <input type="button" class="qty-btn" id="qty-minus" value="-">
					    <input type="number" class="qty-input" value="1" min="1" max="99" readonly>
					    <input type="button" class="qty-btn" id="qty-plus" value="+">
					</div>
	                <input type="button" class="btn btn-cart" value="장바구니"> 
	                <input type="button" class="btn btn-buy" value="구매하기">
	            </div>
            </div>
        </div>
    </div>
    
    <!-- 책 소개 -->
    <div class="book-description-section">
        <h2 class="section-title">책 소개</h2>
        <div class="book-description">${book.book_description}</div>
        
        <h3 class="section-title">기본정보</h3>
        <table class="book-info-table">
            <tr><th>ISBN</th><td>${book.book_no}</td></tr>
            <tr><th>발행일</th><td>${book.book_pubdate}</td></tr>
            <tr><th>쪽수</th><td>${book.book_page}쪽</td></tr>
        </table>
    </div>
    
    <!-- 리뷰 섹션 전체 -->
    <div class="review-section">
        
        <!-- 리뷰 작성 영역 -->
        <div class="review-write-section">
            <div class="review-header">
                <span class="review-title">리뷰</span>
                <span class="average-rating"></span>
            </div>
            
            <div class="rating-question">이 작품은 어떠셨나요?</div>
            
            <!-- 별점 선택 -->
            <div class="star-rating">
			    <div class="star-input">
			        <input type="radio" name="rating" value="5" id="star5">
			        <label for="star5" class="star-label"></label>
			    </div>
			    <div class="star-input">
			        <input type="radio" name="rating" value="4" id="star4">
			        <label for="star4" class="star-label"></label>
			    </div>
			    <div class="star-input">
			        <input type="radio" name="rating" value="3" id="star3">
			        <label for="star3" class="star-label"></label>
			    </div>
			    <div class="star-input">
			        <input type="radio" name="rating" value="2" id="star2">
			        <label for="star2" class="star-label"></label>
			    </div>
			    <div class="star-input">
			        <input type="radio" name="rating" value="1" id="star1">
			        <label for="star1" class="star-label"></label>
			    </div>
			</div>
            
            <!-- 리뷰 작성 폼 -->
            <form class="review-form">
                <textarea class="review-textarea" placeholder="리뷰를 10자 이상 입력해 주세요. 타인을 비방 혹은 욕설은 블라인드 처리됩니다."></textarea>
                
                <div class="review-form-footer">
                    <label class="spoiler-checkbox">
                        <input type="checkbox" id="spoilerCheck">
                        <span>스포일러 포함</span>
                    </label>
                    <input type="button" class="submit-btn" value="리뷰 등록">
                </div>
            </form>
        </div>
        
        <!-- 리뷰 목록 영역 -->
        <div class="review-list-section">
            
            <!-- 탭 영역 -->
            <div class="review-tabs">
			  <ul class="nav nav-tabs nav-justified">
			    <li class="nav-item">
			      <button class="nav-link active" onclick="reviewTab('all', this)">
			      	전체 <span id="allReviewCount"></span>
			      </button>
			    </li>
			    <li class="nav-item">
			      <button class="nav-link" onclick="reviewTab('buyer', this)">
			      	구매자 <span id="buyerReviewCount"></span>
			      </button>
			    </li>
			  </ul>
			</div>
            
            <!-- 정렬 옵션 -->
            <div class="review-sort">
                <select class="sort-select">
                    <option value="likes">좋아요 순</option>
                    <option value="latest">최신순</option>
                    <option value="oldest">오래된순</option>
                </select>
            </div>
            
            <!-- 리뷰 목록 -->
            <div class="review-list">
            </div>
            
            <!-- 리뷰 페이지네이션 -->
            <div class="review-pagination">
            </div>
        </div>
    </div>
    
    <!-- 리뷰 수정 모달창 -->
	<div id="editReviewModal" class="modal" style="display: none;">
	    <div class="modal-background"></div>
	    <div class="modal-content">
	        <div class="modal-header">
	            <h3>리뷰 수정</h3>
	            <span class="close-modal">&times;</span>
	        </div>
	        
	        <div class="modal-body">
	            <input type="hidden" id="editReviewId">
	            
	            <!-- 별점 선택 -->
	            <div class="form-group">
	                <label>별점</label>
	                <select id="editRating" required>
	                    <option value="1">★ (1점)</option>
	                    <option value="2">★★ (2점)</option>
	                    <option value="3">★★★ (3점)</option>
	                    <option value="4">★★★★ (4점)</option>
	                    <option value="5">★★★★★ (5점)</option>
	                </select>
	            </div>
	            
	            <!-- 리뷰 내용 -->
	            <div class="form-group">
	                <label>리뷰 내용</label>
	                <textarea id="editContent" rows="6" placeholder="리뷰 내용을 입력하세요" required></textarea>
	            </div>
	            
	            <!-- 스포일러 체크박스 -->
	            <div class="form-group">
	                <label class="checkbox-label">
	                    <input type="checkbox" id="editSpoiler">
	                    스포일러 포함
	                </label>
	            </div>
	        </div>
	        
	        <div class="modal-footer">
	            <button class="close-modal">취소</button>
	            <button class="modal-save">저장</button>
	        </div>
	    </div>
	</div>
  </div> <!-- 컨테이너 끝 -->
  
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