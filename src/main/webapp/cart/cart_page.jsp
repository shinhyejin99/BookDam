<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니</title>

<style>

    .container {
	  display: flex;
	  justify-content: center;       /* 가로 중앙 정렬 */
	  align-items: flex-start;       /* 위쪽 정렬 (필요 시 center로 변경) */
	  gap: 40px;                     /* gift-section과 summary 사이 여백 */
	  min-height: 700px;
	  max-width: 1200px;             /* 최대 너비 제한 */
	  margin: 0 auto;                /* 브라우저에서 가운데 정렬 */
	  padding: 10px;
	  
	}
	
    .cart-section {
	  width: 88%;
	  padding: 3%;
	  position: relative;
  	  color: #272727;
  	  
  	 /*  border: 2px solid orange; */
  	  left: -130px; /* 왼쪽으로 이동 */
  	  
  	  /* 만약 배경이 흰색이 아니면 */
  	  border-radius: 15px;
  	  background-color: white;
  	  /* box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); */
	}
	
	.result-word {
	  width: 90%;
	 /*  border: 2px solid pink; */
	  margin: 0 auto 30px auto;
	}

  table {
    width: 90%;
    margin: 10px auto;
    border-collapse: collapse;
  }
  
  th, td {
    border : none;
    padding: 10px;
    text-align: center;
  }
  
  th {
    background-color: #f2f2f2;
  }
  
  tr{
 	 border-top: 1px solid #ccc;
	 border-bottom: 1px solid #ccc;
  }
  
	.col-name {
	  width: 150px; /* 상품명 너비 줄임 */
	}
	
	.col-qty {
	  width: 120px; /* 수량 열 너비 늘림 */
	}
  
  
  img {
    height : 150px;
  }
  
  .col-checkbox {
  	width : 6%;
  }
  
  .col-name {
  	width : 30%;
  }
  
  .col-cover, .col-price, .col-qty, .col-totalPrice {
  	width : 16%;
  }
  
   /* 장바구니 수량조절 */
   .qty-controls {
	   display: flex;
	   align-items: center;
	   border: 2px solid #ddd;
	   border-radius: 6px;
	   overflow: hidden;
	   width: 110px;
	   height: 40px;
	   
	   margin: 0 auto;
	}
	
	.qty-btn {
	    width: 36px;
	    height: 40px;
	    border: none;
	    background: #f8f9fa;
	    cursor: pointer;
	    font-size: 19px;
	    /* font-weight: bold; */
	    color: #666;
	}
	
	.qty-btn:hover {
	    background: #e9ecef;
	    color: #333;
	}
	
	.qty-val {
	    flex: 1;
	    text-align: center;
	    border: none;
	    font-size: 16px;
	    /* font-weight: bold; */
	    background: white;
	    cursor: default;
	}
	
	.qty-val:focus {
	    outline: none;
	}
	
	.del-btn {
	  display: flex;
	  width: 90%;
	  margin: 0 auto 30px auto;  
	  
	}
	
	#deleteCartItemBtn:hover {
		background: #404040;
	}
  
   hr {
    	height : 1px;
    	background-color : #e9ecef;
    	border : none;
    }

    .summary{
   		margin-top: 100px;
   } 

    
</style>

<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/summaryCss.css">
<script src="../js/jquery-3.7.1.js"></script>
<script src="../js/cart.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookSearchCss.css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/main/main.css">

<!-- /////////////////////////// 장바구니 내역 출력 /////////////////////////// -->
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

if (logUser != null) {
	console.log("회원 정보(세션) : " + logUser.mem_mail);
} else {
	// 비회원 장바구니 세션 값 가져오기
	cartArr = JSON.parse(sessionStorage.getItem("cartArr"));
	if (cartArr) {
		console.log("비회원 장바구니(세션) : ", cartArr)
	} else {
		console.log("세션 값 없음")
	}
}


total =  0;	// total은 순수 총 금액

