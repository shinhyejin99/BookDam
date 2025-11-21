
<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@page import="kr.or.ddit.dam.mem.service.MemServiceImpl"%>
<%@page import="kr.or.ddit.dam.mem.service.IMemService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>BookDam</title>
   <link rel="shortcut icon" href="${pageContext.request.contextPath}/images/favicon.png" type="image/png" />
   <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.js"></script>
   <script src="${pageContext.request.contextPath}/js/jquery.serializejson.min.js"></script>
   <script src="${pageContext.request.contextPath}/js/bookSearch.js"></script>
<%--    <li><a href="<%=request.getContextPath()%>/BestBook.do"></a></li> --%>
<%--    <ul class="no-dot">	
	<li><a href="<%=request.getContextPath()%>/BestBook.do"></a></li>
    <li><a href="<%=request.getContextPath()%>/BookDetail.do"></a></li>
   </ul> --%>
   <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookSearchCss.css">
   <link rel="stylesheet" href="${pageContext.request.contextPath}/main/main.css" />
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mainBannerCss.css"/>
	
  <script>

  currentPage = 1;
  memMail = null;

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
			location.href= `<%=request.getContextPath()%>/myPage/mypage.jsp`
		} else {
			location.href= `<%=request.getContextPath()%>/log/login.jsp`;	
		}
	}

