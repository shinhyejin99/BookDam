/**
 * 
 */
const attendanceClick = () => {
	
	// 출석하기 버튼 눌렀을 때
	$('#attendanceBtn').on('click', function(){
		
		const btn = $(this); // 클릭한 버튼
		
		//const message = $('#message'); // 멘트 부분
		
		
		// 비회원일 때 = 로그인 후 가능하다는 알림창이 뜬다.
		if(!memMail) {
			alert("로그인 후 가능합니다.");
			return; // 여기서 끝
		}
		
		// 회원일 때 
		$.ajax({
			url: `${mypath}/Attendance.do`,
			method: 'post',
			data: {
				// 출석체크 버튼을 눌렀다는 상태를 서버에게 알려줌 => 서버는 이 액션을 받고 출석체크 여부도 확인함.(DB에서!)
				// 이미 했다면 return 하고 이미 출석체크를 했다는 메세지를 출력하도록 함
				// 안 했다면 => 출석체크 insert, 회원 마일리지 컬럼 update, 마일리지 테이블 insert
				action: 'attendanceCheck', // 따옴표!!!!
				mem_mail: memMail
			},
			success: function(res) { // mileage가 res!
				console.log("출석체크: " + res.flag);
				
				/*console.log("=== SUCCESS 블록 실행됨 ===");
		        console.log("응답 타입:", typeof res);
		        console.log("응답 내용:", res);
		        console.log("응답이 null인가?", res === null);
		        console.log("응답이 undefined인가?", res === undefined);
		        console.log("응답 길이:", res ? res.length : "길이 없음");*/
				
				if (res.flag == "성공") {
					
					// 모달 표시
					showAttendanceSuccessModal(res.mileage);
					
	               $('#message').html(`
	                   <span style="color:green;">
	                       ✅ 출석 완료! 
	                       
	                   </span>`);

				   // 버튼 비활성화
			       $('#attendanceBtn').prop('disabled', true);
			       $('#attendanceBtn').text('출석 완료');
			       $('#attendanceBtn').css('background', '#6c757d'); // 회색으로 변경      
					   
				   // 캘린더 새로고침
				   loadCalendar();
				   
				} else if (res.flag == "오늘 출석체크 완료함"){
					$('#message').html(`
	                   <span id="btn-finish">
	                       ✅ 내일 또 만나요! 
	                   </span>`);
				   // 이미 출석한 경우에도 버튼 비활성화
			       $('#attendanceBtn').prop('disabled', true);
			       $('#attendanceBtn').text('출석 완료');
			       $('#attendanceBtn').css('background', '#6c757d');   
				}
			},
			error: function(xhr) {
				alert("오류 : " + xhr.status);
				/*console.log("=== ERROR 블록 실행됨 ===");
		        console.log("에러 상태:", xhr.status);
		        console.log("응답 텍스트:", xhr.responseText);
		        console.log("에러 타입:", xhr.statusText);*/
			},
			dataType: 'json'
		})
	})
}

// 캘린더 새고 및 로드
const loadCalendar = () => {
	
	console.log("loadCalendar 시작");
	
	// 현재의 날짜 데이터 얻기 - 2025년 6월 30일
	const now = new Date(); // 현재날짜 - 여기서 연도랑 월 추출
	const year = now.getFullYear(); // 연도 추출 - 2025년
	const month = now.getMonth(); // 월 추출 - 현재 6월이지만 5가 추출됨. (0부터 시작하기 때문)

	console.log(`현재 년도: ${year}, 월: ${month + 1}`);
	
	// 현재 월 표시 - 달력 상단에
	$('#currentMonth').text(`${year}년 ${month + 1}월`);
	
	// 캘린더 날짜들 생성 - generateCalendar(a,b) 함수 이용
	// 위에서 구한 현재 년도와 월을 함수의 파라미터로 넣어서 달력 틀을 만든다.
	generateCalendar(year, month);
	
	console.log("캘린더 생성 완료");	
	
	// 출석 데이터 로드 - 함수 이용 - 현재 년도와 월을 넣어서 데이터를 로드함
	loadAttendanceData(year, month);
}


