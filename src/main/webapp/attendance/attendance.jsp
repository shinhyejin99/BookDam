<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출석체크</title>

<script src="<%=request.getContextPath() %>/js/jquery-3.7.1.js"></script>  
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookSearchCss.css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/main/main.css">
<script src="<%=request.getContextPath() %>/js/attendance.js"></script>
<style>

	.image-container {
		width: 100%; /* 화면 전체 너비 100%*/
		height: 450px;
		background: url('/BookDam/images/출석체크배너.png') no-repeat center center;
		background-size: contain; /* 가로는 100%, 세로는 비율 유지 */
	}
	
	.event-text {
	    text-align: center;
	    width: 100%;
	    font-family: sans-serif;
	    color: #333;
	    margin-top: 50px;
	    margin-bottom: 60px;
	}
	
	#info-one {
		font-size: 25px;
	}
	
	#info-two {
		font-size: 32px;
		font-weight: bold;
	}
	
		/* 캘린더 스타일 */
	.calendar-container {
		font-family: sans-serif;
	    max-width: 600px;
	    margin: 30px auto;
	    padding: 20px;
	    background: #fff;
	    border-radius: 10px;
	    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
	}
	
	.calendar-header {
	    text-align: center;
	    margin-bottom: 20px;
	}
	
	.calendar-header h2 {
	    color: #333;
	    font-size: 24px;
	    margin: 0;
	}
	
	/* 그리드 컨테이너 */
	.calendar {
	    width: 100%;
	}
	
	/* 그리드 아이템! */ /* 두 방향(가로-세로) 레이아웃 시스템 (2차원) => 달력 같은 모양임! */
	.calendar-weekdays {
	    display: grid;
	    grid-template-columns: repeat(7, 1fr); /* 열(column)의 배치 */ /* 7개(요일 칸)를 1대1 비율로 만든다 */
	    gap: 1px;
	    margin-bottom: 10px;
	}
	
	/* 요일 1개 요소 (월) */
	.weekday {
	    padding: 10px;
	    text-align: center;
	    font-weight: bold;
	    background: #f8f9fa;
	    color: #666;
	}
	
	/* 캘린더 숫자들 컨테이너 */
	.calendar-days {
	    display: grid;
	    grid-template-columns: repeat(7, 1fr);
	    gap: 2px;
	    background: #e9ecef;
	    border: 1px solid #dee2e6;
	    padding: 2px;
	    border-radius: 8px;
	}
	
	/* 캘린더 숫자 하나하나 요소 */
	.calendar-day {
		border-radius: 8px;
	    aspect-ratio: 1;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    background: #fff;
	    border: 1px solid #e9ecef;
	    position: relative;
	    font-size: 16px;
	    font-weight: 500;
	    transition: all 0.2s ease;
	    min-height: 50px;
	}
	
	.calendar-day.empty {
	    background: transparent;
	    border: none;
	    cursor: default;
	}
	
	.calendar-day.current-month {
	    cursor: pointer;
	}
	
	.calendar-day.current-month:hover {
	    background: #f8f9fa;
	}
	
	/* 오늘 */
	.calendar-day.today { 
	    background: #007bff;
	    color: white;
	    font-weight: bold;
	    border: 2px solid #0056b3;
	}
	
	/* 출석한 날 */
	.calendar-day.attended { 
	    color: #fff; /* 투명 */
	    font-weight: bold;
	}
	
	.calendar-day.attended::after {
	    content: '';
	    position: absolute;
	    top: 50%;
	    left: 50%;
	    transform: translate(-50%, -50%); /* 정 가운데 정렬 */
	    width: 50px; /* 이미지 크기 */
	    height: 50px;
	    background: url('/BookDam/images/attendCheck.png') no-repeat center center;
		background-size: contain;
		font-size: 0; /* 기존 폰트 크기 무시 */
	}
	
	/* 출석한 날 - 오늘 */
	.calendar-day.today.attended {
	    background: #ffffff !important;
	    border: 2px solid #1e7e34;
	}
	
	.day-number {
	    display: block;
	    z-index: 1;
	}
	
	.attendance-section {
	    max-width: 600px;
	    margin: 30px auto;
	    padding: 20px;
	    font-family: sans-serif;
	    text-align: center;
	    background: #fff;
	    border-radius: 10px;
	    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
	}
	
	.attendance-btn {
	    background: #007bff;
	    color: white;
	    border: none;
	    padding: 15px 30px;
	    font-size: 18px;
	    border-radius: 25px;
	    cursor: pointer;
	    margin-bottom: 20px;
	    transition: background 0.3s ease;
	}
	
	.attendance-btn:hover {
	    background: #0056b3;
	}
	
	#btn-finish {
		color: green;
	}
	
	.message {
	    font-size: 16px;
	    min-height: 20px;
	}


	/* 모달 오버레이 */