// html이 로드되고
$(function() {
	
	// 카트 리스트 가져오기
	if (logUser != null && logUser.mem_mail != "undefined") {
		getCartInfo();		
	} else {
		console.log("비회원 장바구니 조회");
		getSessionCartInfo();
	}
	
	// 페이지 로드 후 체크된 상품이 없다면(.itemCheckbox:checked 의 legnth 값이 0이라면) '삭제', '다음' 버튼 비활성화
	if ($('.itemCheckbox:checked').length < 1) {
		$('#btn-next').prop('disabled', true);
		$('#deleteCartItemBtn').prop('disabled', true);
		$('#btn-next').css('background-color', '#ccc');
		$('#deleteCartItemBtn').css('background-color', '#eee');
		$('#deleteCartItemBtn').css('color', 'gray');
	}

	// 체크 박스를 클릭할 때마다 '삭제', '다음' 버튼 상태 조절
	$(document).on('change', 'input[type="checkbox"]', function() {
		
		// 체크된 상품이 없다면 '삭제', '다음' 버튼 비활성화
		if ($('.itemCheckbox:checked').length < 1) {
			$('#btn-next').prop('disabled', true); // 다음
			$('#deleteCartItemBtn').prop('disabled', true); // 삭제
			$('#btn-next').css('background-color', '#ccc');		
			$('#deleteCartItemBtn').css('background-color', '#eee');
			$('#deleteCartItemBtn').css('color', 'gray');
			
			
		// 체크된 상픔이 있다면 '삭제', '다음' 버튼 활성화
		} else {
			$('#btn-next').prop('disabled', false); // 다음
			$('#deleteCartItemBtn').prop('disabled', false); // 삭제
			$('#btn-next').css('background-color', '#F85A44');
			$('#deleteCartItemBtn').css('background-color', 'gray');
			$('#deleteCartItemBtn').css('color', 'white');
			
		}
		
		// 총 결제 금액 업데이트
		updateTotal();	
	})
	
	// '+', '-' 버튼을 누르면 수량 조절 (동적으로 새로 작성된 요소이기 때문에 delgate 방식)
	$(document).on('click', '.qty-btn', function() {
		
		if ($(this).text() == "-") {
			// 현재 수량 텍스트를 가져옴
			thisQty = $(this).next().text();
			
			// 만약 수량이 1 이하인데 '-' 버튼 클릭하면
			if (thisQty <= 1) {
				// 1로 세팅
				$(this).next().text(1);
				
			// '-' 버튼을 누르면
			} else {
				// 현재 수량에서 -1
				$(this).next().text(thisQty - 1);
				// -1을 적용한 수량을 가져옴
				thisQty = $(this).next().text();
				
				
				// 위에서 구한 수량대로 업데이트
				book_no =  $(this).parents('tr').find('.book_no_td').text();
				
				// 만약 로그인한 회원이면, 카트 수량 DB 업데이트
				if (logUser != null) {
					sendUpdateData = {btn : 0, book_no : book_no, cust_id : logUser.mem_mail};
					updateCartQty(sendUpdateData);
					
				// 비회원이라면 수량 세션 정보 업데이트
				} else {
					$.each(cartArr, function(index, item) {
						if (item.book_no == book_no) {
							item.cart_qty = thisQty;
							console.log("비회원 세션 cart_qty 조작 : " + item.cart_qty);
							//sessionStorage.setItem()
						}
					})
				}
				
				// '-' 버튼 누를 때마다 도서 가격 * 수량 가격 변경 
				this_tr = $(this).parents('tr');
				let book_price = this_tr.find($('.book_price_td')).text().replaceAll(',', '');
				this_tr.find($('.total_td')).text((thisQty * book_price).toLocaleString());
				
				// 체크박스에 체크된 상태라면
				if ($(this).parents('tr').find('.itemCheckbox').prop('checked')) {
					// 체크한 항목의 '총합' 가져오기
					updateTotal();
				}
			}
			
		// '+' 버튼을 누르면
		} else {
			// 현재 수량 텍스트를 가져옴
			thisQty = $(this).prev().text();
			// 현재 수량에서 +1
			$(this).prev().text(parseInt(thisQty) + 1);
			// +1을 적용한 수량을 가져옴
			thisQty = $(this).prev().text();
			
			
			// 위에서 구한 수량대로 업데이트
			book_no =  $(this).parents('tr').find('.book_no_td').text();
			
			// 만약 로그인한 회원이면, 카트 수량 DB 업데이트
			if (logUser != null) {
				sendUpdateData = {btn : 1, book_no : book_no, cust_id : logUser.mem_mail};
				updateCartQty(sendUpdateData);
				
			// 비회원이라면 세션 정보 업데이트
			} else {
				$.each(cartArr, function(index, item) {
					if (item.book_no == book_no) {
						item.cart_qty = thisQty;
						console.log("비회원 세션 cart_qty 조작 : " + item.cart_qty);
					}
				})
			}
			
			
			// '+' 버튼 누를 때마다 도서 가격 * 수량 가격 변경 
			this_tr = $(this).parents('tr');
			let book_price = this_tr.find($('.book_price_td')).text().replaceAll(',', '');
			this_tr.find($('.total_td')).text((thisQty * book_price).toLocaleString());
			
			// 체크박스에 체크된 상태라면
			if ($(this).parents('tr').find('.itemCheckbox').prop('checked')) {
				// 체크한 항목의 '총합' 가져오기
				updateTotal(this);
			}
		}
	})
	
	
	// '장바구니에서 삭제' 버튼 누르면...
	$('#deleteCartItemBtn').on('click', function() {
		const delArr = []; // 삭제될 도서 번호를 담을 배열 생성
		$('.itemCheckbox:checked').each(function(i, v) {
			// 체크된 상품의 도서 번호 가져와서 delArr에 push
			let book_no = $(v).parents('tr').find('td.book_no_td').text();
			delArr.push({book_no : book_no});
		})
		
		// 로그인한 유저는 DB에서 삭제
		if (logUser != null && logUser.mem_mail != "undefined") {
			// 서버에 전송할 데이터 만들기 {cust_id : logUser.mem_mail, book_no : [{book_no:123456}, {book_no:789123}] }
			const sendDelData = {
				cust_id : logUser.mem_mail,
				book_no : delArr
			};	
			// cart_detail 테이블에서 삭제
			deleteCartItem(sendDelData);
			location.reload();
			
		} else {
			$('.itemCheckbox:checked').each(function(i, v) {
				// 체크된 상품의 도서 번호들 가져오기
				let book_no = $(v).parents('tr').find('td.book_no_td').text();
				
				// 객체 배열의 특정 요소 제거하기 위해서 filter() 사용
				cartArr = cartArr.filter(item => item.book_no !== book_no);
				
				// carrArr 세션에 다시 저장
				sessionStorage.setItem("cartArr", JSON.stringify(cartArr));
				
				// 세션 저장 후 페이지 새로고침해서 반영
				location.reload();
			})
		}
		
		// 총 결제 금액 업데이트
		$('#total-text1').text(0);
		$('#total-text2').text(0);
	})
	
	
	// '다음 페이지로 이동' 버튼 누르면...
	$('#btn-next').on('click', function() {
		// 세션 객체 접근
		const sessionStorage = window.sessionStorage;
		const sendArr = []; // 도서 번호를 담을 배열 생성
		
		// 체크된 상품의 도서번호 가져와서 세션에 저장
		$('.itemCheckbox:checked').each(function(i, v) {
			let book_no = $(v).parents('tr').find('td.book_no_td').text();
			let cart_qty = $(v).parents('tr').find('td div span.qty-val').text();
			
			sendArr.push({book_no : book_no, cart_qty : cart_qty});
		})
		
		// 배열을 JSON 문자열로 변환하여 세션 스토리지에 저장 (세션 스토리지는 문자열 데이터만 저장 가능, 문자열로 변환하여 전송)
		sessionStorage.setItem('sendArr', JSON.stringify(sendArr));
		
		// 다음 페이지로 이동(사은품 화면 'gift_page.jsp')
		location.href=`<%=request.getContextPath()%>/order/gift_page.jsp`;
	})
	
<%-- 	$('#search-btn').click(function() {
		const stype = $('#stype').val();
		const sword = $('#sword').val();
		
		location.href = `<%=request.getContextPath()%>/bookSearch/bookSearchRes.jsp?stype=${stype}&sword=${sword}&sortType=popularity&currentPage=1`;
	}) --%>
	
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
	/* alert("선택된 카테고리:"+ category); */
    closeCategoryMenu();
    
    window.location.href = '<%=request.getContextPath()%>/bookSearch/bookCategoryList.jsp?category=' + encodeURIComponent(category);
}


</script>

<!-- //////////////////////////////////////////////////////////////////////// -->
  
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

    <!-- 메인 컨테이너 -->
    <div class="container">
		<div class="cart-section">
		   <div class="result-word">🛒 장바구니</div>
		
			<table>
			  <thead>
			    <tr>
			      <th class="col-checkbox"><input type="checkbox" id="selectAll"></th>
			      <th class="col-cover">표지</th>
			      <th class="col-name">상품명</th>
			      <th class="col=price">가격</th>
			      <th class="col-qty">수량</th>
			      <th class="col-totalPrice">합계</th>
			    </tr>
			  </thead>
			  <tbody id="cartBody">
			    <!-- 추가 상품 row는 여기에 동적으로 생성 가능 -->
			  </tbody>
			</table>
		
		
		<div class="del-btn">
		  <button class="btn" id="deleteCartItemBtn">선택 삭제</button>
		  <!-- <button class="btn" id="btn-next"> 다음 </button> -->
		</div> 
		
		</div>
		
		<div class="summary">
	      <div id="summary-title"><h3>주문합계</h3></div>
	      <div class="price-container">
	        <strong>상품 금액</strong>
	        <div><span id="total-text1">0</span>원</div>
	      </div>
	      <div class="deliveryprice-container"><strong>배송비</strong>무료배송</div>
	      
	      <hr class="summary-hr">
          
          <div class="totalprice-container">전체 주문 금액
          	<br>
          	<div class="totalprice-section">
          		<strong id="total-text2">0</strong><strong>원</strong>
          	</div>
          </div>
          <button id="btn-next" class="btn-next">다음</button>
	    </div>
		
	</div>

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
	
		<script>
		  // 전체 선택 체크박스 제어
		  document.getElementById('selectAll').addEventListener('change', function() {
		    const checkboxes = document.querySelectorAll('.itemCheckbox');
		    checkboxes.forEach(cb => cb.checked = this.checked);
		    
		  });
</script>
</body>
</html>