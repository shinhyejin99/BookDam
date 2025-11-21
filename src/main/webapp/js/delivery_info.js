/**
 *
 */

// 도서 번호에 따라 (표지, 제목, 가격)을 가져와서 <tbody id="cartBody"> </tbody>에 삽입하는 코드
/*const getBookInfo = () => {
	// 선택한 모든 도서에 대한 정보를 가져옴
	$.each(sendArr, function (index, item){
		$.ajax({
			// 비동기 get 요청 -> GetBookInfo 서블릿으로 이동
			url : `${mypath}/GetBookInfo.do`,
			method : 'get',
			data : {book_no : item.book_no},

			// 장바구니 아이템을 res 배열로 받아옴
			success : function(res) {
				console.log("res : ", res);
				let code = "";

				// 장바구니에 담은 아이템을 모두 출력
				code += `
					<tr>
					  <td class="book_no_tr" hidden>${item.book_no}</td>
					  <td><img src=${res.cover_img} alt="사진오류"></td>
					  <td class="book_title_td">${res.book_title}</td>
					  <td>${(res.book_price).toLocaleString()} 원</td>
					  <td>${item.cart_qty}</td>
					  <td>${(res.book_price * item.cart_qty).toLocaleString()} 원</td>
					</tr>`;

				// code 출력
					  $('#cartBody').append(code);

				total += (res.book_price * item.cart_qty);
				$('#total-text1').text(total.toLocaleString());
				$('#total-text2').text(total.toLocaleString());

				totalPrice = parseInt($('#total-text2').text().replaceAll(",", ""));
				totalQty += parseInt(item.cart_qty);

			},
			error : function(xhr) {
				console.log(xhr.status)
			},
			dataType : 'json'
		})

	})

	// 회원 등급별로 적립 마일리지 계산
		let earnRate = 0;
	// 0. 회원 등급 가져오기
	if (logUser != null) {

		const memGrade = logUser.memGrade
		if (memGrade == "일반등급" || memGrade == "일반 등급" || memGrade == "일반") {
			earnRate = 5;
		} else if (memGrade == "실버") {
			earnRate = 7;
		} else if (memGrade == "골드") {
			earnRate = 8;
		} else if (memGrade == "다이아몬드") {
			earnRate = 10;
		}

		$('#earnedmileage-text').text((totalPrice * (earnRate / 100)).toLocaleString());

	}
}*/

const getBookInfo = async () => {
	// 선택한 모든 도서에 대한 정보를 가져옴
	const promises1 = sendArr.map(item => {
		return $.ajax({
			// 비동기 get 요청 -> GetBookInfo 서블릿으로 이동
			url: `${mypath}/GetBookInfo.do`,
			method: 'get',
			data: { book_no: item.book_no },
			dataType: 'json'
		}).then(res => {
			// 장바구니 아이템을 res 배열로 받아옴
			console.log("res : ", res);
			let code = "";

			// 장바구니에 담은 아이템을 모두 출력
			code += `
				<tr>
				  <td class="book_no_tr" hidden>${item.book_no}</td>
				  <td><img src=${res.cover_img} alt="사진오류"></td>
				  <td class="book_title_td">${res.book_title}</td>
				  <td>${(res.book_price).toLocaleString()}원</td>
				  <td>${item.cart_qty}권</td>
				  <td>총 ${(res.book_price * item.cart_qty).toLocaleString()}원</td>
				</tr>`;

			// code 출력
			$('#cartBody').append(code);

			total += (res.book_price * item.cart_qty);
			$('#total-text1').text(total.toLocaleString());
			$('#total-text2').text(total.toLocaleString());

			totalPrice = parseInt($('#total-text2').text().replaceAll(",", ""));
			totalQty += parseInt(item.cart_qty);

		});
	});

	// 모든 AJAX 요청이 끝난 뒤 실행
	await Promise.all(promises1);

	// 사은품 정보 테이블에 삽입
	if (giftArr) {
		const promises2 = giftArr.map(item => {
			return $.ajax({
				// 비동기 get 요청 -> GetBookInfo 서블릿으로 이동
				url: `${mypath}/GetGiftSelectInfo.do`,
				method: 'get',
				data: { gift_no: item.gift_no },
				dataType: 'json'

			}).then(res => {
				let code = "";

				// '받지 않음'을 제외한 사은품 출력
				if (item.gift_no != 999) {
					// 선택한 사은품 리스트 전부 출력
					code += `
						<tr>
						  <td class="gift_no_tr" hidden>${item.gift_no}</td>
						  <td><img src=${res.gift_image} alt="사진오류" style="border: 1px solid gray; height: 140px"></td>
						  <td class="gift_name_td">[사은품]${res.gift_name}</td>
						  <td></td>
						  <td></td>
						  <td></td>
						</tr>`;

					// code 출력
					$('#cartBody').append(code);
				}
			});
		});
	}



	// 회원 등급별로 적립 마일리지 계산
	let earnRate = 0;
	if (logUser != null) {

		//const memGrade = logUser.mem_grade
		console.log("회원등급 : " + memGrade)
		if ((memGrade == "일반등급") || (memGrade == "일반 등급") || (memGrade == "일반")) {
			earnRate = 5;
		} else if (memGrade == "실버등급" || memGrade == "실버") {
			earnRate = 7;
		} else if (memGrade == "골드등급" || memGrade == "골드") {
			earnRate = 8;
		} else if (memGrade == "다이아몬드등급" || memGrade == "다이아몬드") {
			earnRate = 10;
		}

		$('#earnedmileage-text').text(Math.floor(totalPrice * (earnRate / 100)).toLocaleString() + "M(" + earnRate + "%)");
	}
}

