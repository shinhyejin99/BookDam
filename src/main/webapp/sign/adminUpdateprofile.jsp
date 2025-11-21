<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
  <%
    String targetMail = request.getParameter("target_mail");

    if (targetMail == null || targetMail.trim().isEmpty()) {
        out.println("<script>alert('조회할 회원 이메일이 없습니다.'); history.back();</script>");
        return;
    }

    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html >
<head>
<meta charset="UTF-8">
<title>관리자용 회원 정보수정</title>
<link rel="shortcut icon" type="image/x-icon" href="../images/logo/찐.png">
 
  
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
label[for="mail"] {
  color:#e5e5e5;
 
}
  
input[readonly],
input[disabled] {
  color: #e5e5e5;              
  border-color : #e5e5e5;
}
  </style>

  <script>
  
  
    $(function () {
    	$.ajax({
            url: contextPath + "/GetMemberInfo.do",
            method: "POST",
            data: { mem_mail: target_mail },
            dataType: "json",
            success: function(res) {
                $('#mail').val(res.mem_mail).prop('readonly', true);
                $('#name').val(res.cust_name);
                $('#bir').val(res.mem_bir);

                if(res.cust_gender === '남성') {
                    $('#gender_m').prop('checked', true);
                } else if(res.cust_gender === '여성') {
                    $('#gender_f').prop('checked', true);
                }

                $('#nickname').val(res.mem_nickname);
                $('#tel').val(res.cust_tel);
                $('#zip').val(res.cust_zip);
                $('#add1').val(res.cust_addr1);
                $('#add2').val(res.cust_addr2);
            },
            error: function() {
                alert("회원 정보 불러오기에 실패했습니다.");
            }
        });

      // 정보수정
      $('#update').on('click', function () {
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
          url: '<%=request.getContextPath()%>/AdminUpdateProfile.do',
          method: 'POST',
          data: $('#ff').serialize(),
          success: function (res) {
            $('#updatespan').css('color', 'green').text('정보수정이 완료되었습니다.');
          },
          error: function () {
            $('#updatespan').css('color', 'red').text('정보수정 실패');
          }
        });
      });

      // 회원탈퇴
      $('#secessionn').on('click', function () {
        if (!confirm('정말 탈퇴하시겠습니까?')) return;

        $.ajax({
          url: '<%=request.getContextPath()%>/AdminDeleteMember.do',
          method: 'POST',
          data: { mem_mail: mem_mail },
          success: function (res) {
            if (res.result === "success") {
              alert('회원탈퇴가 완료되었습니다.');
              location.href = '<%=request.getContextPath()%>/main.jsp';
            } else {
              alert('회원탈퇴 실패');
            }
          },
          error: function () {
            alert('서버 오류');
          }
        });
      });
    });
  </script>
</head>

<body>
  <div class="box">
    <img src="../images/logo/찐.png" alt="찐.png">
    <div class="container">
      <h2>📌 관리자용 회원 정보수정</h2>
      <form id="ff" autocomplete="off">
        <div>
          <label for="mail">이메일</label>
          <input type="text" id="mail" name="mem_mail" />
        </div>
        <div>
          <label for="pass">비밀번호</label>
          <input type="password" id="pass" name="mem_pass" />
        </div>
        <div>
          <label for="passcheck">비밀번호 확인</label>
          <input type="password" id="passcheck" name="mem_passcheck" />
          <span id="passspan"></span>
        </div>
        <div>
          <label for="name">이름</label>
          <input type="text" id="name" name="cust_name" />
        </div>
        <div>
          <label for="bir">생일</label>
          <input type="text" id="bir" name="mem_bir" />
          <input type="radio" name="cust_gender" value="남성" id="gender_m" />남성
          <input type="radio" name="cust_gender" value="여성" id="gender_f" />여성
        </div>
        <div>
          <label for="nickname">닉네임</label>
          <input type="text" id="nickname" name="mem_nickname" />
        </div>
        <div>
          <label for="tel">전화번호</label>
          <input type="text" id="tel" name="cust_tel" />
        </div>
        <div>
          <label for="zip">우편번호</label>
          <input type="text" id="zip" name="cust_zip" />
          <input type="button" id="zipbtn" value="우편번호 찾기" class="btn" />
        </div>
        <div>
          <input type="text" id="add1" name="cust_addr1" />
        </div>
        <div>
          <input type="text" id="add2" name="cust_addr2" />
        </div>
        <div>
          <button type="button" id="update" class="btn">정보수정</button>
          <button type="button" id="secessionn" class="btn">회원탈퇴</button>
          <span id="updatespan"></span>
        </div>
      </form>
    </div>
  </div>
</body>
</html>