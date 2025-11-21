/**
 * 
 */

// 검색 도서 리스트와 페이지 정보
const bookSearchListBasic = (urlStype, urlSword, currentSortType) => {
	  
	  console.log("bookSearchListBasic 실행" + urlStype + " " + urlSword + " " + currentSortType);
	  
	  // 도서검색 리스트 가져오기
	  $.ajax({
		  /*= url : /BookDam/BookSearchList.do */
		  url : `${mypath}/BookSearchList.do`,
		  data : JSON.stringify({
			  page : currentPage,
			  stype : urlStype, 
			  sword : urlSword,
			  sortType : currentSortType,
			  mem_mail : memMail  
		  }),
		  method : 'post',
		  contentType: 'application/json;charset=utf-8', /* 생략가능 */
		  
		  success: function(res) {  /*res는 bookSearchView.jsp의 결과 = 실제 데이터X, response 객체!*/
			console.log(res);
			            
            // 검색 결과가 있는 경우만 표시
            if(res.datas && res.datas.length > 0) {
                
                // 검색 결과 영역 표시
                $('#searchResults').show();
                $('#noResults').hide();
                $('#loading').hide();
				
                // 총 건수 업데이트
                $('#totalCount').text(res.totalCount);
				
				// 현재 정렬 상태 유지
				$('#sortType').val(currentSortType);
				
				
				// ===== 새로 추가함: URL 업데이트 (AJAX 성공 후) =====
				updateURLAfterSearch();
				
				
                // 출력모양 만들기
                let code = '<div class="book-list">';
                
                $.each(res.datas, function(i, book) {
                    
                    // 이미지 처리 (없으면 기본 이미지)
                    let bookImage = book.cover_img ? 
                        `<img src="${book.cover_img}" alt="${book.book_title}" class="book-image">` : 
                        `<div class="book-image">📖<br>이미지</div>`;
                    
                    // 가격 포맷 (천단위 콤마)
                    let formattedPrice = book.book_price ? 
                        book.book_price.toLocaleString() + '원' : '가격정보없음';
                    
                    // 마일리지 계산 (일반은 5%적립)
                    let mileage = book.book_price ? Math.floor(book.book_price * res.mileageRate) : 0;
                    
					let mileageInfo = ""; // 출력용 변수
					if(res.memGrade !== "비회원") {
						// 로그인 한 회원
						let ratePercent = (res.mileageRate * 100);
						mileageInfo = `<div class="book-mileage">적립예정: ${mileage.toLocaleString()}마일리지 (${ratePercent}%)</div>`;
					} else {
						// 비회원
						mileageInfo = `<div class="book-mileage non-member">로그인 후 마일리지 적립 가능</div>`;
					}

                    // 출간일 포맷
                    let pubDate = book.book_pubdate ? 
                        new Date(book.book_pubdate).toLocaleDateString() : '';
                    
                    code += `
                        <div class="book-item" onclick="goToBookDetail(${book.book_no})" data-bookno="${book.book_no}">
                            ${bookImage}
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
                $('#result').html(code);
                
            } else {
                // 검색 결과가 없는 경우
                $('#searchResults').hide();
                $('#noResults').show();
                $('#loading').hide();
            }
            
            // 페이지 정보 출력
            pager = pageList(res.sp, res.ep, res.tp);
            $('#pagelist').html(pager);
        },
        error: function(xhr) {
            $('#loading').hide();
            alert("오류 : " + xhr.status);
        },
        dataType: 'json'
    });
}

// 카테고리별 책 리스트 가져오기
const loadCategoryList = (category, page, sortType) => {
	console.log('AJAX 요청:', {category: category, page: page, sortType: sortType}); // 디버그
	
	  // 도서 리스트 가져오기
	  $.ajax({
		  /*= url : /BookDam/BookSearchList.do */
		  url : `${mypath}/BookCategoryList.do`,
		  method : 'get',
		  data : {
			  category: category,
			  page: page,	  
			  sortType : currentSortType  			  
		  },
		  success: function(res) {  /*res는 bookSearchView.jsp의 결과 = 실제 데이터X, response 객체!*/
			console.log(res);
			            
            // 검색 결과가 있는 경우만 표시
            if(res.datas && res.datas.length > 0) {

                // 총 건수 업데이트
                $('#totalCount').text(res.totalCount);
				
				// 현재 정렬 상태 유지
				$('#sortType').val(currentSortType);
				
				
				// ===== 새로 추가함: URL 업데이트 (AJAX 성공 후) =====
				//updateURLAfterSearch();
				
				
                // 출력모양 만들기
                let code = '<div class="book-list">';
                
                $.each(res.datas, function(i, book) {
                    
                    // 이미지 처리 (없으면 기본 이미지)
                    let bookImage = book.cover_img ? 
                        `<img src="${book.cover_img}" alt="${book.book_title}" class="book-image">` : 
                        `<div class="book-image">📖<br>이미지</div>`;

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
                            ${bookImage}
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
                $('#result').html(code);
                
            } else {
                // 검색 결과가 없는 경우
                
                $('#searchResults').hide();
                $('#noResults').show();
                $('#loading').hide();
            }
            
            // 페이지 정보 출력
            pager = pageList(res.sp, res.ep, res.tp);
            $('#pagelist').html(pager);
        },
        error: function(xhr) {
            $('#loading').hide();
            alert("오류 : " + xhr.status);
        },
        dataType: 'json'
    });
}


// 새로고침해도 그 전 결과가 유지되도록 URL에 검색 카테고리, 검색어, 정렬기준을 저장한다. - 
const updateURLAfterSearch = () => {
	const stype = $('#stype').val();
	/*const sword = $('#sword').val().trim();*/
	const sword = $('#sword').val();
	const sortType = $('#sortType').val();
	
	console.log("update : " + stype + " " + sword + " " + sortType);
	
	if(sword) { // 검색어가 있다면 = 도서 리스트가 출력된 상태 - 새고 위해 저장
		const params = new URLSearchParams();
		params.set('stype', stype);
		params.set('sword', sword);
		params.set('sortType', sortType);
		params.set('currentPage', currentPage);
		
		const newURL = `${window.location.pathname}?${params.toString()}`;
		
		console.log("window.location.href: " + window.location.href);
		console.log("newURL: " + newURL);
		
		// 현재 URL과 다를 때만 업데이트
		if(window.location.href != newURL) {
			console.log("새로고침이 현재 URL과 다를 때");
			window.history.replaceState({
				stype: stype,
				sword: sword,
				sortType: sortType,
				currentPage: currentPage
			}, '', newURL);
		}
	}
}

// 페이지네이션
const pageList = (sp, ep, tp) => {

	let pager = `<div class="pagination">`;
	
	// 이전 버튼
	if(sp > 1 ) {
		pager += `<button class="page-btn prev-btn" data-page="prev">
		             <i class="arrow-left">‹</i>
		          </button>`;
	} else {
	    pager += `<button class="page-btn prev-btn disabled">
			         <i class="arrow-left">‹</i>
			      </button>`;
	}
	
	// 페이지 번호
	for(i = sp; i <= ep; i++) {
		if(i == currentPage) {  /*currentPage = bookSearch.jsp에 있음*/
			pager += `<button class="page-btn page-number active">${i}</button>`;
		} else {
			pager += `<button class="page-btn page-number" data-page="${i}">${i}</button>`;
		}
	} 
	
	// 다음 버튼
	if(ep < tp) {
		pager += `<button class="page-btn next-btn" data-page="next">
		             <i class="arrow-right">›</i>
		          </button>`;
	}  else {
		 pager += `<button class="page-btn next-btn disabled">
			         <i class="arrow-right">›</i>
			       </button>`;
	}
	
	pager += `</div>`;
	
	return pager;
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