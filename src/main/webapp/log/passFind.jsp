<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
<link rel="shortcut icon" type="image/x-icon" href="../images/logo/찐.png">
<script src="../js/jquery-3.7.1.js"></script>
    <script> const contextPath = '<%= request.getContextPath() %>/';</script>
    
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
	
		}
		
		h2 {
		text-align: center; /* 제목 중앙 정렬 */
		margin-bottom: 35px;
		font-size: 32px;
		}


	img {
	    width: 200px;
		margin-top: 30px;
		margin-left: 300px;
		margin-bottom: 20px; 
}




  input {
	width: 100%; /* 입력 필드를 100% 너비로 */
	max-width: 400px; /* 최대 너비 400px */
	padding: 30px; /* 패딩 */
	margin: 10px auto; /* 자동 마진으로 중앙 정렬 */
	border: 1px solid #ccc;
	border-radius: 4px;
	font-size: 16px;
}
  .find_text.active {
	color: black;
	font-weight: bold;
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
}
  button:hover {
	background-color: #45a049; /* 호버시 배경색 변경 */
}
  
  .form-group label{
	margin-left: -320px; 
	margin-bottom: 100px;
	 

}

	  form div {
  display: flex;
  align-items: center; /* 수직 가운데 정렬 */
  margin-bottom: 30px;
}

     #err {
    font-size: 16px;
     margin-top: 10px; 
    margin-bottom: 10px; /* 버튼과의 하단 여백 (필요시 조정) */
    text-align: center; /* <--- 이 부분이 핵심입니다. 텍스트를 중앙 정렬합니다. */
    min-height: 40px; /* 두 줄 메시지를 위한 충분한 높이 확보 (예: 20px -> 40px) */
    font-weight: bold;
    color: red; /* 기본 에러 색상 */
    margin-left: 210px;
}

#err.success { 
margin-left: 0px;
}


   #mem_mail,
    #mem_bir,
    #otpInput {
      width: 80%; /* 입력 필드를 100% 너비로 */
	  max-width: 400px; /* 최대 너비 400px */
	  padding: 10px; /* 패딩 */
	  margin: auto; /* 자동 마진으로 중앙 정렬 */
	  border: 1px solid #ccc;
	  border-radius: 4px;
	  font-size: 16px
      box-sizing: border-box; 
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
      transition: all 0.3s ease;
      height: 40px;
    }
    
     #mem_mail:hover,
      #mem_bir:hover,
      #otpInput:hover {
    transform: translateY(-2px); /* 위로 10px 이동 */
  
}
	/* 인증번호 섹션 초기 숨김 */
	#otpSection {
		display: none;
	}
	
	#otpcheck,
	#emailcheck{
	
	width: 90px;
	padding: 0;
	margin-left: 10px;
	}
	
	#mem_mail,
	#otpInput{
	
	margin-left: 203px;
	}
	
	#mailspan {
      color: red;
      margin-left: -490px;
      font-size: 0.9em;
      flex-grow: 1;
      white-space: nowrap; 
      min-width: 0;
      font-size: 15px;
      margin-top: 70px; 
      position: relative;
  
}

  #otpspan
  {
      color: red;
      margin-left: 215px;
      font-size: 0.9em;
      flex-grow: 1;
      white-space: nowrap; 
      min-width: 0;
      font-size: 15px;
       position: relative;
}

#next-buttons {
  display: none;
  display: flex;                  /* 수평 정렬 */
  justify-content: center;        /* 가운데 정렬 */
  align-items: center;            /* 수직 중앙 정렬 */
  gap: 8px;      
  margin-top: 20px;
}

#next-buttons button {
  width: 100%;
  height: 45px;
  padding: 10px;
  font-size: 15px;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
    margin: 0;
}


/* 호버 효과 (선택 사항) */
#next-buttons button:hover {
  background-color: #45a049;
}


</style>




