/**
 * 
 */

const updateMileageInfo = () => {
	/*let mileageInfo = '';*/
	//let bookPrice = ${book.book_price};
	
	////////////////가영 추가 07.01 ////////////////
    // 멤버 정보 가져오기 (회원 등급을 얻기 위해)
	if (logUser != null) {
	    $.ajax({
		    url: `${mypath}/GetMemberInfobyMail.do`,
		    method: 'get',
		    data: {mem_mail : logUser.mem_mail},
		    dataType: 'json',
		
		    success: function(res) {
		   	    memGrade = res.mem_grade;
			
			    if(memGrade === "일반등급") mileageRate = 0.05; 
			    else if(memGrade === "실버등급") mileageRate = 0.07;
			    else if(memGrade === "골드등급") mileageRate = 0.08;
			    else if(memGrade === "다이아몬드등급") mileageRate = 0.1;
					
				/*if(memGrade !== "비회원") {*/
				// 로그인 한 회원
				let mileage = bookPrice ? Math.floor(bookPrice * mileageRate) : 0;
		        let ratePercent = Math.floor(mileageRate * 100);
		        
		        mileageInfo = `<div class="book-mileage">적립/혜택 | ${mileage.toLocaleString()}마일리지 (${ratePercent}%)</div>`;
			    /*} else {
			        // 비회원
			        mileageInfo = `<div class="book-mileage non-member">로그인 후 마일리지 적립 가능</div>`;
			    }*/
				
				$('#memMileage').html(mileageInfo);
		    }, 
		    error: function(xhr) {
			    console.log(xhr.status);
	  	    }
	    });
	} else {
		mileageInfo = `<div class="book-mileage non-member">로그인 후 마일리지 적립 가능</div>`;
		$('#memMileage').html(mileageInfo);
	}
    //////////////////////////////////////////////
}

// 도서정보섹션에 있는 별점 부분 div 클릭하면 하단의 리뷰섹션으로 이동
const scrollReview = () => {
	
	$('#info-average-rating').css('cursor', 'pointer').on('click', function() {
		$('html, body').animate({
			scrollTop: $('.review-section').offset().top - 120}, 80);
	})
}


// 리뷰 탭 전환
const reviewTab = (type, target) => {
	
	// 모든 탭에서 active 제거
	$('.nav-link').removeClass('active').css('color', '#919191');
	
	// 클릭된 탭에 active 추가
	$(target).addClass('active').css('color', '#000000');
	    
    // 확인용
    console.log('선택된 리뷰 타입:', type);
	
	// 탭 필터링
	currentTab = type;
	currentReviewPage = 1;
	
	reviewListPrint(); // 리뷰 리스트 출력
}

 // 리뷰 리스트 출력
