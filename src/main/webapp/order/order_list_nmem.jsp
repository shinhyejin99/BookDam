<%@page import="kr.or.ddit.dam.vo.NoMemVO"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@page import="com.google.gson.Gson"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>주문 내역</title>
  <style>
    /* body {
      font-family: Arial, sans-serif;
      width: 80%;
      margin: 30px auto;
    } */
    
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
	
    .order-section {
	  width: 88%;
	  padding: 2%;
	  position: relative;
  	  color: #272727;
  	  
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

    .order-summary {
      width: 90%;
      border: 1px solid #ccc;
      padding: 25px;
      margin: auto auto 30px auto;
      border-radius: 8px;
      
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    .order-header {
      display: flex;
      justify-content: space-between;
      margin-bottom: 20px;
      font-weight: bold;
    }

    .product-list {
      border-top: 1px solid #eee;
      padding-top: 15px;
      margin-top: 15px;
    }

    .product-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin: 10px 0;
    }

    .product-info {
      flex: 1;
    }

    .review-btn {
       padding: 12px 20px;
       border: none;
       border-radius: 6px;
       font-size: 14px;
       font-weight: bold;
       cursor: pointer;
       transition: all 0.3s ease;
       min-width: 100px;
       background-color: #F86E6E;
	   color: white;
     }

    .review-btn:hover {
          background-color: #e55a5a;
     }

    .order-status {
      margin: 15px 0;
      font-size: 14px;
      color: #555;
    }

    .payment-summary {
      display: flex;
      flex-direction: row;
      justify-content: space-between;
      align-items: center;
      
      text-align: right;
      border-top: 1px solid #ccc;
      margin-top: 20px;
      padding-top: 10px;
    }
    
    .payment-summary button {
	  padding: 8px 12px;
	  font-size: 14px;
	  cursor: pointer;
	}

    .payment-summary div {
      margin: 5px 0;
    }
    
    .price-info {
	  text-align: right;
	}
	
	.cancel-btn {
      background-color: #A8A8A8;
      height: 42px;
      border: none;
      border-radius: 6px;
      font-size: 14px;
      cursor: pointer;
      transition: all 0.3s ease;
      min-width: 100px;
	  color: white;
	}
	
	.cancel-btn:hover {
          background-color: #848484;
     }
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
  
  
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/refundModalCss.css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookSearchCss.css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/main/main.css">
<script src="../js/order_list_nmem.js"></script> 
<script src="../js/jquery-3.7.1.js"></script> 

<script>
//////////////////다른 페이지에도 필수로 넣어야 하는 이벤트 //////////////////
// 비회원 아이디 받아오기
<%
	NoMemVO nmvo = (NoMemVO) session.getAttribute("nmloginOk");
	MemVO mvo = null;
	
	String user = null;
	Gson gson = new Gson();
	if (nmvo != null) user = gson.toJson(nmvo);
%>

mypath = '<%= request.getContextPath()%>';
logUser = <%= user == null ? "null" : user %>;

//로그인 확인용 콘솔창
if(logUser != null) {
	console.log("현재 비회원 :" + logUser.nmem_mail);
	nmemMail = logUser.nmem_mail;
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
	if (<%=mvo%> != null) {
		location.href= mypath + '/myPage/mypage.jsp'
	} else {
		location.href= `\${mypath}/log/login.jsp`	
	}
}

////////////////////////////////////////////////////////////////////



today = new Date();

// 주문번호, 주문 정보(도서번호, 도서이미지, 도서제목, 수량, 가격, 사용 마일리지, 총 결제금액), 배송상황 받아오기
$(function() {
	getOrdersNo_nmem();
	
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
	
    // '리뷰 작성' 버튼 클릭 이벤트
    $(document).on('click', '.review-btn', function() {
    	const bookNo = $(this).siblings('p').text();
    	console.log("bookNo: [" + bookNo + "]");

    	location.href = `<%= request.getContextPath()%>/BookDetail.do?bookNo=\${bookNo}#editReviewModal`;
    })
    
    // '취소 & 반품 버튼 클릭 이벤트'
    $(document).on('click', '.cancel-btn', function() {
    	// 클릭한 주문 내역의 주문 번호, 결제 금액, 수량, 총 구매금액을 가져온다
    	const orderSummary = $(this).parents('.order-summary');
    	modal_order_no = orderSummary.find('.order-header-no').text(); // 모달이 가져갈 주문 번호
    	modal_cancel_amount = orderSummary.find('.item-total_pay').text().replaceAll(",", ""); // 모달이 가져갈 결제 금액
    	const quantity_span = orderSummary.find('.item-qty');
    	
    	modal_quantity = 0; // 모달이 가져갈 총 수량
    	modal_total_amount = 0; // 모달이 가져갈 총 구매 금액
    	$.each(quantity_span, function(i) {
    		modal_quantity += parseInt($(this).text().trim());
    		modal_price = $(this).parents('.product-info').find('.item-price').text().replaceAll(",", "");
    		modal_total_amount += (parseInt($(this).text().trim()) * parseInt(modal_price));
    	})	
    	
    	
    	$('#reason').val("");
    	$('.refund-modal')[0].showModal(); // jQuery 객체에는 showModal이 없다
    })
    
    // '신청' 버튼 클릭 이벤트
    $(document).on('click', '.submit-btn', function() {
    	if (confirm("정말 취소/환불 하시겠습니까?")) {
    		// refund 함수로 이동
	    	refund(this);		
    	}
    });
    
    // '닫기' 버튼 클릭 이벤트
    $(document).on('click', '.close-btn', function() {	
    	/* $('.refund-modal')[0].close();
    	$('.refund-success-modal')[0].close(); */
    	$(this).parents('dialog')[0].close();
    });
    
    // '확인' 버튼 클릭 이벤트
    $(document).on('click', '.confirm-btn', function() {	
    	
    	$(this).parents('dialog')[0].close();
		
   		// 현재 누른 주문번호의 '취소/반품' 버튼을 '취소/반품 완료'로 변경
    	
    });

})

const refund = async(target) => {
	
	refund_reason = $(target).siblings('#reason').val();
	
	console.log("refund: " + modal_order_no + " " + modal_cancel_amount + " " + modal_quantity + " " + modal_total_amount + " " + refund_reason);
	
	
	data = {
		order_no : modal_order_no, // 주문 번호,
		cancel_amount : modal_cancel_amount,// 환불될 금액 (마일리지 뺀 값)
		quantity : modal_quantity,// 수량
		total_amount : modal_total_amount,// 총 결제 금액
		tax_free_amount : 0, // 세금 (기본값 0)
		refund_reason : refund_reason // 환불 사유
	};
	
	 
	try {
		response = await fetch(`<%=request.getContextPath()%>/Refund.do`, {
			method : 'post',
			headers : {
				"content-type" : "application/json;charset=utf-8"
			},
			body : JSON.stringify(data)
		})
		
		if (response.ok) { // fetch로 받은건 response 객체. 따라서 response.flag 이런건 불가능
			res = await response.json(); // response를 JSON으로 바꾸고
			console.log("완료");
			console.log(res);
			
			$('.refund-success-modal')[0].showModal();
			
			// 해당하는 주문의 '취소/반품' 버튼을 '취소/반품 완료' 텍스트로 변경
			const order_list = $('.order-header-no');
			$.each(order_list, function() {
				if ($(this).text() === modal_order_no) {
					const p_order_list = $(this).parents('.order-summary');
					p_order_list.find('.cancel-btn').remove();
					p_order_list.find('.payment-summary').prepend('<span>취소/반품 완료</span>');
				}
			})
		}
	} catch (err) {
		console.log(err);
		
		$('.refund-fail-modal')[0].showModal();
	} 
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
        	<!-- 네비게이션 메뉴 -->
            <nav class="nav-menu">
                <a href= '<%=request.getContextPath() %>/main/map.jsp'>서점이용안내</a>
                <a href= '<%=request.getContextPath() %>/bookSearch/bookBestseller.jsp'>베스트셀러</a>
                <a href= '<%=request.getContextPath() %>/EventList.do'>문화/행사</a>
                <a href= '<%=request.getContextPath() %>/NoticeList.do'>공지사항</a>
                <a href= '<%=request.getContextPath() %>/QnaList.do'>고객센터</a> 
            </nav>
        
    <hr id="nav-bottom">

    
<div class="container">
	
    
    <div class="order-section">
    <div class="result-word">
    	📃 비회원 주문내역
    </div>
    </div>
</div>

     <dialog class="refund-modal">
	  <div class="refund-modal-body">
	    <h2>취소/반품 신청</h2>
	    <form id="refundForm" method="dialog">
	      <label for="reason">취소/반품 사유를 선택해 주세요.</label>
	      <select id="reason" name="reason" required>
	        <option value="">(사유 선택)</option>
	        <option value="단순 변심">단순 변심</option>
	        <option value="상품 오배송">상품 오배송</option>
	        <option value="상품 파손/불량">상품 파손/불량</option>
	        <option value="배송 지연">배송 지연</option>
	        <option value="기타">기타</option>
	      </select>
	
	      <br><br>
		  <button type="button" class="close-btn">닫기</button>
	      <button type="submit" class="submit-btn">신청</button>
	    </form>
	  </div>
	</dialog> 
	
	<dialog class="refund-modal refund-fail-modal">
	  <div class="refund-modal-body">
	    <span>취소/반품에 실패했습니다. 다시 시도해 주세요.</span><br>
	    
	      <button type="button" class="confirm-btn">확인</button>
	  </div>
	</dialog> 
	
	<dialog class="refund-modal refund-success-modal">
	  <div class="refund-modal-body">
	    <span >취소/반품 신청이 완료되었습니다.</span><br>
	    <span>카드사 사정에 따라 최대 2주 이내에 환불됩니다.</span><br>
	    
	      <button type="button" class="confirm-btn">확인</button>
	  </div>
	</dialog> 
	
	
<footer>
  <div>
	  대전광역시 중구 계룡로 846, 3-4층 406호 (우)34035 <br>
	  도서 데이터 제공: 알라딘 API & 도서관 정보나루 <br>
	  &copy; 2025 BookDam. All rights reserved.
  </div>
</footer>   
</body>
</html>