////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////
 
    // ===== 슬라이더  =====
	let newCurrentSlide = 0; // 현재 슬라이드
	const newTotalSlides = 5; // 슬라이드 수 (0, 1, 2, 3, 4)
	let newAutoSlideInterval = null;
	
	// 슬라이드 이동 함수
	function newMoveToSlide(slideIndex) {
		console.log("새 슬라이더 이동:", slideIndex);
	    
	    const wrapper = document.getElementById('newSliderWrapper');
	    if (!wrapper) {
	        console.log("wrapper 요소 없음!");
	        return;
	    }
	    
	    const movePercent = -slideIndex * 20; // 20% = 100% / 5개
	    console.log("계산된 movePercent:", movePercent);
	    
	    wrapper.style.transform = "translateX(" + movePercent + "%)";
	    console.log("적용된 transform:", wrapper.style.transform)
	    
	    // 인디케이터 업데이트
	    document.querySelectorAll('.new-indicator').forEach((dot, index) => {
	        dot.classList.toggle('active', index === slideIndex);
	    });
	    
	    newCurrentSlide = slideIndex;
	    console.log(`슬라이드 ${slideIndex}로 이동 완료: ${movePercent}%`);
	}
	
	// 슬라이드 변경 - 콘솔 메세지 잘 보기.....
	function newChangeSlide(direction) {
		
		
		
		console.log("슬라이드 변경 시작 - direction:", direction, "현재:", newCurrentSlide); // 콘솔에 찍히는 거 확인하기!!!!!!!!
	    
	    newCurrentSlide += direction;
	    console.log("슬라이드 변경 시작 - direction:", direction, "현재:", newCurrentSlide); // 콘솔에 찍히는 거 확인하기!!!!!!!! 여기두...
	    
	    if (newCurrentSlide >= newTotalSlides) { // 현재 슬라이드 >= 마지막 슬라이드 -> 현재 슬라이드를 1번째 슬라이드로(마지막 슬라이드면 1번째 슬라이드로 간다)
	        newCurrentSlide = 0;
	        console.log("마지막에서 처음으로:", newCurrentSlide);
	    } else if (newCurrentSlide < 0) {		
	        newCurrentSlide = newTotalSlides - 1;
	        console.log("처음에서 마지막으로:", newCurrentSlide);
	    }
	    console.log("최종 이동할 슬라이드:", newCurrentSlide);
	    newMoveToSlide(newCurrentSlide);
	    newResetAutoSlide();
	}
	
	// 특정 슬라이드로 이동
	function newGoToSlide(slideIndex) {
	    console.log("특정 슬라이드로 이동:", slideIndex);
	    newCurrentSlide = slideIndex;
	    newMoveToSlide(slideIndex);
	    newResetAutoSlide();
	}
	
	// 자동 슬라이드 시작
	function newStartAutoSlide() {
	    console.log("자동 슬라이드 시작");
	    if (newAutoSlideInterval) clearInterval(newAutoSlideInterval);
	    
	    newAutoSlideInterval = setInterval(() => {
	        console.log("자동 슬라이드 실행");
	        newChangeSlide(1);
	    }, 3500);
	}
	
	// 자동 슬라이드 중지 - 마우스 올려놓을 때 멈추게 하려고!
	function newStopAutoSlide() {
	    if (newAutoSlideInterval) {
	        clearInterval(newAutoSlideInterval);
	        newAutoSlideInterval = null;
	        console.log("자동 슬라이드 중지");
	    }
	}
	
	// 자동 슬라이드 리셋
	function newResetAutoSlide() {
	    newStopAutoSlide();
	    newStartAutoSlide();
	}
	
	//슬라이더 초기화 함수
	function initializeSlider() {
	    console.log("슬라이더 초기화 시작");
	    
	    // 첫 번째 슬라이드로 설정
	    newMoveToSlide(0);
	    
	    // 기존 이벤트 완전히 제거 - 이벤트 중복때문에 2칸씩 건너뛰는 거 방지
	    $('.new-prev-btn').off();
	    $('.new-next-btn').off();
	    
	    // 이전/다음 버튼 이벤트
	    $('.new-prev-btn').on('click.slider', function() {
	    	e.preventDefault(); // 이벤트 중복때문에 2칸씩 건너뛰는 거 방지
	        e.stopPropagation();
	        console.log("이전 버튼 클릭");
	        newChangeSlide(-1); // 이전 버튼: 슬라이더 -1 -> 이전 슬라이더로 감
	    });
	    
	    $('.new-prev-btn').on('click.slider', function() {
	    	e.preventDefault(); // 이벤트 중복때문에 2칸씩 건너뛰는 거 방지
	        e.stopPropagation();
	        console.log("이전 버튼 클릭");
	        newChangeSlide(-1); // 이전 버튼: 슬라이더 -1 -> 이전 슬라이더로 감
	    });
	    
	    $('.new-next-btn').on('click.slider', function() {
	    	e.preventDefault(); // 이벤트 중복때문에 2칸씩 건너뛰는 거 방지
	        e.stopPropagation();
	        console.log("다음 버튼 클릭");
	        newChangeSlide(1); // 다음 버튼: 슬라이더 +1 -> 다음 슬라이더로 감
	    });
	    
	    // 인디케이터 이벤트 - 밑에 동그라미들
	    $('.new-indicator').off('click').on('click', function() {
	        const slideIndex = parseInt($(this).attr('data-slide'));
	        console.log("인디케이터 클릭:", slideIndex);
	        newGoToSlide(slideIndex);
	    });
	    
	    // 마우스 이벤트
	    const container = document.querySelector('.new-slider-container');
	    if (container) {
	        container.addEventListener('mouseenter', newStopAutoSlide);
	        container.addEventListener('mouseleave', newStartAutoSlide);
	        console.log("마우스 이벤트 등록됨");
	    }
	    
	    // 슬라이드 클릭 이벤트
	    $('.new-slide').off('click').on('click', function() {
	        const link = $(this).data('link');
	        console.log("슬라이드 클릭:", link);
	        
	        // ============여기는 임시 테스트 if고 채팅 완성하면 바꿔야 합니다================!!!!!!!
	        if (link === '#category') {
	            if (typeof openCategoryMenu === 'function') {
	                openCategoryMenu();
	            }
	        } else if (link && link !== '#') {
	            window.location.href = link;
	        }
	        //==========================================================================
	    });
	    
	    // 키보드 이벤트
	    $(document).off('keydown.slider').on('keydown.slider', function(e) {
	        if (e.key === 'ArrowLeft') {
	            newChangeSlide(-1);
	        } else if (e.key === 'ArrowRight') {
	            newChangeSlide(1);
	        }
	    });
	    
	    // 자동 슬라이드 시작
	    setTimeout(() => {
	        newStartAutoSlide();
	        console.log("자동 슬라이드 시작!");
	    }, 1000);
	    
	    console.log("슬라이더 초기화 완료");
	}
