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
	  max-width: 1200px;             /* 최대 너비 제한 */
	  margin: 0 auto;                /* 브라우저에서 가운데 정렬 */
	  padding: 1%;
	}
	
    .order-section {
	  width: 99%;
	  padding: 2%;
	  /* border: 2px solid orange; */
	  position: relative;
  	  color: #272727;
  	  
  	  display: flex;
  	  flex-direction: column;
  	  
  	  /* 만약 배경이 흰색이 아니면 */
  	 /*  border-radius: 15px;
  	  background-color: white; */
  	  /* box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); */
	}

    .order-summary {
      width: 93%;
      border: 1px solid #ccc;
      padding: 25px;
      margin: auto auto 30px auto;
      border-radius: 8px;
    }

    .order-header {
      display: flex;
      justify-content: space-between;
      margin-bottom: 20px;
      font-weight: bold;
    }
    
    #mypage-title {
    	margin-bottom: 10px;
    }
    
    .mypage-title-section {
    	width: 93%;
    	margin: 0 auto;
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

  </style>
  
  
 <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/refundModalCss.css">
<%-- <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookSearchCss.css">--%>

<script>

today = new Date();

// 주문번호, 주문 정보(도서번호, 도서이미지, 도서제목, 수량, 가격, 사용 마일리지, 총 결제금액), 배송상황 받아오기
$(function() {
	getOrdersNo();
	
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



</script>
</head>
<body>
    
<div class="container">
    <div class="order-section">
    <div class="mypage-title-section"><h3 id="mypage-title">📌 주문내역 확인</h3></div>
    
    
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
</body>
</html>
