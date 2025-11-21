<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이메일 찾기</title>
<link rel="shortcut icon" type="image/x-icon" href="../images/logo/찐.png">
<script src="../js/jquery-3.7.1.js"></script>
    <script> const contextPath = '<%= request.getContextPath() %>/';</script>
<style >

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


	#cust_name, #cust_tel{
	  height: 30px;
	  width: 400px;
	  margin: 20px;
	  font-size: 16px;
	  border-radius: 10px; 
}
		img {
		width: 200px;
		margin-top: 30px;
		margin-left: 300px;
		margin-bottom: 20px; 
}
	 .box {
      text-align: center; 
      margin-bottom: 30px; 
      
 }

	.find_text {
	color: gray;
	font-weight: normal;
	text-decoration: none;
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
  .form-group label{
	margin-left: -320px; 
	margin-bottom: 100px;
	 

}
  .form-group {
	margin-bottom: 10px;
	text-align: center; /* 입력 필드 중앙 정렬 */

}

  button:hover {
	background-color: #45a049; /* 호버시 배경색 변경 */
}
  
     #err {
    font-size: 16px;
     margin-top: 10px; 
    margin-bottom: 10px; /* 버튼과의 하단 여백 (필요시 조정) */
    /* text-align: center; */ /* <--- 이 부분이 핵심입니다. 텍스트를 중앙 정렬합니다. */
    min-height: 40px; /* 두 줄 메시지를 위한 충분한 높이 확보 (예: 20px -> 40px) */
    font-weight: bold;
    color: red; /* 기본 에러 색상 */
/*     margin-left: -350px; */
    padding-left: 220px;
}

/* #err.success { 
margin-left: 0px;
} */

#name{

margin-left: -370px;

}
#cust_name,
    #cust_tel {
      width: 100%; /* 입력 필드를 100% 너비로 */
	  max-width: 400px; /* 최대 너비 400px */
	  padding: 10px; /* 패딩 */
	  margin: 10px auto; /* 자동 마진으로 중앙 정렬 */
	  border: 1px solid #ccc;
	  border-radius: 4px;
	  font-size: 16px
      box-sizing: border-box; 
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
      transition: all 0.3s ease;
      height: 40px;
    }
     #cust_name:hover,
     #cust_tel:hover {
    transform: translateY(-2px); /* 위로 10px 이동 */
  
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
  width: 180px;
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
$(function(){

	$('#memberForm').on('submit',function(e){
		e.preventDefault();
		
		  console.log('submit fired');
		
		//입렵값 가지고 오기
		const name = $('#cust_name').val().trim();
		const tel = $('#cust_tel').val().trim();
		
		// 빈칸 있을시 오류 메시지
		if(!name || !tel){
			$('#err').css('color', 'red').text('모든 정보를 입력해주세요');
			
			return;
		}
		
		$.ajax({
			url : contextPath+'mailFind.do',
			method: 'POST',
			data: {
				cust_name: name,
				cust_tel: tel
			},
			success: function(data){
				
				if(data && data.id){
					$('#err').css('color', 'green').text('회원 이메일 :  ' + data.id +  '  입니다');
					
					console.log(data.id);
					
					$('#login').hide();               // 기존 버튼 숨기기
			          $('#next-buttons').show();      
				}else{
					$('#err').css('color', 'red').text('일치하는 정보가 없습니다.  회원가입 해주세요');
				}
				
			},
			error: function(){
				$('#err').css('color', 'red').text('서버오류');
			}	
		})	
	})
	
	
	  // 로그인 페이지 이동
	  $('#btn-login').on('click', function() {
	    location.href = contextPath + '/log/login.jsp';
	  });
	// 비밀번호 찾기 페이지 이동
	  $('#btn-findPw').on('click', function() {
	    location.href = contextPath + '/log/passFind.jsp';
	  });

	});




</script>
</head>
<body>


<div class="container">
  <img src="../images/logo/찐.png" alt="찐.png" />
  <h2>이메일 찾기</h2>
 
  <!-- ✅ 회원 로그인 폼 -->
  <form id="memberForm" style="display: block">
    <div class="form-group">
    <label id="name">이름</label>
    <br>
      <input type="text" id="cust_name" name="cust_name" placeholder="&nbsp;&nbsp;이름을 입력하세요.">
    </div>

    
    <div class="form-group">
    <label>휴대폰 번호</label>
    <br>
      <input type="tel" id="cust_tel" name="cust_tel" placeholder="&nbsp;&nbsp;휴대폰번호를 입력해주세요.">
    </div>
    

    <div id="err" style="color:red; font-size:14px; margin-top:10px;"></div>

  
    <!-- ✅ 버튼은 링크 아래 동일 위치 -->
    <br><br>
    <button type="submit" id="login">이메일 찾기</button>
    
    <!-- ✅ 전환될 버튼 영역 -->
    <div id="next-buttons" style="display: none;">
      <button type="button" id="btn-login" >확인</button>
      <button type="button" id="btn-findPw" >비밀번호 찾기</button>
    </div>
  </form>
</div>

</body>
</html>