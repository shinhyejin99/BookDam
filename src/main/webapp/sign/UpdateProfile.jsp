<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html >
<head>
<meta charset="UTF-8">
<title>정보수정</title>
 
  
  <script src="../js/jquery-3.7.1.js"></script>
  <script type="text/javascript" src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <script src="../js/join.js"></script>
  <script src="../js/jquery.serializejson.min.js"></script>
  <style >
  
  body {
	 max-width: 600px;
    margin: 30px auto;
    padding: 30px;
    border: 1px solid #ccc;
    border-radius: 10px;
    background-color: #fdfdfd;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
  }

  .box img {
    display: block;
    margin: 0 auto 20px;
    width: 150px;
  }

  form div {
    display: flex;
    align-items: center;
    margin-bottom: 15px;
  }

  form label {
    width: 120px;
    font-weight: bold;
    margin-right: 10px;
    text-align: right;
  }

  form input[type="text"],
  form input[type="password"],
  form input[type="button"] {
    flex: 1;
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 5px;
  }

  form input[type="button"].btn,
  form button.btn {
    flex: none;
    margin-left: 10px;
    padding: 8px 12px;
    cursor: pointer;
    background-color: #3498db;
    color: white;
    border: none;
    border-radius: 5px;
  }

  form input[type="radio"] {
    margin-left: 10px;
    margin-right: 5px;
  }

  #updatespan,
  #mailspan,
  #passspan,
  #nickspan {
    color: red;
    margin-left: 10px;
    font-size: 0.9em;
  }

  .container h2 {
    text-align: center;
    margin-bottom: 20px;
  }
label[for="mail"],
label[for="name"],
label[for="bir"],
label[for="gender_m"],
label[for="gender_f"] {
  color:#e5e5e5;
 
}
  
input[readonly],
input[disabled] {
  color: #e5e5e5;              
  border-color : #e5e5e5;
}

label[for="name"] {
  color: #e5e5e5;
}
input[readonly] {
  color: #e5e5e5;
  border-color: #e5e5e5;
}
</style>
  <script>
  const contextPath = "<%= request.getContextPath() %>";
  const mem_mail = "<%= session.getAttribute("loginCust") != null ? ((kr.or.ddit.dam.vo.CustVO)session.getAttribute("loginCust")).getCust_id() : "" %>";

  $(function() {
    if (mem_mail === "") {
      alert("로그인 해주세요.");
      location.href = contextPath + "/login.jsp";
      return;
    }

    // 기존 회원정보 불러오기
    $.ajax({
      url: contextPath + "/GetMemberInfo.do",
      method: "POST",
      data: { mem_mail: mem_mail },
      dataType: "json",
      success: function(res) {
    	  console.log("DEBUG GetMemberInfo Response:", res);
    	  
        $('#mail').val(res.mem_mail)
        $('#name').val(res.cust_name)
        $('#bir').val(res.mem_bir)

        if (res.mem_gender === '남성' || res.mem_gender === 'M') {
        $('#gender_m').prop('checked', true);
        } else if (res.mem_gender === '여성' || res.mem_gender === 'F') {
        $('#gender_f').prop('checked', true);
        }

        $('#nickname').val(res.mem_nickname);
        $('#tel').val(res.cust_tel);
        $('#zip').val(res.cust_zip);
        $('#add1').val(res.cust_addr1);
        $('#add2').val(res.cust_addr2);
      },
      error: function() {
        alert("회원 정보 불러오기 실패");
      }
    });

    // 정보 수정
    $('#update').on('click', function() {
      let pass = $('#pass').val().trim();
      let passcheck = $('#passcheck').val().trim();

      if (pass === '' || passcheck === '') {
        $('#passspan').text('비밀번호를 입력하세요.');
        return;
      }

      if (pass !== passcheck) {
        $('#passspan').text('비밀번호가 일치하지 않습니다.');
        return;
      } else {
        $('#passspan').text('');
      }

      $.ajax({
        url: contextPath + "/UpdateProfile.do",
        method: 'POST',
        data: $('#ff').serialize(),
        dataType: 'json',
        success: function(res) {
          if (res.result === "success") {
            $('#updatespan').css('color', 'green').text('정보수정 성공');
          } else {
            $('#updatespan').css('color', 'red').text('정보수정 실패');
          }
        },
        error: function() {
          $('#updatespan').css('color', 'red').text('서버 오류');
        }
      });
    });

  });
</script>
</head>

<body>
<div class="box">
 <img src="../images/logo/찐.png" alt="찐.png" />
  <div class="container">
    <h2>정보수정</h2>
    <form id="ff">
      <div><label for="mail">이메일</label>
      <input type="text" id="mail" name="mem_mail" readonly>
      </div>
      
      <div><label for="pass">비밀번호</label>
      <input type="password" id="pass" name="mem_pass">
      </div>
      
      <div><label for="passcheck">비밀번호 확인</label>
      <input type="password" id="passcheck"><span id="passspan"></span>
      </div>
      
      <div><label for="name">이름</label>
      <input type="text" id="name" name="cust_name" readonly>
      </div>
      
      <div>
        <label for="bir">생일</label>
        <input type="text" id="bir" name="mem_bir" readonly>
        <input type="radio" id="gender_m" disabled>남성
        <input type="radio" id="gender_f" disabled>여성
      </div>
      
      <div><label for="nickname">닉네임</label><input type="text" id="nickname" name="mem_nickname">
      </div>
      
      <div><label for="tel">전화번호</label><input type="text" id="tel" name="cust_tel">
      </div>
      
      <div><label for="zip">주소</label><input type="text" id="zip" name="cust_zip" readonly><input type="button" value="우편번호" class="btn">
      </div>
      
      <div><input type="text" id="add1" name="cust_addr1">
      </div>
      
      <div><input type="text" id="add2" name="cust_addr2">
      </div>
      <div>
        <button type="button" id="update" class="btn">수정</button>
        <button type="button" id="secessionn" class="btn">회원탈퇴</button>
        <span id="updatespan"></span>
      </div>
    </form>
  </div>
</div>
</body>
</html>