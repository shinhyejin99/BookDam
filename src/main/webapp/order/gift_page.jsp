<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
 <title>사은품 선택</title>
  
 <style>     
    .container {
	  display: flex;
	  justify-content: center;       /* 가로 중앙 정렬 */
	  align-items: flex-start;       /* 위쪽 정렬 (필요 시 center로 변경) */
	  gap: 40px;                     /* gift-section과 summary 사이 여백 */
	  min-height: 750px;
	  max-width: 1200px;             /* 최대 너비 제한 */
	  margin: 0 auto;                /* 브라우저에서 가운데 정렬 */
	  padding: 10px;
	}
	
    .gift-section {
	  width: 88%;
	  padding: 3%;
	  /* border: 2px solid orange; */
	  position: relative;
  	  left: -130px; /* 왼쪽으로 이동 */
  	  
  	  /* 만약 배경이 흰색이 아니면 */
  	  border-radius: 15px;
  	  background-color: white;
  	  /* box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); */
	}
	
	.gift-section-inner {
		width: 90%;
		margin: 0 auto 30px auto;
	}
	
    .gift-section h2 {
	  /* color: #FF4D6D; */
	  color : #272727;
	  font-weight: bold;
	 /*  margin-bottom : 50px; */
	  margin-bottom : 0px;
	}
	
	.result-word {
	  width: 90%;
	  margin: 0 auto 20px auto;
	  color : #272727;
	}
	
	.gift-amt {
	  width: 92%;
	  margin: 0 auto;
	  color: #2e2e2e;
	}

    .gift-group {
	  margin-top: 30px;
	}


    .gift-options {
	  display: flex;
	  flex-direction: row;
	  gap: 20px;
	  margin-top: 30px;
	 /*  border: 2px solid green; */
	  
	  justify-content: space-evenly; /* 또는 center, space-between */
	}
	
	.gift {
	  text-align: center;
	  width: 100px;
	 /* border: 2px solid purple; */
	}
		
	
    .gift img {
	  width: 150px;
	  height: auto;
	  border-radius: 10px;
	}
	
    .gift input[type="radio"] {
	  margin-top: 10px;
	}
	
    .disabled { 
    	opacity: 0.3;
    	pointer-events: none; 
    }
    
    .giftCard {
    	width: auto;
    	border: 2px solid gray;  
    	padding: 8px; 
    	border-radius: 10px;    	
    	background-color: white;
    	
    	flex: none;
    }
    
   .gift-count-hr {
	   	margin: 20px auto 3% auto; /* 상하 여백 + 가운데 정렬 */
	   	/* border-color: #272727; */
	   	
	   	height : 1.1px;
    	/* background-color : #272727; */
    	background-color : #D5D5D5;
    	border : none;
   }
    
   .gift-hr {
    	weight : 100%;
    	height : 1px;
    	background-color : #D5D5D5;
    	border : none;
    	margin: 5% auto 3% auto; /* 상하 여백 + 가운데 정렬 */
    }
    
  </style>


<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/summaryCss.css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookSearchCss.css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/main/main.css">
<script src="../js/jquery-3.7.1.js"></script>
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



////////////////// gift_page.jsp만 새로 추가 ///////////////////
const sendArr = JSON.parse(sessionStorage.getItem("sendArr"));
if (sendArr) {
	console.log("선택한 도서(세션) :  ", sendArr)
} else {
	console.log("세션 값 없음")
}
/////////////////////////////////////////////////////////////



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
	getGiftInfo();
	
	getBookInfo();
	
	// giftArr 세션 비우기
	sessionStorage.setItem('giftArr', null);
	
	// 다음 버튼을 누르면 체크된 값을 giftArr 세션에 저장
	$('#btn-next').on('click', function() {
		const sessionStorage = window.sessionStorage;
		const giftArr = [];
		
		console.log($('input[type="radio"]:checked').length)
		
		if($('input[type="radio"]:checked').length < count) {
			alert("사은품을 모두 선택해 주세요.")
		} else {
			// 선택된 사은품 가져와서 세션에 저장
			$('input[type="radio"]:checked').each(function(i, v) {
				console.log("체크 된 값 " + $(v).val());
				giftArr.push({gift_no : $(v).val()});
			
				// 배열을 JSON 문자열로 변환하여 세션 스토리지에 저장 (세션 스토리지는 문자열 데이터만 저장 가능, 문자열로 변환하여 전송)
				sessionStorage.setItem('giftArr', JSON.stringify(giftArr));
				
			})
			// 다음 페이지로 이동(배송지 입력창 'delivery_info.jsp')
			window.location.href='./delivery_info.jsp';
		}
	});
	
	// 검색 버튼 클릭 이벤트 (필수)
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