const reviewListPrint = () => {
	
	// 전역변수 - bookDetail.jsp 에서 사용하기 위함
	let totalReviewCount =''; // 전체 리뷰수 : 책 정보에서 출력하기 위함
	let infoAvgRating = '0.0';
	
	currentSort = $('.sort-select').val() || currentSort;
	
	console.log('전송할 데이터:', {  // 추가
	       page : currentReviewPage,
	       book_no : bookNo,
	       sortType : currentSort,
	       tabType : currentTab
	   });
	
	console.log('보낼 bookNo:', bookNo);
	
	// 해당도서 번호 전송
	$.ajax({
		url : `${mypath}/ReviewList.do`,
		method : 'post',
		data : JSON.stringify({
			page : currentReviewPage,
			book_no : bookNo,
			sortType : currentSort,
			tabType : currentTab,
			mem_mail: memMail // 좋아요, 신고 여부 확인하기 위해서 
		}),
		success: function(res) {
			
			console.log('받은 데이터(리뷰): ', res);
			
			totalReviewCount = res.totalAllCount;
			
			// 탭에 리뷰 개수 추가하는 부분 - 추가!
			if(res.totalAllCount !== undefined) {
				$('#allReviewCount').text(`(${res.totalAllCount})`);
			}
			if(res.totalBuyerCount !== undefined) {
			     $('#buyerReviewCount').text(`(${res.totalBuyerCount})`);
			}

			// 평균 별점 계산 - 리뷰 입력 오른쪽 상단에 출력할 용도
			if(res.datas && res.datas.length > 0) {
			    let avgRating = (res.datas.reduce((sum, review) => sum + review.rating, 0) / res.datas.length).toFixed(1);
			    $('.average-rating').text(`평균별점 : ${avgRating}`); // toFixed(1)이면 자동으로 0.0 나옴
			    infoAvgRating = avgRating;
			}
			
			// bookDetail.jsp에서 사용!!!!
			$('#info-average-rating').html(`<img src="/BookDam/images/star2.png" alt="/BookDam/images/star2.png"> 
				<span id="info-rating"> ${infoAvgRating} </span> 
				<span id="info-review"> (${totalReviewCount}) </span>`);

			// 출력모양 만들기
			let code = '';
			if(res.datas && res.datas.length > 0) {
				$.each(res.datas, function(i, review) {
					
					// 스포일러 체크한 리뷰 내용을 블러처리 하기 위해 class 추가
					let contentClass = 'review-content';
						if(review.spoiler === 'Y'){
						    contentClass += ' spoiler-hidden';  // spoiler-hidden으로 변경
					}
								
				code += `			
	            <div class="review-item">
					<input type="hidden" class="review-id" value="${review.rv_id}">
	                <div class="review-item-header">
	                    <div class="review-user-info">
	                        <div class="review-stars">
	                            ${getRating(review.rating)}
	                        </div>
	                        <span class="review-username">${review.mem_nickname}</span>
	                        <span class="review-date">${review.rv_date}</span>
							${review.spoiler === 'Y' ? '<span style="background:#ff4757;color:white;padding:2px 6px;border-radius:4px;font-size:12px;">스포일러</span>' : ''}`
							
							/* 로그인한 사람과 리뷰 작성자가 같은지 확인 = 같다면 수정, 삭제 버튼 생성 */
							if(memMail != null && memMail == review.mem_mail) {
								code += `<input type="button" value="수정" name="modify" class="action" id="modify">
										<input type="button" value="삭제" name="delete" class="action" id="delete">`
							}
							
	                    code += `</div>
	                    <div class="review-actions">
	                        <button class="like-btn ${review.user_liked > 0 ? 'liked' : ''}">
	                            ❤️ <span class="like-count">${review.like_count}</span>
	                        </button>
	                    </div>
	                </div>
	                <div class="${contentClass}">
	                    ${review.rv_content}
	                </div>`
					
					if(memMail === review.mem_mail) {
						code += `<button class="report-btn ${review.user_reported > 0 ? 'reported' : ''}" style="display: none;">신고하기</button>`
					} else {
						code += `<button class="report-btn ${review.user_reported > 0 ? 'reported' : ''}">신고하기</button>`
					}

					code += `</div>`
  
				}) // 출력모양 each문 끝
			} else {
				if(currentTab === 'buyer') {
					code = `<p>등록된 리뷰가 없습니다.</p><br>
							<p>첫 번째 리뷰를 등록하세요!</p>`;
				} else {
					code = `<p>등록된 리뷰가 없습니다.</p>`;
				}
				
			}
			
			$('.review-list').html(code);
			
			// 스포일러 버튼 부분
			$('.spoiler-hidden').off('click').on('click', function() {
			    $(this).removeClass('spoiler-hidden').addClass('spoiler-shown');
			    $(this).parent().find('.spoiler-warning').remove(); // 부모에서 경고 메시지 제거
			}).each(function() {
			    // 경고 메시지를 부모 요소(review-item)에 추가
			    if(!$(this).parent().find('.spoiler-warning').length) {
			        $(this).parent().css('position', 'relative').append('<div class="spoiler-warning" style="position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);color:white;font-size:12px;background:rgba(255,71,87,0.95);padding:5px 10px;border-radius:15px;white-space:nowrap;pointer-events:none;z-index:999;">⚠️ 스포일러 - 클릭하여 보기</div>');
			    }
			});
			
			// 페이지 정보 출력 - 페이지네이션
            pager = pageList(res.startPage, res.endPage, res.totalPage);
            $('.review-pagination').html(pager);
			
			
			// 좋아요 버튼 이벤트
			$('.like-btn').off('click').on('click', function() {
			 	// off('click') : 버튼에 있던 clikc 이벤트 삭제 - 그래야 토글
				
				// 비회원일 때 = 로그인 후 가능하다는 알림창이 뜬다.
				if(!memMail) {
					alert("로그인 후 가능합니다.");
					return;
				}
				
				let clickButton = $(this); // 클릭된 버튼을 미리 저장
				
				let reviewId = $(this).closest('.review-item').find('.review-id').val();
			 	let isLiked = $(this).hasClass('liked'); // 'liked' 클래스가 있으면 true, 아니면 false를 리턴함
				let likeCount = isLiked ? -1 : 1; // 좋아요 눌렀으면 -1, 아니면 +1 - 서버로 전송할 거임
			 	
			 	$.ajax({
			 		url : `${mypath}/LikeUpdate.do`,
			 		method : 'post',
			 		data : JSON.stringify({
			 			rv_id : reviewId,
			 			like_count: likeCount,
						mem_mail: memMail
			 		}),
			 		success: function(res) {
			 			console.log(res);
						if(res.flag === "성공") {
					        
							let likeCountSpan = clickButton.find('.like-count');
							let currentNumber = parseInt(likeCountSpan.text());
							
							if(isLiked) {
								// 좋아요 취소
								clickButton.removeClass('liked');
								likeCountSpan.text(currentNumber-1);
							} else {
								// 좋아요 추가
								clickButton.addClass('liked');
								likeCountSpan.text(currentNumber+1);
							}
							
					    } else {
					        console.log(res.flag);
					    }
			 		},
			 		error: function(xhr){
			 			alert("오류 : " + xhr.status);
			 		},
			 		dataType : 'json'
			 	})
			 })
			 
			 // 신고하기 버튼 - 한 번 누르면 끝!
			 // 신고버튼클릭 이벤트 삭제해줘야함
			 $('.report-btn').off('click').on('click', function() {

				// 비회원일 때 = 로그인 후 가능하다는 알림창이 뜬다.
				if(!memMail) {
					alert("로그인 후 가능합니다.");
					return;
				}
				
				let clickButton = $(this); // 클릭된 버튼을 미리 저장	
				
				// 신고버튼을 눌렀을 때 신고 했는지 안 했는지부터 확인한다!!!
				// 얘를 처음에 올려놓지 않으면 계속 신고가 누적이 되더라...
				// 신고를 했는지 안했는지 판단을 못하니까...
				// isReport를 만들었던 변수를 삭제하고 그냥 지금 클릭된 버튼이 class를 갖고 있는지 바로 확인하는 걸로 변경함
				// * 이미 신고한 경우
				if(clickButton.hasClass('reported')) {
					// 이미 신고한 경우
					alert("이미 신고한 리뷰입니다.");
					return; // 종료!
				}
				
				// * 처음 신고하기 버튼 누른 경우
				let vcon = confirm("정말 신고하시겠습니까?"); 
				if(!vcon) { // 취소하기 버튼 눌렀을 때
					return; // 종료
				}

				// 여기부터 ajax 실행
				let reviewId = clickButton.closest('.review-item').find('.review-id').val();
				
				// confirm 확인 눌렀을 때 실행
				$.ajax({
					url : `${mypath}/ReportUpdate.do`,
					method: 'post',
					data: JSON.stringify({
						rv_id: reviewId,
						report_count: 1, // like와 달리 무조건 1 (신고 추가)
						mem_mail: memMail			
					}), 
					success: function(res) {
						console.log(res);
						
						if(res.flag === "성공"){
							// 지금 내가 클릭한 신고 버튼에 클래스 추가
							clickButton.addClass('reported');
							alert("신고가 접수되었습니다.");
						} else if(res.flag === "이미 신고함"){
							alert("이미 신고한 리뷰입니다.")
						} else {
							alert("오류가 발생했습니다.");
						}
						
					},
					error: function(xhr) {
						alert("오류 : " + xhr.status);
					},
					dataType : 'json'
				})
			 }) // 신고 버튼 이벤트 끝!
		}, // success 끝
		error: function(xhr){
			alert("오류 : " + xhr.status);
		},
		dataType : 'json'
	}) // 해당도서 번호 전송 ajax끝

} // 리뷰 리스트 출력 함수 끝

