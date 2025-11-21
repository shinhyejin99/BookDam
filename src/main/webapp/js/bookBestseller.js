/**
 * 
 */

// 정렬 옵션 변경 이벤트 추가
$('#sortType').on('change', function() {
	currentSortType = $(this).val();
	currentPage = 1; // 정렬 변경시 첫 페이지로
    bookSearchList(); // 다시 검색 실행
});

// 베스트셀러 출력
const getBestsellerList = () => {
	
	
	$.ajax({
		url: `${mypath}/BestPageList.do`,
		method: 'get',
		data: {
			limit: 10
		},
		
		success: function(res) {
			console.log("서버 응답: ", res);

			// 출력모양 만들기
            let code = '<div class="book-list">';
            
            $.each(res.datas, function(i, book) {
                
                // 이미지 처리 (없으면 기본 이미지)
                let bookImage = book.cover_img ? 
                    `<img src="${book.cover_img}" alt="${book.book_title}" class="book-image">` : 
                    `<div class="book-image">📖<br>이미지</div>`;
					
					// 순위별 클래스 지정
					let rankClass = '';
					if (book.best_rank === 1) {
					    rankClass = 'rank-badge gold';
					} else if (book.best_rank === 2) {
					    rankClass = 'rank-badge silver';
					} else if (book.best_rank === 3) {
					    rankClass = 'rank-badge bronze';
					} else {
					    rankClass = 'rank-badge';
					}	
					
                
                // 별점 표시 (avgRating 값에 따라)
                /*let starRating = '';
                let rating = book.avgRating || 0;
                for(let j = 1; j <= 5; j++) {
                    if(j <= Math.floor(rating)) {
                        starRating += '★';
                    } else if(j === Math.ceil(rating) && rating % 1 >= 0.5) {
                        starRating += '★';
                    } else {
                        starRating += '☆';
                    }
                }*/
                
                // 가격 포맷 (천단위 콤마)
                let formattedPrice = book.book_price ? 
                    book.book_price.toLocaleString() + '원' : '가격정보없음';
                
                // 마일리지 계산 (일반은 5%적립)
                let mileage = book.book_price ? Math.floor(book.book_price * res.mileageRate) : 0;
                
				let mileageInfo = ""; // 출력용 변수
				if(res.memGrade !== "비회원") {
					// 로그인 한 회원
					let ratePercent = (res.mileageRate * 100);
					mileageInfo = `<div class="book-mileage">적립예정: ${mileage.toLocaleString()}마일리지(${ratePercent}%)</div>`;
				} else {
					// 비회원
					mileageInfo = `<div class="book-mileage non-member">로그인 후 마일리지 적립 가능</div>`;
				}  

                // 출간일 포맷
                let pubDate = book.book_pubdate ? 
                    new Date(book.book_pubdate).toLocaleDateString() : '';
                
                code += `
                    <div class="book-item" onclick="goToBookDetail(${book.book_no})" data-bookno="${book.book_no}">
						<div class="book-image-container">
						    ${bookImage}
						    <div class="${rankClass}">${book.best_rank}</div>
						</div>
                        <div class="book-info">
                            <div class="book-title">${book.book_title}</div>
                            <div class="book-author">${book.book_author}</div>
                            <div class="book-publisher">${book.publisher || ''}</div>
                            <div class="book-publish-date">${pubDate}</div>
                            <div class="book-rating">
								<img id="img-star" src="${mypath}/images/star2.png" alt="${mypath}/images/star2.png">
								<span class="stars">${(book.avgRating).toFixed(1)}</span>
								<span class="reviewCount">(${book.reviewCount})</span>
                            </div>
                            <div class="book-price">${formattedPrice}</div>
							
							${mileageInfo}
                        </div>
                        <div class="book-actions">
                            <button class="btn btn-cart">장바구니</button>
                            <button class="btn btn-buy">바로구매</button>
                        </div>
                    </div>
                `;
            });
            
            code += '</div>';
            
            // bookSearch.jsp의 id="result"에 출력
            $('#best-list').html(code);
			
			
		}, error: function(xhr) {
			alert("오류 : " + xhr.status);
		},
		dataType: 'json'	
	})	
}


// 선택한 도서 상세보기 페이지로 이동
const goToBookDetail = (bookNo) => {
	window.location.href = `${mypath}/BookDetail.do?bookNo=${bookNo}`;
}


// 장바구니 insert (가영)
const insertCart = (sendInsertData) => {
	$.ajax({
		url : `${mypath}/InsertCartItem.do`,
		method : 'post',
		data : sendInsertData,
		dataType : 'json',
		
		success : function(res) {
			if (res.flag == "성공") {
				let result = confirm("장바구니에 추가 되었습니다. (회원)\n장바구니로 이동할까요?");
				if (result) {
					window.location.href= mypath+"/cart/cart_page.jsp";
				}
			} else {
				alert("장바구니에 이미 상품이 있습니다.");
			}
			
		},
		error : function(xhr) {
			console.log(xhr.status);
		}
		
	});
}
