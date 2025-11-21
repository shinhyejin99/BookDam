/**
 * 
 */
// 주문 내역 리스트를 얻어오는 함수
const getOrdersNo_nmem = () => {
	$.ajax({
		// 주문 리스트에 대한 요청
		url: `${mypath}/GetOrdersNo.do`,
		method : 'get',
		data : {cust_id : nmemMail},
		dataType : 'json',
		
		// 1. res1은 주문번호, 주문상태, 회원번호, 순수총금액, 카트번호
		success : function(res1) {
			
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
							console.log(item.payment_status);
							code += `
								  <div class="product-item">
									<p hidden>${item.book_no}</p>
								    <img src=${item.cover_img} alt="도서 이미지" width="90px" height="135px" style="margin-right: 15px;">
								    <div class="product-info">
								      <div style="font-size: 16px"><strong>${item.book_title}</strong></div><br>
								      <div style="font-size: 15px">수량: <span class="item-qty">${item.order_qty}</span></div>
								      <div style="font-size: 15px"> <span class="item-price">${item.order_price.toLocaleString()}</span>원</div>
								    </div>
						
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
						      		code += `<button class="cancel-btn" type="button" disabled hidden>반품 신청</button>`;
									code += `<span>구매 확정</span>`;
						      	}
	      					  } else if (payment_status === '취소/반품') {

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