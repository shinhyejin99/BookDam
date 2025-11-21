/**
 * 
 */
// 장바구니에서 선택한 상품 삭제하는 코드
const deleteCartItem = (sendDelData) => {
	$.ajax( {
		url : `${mypath}/DeleteCartItem.do`,
		method : 'post',
		data : JSON.stringify(sendDelData), // JSON 문자열로 전송
		
		success : function(res) {
			// console.log(sendDelData.book_no)
			if (res.flag == "성공") {
				// remove로 해당 영역 삭제
				sendDelData.book_no.forEach(function(i) {
					// console.log(i.book_no)
					$('.book_no_td').each(function() {
						if ($(this).text() == i.book_no) {
							$(this).parent().remove();
						} 
					});
				});
				
			} else {
				console.log("삭제 실패")
			}
		}, // success 끝
		error  : function (xhr) {
			console.log(xhr.status)		
		},
		dataType : 'json'
	})
}

// 장바구니 상품의 수량을 업데이트 하는 코드
const updateCartQty = (sendUpdateData) => {
	$.ajax ( {
		url : `${mypath}/UpdateCartQty.do`,
		method : 'post',
		data : sendUpdateData,
		
		success : function(res) {
			if (res.flag == "성공") console.log("수량 업데이트 성공");
		},
		error : function (xhr) {
			console.log(xhr.status);
		},
		dataType : 'json'
		
	})
}


// 장바구니(표지, 제목, 가격, 수량 총합) 내역을 <tbody id="cartBody"> </tbody>에 삽입하는 코드
const getCartInfo = () => {
	console.log("getCartInfo 수행");
	$.ajax({
		// 비동기 get 요청 -> GetCartList 서블릿으로 이동
		url : `${mypath}/GetCartList.do`,
		method : 'get',
		data : {cust_id : logUser.mem_mail},
		
		// request 값을 res 배열로 받고
		success : function(res) {
			
			if (res.length <= 0) {
				null_code = `<tr><td colspan="6" style="padding: 80px 0; text-align: center;">장바구니에 담은 상품이 없습니다.</td></tr>`
				$('#cartBody').append(null_code);
			}

			
			code = "";
			// 장바구니에 리스트 모두 출력
			$.each(res, function (index, item){
				code += `
					<tr id="cartItem_tr">
					  <td class="book_no_td" hidden>${item.book_no}</td>
					  <td><input type="checkbox" class="itemCheckbox"></td>
					  <td><img src=${item.cover_img} alt="사진오류"></td>
					  <td>${item.book_title}</td>
					  <td class="book_price_td">${(item.book_price).toLocaleString()}</td>
					  <td>
					    <div class="qty-controls" data-price="\${item.book_price}">
						    <button class="qty-btn minus">-</button>
						    <span class="qty-val">${item.cart_qty}</span>
						    <button class="qty-btn plus">+</button>
						  </div>
					  </td>					  
					  <td class="total_td">${(item.book_price * item.cart_qty).toLocaleString()}</td>
					</tr>`;
					
			})
			
			// 장바구니 목록 출력
		   	$('#cartBody').append(code);  
			// 총 결제금액 출력
			/*$('#totalPrice').text(totalPrice.toLocaleString());*/
		},
		error : function(xhr) {
			console.log(xhr.status)
		},
		dataType : 'json'
	})
}

/*<button class="qty-btn minus">-</button>
<span class="qty-val">${item.cart_qty}</span>
<button class="qty-btn plus">+</button>*/

// 비회원의 장바구니(표지, 제목, 가격, 수량 총합) 내역을 <tbody id="cartBody"> </tbody>에 삽입하는 코드
const getSessionCartInfo = () => {
	console.log("getSessionCartInfo 수행");
	if (!cartArr) {
		null_code = `<tr><td colspan="6" style="padding: 80px 0; text-align: center;">장바구니에 담은 상품이 없습니다.</td></tr>`
		$('#cartBody').append(null_code);
		console.log("얍")
	}
			
	$.each(cartArr, function (index, cartItem) {
		$.ajax({
			// 비동기 get 요청 -> GetCartList 서블릿으로 이동
			url : `${mypath}/GetBookInfo.do`,
			method : 'get',
			data : {book_no : cartItem.book_no},
			
			// request 값을 res 배열로 받고
			success : function(res) {
				console.log(res)
				code = "";
				// 장바구니에 리스트 모두 출력
				code += `
					<tr id="cartItem_tr">
					  <td class="book_no_td" hidden>${res.book_no}</td>
					  <td><input type="checkbox" class="itemCheckbox"></td>
					  <td><img src=${res.cover_img} alt="사진오류"></td>
					  <td>${res.book_title}</td>
					  <td class="book_price_td">${(res.book_price).toLocaleString()}</td>
					  <td>
						  <div class="qty-controls" data-price="\${item.book_price}">
						    <button class="qty-btn minus">-</button>
						    <span class="qty-val">${cartItem.cart_qty}</span>
						    <button class="qty-btn plus">+</button>
						  </div>
					  </td>
					  <td class="total_td">${(res.book_price * cartItem.cart_qty).toLocaleString()}</td>
					</tr>`;
					
				// 장바구니 목록 출력
			   	$('#cartBody').append(code);  
			},
			error : function(xhr) {
				console.log(xhr.status)
			},
			dataType : 'json'
		})
	})
	
}


const updateTotal = () => {
	// 체크한 항목의 '총합' 가져오기
	total = 0;
	$('.itemCheckbox:checked').each(function() {
		totalPrice = $(this).parents('tr').find('.total_td').text().replaceAll(',', '');
		console.log("총액: " + totalPrice)
		total += parseInt(totalPrice);
	})
		console.log("총 결제 금액: " + total);
	
	// '총 결제 금액' 에 체크한 항목 가격만 표시
	$('#total-text1').text(total.toLocaleString());
	$('#total-text2').text(total.toLocaleString());
}