.attendance-modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.6);
    z-index: 1000;
    display: flex;
    justify-content: center;
    align-items: center;
    animation: fadeIn 0.3s ease;
}

/* 모달 컨테이너 */
.attendance-modal {
    background: white;
    padding: 40px 30px;
    border-radius: 20px;
    text-align: center;
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
    max-width: 400px;
    width: 90%;
    position: relative;
    animation: slideUp 0.4s ease;
}

/* 모달 헤더 */
.attendance-modal h3 {
    font-size: 24px;
    color: #333;
    margin: 0 0 20px 0;
    font-weight: bold;
}

/* 성공 아이콘 */
.attendance-modal .success-icon {
    font-size: 48px;
    margin-bottom: 15px;
    display: block;
}

/* 모달 메시지 */
.attendance-modal .message {
    font-size: 18px;
    color: #666;
    margin: 15px 0 25px 0;
    line-height: 1.5;
}

/* 마일리지 강조 */
.attendance-modal .mileage-highlight {
    background: linear-gradient(135deg, #28a745, #20c997);
    color: white;
    padding: 12px 20px;
    border-radius: 25px;
    font-size: 16px;
    font-weight: bold;
    margin: 15px 0;
    display: inline-block;
    box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
}

/* 확인 버튼 */
.attendance-modal .confirm-btn {
    background: linear-gradient(135deg, #007bff, #0056b3);
    color: white;
    border: none;
    padding: 12px 30px;
    font-size: 16px;
    border-radius: 25px;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
    margin-top: 10px;
}

.attendance-modal .confirm-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(0, 123, 255, 0.4);
}

.attendance-modal .confirm-btn:active {
    transform: translateY(0);
}

/* 닫기 버튼 (X) */
.attendance-modal .close-btn {
    position: absolute;
    top: 15px;
    right: 20px;
    background: none;
    border: none;
    font-size: 24px;
    color: #999;
    cursor: pointer;
    transition: color 0.3s ease;
}

.attendance-modal .close-btn:hover {
    color: #666;
}

/* 애니메이션 */
@keyframes fadeIn {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}

@keyframes slideUp {
    from {
        opacity: 0;
        transform: translateY(50px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* 모달 사라지는 애니메이션 */
.attendance-modal-overlay.fade-out {
    animation: fadeOut 0.3s ease forwards;
}

.attendance-modal-overlay.fade-out .attendance-modal {
    animation: slideDown 0.3s ease forwards;
}

@keyframes fadeOut {
    from {
        opacity: 1;
    }
    to {
        opacity: 0;
    }
}

@keyframes slideDown {
    from {
        opacity: 1;
        transform: translateY(0);
    }
    to {
        opacity: 0;
        transform: translateY(50px);
    }
}

</style>
<script>
memMail = '${sessionScope.loginOk.mem_mail}'// 회원 이메일 - 서버로 보낼 때 변수 사용!!!
//////////////////다른 페이지에도 필수로 넣어야 하는 이벤트 //////////////////
<%
	// 세션에서 loginOk 값을 가져와 로그인 여부 확인
	MemVO mvo = (MemVO) session.getAttribute("loginOk");
	
	String user = null;
	Gson gson = new Gson();
	// 만약 loginOk 값이 있다면 mvo 객체를 user에 대입
	if (mvo != null) user = gson.toJson(mvo);
%>

// BookDam (프로젝트 이름)
mypath = '<%= request.getContextPath()%>';  
// 로그인 유저 객체
logUser = <%= user == null ? "null" : user %>;



// 로그인 확인용 콘솔창
if(logUser != null) {
	console.log("현재 로그인ID :" + logUser.mem_mail);
	memMail = logUser.mem_mail;
} else {
	console.log("로그인 상태 : 비회원");
	memMail = null;
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
	if (logUser != null) {
		location.href= mypath + '/myPage/mypage.jsp'
	} else {
		location.href= `\${mypath}/log/login.jsp`	
	}
}

////////////////////////////////////////////////////////////////////
	
	$(function() {	  
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
	
		attendanceClick(); // 출석체크 버튼 클릭
		loadCalendar(); // 달력 로드
	})
	
	// 카테고리 버튼 영역 추가함
 	function openCategoryMenu() {
        document.getElementById('categoryOverlay').classList.add('active');
        document.body.style.overflow = 'hidden'; // 스크롤 방지
    }

    function closeCategoryMenu() {
        document.getElementById('categoryOverlay').classList.remove('active');
        document.body.style.overflow = 'auto'; // 스크롤 복원
    }
    
    function goToBookList(category) {
    	console.log('클릭한 카테고리:', category);
    	console.log('인코딩된 카테고리:', encodeURIComponent(category)); 
    	/* alert("선택된 카테고리:"+ category); */
        closeCategoryMenu();
        
        window.location.href = '<%=request.getContextPath()%>/bookSearch/bookCategoryList.jsp?category=' + encodeURIComponent(category);
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
    	<!-- 헤더 영역 -->
    	<div class="header-container-ham">
        	<!-- 네비게이션 메뉴 -->
            <nav class="nav-menu">
            	<!-- 햄버거 메뉴 버튼 -->
		        <button class="hamburger-btn" onclick="openCategoryMenu()">
		            <div class="hamburger-icon">
		                <span></span>
		                <span></span>
		                <span></span>
		            </div>
		        </button>
                <a href= '<%=request.getContextPath() %>/main/map.jsp'>서점이용안내</a>
                <a href= '<%=request.getContextPath() %>/bookSearch/bookBestseller.jsp'>베스트셀러</a>
                <a href= '<%=request.getContextPath() %>/EventList.do'>문화/행사</a>
                <a href= '<%=request.getContextPath() %>/NoticeList.do'>공지사항</a>
                <a href= '<%=request.getContextPath() %>/QnaList.do'>고객센터</a> 
            </nav>
         </div>
    <hr id="nav-bottom">

	<div class="image-container">
	</div>
	<div class="event-text">
		<span id="info-one">매일 출석체크하면</span><br><br>
		<sapn id="info-two">최대 1000마일리지 지급!</sapn>
	</div>
	
	<div class="calendar-container">
	    <div class="calendar-header">
	        <h2 id="currentMonth"></h2> <!-- loadCalendar()에서 생성 "2025년 6월" 이런 식으로-->
	    </div>
	    <div class="calendar">
	        <div class="calendar-weekdays">
	            <div class="weekday">일</div>
	            <div class="weekday">월</div>
	            <div class="weekday">화</div>
	            <div class="weekday">수</div>
	            <div class="weekday">목</div>
	            <div class="weekday">금</div>
	            <div class="weekday">토</div>
	        </div>
	        <div class="calendar-days" id="calendarDays">
	            <!-- 날짜는 attendance.js에서 생성됨! -->
	        </div>
	    </div>
	</div>

	<!-- 출석 버튼 섹션 -->
	<div class="attendance-section">
        <button id="attendanceBtn" class="attendance-btn">출석하기</button>
        <div id="message" class="message"></div>
        <div id="message-mileage"></div>
    </div>

	<!-- 전체화면 카테고리 오버레이 -->
    <div class="category-overlay" id="categoryOverlay" onclick="closeCategoryMenu()">
        <div class="category-popup" onclick="event.stopPropagation()">
            <!-- 팝업 헤더 -->
            <div class="popup-header">
                <div class="popup-title">카테고리 전체보기</div>
                <button class="close-btn" onclick="closeCategoryMenu()">×</button>
            </div>
            <!-- 카테고리 컨텐츠 -->
            <div class="category-content">
                <div class="category-grid">

                   <!-- 국내도서 -->
                   <div class="sub-category-section active" id="novel">
                       <div class="sub-category-title"></div>
                       <div class="sub-category-grid">
                           <a href="#" class="sub-category-item" onclick="goToBookList('소설')">소설</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('에세이')">에세이</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('인문학')">인문학</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('사회과학')">사회과학</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('과학')">과학</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('자기계발')">자기계발</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('경제경영')">경제경영</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('만화')">만화</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('어린이')">어린이</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('유아')">유아</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('종교')">종교</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('역사')">역사</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('예술')">예술</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('청소년')">청소년</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('요리')">요리</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('좋은부모')">좋은부모</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('잡지')">잡지</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('건강')">건강</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('성공')">성공</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('컴퓨터')">컴퓨터</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('수험서')">수험서</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('중학교참고서')">중학교참고서</a>
                           <a href="#" class="sub-category-item" onclick="goToBookList('대학교재')">대학교재</a>
                       </div>
                   </div>
               </div>
           </div>
       </div>
   </div>

<footer>
  <div>
	  대전광역시 중구 계룡로 846, 3-4층 406호 (우)34035 <br>
	  도서 데이터 제공: 알라딘 API & 도서관 정보나루 <br>
	  &copy; 2025 BookDam. All rights reserved.
  </div>
</footer>  

</body>
</html>