<script>
$(document).ready(function() {
  // 이메일 정규식 체크
  function isValidEmail(email) {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
  }

  // 이메일 인증번호 요청
  $('#emailcheck').on('click', function() {
    const email = $('#mem_mail').val().trim();
    
    if (!email) {
      alert('이메일을 입력하세요.');
      return;
    }
    if (!isValidEmail(email)) {
      alert('올바른 이메일 형식이 아닙니다.');
      return;
    }

    // 인증번호 입력칸, 인증완료 버튼 보이기
    $('#otpSection').show();
    $('#otpcheck').show();

    const contextPath = '/' + location.pathname.split('/')[1];

    $.ajax({
      url: contextPath + '/emailAuth',
      method: 'POST',
      data: {
        action: 'sendCode',
        userEmail: email
      },
      dataType: 'json',
      success: data => {
        $('#mailspan').text(data.msg).css('color', data.success ? 'green' : 'red');
      },
      error: () => {
        alert('이메일 인증 요청 중 오류가 발생했습니다.');
      }
    });
  });

  // 인증번호 검증
  $('#otpcheck').on('click', function() {
    const code = $('#otpInput').val().trim();
    if (!code) {
      alert('인증번호를 입력하세요.');
      return;
    }

    const contextPath = '/' + location.pathname.split('/')[1];

    $.ajax({
      url: contextPath + '/emailAuth',
      method: 'POST',
      data: {
        action: 'verifyCode',
        authCode: code
      },
      dataType: 'json',
      success: data => {
        $('#otpspan').text(data.msg).css('color', data.success ? 'green' : 'red');
        if (data.success) {
          // 인증완료되면 이메일 인증 버튼 글씨 빨간색으로 변경
          $('#emailcheck').css('color', 'red');
        }
      },
      error: () => {
        alert('인증번호 확인 중 오류가 발생했습니다.');
      }
    });
  });

  // 비밀번호 찾기 폼 제출 시
//비밀번호 찾기 폼 제출 시
  $('#memberForm').on('submit', function(e) {
    e.preventDefault();

    // .val() 호출 후 trim()을 통해 양쪽 공백 제거
    const mail = $('#mem_mail').val() ? $('#mem_mail').val().trim() : "";  // 빈 값은 ""로 처리
    const bir = $('#mem_bir').val() ? $('#mem_bir').val().trim() : "";  // 빈 값은 ""로 처리

    // 빈 값 체크
    if (!mail || !bir) {
      $('#err').css('color', 'red').text('모든 정보를 정확히 입력해주세요');
      return;
    }

    $.ajax({
        url: contextPath + '/PassFind.do',
        method: 'POST',
        data: {
          mem_mail: mail,
          mem_bir: bir
        },
        success: function(data) {
          if (data && data.pass) {
            $('#err').css('color', 'green').text('회원 비밀번호: ' + data.pass);

            // 기존 "비밀번호 찾기" 버튼 숨김
            $('#login').hide();

            // "확인" 버튼 보이기
            $('#next-buttons').show();
          } else {
            $('#err').css('color', 'red').text('일치하는 정보가 없습니다. 회원가입 해주세요');
          }
        },
        error: function() {
          $('#err').css('color', 'red').text('서버 오류');
          $('#login').prop('disabled', false);
        }
      });
    });

    // 확인 버튼 클릭 시 로그인 페이지 이동
    $('#btn-login').on('click', function() {
      location.href = contextPath + 'log/login.jsp';  // 경로 필요 시 조정
    });
}); 

</script>
</head>
<body>
  <div class="container">
  <img src="../images/logo/찐.png" alt="찐.png" />
    <h2>비밀번호 찾기</h2>

    <!-- 회원 로그인 폼 -->
    <form id="memberForm" >
      <div class="form-group">
        <input type="text" id="mem_mail" name="mem_mail" placeholder="이메일을 입력하세요.">
        <input type="button" id="emailcheck" value="이메일 인증" class="btn" />
        <span id="mailspan"></span>
        
      </div>

      <!-- 인증번호 입력란, 처음에는 숨김 -->
      <div id="otpSection" class="form-group">
        <input type="text" id="otpInput" placeholder="인증번호를 입력하세요." />
        <input type="button" id="otpcheck" value="인증완료" class="btn" />
        <span id="otpspan"></span>
      </div>

      <div class="form-group">
        <input type="text" id="mem_bir" name="mem_bir" placeholder="생년월일 8자리를 입력하세요." />
      </div>

      <div id="err"></div>

      <br><br>
      <button type="submit" id="login">비밀번호 찾기</button>
      
    </form>
      <!-- ✅ 전환될 버튼 영역 -->
    <div id="next-buttons" style="display: none;">
      <button type="button" id="btn-login" >확인</button>
  </div>
</body>
</html>