<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인창</title>
<link rel="shortcut icon" type="image/x-icon" href="../images/logo/찐.png">
<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
body {

display: flex;
justify-content: center; /* 수평 중앙 정렬 */
align-items: center; /* 수직 중앙 정렬 */
height: 100vh; /* 화면 전체 높이 사용 */
margin: 0; /* 기본 마진 제거 */
background-color: #f7f7f7; /* 배경색 설정 */
}

.container {
height:80%;
width: 100%; /* 기본적으로 가로 100% */
max-width: 850px; /* 최대 너비 설정 */
padding: 20px; /* 내부 여백 */
background-color: #fff; /* 배경색 */
box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* 그림자 */
border-radius: 10px; /* 모서리 둥글게 */
box-sizing: border-box; /* 패딩을 포함한 박스 크기 계산 */
margin-top: -110px;
margin-left: 100px;
}

h2 {
text-align: center; /* 제목 중앙 정렬 */
margin-bottom: 35px;
font-size: 32px;
}

#inq {
text-align: center; /* 로그인 방식 선택 텍스트 중앙 정렬 */
margin-bottom: 20px;
}

#inq li {
display: inline-block;
margin-right: 10px; /* 간격 조정 */
}

.form-group {
margin-bottom: 10px;
text-align: center; /* 입력 필드 중앙 정렬 */
}

input {
width: 100%; /* 입력 필드를 100% 너비로 */
max-width: 400px; /* 최대 너비 400px */
padding: 10px; /* 패딩 */
margin: 10px auto; /* 자동 마진으로 중앙 정렬 */
border: 1px solid #ccc;
border-radius: 4px;
font-size: 16px;
}

.check{
display: flex; /* Flexbox를 사용하여 내부 요소를 정렬합니다. */
justify-content: flex-start; /* 왼쪽 정렬 */
align-items: center; /* 수직 중앙 정렬 */
margin-top: 5px; /* 상단 여백 */
margin-bottom: 15px; /* 하단 여백 */
max-width: 400px; /* input과 동일한 최대 너비 */
margin-left: auto; /* 좌우 마진 자동 (중앙 정렬) */
margin-right: auto;
}

.check label {
display: flex; /* label 내부의 input과 텍스트를 flex로 정렬 */
align-items: center; /* 체크박스와 텍스트 수직 중앙 정렬 */
font-size: 13px; /* ✅ 폰트 크기 조정 (원하는 크기로 변경) */
}

.check input[type="checkbox"] {
width: auto; /* 체크박스 본연의 크기 유지 */
height: auto; /* 체크박스 본연의 크기 유지 */
margin: 0 5px 0 0; /* 체크박스와 텍스트 사이 간격 조정 */
padding: 0;
box-shadow: none; /* 체크박스에 그림자 제거 */
}

button {
display: block; /* 버튼을 블록 요소로 설정 */
width: 100%; /* 버튼을 100% 너비로 */
max-width: 400px; /* 최대 너비 400px */
padding: 10px;
margin: 20px auto; /* 버튼을 중앙 정렬 */
background-color: #4CAF50; /* 배경색 */
color: white; /* 글자 색 */
border: none;
border-radius: 4px;
font-size: 15px;
cursor: pointer;
margin-top: -20px;
}

button:hover {
background-color: #45a049; /* 호버시 배경색 변경 */
}

.find_text {
color: gray;
font-weight: normal;
text-decoration: none;
}

.find_text.active {
color: black;
font-weight: bold;
}

ul#inq {
text-align: center;
margin-bottom:  30px;
}

img {
width: 200px;
margin-top: 30px;
margin-left: 300px;
margin-bottom: 20px; 
}

#mem_mail, #mem_pass, #nomem_mail, #nomem_pass{
box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
transition: all 0.3s ease;
margin-top: 20px;
}

#mem_mail:hover, #mem_pass:hover, #nomem_mail:hover, #nomem_pass:hover{
transform: translateY(-2px); /* 위로 10px 이동 */
}