$(function() {

    let reviewId;

	// 취소 버튼+"x"버튼 눌렀을 때 - 모달창 닫기
	$('.close-modal').on('click', function() {
		$('#editReviewModal').hide();
	})

	// 수정, 삭제 버튼 클릭 이벤트
	$(document).on('click', '.action', function() {
		btnType = $(this).attr('id'); // 수정인지 삭제인지 알기 위해서
		let reviewItem = $(this).closest('.review-item');
		reviewId = reviewItem.find('.review-id').val(); // 현재 리뷰 아이디(rv_id) 가져오기

		// 수정하기
		if(btnType == "modify") {
			// (수정) 모달창 띄우기
			$('#editReviewModal').show(); // jQuery 방식

			// 현재(수정 전) 리뷰 데이터 가져오기
			let currentRating = reviewItem.find('.review-star.filled').length;
			let currentContent = reviewItem.find('.review-content').text().trim();
			let currentSpoiler = reviewItem.find('.review-item-header').find('span[style*="background:#ff4757"]').length > 0 ? 'Y' : 'N';

			// 모달창에 기존 데이터 설정
			$('#editReviewId').val(reviewId);
			$('#editRating').val(currentRating);
			$('#editContent').val(currentContent);
			$('#editSpoiler').prop('checked', currentSpoiler === 'Y');

		} else { // 삭제하기 버튼 btnType = "delete" 일 때
			
			let vcon = confirm("리뷰를 삭제하시겠습니까?");
			if(!vcon) {
				return;
			}
			
			// 삭제 요청 전송
			$.ajax({
				url: `${mypath}/ReviewDelete.do`,
				method: 'get',
				data: {
				// 해당 리뷰 번호만
				rv_id: reviewId
				},
				success: function(res) {
					console.log(res.flag);
					// 다시 리뷰 출력
					reviewListPrint();
				},
				error: function(xhr){
					alert("오류 : " + xhr.status);
				},
				dataType: 'json'
			})
		}
	}) // 수정, 삭제 버튼 클릭 이벤트 끝

 

	// 수정 모달창에서 저장 버튼 눌렀을 때 실행
	$('.modal-save').off('click').on('click', function() {

		let newRating = $('#editRating').val();
		let newContent = $('#editContent').val();
		let newSpoiler = $('#editSpoiler').prop('checked') ? 'Y' : 'N';

		// 수정한 내용 서버로 전송
		$.ajax({
			url : `${mypath}/ReviewUpdate.do`,
			method : 'post',
			data : JSON.stringify({
				rv_id: reviewId, // 리뷰 번호 전송 - 어떤 리뷰인지
				rating: newRating, // 별점
				rv_content: newContent, // 리뷰내용
				spoiler: newSpoiler // 스포일러 여부
			}),
			success: function(res) {
				console.log(res);
				if(res.flag === "성공") {
					alert("리뷰 수정 성공 ✅");
					$('#editReviewModal').hide(); // 모달창 닫기
					reviewListPrint();
				} else {
					alert(res.flag); // 비속어 포함 시 컨트롤러에서 작성한 flag 내용 출력됨
				}
			},
			error: function(xhr){
				alert("오류: " + xhr.status);
			},
			dataType: 'json'
		}) // 수정하기 ajax 끝
	}) // 수정 모달창에서 저장 버튼 클릭 이벤트 끝
}) // $(function) 끝