// DB에서 사은품 정보를 얻어오는 메소드
const getGiftInfo = () => {
	$.ajax({
		url : '<%=request.getContextPath()%>/GetGiftInfo.do',
		method : 'get',
		dataType : 'json',
		
		success: function(res) {
			console.log("res : ", res);
			 $.each(res, function(index, item) {
				 
				// 2만원대 사은품이면 첫 줄에 표시
				if (item.gift_amt == 2) {
					console.log("2만원대 : " + item.gift_name);
					code = `<div class="giftCard">
								<label class="gift">
				            		<img src=\${item.gift_image} alt=\${item.gift_name}>
				           			<div><input type="radio" name="\${item.gift_amt}" value="\${item.gift_no}"> \${item.gift_name}</div>
		          				</label>
		          			</div>`;
		          	$('.gift-options-2').prepend(code);
		          	
		        // 5만원대 사은품이면 두 번째 줄에 표시
				} else if (item.gift_amt == 5) {
					console.log("5만원대 : " + item.gift_name);
					code = `<div class="giftCard">
						<label class="gift">
	            		<img src=\${item.gift_image} alt=\${item.gift_name}>
	           			<div><input type="radio" name="\${item.gift_amt}" value="\${item.gift_no}"> \${item.gift_name}</div>
          			</label>
          			</div>`;
					$('.gift-options-5').prepend(code);
					
				// 10만원대 사은품이면 세 번째 줄에 표시
				} else if (item.gift_amt == 10){
					console.log("10만원대 : " + item.gift_name);
					code = `<div class="giftCard">
					<label class="gift">
	            		<img src=\${item.gift_image} alt=\${item.gift_name}>
	           			<div><input type="radio" name="\${item.gift_amt}" value="\${item.gift_no}"> \${item.gift_name}</div>
          			</label>
          			</div>`;
					$('.gift-options-10').prepend(code);
				}
			}) 
		},
		error: function(xhr) {
			console.log(xhr.status);
		}
	});
}