.form-group label input[type="checkbox"] {
    margin-right: -180px; 
    margin-bottom: 20px; 
    } 
    
 .form-group label{
    margin-left: -500px;
    
    }
    #nomem_pass{
    margin-bottom: 20px;
     }
     
     #err {
    font-size: 16px;
     margin-top: -5px; 
    margin-bottom: 10px; /* 버튼과의 하단 여백 (필요시 조정) */
    text-align: center; /* <--- 이 부분이 핵심입니다. 텍스트를 중앙 정렬합니다. */
    min-height: 40px; /* 두 줄 메시지를 위한 충분한 높이 확보 (예: 20px -> 40px) */
    font-weight: bold;
    color: red; /* 기본 에러 색상 */
    margin-left: -50px;
   
}

#errNonMember{

font-size: 16px;
 margin-bottom : 40px;
   margin-top:10px;
    text-align: center;
    font-weight: bold;
    color: red; /* 기본 에러 색상 */
    margin-left: -160px;
  
	
}


/* #err.success-message (기존 성공 메시지 스타일) */
#err.success-message {
    color: green;
    background-color: #e6ffe6;
    padding: 8px 15px;
    border-radius: 5px;
    border: 1px solid #a3e6a3;
    margin-top: 10px; /* 위쪽 여백 */
    margin-bottom: 5px; /* 아래쪽 여백 (버튼과의 간격) */
    display: inline-block; /* 패딩 등을 위해 블록 요소처럼 동작 */
    max-width: 400px; /* 성공 메시지 박스도 너비 제한 */
 
}
     
   
</style>

<script src="../js/jquery-3.7.1.js"></script>
<script src="../js/jquery.serializejson.min.js"></script>
<script type="text/javascript">
    const contextPath = "<%= request.getContextPath() %>";
</script>
<script>
document.addEventListener("DOMContentLoaded", function(){
  member = document.getElementById('memberlogin');
  nomember = document.getElementById('nomemberlogin');
  memberForm = document.getElementById('memberForm');
  nomemberForm = document.getElementById('nomemberForm');

  member.addEventListener("click", function(e){
    e.preventDefault();
    member.classList.add("active");
    nomember.classList.remove("active");
    memberForm.style.display="block";
    nomemberForm.style.display="none";
  });

  nomember.addEventListener("click", function(e){
    e.preventDefault();
    nomember.classList.add("active");
    member.classList.remove("active");
    memberForm.style.display="none";
    nomemberForm.style.display="block";
  });
});

// ✅ 관리자 / 회원 로그인
$(function() {
  $('#memberForm').on('submit', async function(e) {
    e.preventDefault(); // 기본 폼 제출 방지

    const email = $('#mem_mail').val().trim();
    const password = $('#mem_pass').val().trim();
    const isAdmin = $('#isAdmin').is(':checked');  // 관리자 체크 여부

    let fdata;
    if (isAdmin) {
      fdata = {
        admin_id: email,
        admin_pass: password
      };
    } else {
      fdata = {
        mem_mail: email,
        mem_pass: password
      };
    }
    


    try {
      const response = await fetch('/BookDam/Login.do', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json;charset=utf-8'
        },
        body: JSON.stringify(fdata)
      });

      if (!response.ok) {
          throw new Error(`서버 오류: ${response.status}`);
        }
      
      const result = await response.json();
      console.log(result);

      if (result.flag === 'ok') {
      if (result.role === 'admin') {
     
          location.href = contextPath + "/main/adminMain.jsp"; // 관리자 페이지
        } else {
          /* location.href = "../main/bookdam_main.jsp"; // 일반 회원 */
          location.href = "<%=request.getContextPath()%>/BestBook.do"; // 일반 회원
        }
      } else {
        $('#err').html('<style="width:30px; margin-left: -300px;"">🚨 입력하신 정보가 일치하지 않습니다.다시 확인해 주세요.')
                 .css('color', 'red');
      }
    } catch (error) {
    	console.error('로그인 중 오류 발생:', error);
      $('#err').text('로그인 중 오류가 발생했습니다.').css('color', 'red');
    }
  });
});

