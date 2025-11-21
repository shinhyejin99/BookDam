<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html >
<head>
<meta charset="UTF-8">
<title>회원 정보 수정</title>
 

  <style >
  
  .container {
	  display: flex;
	  flex-direction: column;
	  justify-content: center;       /* 가로 중앙 정렬 */
	  align-items: flex-start;       /* 위쪽 정렬 (필요 시 center로 변경) */
	  gap: 40px;                     /* gift-section과 summary 사이 여백 */
	  max-width: 1200px;             /* 최대 너비 제한 */
	  margin: 0 auto;                /* 브라우저에서 가운데 정렬 */
	  padding: 1%;
	}
	
	.modify-section {
		display: flex;
		flex-direction: column;
		width: 93%;
		padding: 2%;
		margin: 0 auto;
		
	}
	
	.form-section {
		margin: 40px auto;
		width: 70%;
		
		/* border: 2px solid skyblue; */
	}
	
  /* body {
	max-width: 600px;
    margin: 30px auto;
    padding: 30px;
    border: 1px solid #ccc;
    border-radius: 10px;
    background-color: #fdfdfd;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
  } */

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
    width: 130px;
    font-weight: bold;
    margin-right: 20px;
    text-align: right;
    
    /* border: 2px solid orange; */
  }

  #ff input[type="text"],
  #ff input[type="password"]
  /* form input[type="button"] */ {
    /* flex: 1; */
    width: 60%;
    height: 35px;
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 5px;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
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
    border-radius: 6px;
    
  }
  
  #ff #cust_zip {
  	width: 30%;
  }
  
  #zip-btn {
  	width: auto;
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

/*   .container h2 {
    text-align: center;
    margin-bottom: 20px;
  } */
  
label[for="mail"],
label[for="name"],
label[for="bir"],
label[for="gender_m"],
label[for="gender_f"] {
  color:#black;
 
}
  
input[readonly],
input[disabled] {
  color: #595959;              
  border-color : #595959;
}

.form-section input:not input[type="radio"] {
	width: 150px;
	height: 50px;
}

#bottom-btn {
	display: flex;
	justify-content: center;
	margin-top: 40px;

}


</style>
  <script>
  <%-- const mem_mail = "<%= session.getAttribute("loginCust") != null ? ((kr.or.ddit.dam.vo.CustVO)session.getAttribute("loginCust")).getCust_id() : "" %>"; --%>

  $(function() {
    if (logUser.mem_mail === "") {
      alert("로그인 해주세요.");
      location.href = mypath + "/login.jsp";
      return;
    }

    // 기존 회원정보 불러오기
    $.ajax({
      url: mypath + "/GetMemberInfo.do",
      method: "POST",
      data: { mem_mail: logUser.mem_mail },
      dataType: "json",
      success: function(res) {
    	  console.log("DEBUG GetMemberInfo Response:", res);
    	  
        $('#mail').val(res.mem_mail);
        $('#cust_name').val(res.cust_name);
        $('#bir').val(res.mem_bir);

        if (res.mem_gender === '남성' || res.mem_gender === 'M') {
        $('#gender_m').prop('checked', true);
        } else if (res.mem_gender === '여성' || res.mem_gender === 'F') {
        $('#gender_f').prop('checked', true);
        }

        $('#nickname').val(res.mem_nickname);
        $('#tel').val(res.cust_tel);
        $('#cust_zip').val(res.cust_zip);
        $('#add1').val(res.cust_addr1);
        $('#add2').val(res.cust_addr2);
        $('#pass').val(res.mem_pass);
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
        url: mypath + "/UpdateProfile.do",
        method: 'POST',
        data: $('#ff').serialize(),
        dataType: 'json',
        success: function(res) {
          if (res.result === "success") {
            $('#updatespan').css('color', 'green').text('정보수정 성공');
            
            $('#name').text($('#nickname').val());
          } else {
            $('#updatespan').css('color', 'red').text('정보수정 실패');
          }
        },
        error: function() {
          $('#updatespan').css('color', 'red').text('서버 오류');
        }
      });
    });

 	// 6. 우편번호 검색 (카카오 주소 API 사용)
   $('#zip-btn').on('click', () => {
       new daum.Postcode({
           oncomplete: function(data) {
               $('#cust_zip').val(data.zonecode);          // 우편번호
               $('#add1').val(data.roadAddress);      // 기본주소
               $('#add2').focus();                    // 상세주소로 포커스 이동
           }
       }).open();
   });
 	
   // 회원탈퇴
   $('#secessionn').on('click', function () {
     if (!confirm('정말 탈퇴하시겠습니까?')) return;


     $.ajax({
   	url: '/BookDam/DeleteMember.do',
       method: 'POST',
       success: function (res) {
           if (res.result === "success") {
               alert('회원탈퇴가 완료되었습니다.');
               location.href = '/BookDam/main/bookdam_main.jsp'; // 탈퇴 후 이동할 페이지
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
<div class="container">

	<div class="modify-section">
	 <!-- <img src="../images/main-logo.png" alt="main-logo.png" /> -->
	    <h3>📌 회원정보 수정</h3>
	    
	    <div class="form-section">
		    <form id="ff">
		      <div><label for="mail">이메일</label>
		      <input type="text" id="mail" name="mem_mail" readonly>
		      </div>
		      
		      <div><label for="pass">비밀번호 재설정</label>
		      <input type="password" id="pass" name="mem_pass">
		      </div>
		      
		      <div><label for="passcheck">비밀번호 확인</label>
		      <input type="password" id="passcheck"><span id="passspan"></span>
		      </div>
		      
		      <div><label for="name">이름</label>
		      <input type="text" id="cust_name" name="cust_name" readonly>
		      </div>
		      
		      <div>
		        <label for="bir">생일</label>
		        <input type="text" id="bir" name="mem_bir" readonly>
		      </div>
		      
		      <div>
		        <label for="gender">성별</label>
		        <input type="radio" id="gender_m" disabled>남성
		        <input type="radio" id="gender_f" disabled>여성
		      </div>
		     
		      
		      <div><label for="nickname">닉네임</label><input type="text" id="nickname" name="mem_nickname">
		      </div>
		      
		      <div><label for="tel">전화번호</label><input type="text" id="tel" name="cust_tel">
		      </div>
		      
		      <div><label for="zip">주소</label><input type="text" id="cust_zip" name="cust_zip" readonly><input id="zip-btn" type="button" value="우편번호" class="btn">
		      </div>
		      
		      <div><label for="addr1"></label><input type="text" id="add1" name="cust_addr1">
		      </div>
		      
		      <div><label for="addr2"></label><input type="text" id="add2" name="cust_addr2">
		      </div>
		      <div id="bottom-btn">
		        <button type="button" id="update" class="btn">수정</button>
		        <button type="button" id="secessionn" class="btn">회원탈퇴</button>
		        <span id="updatespan"></span>
		      </div>
		    </form>
		   </div>
	  </div>
</div>
</body>
</html>