// async, await로 바꾸는 방법 생각해보기
<%-- const getBookInfo = () => {
	let total = 0;
	$.each(sendArr, function (index, item) {
		$.ajax({
			url : '<%=request.getContextPath()%>/GetBookInfo.do',
			method : 'get',
			data : {book_no : item.book_no},
			dataType : 'json',
			
			success : function(res) {
				// 주문 합계 카드에 정보 삽입
				console.log("도서 금액 : " + res.book_price + " 권 수 : " + item.cart_qty);
				total += res.book_price * item.cart_qty;
				console.log("합계1 : " + total);
			
				code1 = `<br>\${res.book_title} \${item.cart_qty}권`;
				code2 = `<br>\${res.book_title} \${item.cart_qty}권: \${(res.book_price * item.cart_qty).toLocaleString()}원`;
				
				$('#order_qty').append(code1);
				$('#order_price').append(code2);
				$('#total').text(total.toLocaleString() + "원");
				
				if (total >= 20000 && total < 50000) {
					// 2 만원 이상 구매
					$('#giftCount').html('사은품을 <strong>1개</strong> 받을 수 있어요');
					// disabled 클래스를 추가해서 클릭 못하게 하는 css 설정
					$('.gift-group-5').addClass('disabled');
					$('.gift-group-10').addClass('disabled');
					
				} else if (total >= 50000 && total < 100000) {
					// 5 만원 이상 구매
					$('#giftCount').html('사은품을 <strong>2개</strong> 받을 수 있어요');
					// disabled 클래스를 추가해서 클릭 못하게 하는 css 설정
					$('.gift-group-10').addClass('disabled');
					
				} else if (total >= 100000) {
					// 10 만원 이상 구매
					$('#giftCount').html('사은품을 <strong>3개</strong> 받을 수 있어요');
					
				} else {
					// 2만원 이하 구매시
					$('#giftCount').html('아쉽지만 사은품을 받을 수 없어요');
					// disabled 클래스를 추가해서 클릭 못하게 하는 css 설정
					$('.gift-group-2').addClass('disabled');
					$('.gift-group-5').addClass('disabled');
					$('.gift-group-10').addClass('disabled');
				}
			},
			error : function(xhr) {
				console.log(xhr.status);
			}
		})
	})
}
 --%>
 
 // 선택한 도서 정보를 세션에서 얻어와 보여주는 메소드
 const getBookInfo = async() => {
	 let total = 0;
	 let code1 = "";
	 let code2 = "";
	 
	 const promises = sendArr.map(item => {
		 console.log(item.book_no)
			return $.ajax({
				url: '<%=request.getContextPath()%>/GetBookInfo.do',
				method: 'get',
				data: { book_no: item.book_no },
				dataType: 'json'
			}).then(res => {
			     console.log("도서 금액 : " + res.book_price + " 권 수 : " + item.cart_qty);
			     total += res.book_price * item.cart_qty;

			     code1 += `<br>\${res.book_title} \${item.cart_qty}권`;
			     code2 += `<br>\${res.book_title} \${item.cart_qty}권: \${(res.book_price * item.cart_qty).toLocaleString()}원`;
			});
		});
	// 모든 AJAX 요청이 끝난 뒤 실행
	await Promise.all(promises);
	
	// 주문 합계 카드에 상품 수, 상품 금액, 전체 주문 금액 표시
	$('#order_qty').append(code1);
	$('#order_price').append(code2);
	/* $('#total').text(total.toLocaleString() + "원"); */
	// 총 결제 금액 업데이트
	$('#total-text1').text(total.toLocaleString());
	$('#total-text2').text(total.toLocaleString());
	
	// 금액대 별 문구 다르게 표시
	if (total >= 20000 && total < 50000) {
		// 2 만원 이상 구매
		$('#giftCount').html('사은품을 <strong style="color: #FF4D6D; font-size: 1.6rem">1</strong>개 받을 수 있어요');
		// disabled 클래스를 추가해서 클릭 못하게 하는 css 설정
		$('.gift-group-5').addClass('disabled');
		$('.gift-group-10').addClass('disabled');
		
		count = 1;
		
	} else if (total >= 50000 && total < 100000) {
		// 5 만원 이상 구매
		$('#giftCount').html('사은품을 <strong style="color: #FF4D6D; font-size: 1.6rem">2</strong>개 받을 수 있어요');
		// disabled 클래스를 추가해서 클릭 못하게 하는 css 설정
		$('.gift-group-10').addClass('disabled');
		
		count = 2;
		
	} else if (total >= 100000) {
		// 10 만원 이상 구매
		$('#giftCount').html('사은품을 <strong style="color: #FF4D6D; font-size: 1.6rem">3</strong>개 받을 수 있어요');
		
		count = 3;
		
	} else {
		// 2만원 이하 구매시
		$('#giftCount').html('아쉽지만 사은품을 받을 수 없어요');
		// disabled 클래스를 추가해서 클릭 못하게 하는 css 설정
		$('.gift-group-2').addClass('disabled');
		$('.gift-group-5').addClass('disabled');
		$('.gift-group-10').addClass('disabled');
		
		count = 0;
	}
 }
 
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

			                <!-- <button onclick="location.href= mypath + '/attendance/attendance.jsp'" class="icon-btn" title="출석체크">❤️</button> -->
			              	<!--<button class="icon-btn" title="장바구니">🛒</button>-->

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
    <div class="gift-section">
    <div class="result-word">🎁 사은품 선택</div>
    
    <div class="gift-section-inner">
	      <h2 id="giftCount"></h2>
	      <hr class="gift-count-hr">
	
	      <!-- 2만원 이상 -->
	      <div class="gift-group-2">
	        <h3 class="gift-amt">2만원 이상 구매 시 선택 가능 (2종 중 1택)</h3>
	        <div class="gift-options gift-options-2">
	        
	        	<div class="giftCard">
					<label class="gift">
	           			<img src="../images/x-mark3.jpg" alt="사진 오류">
	          			<div><input type="radio" name="2" value="999">받지 않음</div>
	        		</label>
	        	</div>
	
	        </div>
	      </div>
	      
	      <hr class="gift-hr"/>
	
	      <!-- 5만원 이상 -->
	      <div class="gift-group-5">
	        <h3 class="gift-amt">5만원 이상 구매 시 선택 가능 (2종 중 1택)</h3>
	        <div class="gift-options gift-options-5">
	         
	        	 <div class="giftCard">
					<label class="gift">
	           			<img src="../images/x-mark3.jpg" alt="사진 오류">
	          			<div><input type="radio" name="5" value="999">받지 않음</div>
	        		</label>
	        	</div>	
	        </div>
	      </div>
	      
	      <hr class="gift-hr"/>
	
	      <!-- 10만원 이상 -->
	      <div class="gift-group-10">
	        <h3 class="gift-amt">10만원 이상 구매 시 선택 가능 (2종 중 1택)</h3>
	        <div class="gift-options gift-options-10">
	          
	          <div class="giftCard">
					<label class="gift">
	           			<img src="../images/x-mark3.jpg" alt="사진 오류">
	          			<div><input type="radio" name="10" value="999">받지 않음</div>
	        		</label>
	        	</div>
	        	
	        </div>
	      </div>
	      
	      <hr class="gift-hr"/>
	      
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

</body>
</html>