// ✅ 비회원 주문확인
$(function() {
  $('#nomemberForm').on('submit', async function(e) {
    e.preventDefault();

    const fdata = $(this).serializeJSON();
    try {
      const response = await fetch('/BookDam/NmOrder.do', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json;charset=utf-8'
        },
        body: JSON.stringify(fdata)
      });

      if (!response.ok) {
        throw new Error('서버 오류: ' + response.status);
      }

      const result = await response.json();

      if (result.flag === 'ok') {
        location.href = "../order/order_list_nmem.jsp";
      } else {
        $('#errNonMember').html(' 🚨 입력하신 정보가 일치하지 않습니다.<br>다시 확인해 주세요')
                          .css('color', 'red');
      
      }
    } catch (error) {
      console.error('비회원 로그인 요청 실패:', error);
      $('#errNonMember').html('🚨비회원 로그인 중 오류가 발생했습니다.').css('color', 'red');
    }
  });
});
</script>
</head>

<body>
<div class="container">
  <img src="../images/logo/찐.png" alt="${book.bookTitle}" />
  <h2>로그인</h2>

  <!-- 로그인 방식 선택 -->
  <ul id="inq">
    <li><a href="#" class="find_text active" id="memberlogin">회원 로그인</a></li>
    <li class="l">|</li>
    <li><a href="#" class="find_text" id="nomemberlogin">비회원 주문확인</a></li>
  </ul>

  <!-- ✅ 회원 로그인 폼 -->
  <form id="memberForm" style="display: block">
    <div class="form-group">
      <input type="text" id="mem_mail" name="mem_mail" placeholder="&nbsp;&nbsp;이메일을 입력해주세요.">
    </div>

    <div class="form-group">
      <input type="password" id="mem_pass" name="mem_pass" placeholder="&nbsp;&nbsp;비밀번호를 입력해주세요.">
    </div>

    <!-- ✅ 관리자 로그인 체크박스 추가 -->
    <div class="form-group" style="margin-left:20px; font-size:14px;">
      <label><input type="checkbox" id="isAdmin"> 관리자 로그인</label>
    </div>

    <div id="err" style="color:red; font-size:14px;"></div>

    <!-- 하단 링크 -->
    <ul id="inq">
      <li><a href="../log/mailFind.jsp" class="find_text">이메일 찾기</a></li>
      <li class="l">|</li>
      <li><a  href="../log/passFind.jsp" class="find_text">비밀번호 찾기</a></li>
      <li class="l">|</li>
      <li><a href="../sign/회원가입.html" class="find_text">회원가입</a></li>
    </ul>

    <br><br>
    <button type="submit" id="login">로그인</button>
  </form>

  <!-- ✅ 비회원 주문확인 폼 -->
  <form id="nomemberForm" style="display: none">
    <div class="form-group">
      <input type="text" id="nomem_mail" name="nmem_mail" placeholder="&nbsp;&nbsp;이메일을 입력해주세요.">
    </div>

    <div class="form-group">
      <input type="password" id="nomem_pass" name="nmem_pass" placeholder="&nbsp;&nbsp;주문 비밀번호를 입력해주세요.">
    </div>

    <div id="errNonMember" style="color:red; font-size:14px; margin-top:10px;"></div>

    <ul id="inq">
      <li><a target="_blank" href="#" class="find_text">이메일 찾기</a></li>
      <li class="l">|</li>
      <li><a target="_blank" href="#" class="find_text">비밀번호 찾기</a></li>
      <li class="l">|</li>
      <li><a href="../sign/회원가입.html" class="find_text">회원가입</a></li>
    </ul>

    <br><br>
    <button type="submit" id="nomem_login">주문 확인</button>
  </form>
</div>
</body>
</html>