<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배송 정보 입력</title>
</head>
<style>

	.container {
	  display: flex;
	  justify-content: center;       /* 가로 중앙 정렬 */
	  align-items: flex-start;       /* 위쪽 정렬 (필요 시 center로 변경) */
	  gap: 40px;                     /* gift-section과 summary 사이 여백 */
	  min-height: 750px;
	  max-width: 1200px;             /* 최대 너비 제한 */
	  margin: 0 auto;                /* 브라우저에서 가운데 정렬 */
	  padding: 10px;
	}
	
	.delivery-section {
	  width: 88%;
	  padding: 3%;
	  /* border: 2px solid orange; */
	  position: relative;
  	  left: -130px; /* 왼쪽으로 이동 */
  	  
  	  /* 만약 배경이 흰색이 아니면 */
  	  border-radius: 15px;
  	  background-color: white;
	}
	
	  .form-section {
	    display: flex;
	    margin: 0 auto 40px auto;
	    width: 88%;
	    padding: 3% 0 3% 0;
	  	/* border : 2px solid skyblue; */
	  	border-radius: 15px;
	  	box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
	  	
	  	align-content: flex-start;
	  }
	
  
	  #cartTable {
	    width: 100%;
	    border-collapse: collapse;
	    margin-top: 20px;
	    
	  }

    #deliverTable {
	   width: 100%;
	   border-collapse: collapse;
	   
	   /* border: 2px solid blue; */
	}
	
	#deliverTable td:first-child {
	  width: 35%;
	}
	
	
	#cartTable tr {
	  border-top: 1px solid #ccc;
	  border-bottom: 1px solid #ccc;
	}
	
	#cartTable td:nth-child(2) {
	  width: 20%;
	}  
	
	#cartTable td:nth-child(3) {
	  width: 40%;
	}
	
	#cartTable td:nth-child(4) {
	  width: 17%;
	}
	

	#cartTable th, #cartTable td {
	   border: none;
	   padding: 10px;
	   text-align: center;
	   
	   /* border : 2px solid skyblue; */
	 }
	  
	#deliverTable td {
  	   /* border : 2px solid skyblue; */
	  	width : auto;
	    padding: 10px;
	    vertical-align: middle;
  }
  

  input[type='text']:not(.search-input), [type='email'], [type='password'], [type='tel'], [type='number']{
    width: 100%;
    padding: 12px 10px;
    border-radius: 6px;
    border : 1px solid #bbbbbd;
    box-sizing: border-box;
    box-shadow: 0 1px 5px 0 rgba(0, 0, 0, .05);
    font-size: 13px;
  }
  
  input#zipcode {
  	width: 60%;
  	margin-right : 2%
  }
  
  input#searchZip {
  	  width: 38%;
      background-color: #F85A44;
      color: white;
       
      padding: 10px 15px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 13px;
      
	  /* line-height: 1.3; */              /* 줄 높이 조정 */
	  text-align: center;            /* 텍스트 수평 중앙 */
	  vertical-align: middle;        /* 인라인 요소의 수직 정렬 */
	  transition: background-color 0.2s;
	  box-sizing: border-box;        /* padding 포함해서 크기 계산 */
   }
        
  input#searchZip:hover {
      background-color: #c0392b;
  }

  #myMileage {
    font-weight: bold;
    color: #FF4D6D;
  }
  
  #cartList {
  	width : 85%;
  	height : 800px;
  	
 	/* 중앙 정렬 추가 */
  	margin: 20px auto;  /* 상하 여백 + 수평 중앙 */
  	display: block;
  	
  	/* border: 2px solid pink; */
  }
  
  img {
  	height : 160px;
  }
  
  .result-word {
	  width: 90%;
	  margin: 0 auto 20px auto;
	  color : #272727;
	}

</style>

<script type="text/javascript" src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/summaryCss.css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookSearchCss.css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/main/main.css">
<script src="../js/jquery-3.7.1.js"></script>
<script src="../js/delivery_info.js"></script>

<script>
<%
	// 세션에서 loginOk 값을 가져와 로그인 여부 확인
	MemVO mvo = (MemVO) session.getAttribute("loginOk");
	
	String user = null;
	Gson gson = new Gson();
	// 만약 loginOk 값이 있다면 mvo 객체를 user에 대입
	if (mvo != null) user = gson.toJson(mvo);
%>