//-------------슬라이더 끝-----------

// 채팅 배너 클릭 이벤트
function connectWebSocket() {
 	const width = 1400
	const height = 900

	const left = (window.screen.width - width) / 2;
	const top = (window.screen.height - height) / 2;

	window.open(
	   `\${mypath}/ext/webSocketMutiChatting.jsp`, // 채팅 전용 페이지
	   "chatPopup",
	   `width=\${width},height=\${height},left=\${left},top=\${top},resizable=no`
	);
	
	// 다른 페이지로 이동
	//location.href=`\${mypath}/ext/webSocketMutiChatting.jsp`; // 채팅 전용 페이지
}

	// HTML이 로드 된 후...
 	$(function() {
		//////////////// 다른 페이지에도 필수로 넣어야 하는 이벤트 //////////////////
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
	 
	 // 슬라이더 초기화 (DOM 준비 완료 후)
		initializeSlider();


 	}) // $(function(){}) 끝

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

    <!-- 메인 컨테이너 -->
     <div class="main-container"> 
     	
     	<div class="new-slider-container">
        <div class="new-slider-wrapper" id="newSliderWrapper">
            <!-- 슬라이드 1 -->
            <div class="new-slide" data-link="<%=request.getContextPath()%>/BookDetail.do?bookNo=9788936434120">
                <img src="<%=request.getContextPath()%>/images/홈배너1.png" alt="<%=request.getContextPath()%>/images/홈배너1.png">
                <div class="new-slide-overlay">
                </div>
            </div>
            
            <!-- 슬라이드 2 -->
            <div class="new-slide" data-link="<%=request.getContextPath()%>/BookDetail.do?bookNo=9788952240569">
                <img src="<%=request.getContextPath()%>/images/홈배너2.png" alt="<%=request.getContextPath()%>/images/홈배너2.png">
                <div class="new-slide-overlay">
                </div>
            </div>
            
            <!-- 슬라이드 3 -->
            <div class="new-slide" data-link="<%=request.getContextPath()%>/attendance/attendance.jsp">
                <img src="<%=request.getContextPath()%>/images/홈배너3.png" alt="<%=request.getContextPath()%>/images/홈배너3.png">
                <div class="new-slide-overlay">
                </div>
            </div>
            
            <!-- 슬라이드 4 --> <!-- 채팅 하면 연결해야 합니다!!!! 스크립트도 수정 -->
            <!-- <div class="new-slide" data-link="#category"> -->
            
            <div class="new-slide" onclick="connectWebSocket()">
            <!-- <div class="new-slide" data-link="http://192.168.146.75/chatExam/ext/webSocketMutiChatting.jsp"> -->
            <%-- <div class="new-slide" data-link="<%=request.getContextPath()%>/ext/webSocketMutiChatting.jsp">
            <div class="new-slide" data-link="http://192.168.146.75/chatExam/ext/webSocketMutiChatting.jsp">
            <div class="new-slide" data-link="<%=request.getContextPath()%>/ext/webSocketMutiChatting.jsp"> --%>
                <img src="<%=request.getContextPath()%>/images/홈배너4.png" alt="<%=request.getContextPath()%>/images/홈배너4.png">
                <div class="new-slide-overlay">
                </div>
            </div>
            
            <!-- 슬라이드 5 -->
            <div class="new-slide" data-link="<%=request.getContextPath()%>/BookDetail.do?bookNo=9791193080146">
                <img src="<%=request.getContextPath()%>/images/홈배너5.png" alt="<%=request.getContextPath()%>/images/홈배너5.png">
                <div class="new-slide-overlay">
                </div>
            </div>
        </div>
        
        <!-- 네비게이션 버튼 -->
        <button class="new-slider-nav new-prev-btn" onclick="newChangeSlide(-1)">‹</button>
        <button class="new-slider-nav new-next-btn" onclick="newChangeSlide(1)">›</button>
        
        <!-- 인디케이터 -->
        <div class="new-slider-indicators">
		    <span class="new-indicator active" data-slide="0"></span>
		    <span class="new-indicator" data-slide="1"></span>
		    <span class="new-indicator" data-slide="2"></span>
		    <span class="new-indicator" data-slide="3"></span>
		    <span class="new-indicator" data-slide="4"></span>
		</div>
    </div>
		
		<!-- 🔥 베스트셀러 -->
		<section class="book-section">
		  <div style="display: flex; justify-content: space-between; align-items: center;">
		    <h2 class="section-title">🔥 베스트셀러</h2>
		    <a href="<%=request.getContextPath()%>/bookSearch/bookBestseller.jsp" class="btn-more" 
		    style="background-color: #F85A44; color: white; padding: 6px 12px; border-radius: 5px; text-decoration: none;">더보기</a>
		  </div>
		  
		  <div class="book-grid">
		    <c:forEach var="i" begin="0" end="4">
		      <c:choose>
		        <c:when test="${i < fn:length(bestList)}">
		          <c:set var="book" value="${bestList[i]}" />
		          <div class="book-card" onclick="goToBookDetail('${book.bookNo}')">
		            <img src="${book.coverImg}" alt="${book.bookTitle}" />
		            <div class="title">${book.bookTitle}</div>
		            <%-- <div class="price">₩${book.bookPrice}</div> --%>
		            <div class="price">₩<fmt:formatNumber value="${book.bookPrice}" type="number"/></div>
		          </div>
		        </c:when>
		        <c:otherwise>
		          <div class="book-card empty"></div>
		        </c:otherwise>
		      </c:choose>
		    </c:forEach>
		  </div>
		</section>
		
		<!-- 📚 20대 인기도서 -->
		<section class="book-section">
		  <h2>📚 20대 인기도서</h2>
		  <div class="book-grid" >
		    <c:forEach var="i" begin="0" end="4">
		      <c:choose>
		        <c:when test="${i < fn:length(ageList)}">
		          <c:set var="book" value="${ageList[i]}" />
		          <div class="book-card" onclick="goToBookDetail(${book.bookNo})">
		            <img src="${book.coverImg}" alt="${book.bookTitle}" />
		            <div class="title">${book.bookTitle}</div>
		            <%-- <div class="price">₩${book.bookPrice}</div> --%>
		            <div class="price">₩<fmt:formatNumber value="${book.bookPrice}" type="number"/></div>
		          </div>
		        </c:when>
		        <c:otherwise>
		          <div class="book-card empty"></div>
		        </c:otherwise>
		      </c:choose>
		    </c:forEach>
		  </div>
		</section>
		
		<!-- 📖 카테고리별 인기 도서 -->
		<section class="book-section">
		  <h2>📖 ${topCategory} 인기 도서</h2>
		  <div class="book-grid">
		    <c:forEach var="i" begin="0" end="4">
		      <c:choose>
		        <c:when test="${i < fn:length(categoryList)}">
		          <c:set var="book" value="${categoryList[i]}" />
		          <div class="book-card" onclick="goToBookDetail('${book.bookNo}')">
		            <img src="${book.coverImg}" alt="${book.bookTitle}" />
		            <div class="title">${book.bookTitle}</div>
		            <%-- <div class="price">₩${book.bookPrice}</div> --%>
		            <div class="price">₩<fmt:formatNumber value="${book.bookPrice}" type="number" /></div>
		          </div>
		        </c:when>
		        <c:otherwise>
		          <div class="book-card empty"></div>
		        </c:otherwise>
		      </c:choose>
		    </c:forEach>
		  </div>
		</section>
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

 	<!-- ✅ 푸터 -->
	<footer>
	  <div>
		  대전광역시 중구 계룡로 846, 3-4층 406호 (우)34035 <br>
		  도서 데이터 제공: 알라딘 API & 도서관 정보나루 <br>
		  &copy; 2025 BookDam. All rights reserved.
	  </div>
	</footer>    
</body>
</html>