// 결제 API
const payReadyAPI = () => {

	// from 데이터 가져오기
	let formData = {
		cust_name: $('#receiver').val(),
		cust_tel: $('#tel').val(),
		nmem_pass: $('#pass').val() ? $('#pass').val() : null,
		cust_zip: $('#zipcode').val(),
		cust_addr1: $('#address1').val(),
		cust_addr2: $('#address2').val()
	};

	// ready API로 보낼 데이터 생성
	let quantity = totalQty; // 총 수량
	let total = parseInt($('#total-text2').text().replaceAll(',', '')); // 총 결제 금액

	let name = ""; // 결제 시 표시되는 이름

	if ((sendArr.length - 1) <= 0) {
		// 도서 번호 세션 길이가 1 이하라면 '총 ~권' 텍스트 뺌
		name = `${$('.book_title_td:eq(0)').text()}`;
	} else {
		// 도서 번호 세션 길이가 1 이상이라면 '총 ~권' 텍스트 붙임
		name = `${$('.book_title_td:eq(0)').text()} 외 총 ${sendArr.length - 1}권`;
	}

	let data = {
		partner_user_id: $('#receiver-mail').val(),
		name: name,
		quantity: quantity,
		total_amount: total,
		tax_free_amount: '0',
		use_mileage: $('#useMileage').val() ? $('#useMileage').val() : 0,

		form_data: JSON.stringify(formData),

		sendArr: JSON.stringify(sendArr),

		giftArr: JSON.stringify(giftArr) ? JSON.stringify(giftArr) : null
	};


	// 클라이언트에서 ready API 호출
	$.ajax({
		url: `${mypath}/ReadyPay.do`,
		method: 'post',
		data: data,
		dataType: 'json',
		success: function(res) {
			console.log("결제 준비 : ", res);
			console.log("결제 url : ", res.next_redirect_pc_url);
			location.href = res.next_redirect_pc_url;

		},
		error: function(xhr) {
			console.log(xhr.status);
		}
	});
}

// 회원 배송 정보(이름, 연락처, 이메일, 우편번호, 배송지, 상세주소) + 마일리지를 폼에 삽입하는 코드
const getDeliveryInfo = () => {
	$.ajax({
		url: `${mypath}/GetDeliveryInfo.do`,
		method: 'get',
		data: { cust_id: logUser.mem_mail },
		dataType: 'json', //dataType : 'json', // 응답데이터의 역직렬화 - script 객체로 변환

		// 회원 배송 정보를 받아옴
		success: function(res) {
			console.log(res);
			$('#receiver').val(res.cust_name);
			$('#tel').val(res.cust_tel);
			$('#receiver-mail').val(logUser.mem_mail);
			$('#zipcode').val(res.cust_zip);
			$('#address1').val(res.cust_addr1);
			$('#address2').val(res.cust_addr2);
			$('#myMileage').text((res.mem_mileage).toLocaleString());

			myMile = parseInt($('#myMileage').text().replaceAll(",", ""));
		}
	})
}