// 리뷰에서 별점 나타내는 함수
const getRating = (rating) => {
	stars = '';
	for(i = 1; i <= 5 ; i++) {
		if(i <= rating) {
			stars += `<span class="review-star filled">★</span>`;
		} else {
			stars += `<span class="review-star">☆</span>`;
		}
	}
	return stars;
}

// 리뷰 작성
const reviewInsert = () => {
	
	// 별점 선택 이벤트
	let selectedRating = 0; // 선택한 별점 변수

	// 별점 채우기 - 만약 4번째 버튼을 누르면 1,2,3,4번째 버튼이 노랑색으로 되도록 하는 건데...
	const fillStar = (rating) => {
		$('.star-label').removeClass('filled');
		for(let i = 1; i <= rating; i++){
			$(`#star${i}`).next('.star-label').addClass('filled');
		}
	}
	
    $('input[name="rating"]').on('change', function() {
    	selectedRating = parseInt($(this).val()); // 클릭한 별점의 값 대입
        console.log('선택된 별점:', selectedRating);
        fillStar(selectedRating); // 이전 별점이 채워지도록 함수에 파라미터로 대입
    })

 	// 호버 효과
    $('.star-input').hover(function() {
        fillStar($(this).find('input').val());
    });
    
    $('.star-rating').mouseleave(function() {
        fillStar(selectedRating);
    });

    // 리뷰작성 버튼 클릭 시 별점, 글자수 체크
    $('.submit-btn').on('click', function(e) {
        e.preventDefault();
		
		// 로그인 체크 - 비회원은 리뷰 작성할 수 없음!!
	    if(!memMail || memMail === '') {
	        alert('로그인 후 리뷰 작성이 가능합니다.');
			// 폼 초기화
	        $('.review-textarea').val('');
	        $('input[name="rating"]').prop('checked', false);
			fillStar(0);  // 0점으로 초기화 - 시각적 별 비우기
			selectedRating = 0; // 선택했던 별점 지우기
			$('#spoilerCheck').prop('checked', false);
	        return;
	    }
        
        const rating = $('input[name="rating"]:checked').val();
        const reviewContent = $('.review-textarea').val().trim();
        const spoilerValue = $('#spoilerCheck').prop('checked') ? 'Y' : 'N';
        
        if (!rating) {
            alert('별점을 선택해주세요!');
            return;
        }
        
        if (reviewContent.length < 10) {
            alert('리뷰를 10자 이상 입력해주세요!');
            return;
        }
        
        // AJAX 전송 - ReviewInsert.do
        console.log('별점:', rating, '리뷰:', reviewContent);
        $.ajax({
			url : `${mypath}/ReviewInsert.do`,
			method : 'post',
			data : JSON.stringify({
				// 별점
				rating : rating,
				// 리뷰내용
				rv_content : reviewContent,
				// 스포일러 여부
				spoiler : spoilerValue,
				// 책 번호 - 이전 페이지에서 전달받은 책 번호
				book_no : bookNo,
				mem_mail : memMail,
			}),
			
			success: function(res) {
				console.log(res); // 성공, 실패 여부
				if(res.flag === "성공") {
			        alert('리뷰가 등록되었습니다!');
			        // 폼 초기화
			        $('.review-textarea').val('');
			        $('input[name="rating"]').prop('checked', false);
					fillStar(0);  // 0점으로 초기화 - 시각적 별 비우기
					selectedRating = 0; // 선택했던 별점 지우기
					$('#spoilerCheck').prop('checked', false);
			        // 리뷰 목록 새로고침
			        reviewListPrint();
			    } else {
			        alert(res.flag); // "이미 리뷰를 작성하셨습니다" or "비속어가 포함되어 등록할 수 없습니다"
					// 폼 초기화
			        $('.review-textarea').val('');
			        $('input[name="rating"]').prop('checked', false);
					fillStar(0);  // 0점으로 초기화 - 시각적 별 비우기
					selectedRating = 0; // 선택했던 별점 지우기
					$('#spoilerCheck').prop('checked', false);
			    }
			},
			error:function(xhr) {
				alert("오류 : " + xhr.status);
			},
			dataType: 'json'
		})
    });
} // 리뷰 작성 함수 끝


// 리뷰 페이지네이션
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
		if(i == currentReviewPage) {  
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
	
} // 페이지네이션 함수 끝


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