//BookDam (프로젝트 이름)
mypath = '<%= request.getContextPath()%>';  
// 로그인 유저 객체
logUser = <%= user == null ? "null" : user %>;



///////////////// deliveryInfo.jsp만 새로 추가 //////////////////
// 선택한 도서 세션 값 가져오기
const sendArr = JSON.parse(sessionStorage.getItem("sendArr"));
if (sendArr) {
	console.log("선택한 도서(세션) :  ", sendArr)
} else {
	console.log("도서 세션 값 없음")
}
// 선택한 사은품 세션 값 가져오기
const giftArr = JSON.parse(sessionStorage.getItem("giftArr"));
if (giftArr) {
	console.log("사은품(세션) : ", giftArr)
} else {
	console.log("사은품 세션 값 없음")
}
////////////////////////////////////////////////////////////



//////////////////다른 페이지에도 필수로 넣어야 하는 이벤트 //////////////////

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


let myMile = 0;
let totalPrice = 0; // totalPrice는 개별 총 금액 (금액 * 수량)
total = 0; // total은 순수 총 금액
totalQty = 0;

// html이 로드된 후
$(function() {
	// 만약 로그인한 사용자라면 DB에서 카트 정보 가져오기
	if (logUser != null) {
		console.log("회원 정보(세션) : " + logUser.mem_mail);
		getDeliveryInfo();		
		
		// 멤버 정보 가져오기 (회원 등급을 얻기 위해)
		$.ajax({
			url: `\${mypath}/GetMemberInfobyMail.do`,
			method: 'get',
			data: {mem_mail : logUser.mem_mail},
			dataType: 'json',
			
			success: function(res) {
				memGrade = res.mem_grade;
			}, 
			error: function(xhr) {
				console.log(xhr.status);
			}
		});
	}
	

		
	// 선택한 상품만 보여주기 (단일 상품도 표시 가능)
	getBookInfo();
	
	// 사용할 마일리지 변경할 때마다 결제 금액 조절
	$('#useMileage').on('input', function() {
		// myMile 과 totalPrice 를 받아오고 실행 (비동기 때문에)
		if (!myMile || !totalPrice) return;
		
		$("input[type='radio']").prop('disabled', false);
		$("input[type='radio'][value='4']").prop('checked', false)
		
		let used = $(this).val();
		// 원래 마일리지보다 사용한 마일리지가 더 큰 경우
		if (used > myMile) {
			alert("보유 마일리지보다 많이 사용할 수 없습니다.");
			$(this).val(myMile);
			$('#total-text2').text((totalPrice-myMile).toLocaleString());
			$('#usedmileage-text').text('-' + used.toLocaleString() + "P");
		} else {
			$('#total-text2').text((totalPrice-used).toLocaleString());
			$('#usedmileage-text').text('-' + used.toLocaleString() + "P");
		}
			
		// 총 결제 금액보다 사용할 마일리지가 더 큰 경우
		if (used > totalPrice) {
			$(this).val(totalPrice);
			if (totalPrice-myMile <= 0){
				$('#total-text2').text("0 원");
				$("input[type='radio']").prop('disabled', true);
				$("input[type='radio'][value='4']").prop('disabled', false).prop('checked', true)
			} 
		}	
	})
	
	// 결제 버튼을 누르면
	// $('#btn-pay').on('click', function() {
	   $('#deliveryForm').on('submit', function() {
		event.preventDefault(); // 폼 제출 방지	   
		
		radioBtn = $('input[name="paytool"]:checked').val();
		console.log(radioBtn);
		
		if (radioBtn == 1) {
			alert("무통장 입금은 준비 중입니다. 다른 결제 수단을 이용해 주세요.");
		} else if (radioBtn == 2) {
			alert("신용카드 결제는 중비 중 입니다. 다른 결제 수단을 이용해 주세요.");
		} else if (radioBtn == 3) {
			// 카카오페이 API 시작
			payReadyAPI();
		} else if (radioBtn == 4) {
			alert("only 마일리지 결제");
		} else {
			alert("결제 수단을 선택하세요.");
		}
	});
	   
	// 6. 우편번호 검색 (카카오 주소 API 사용)
	   $('#searchZip').on('click', () => {
	       new daum.Postcode({
	           oncomplete: function(data) {
	               $('#zipcode').val(data.zonecode);          // 우편번호
	               $('#address1').val(data.roadAddress);      // 기본주소
	               $('#address2').focus();                    // 상세주소로 포커스 이동
	           }
	       }).open();
	   });

	   
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
    
    
<div class="container">
	<div class="delivery-section">
		<div class="result-word">📦 배송 정보 입력</div>
		
		<div class="form-section">
			<form id="deliveryForm" style="width: 60%; margin: auto;">
				  <table id='deliverTable'>
				    <tr>
				      <td><label for="receiver">수령인</label></td>
				      <td><input id="receiver" type="text" id="receiver" name="receiver" required></td>
				    </tr>
				    <tr>
				      <td><label for="tel">연락처</label></td>
				      <td><input type="tel" id="tel" name="tel" required></td>
				    </tr>
				  <tr>
				  <td><label for="mail">이메일</label></td>
				  <td>
				    <input id="receiver-mail" type="email" name="mail" 
				      <%
				        if (mvo != null) {
				          // 회원이면 기존 이메일 값도 표시 가능
				          out.print(" readonly required");
				        } else {
				          out.print(" required");
				        }
				      %>
				    >
				  </td>
				</tr>
				
				
				<tr
					<% 
						if(mvo != null) { 
							out.print(" disabled hidden");
						}
					%>>
				  <td><label for="pass">비밀번호<br><p style="font-size: 13px">(주문 조회시 사용)</p></label></td>
				  <td><input type="password" id="pass" name="pass"
				  	<%
				  		if(mvo == null) out.print(" required");
				  	%>>
				  </td>
				</tr>
				
				    <tr>
				      <td><label for="zipcode">우편번호</label></td>
				      <td><input type="text" id="zipcode" name="zipcode" required><input type="button" id="searchZip" value="우편번호 찾기"></td>
				    </tr>
				    <tr>
				      <td><label for="address1">기본주소</label></td>
				      <td><input type="text" id="address1" name="address1" required></td>
				    </tr>
				    <tr>
				      <td><label for="address2">상세주소</label></td>
				      <td><input type="text" id="address2" name="address2"></td>
				    </tr>
				    <tr
				    <%
				        if (mvo == null) {
				          out.print(" hidden");
				        }
				    %>
				    >
				      <td>보유 마일리지</td>
				      <td><span id="myMileage">0</span> M</td>
				    </tr>
				    <tr  
				    <%
				        if (mvo == null) {
				          out.print(" hidden");
				        }
				    %>
				      >
				      <td><label for="useMileage">사용할 마일리지</label></td>
				      <td><input type="number" id="useMileage" name="useMileage" min="0" step="100" placeholder="100단위로 입력"></td>
				    </tr>
				    
				    <tr>
				    
				   	<td>결제 수단</td>
					<td>
						<label><input type="radio" name="paytool" value="1" /> 무통장입금</label>
					   	<label><input type="radio" name="paytool" value="2" /> 신용카드</label> <br>
					   	<label><input type="radio" name="paytool" value="3" /> 카카오페이</label>
					   	<label><input type="radio" hidden="hidden" name="paytool" value="4" /></label>
					</td>   	
					   
				   </tr>
				  </table>
				  
				  <!-- <button type="submit" id="btn-pay">결제</button> -->
				  <div class="summary">
				      <div id="summary-title"><h3>주문합계</h3></div>
				      <div class="price-container">
				        <strong>상품 금액</strong>
				        <div><span id="total-text1">0</span>원</div>
				      </div>
				      <div class="deliveryprice-container"><strong>배송비</strong>무료배송</div>
				      <div class="usedmileage-container"><strong>사용 마일리지</strong><span id="usedmileage-text">0P</span></div>
				      
				      <hr class="summary-hr">
			          
			          <div class="earnedmileage-container">적립예상 마일리지 <span id="earnedmileage-text">0P</span></div><br>
			          <div class="totalprice-container">전체 주문 금액
			          	<br>
			          	<div class="totalprice-section">
			          		<strong id="total-text2">0</strong><strong>원</strong>
			          	</div>
			          </div>
			          <button id="btn-next" class="btn-next">다음</button>
				   </div>
			    
				</form>
			</div>
			
			<div id="cartList">
				<table id="cartTable">
				  <!-- <thead>
				    <tr>
				      <th>표지</th>
				      <th>상품명</th>
				      <th>가격</th>
				      <th>수량</th>
				      <th>합계</th>
				    </tr>
				  </thead> -->
				  <tbody id="cartBody">
				    <!-- 추가 상품 row는 여기에 동적으로 생성 가능 -->
				  </tbody>
				</table>
			</div>
	    
	</div>
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