// 캘린더 숫자 생성 - 캘린더 틀 만드는 함수
const generateCalendar = (year, month) => {
	
	// 1. 캘린더를 그릴 때 필요한 기본 정보 추출하기!
	const daysInMonth = new Date(year, month + 1, 0).getDate(); // 이번 달이 며칠까지 있는지
	//ex) new Date(2025, 6, 0) -> 2025년 7월 0일 -> 2025년 6월의 마지막 날
	const firstDayOfWeek = new Date(year, month, 1).getDay(); // 이번 달 1일이 무슨 요일인지. - 밑에 for문에 사용
	
	// 2. 누적변수 
	let code = '';
	
	//3. 캘린더에서 이전 달 부분 - 빈 공간으로 만들기
	for(let i = 0; i < firstDayOfWeek; i++) {
		code += `<div class="calendar-day empty"></div>`; // 나중에 그리드로 빈공간 그릴 예정
	}
	
	// 4. 이번 달 날짜들 생성
	for(let day = 1; day <= daysInMonth; day++) { // 이번달이 30일까지 있으면 1~30일까지 출력
		let classes = `calendar-day current-month`;
		
		// 오늘 날짜 체크 - 오늘 날짜를 표시하기 위해 today를 추가한다.
		const today = new Date();
		if(today.getFullYear() === year && today.getMonth() === month && today.getDate() === day) {
			classes += ` today`;
		}
		
		// padStart(2, '0') => 2보다 작으면 앞부터 0으로 채운다. => month=4 / ${String(month).padStart(2, '0') => 04 이런 식으로
		const dateStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
		code += `<div class="${classes}" data-date="${dateStr}">${day}</div>`;
		  // ex) <div class="calendar-day current-month" data-date="2025-06-30"> 30 </div>
	}
	
	// 5. 화면에 출력
	$('#calendarDays').html(code);
}


// 출석 데이터 가져오기 (현재 년도와 월을 파라미터로 사용)
const loadAttendanceData = (year, month) => {
	
	$.ajax({
		url: `${mypath}/Attendance.do`,
		method: 'post',
		data: {
			action: 'userAttendanceCheck',
			mem_mail: memMail,
			year: year,
			month: month +1  // 0부터 시작하기 때문에 +1 해주기! 
		},
		success: function(res) {
			console.log("===== 디버깅 시작 =====");
		    console.log("응답 전체:", res);

			console.log(res.attendanceDateList);
			if(res && res.attendanceDateList){
				// 캘린더에 표시
				res.attendanceDateList.forEach( date => {
					$(`.calendar-day[data-date="${date}"]`).addClass('attended');
				})
				
				// 오늘 출석 여부 확인해서 버튼 상태 설정함!
				const today = new Date();
				const todayStr = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`;
				
				console.log("오늘 날짜:", todayStr);
				console.log("출석 목록에 오늘 포함 :", res.attendanceDateList.includes(todayStr));
				
				if(res.attendanceDateList.includes(todayStr)) {
					// 오늘 이미 출석함 - 버튼 비활성화
					$('#attendanceBtn').prop('disabled', true);
					$('#attendanceBtn').text('출석 완료');
					$('#attendanceBtn').css('background', '#6c757d');
					$('#message').html(`
						<span id="btn-finish">
							✅ 내일 또 만나요! 
						</span>`);
				}
			}
		},
		error: function(xhr) {
			alert("오류 : " + xhr.status);
		},
		dataType: 'json'
	})
}


// 출석 성공 모달 표시 함수
function showAttendanceSuccessModal(mileage) {
    const modalHtml = `
        <div class="attendance-modal-overlay" id="attendanceModal">
            <div class="attendance-modal">
                <button class="close-btn" onclick="closeAttendanceModal()">&times;</button>
                <div class="success-icon">🎉</div>
                <h3>출석 완료!</h3>
                <div class="message">
                    오늘도 북담과 함께해주셔서 감사합니다!
                </div>
                <div class="mileage-highlight">
                    🎁 마일리지 ${mileage}점 지급!
                </div>
                <button class="confirm-btn" onclick="closeAttendanceModal()">확인</button>
            </div>
        </div>
    `;
    $('body').append(modalHtml);
}

// 모달 닫기 함수 (애니메이션 포함)
function closeAttendanceModal() {
    const modal = $('#attendanceModal');
    modal.addClass('fade-out');
    
    // 애니메이션 완료 후 제거
    setTimeout(() => {
        modal.remove();
    }, 300);
}


	