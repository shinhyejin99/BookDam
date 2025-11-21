/**
 * 
 */

// 주문 내역 리스트를 얻어오는 함수
const getOrdersNo = () =>{
	$.ajax({
		// 주문 리스트에 대한 요청
		url: `${mypath}/GetOrdersNo.do`,
		method : 'get',
		data : {cust_id : logUser.mem_mail},
		dataType : 'json',
		
		// 1. res1은 주문번호, 주문상태, 회원번호, 순수총금액, 카트번호
		success : function(res1) {
			
			if (res1.length <= 0) {
				$('.order-section').append(`<div style="margin: 70px auto">주문 내역이 없습니다.</div>`);
			}
			
			// 한 사람 당 주문이 여러 개 일 수 있으므로 반복문
			$.each(res1, function(index, item) {
				
				// 주문한 책에 대한 정보 요청
				$.ajax({
					url: `${mypath}/GetOrdersDetail.do`,
					method : 'get',
					data : {order_no : item.order_no},
					dataType : 'json',
					
					// 2. res2는 주문한 책에 대한 정보
					success : function (res2) {

						// 주문일자 구하기
						let year = String(item.order_no).substring(0,4);
						let month = String(item.order_no).substring(4,6);
						let day = String(item.order_no).substring(6,8);
						let orderDate = `${year}-${month}-${day}`;
						
						
						// 오늘 날짜와 주문일자의 차
						let oday = new Date(orderDate);
						let diffMsec = today.getTime() - oday.getTime();
						let diffDate = diffMsec / (24 * 60 * 60 * 1000);
						console.log('diffMsec : ' + diffMsec);
						console.log('현재 날짜와의 차이 : ' + diffDate + "일");

						code= "";
						code += `<div class="order-summary">
								    <div class="order-header">
								      <div>주문번호:<span class="order-header-no">${item.order_no}</div>
								      <div>주문일자: ${orderDate}</div>
								    </div>
								    <div class="product-list">`;
								    
						// 한 주문 당 여러 권이 있을 수 있으므로 반복문	
						let total_earned_mileage = 0;
						let use_mileage = 0;
						$.each(res2, function(index, item) {
							console.log(item);
							code += `
								  <div class="product-item">
									<p hidden>${item.book_no}</p>
								    <img src=${item.cover_img} alt="도서 이미지" width="90px" height="135px" style="margin-right: 15px;">
								    <div class="product-info">
								      <div style="font-size: 16px"><strong>${item.book_title}</strong></div><br>
								      <div style="font-size: 15px">수량: <span class="item-qty">${item.order_qty}</span></div>
								      <div style="font-size: 15px"> <span class="item-price">${item.order_price.toLocaleString()}</span>원</div>
								    </div>
								    <button class="review-btn">리뷰 작성</button>
								  </div>`;
								  
							total_earned_mileage += item.earned_mileage;
							use_mileage = item.use_mileage;
							total_pay = item.payment_amt;
							
							payment_status = item.payment_status;
						})
						
						code += `</div>
							<div class="order-status">
						      <strong>배송 상황:</strong> ${item.order_status}<br>
						      <strong>적립 마일리지:</strong> ${total_earned_mileage.toLocaleString()} 점
						    </div>

						      <div class="payment-summary">`;
						      if (item.order_status === '배송 전' && payment_status !== '취소/반품') {
						      	code += `<button class="cancel-btn" type="button">주문 취소</button>`;
						      } else if (item.order_status === '배송 중' && payment_status !== '취소/반품'){
						    	code += `<button class="cancel-btn" type="button">반품 신청</button>`;
						      } else if (item.order_status === '배송 완료' && payment_status !== '취소/반품') {
						      	if (diffDate <= 14) {
						    		code += `<button class="cancel-btn" type="button">반품 신청</button>`;						      		
						      	} else {
									code += `<span>구매 확정</span>`;
						      	}
						      } else if (payment_status === '취소/반품') {
								code += `<button class="cancel-btn" type="button" disabled hidden>반품 신청</button>`;
								code += `<span>취소/반품 완료</span>`;
							  }
						      
						      code += `<div class="price-info">
						        <div><strong>배송비:</strong> 무료배송</div>
						        <div><strong>사용 마일리지:</strong> ${use_mileage.toLocaleString()} 점</div>
						        <div><strong>총 결제금액:</strong> <span class="item-total_pay">${total_pay.toLocaleString()}</span> 원</div>
						      </div>
						    </div>

						  </div>`;
						  
						// body 에 추가
						$('.order-section').append(code);

					},
					error : function(xhr) {
						console.log(xhr.status);
					}
				})
				
			})
		},
		
		error : function(xhr) {
			console.log(xhr.status);
		}
	})
}

const refund = async(target) => {
	
	// 취소/환불 사유 가져오기
	refund_reason = $(target).siblings('#reason').val();
	
	console.log("refund: " + modal_order_no + " " + modal_cancel_amount + " " + modal_quantity + " " + modal_total_amount + " " + refund_reason);
	
	// refund 테이블에 넣을 데이터 생성
	data = {
		order_no : modal_order_no, // 주문 번호,
		cancel_amount : modal_cancel_amount,// 환불될 금액 (마일리지 뺀 값)
		quantity : modal_quantity,// 수량
		total_amount : modal_total_amount,// 총 결제 금액
		tax_free_amount : 0, // 세금 (기본값 0)
		refund_reason : refund_reason // 환불 사유
	};
	
	 
	try {
		response = await fetch(`${mypath}/Refund.do`, {
			method : 'post',
			headers : {
				"content-type" : "application/json;charset=utf-8"
			},
			body : JSON.stringify(data)
		})
		
		console.log(response);
		
		// 환불이 완료되면
		if (response.ok) {	// fetch로 받은건 response 객체. 따라서 response.flag 이런건 불가능
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