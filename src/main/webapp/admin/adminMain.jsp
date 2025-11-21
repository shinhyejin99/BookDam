<%@page import="kr.or.ddit.dam.vo.AdminVO"%>
<%@page import="java.util.List"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
 <title>회원 정보 관리</title>
 <link rel="shortcut icon" type="image/x-icon" href="../images/logo/찐.png">


 <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/adminCss.css">
 <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.js"></script>
 <script src="${pageContext.request.contextPath}/js/adminMemberManage.js"></script>
 
 <style>
 .search-btns {
 	display: flex;
 	flex-direction: row;
 	align-items: center;
 	margin-top: 15px;
 	gap: 10px;
 }
 
 thead {
 	background-color: black;
 	color: white;
 	text-align: center;
 }
 </style>
</head>
<body>

<div class="container">
  
    <aside id="side">
      <h3>
	  <a href="<%=request.getContextPath() %>/main/adminMain.jsp" style="color: white; text-decoration: none;">
	  관리자<br>페이지
	  </a>
	  </h3>
        <ul>
            <li class="active"><a href="<%=request.getContextPath() %>/admin/adminMain.jsp">회원관리</a></li>
            <li><a href="${pageContext.request.contextPath}/BookCategory.do">상품관리</a></li> 
            <li><a href="<%=request.getContextPath() %>/orderManage/orderManage.jsp">주문관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/QnaAdminList.do">1:1 고객센터</a></li>
            <li><a href="${pageContext.request.contextPath}/EventAdminList.do">행사 등록</a></li>
            <li><a href="${pageContext.request.contextPath}/NoticeAdminList.do">공지사항 등록</a></li>
        </ul>
    </aside>

  <!-- 오른쪽: 본문 -->
  <div class="content">
    <h2>회원 정보 관리</h2>

    <!-- 검색 영역 -->
    <form id="search-form">
      <table class="search-table">
        <tr>
          <td>검색어</td>
          <td>
            <select name="searchType">
              <option value="email">이메일</option>
              <option value="name">이름</option>
              <option value="nickname">닉네임</option>
            </select>
            <input type="text" name="searchValue">
          </td>
        </tr>
        <tr>
          <td>생년월일</td>
          <td>
            <input type="date" name="birthStart"> ~
            <input type="date" name="birthEnd">
          </td>
        </tr>
        <tr>
          <td>가입일</td>
          <td>
            <input type="date" name="joinStart"> ~
            <input type="date" name="joinEnd">
          </td>
        </tr>
        <tr>
          <td>주소</td>
          <td>
            <input type="text" name="address" placeholder="기본주소 입력">
          </td>
        </tr>
        <tr>
          <td>등급</td>
          <td>
            <label><input type="radio" name="grade" value="all" checked> 전체</label>
            <label><input type="radio" name="grade" value="일반등급"> 일반등급</label>
            <label><input type="radio" name="grade" value="실버등급"> 실버등급</label>
            <label><input type="radio" name="grade" value="골드등급"> 골드등급</label>
            <label><input type="radio" name="grade" value="다이아몬드등급"> 다이아몬드등급</label>
          </td>
        </tr>
      </table>
      
      <div class="search-btns">
	      <button type="button" id="btnSearch">검색</button>
	      <button type="button" id="btnUpgrade" class="btn"">회원 등급 갱신</button>
	      <div id="resultMessage" style="font-size: 16px;"></div>
      </div>
    </form>

	<hr style="margin-top: 2%; margin-bottom: 1%;">
    <!-- 검색 결과 출력 -->

    <h3>검색 결과</h3>
    <table class="result-table">
      <thead>
        <tr>
          <th>이메일</th>
          <th>이름</th>
          <th>닉네임</th>
          <th>전화번호</th>
          <th>주소</th>
          <th>생년월일</th>
          <th>가입일</th>
          <th>등급</th>
          <th>수정</th>
        </tr>
      </thead>
      <tbody id="result-tbody">
        
      </tbody>
    </table>
   
  </div>

</div>

<div id="editModal">
  <div class="modal-content" style="padding: 2%; width: 80%;">
    <span class="close-btn" id="closeModal">&times;</span>
    <h3>회원 정보 수정</h3>
    <form id="editForm" autocomplete="off">
      <div>
        <label for="mail">이메일</label>
        <input type="text" id="mail" name="mem_mail" readonly />
      </div>
      <div>
        <label for="pass">비밀번호</label>
        <input type="text" id="pass" name="mem_pass" />
      </div>
      <!-- <div>
        <label for="passcheck">비밀번호 확인</label>
        <input type="password" id="passcheck" name="mem_passcheck" />
        <span id="passspan"></span>
      </div> -->
      <div>
        <label for="name">이름</label>
        <input type="text" id="name" name="cust_name" />
      </div>
      <div>
        <label for="bir">생일</label>
        <input type="text" id="bir" name="mem_bir" />
      </div>
      <div style="margin: 4px 0 13px 0;">
        <label for="gender">성별</label>
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

      <!-- 버튼들을 같은 라인에 배치 -->
      <div class="button-container">
        <button type="button" id="update" class="btn edit-btn">정보수정</button>
        <button type="button" id="secessionn" class="btn">회원탈퇴</button>
      </div>

      <span id="updatespan"></span>
    </form>
  </div>
</div>

<!-- 모달 제어 -->
<script>
mypath = `<%=request.getContextPath() %>`;

const editBtns = document.querySelectorAll('.editBtn');
const modal = document.getElementById('editModal');
const closeModal = document.getElementById('closeModal');


$(document).on('click', '.editBtn', function() {
	console.log("수정 클릭", this);
	const email = this.getAttribute('data-email');
	document.getElementById('updatespan').style.color = 'white';
	
	// 이메일 셋팅 (readonly)
    document.getElementById('mail').value = email;
	
 	// AJAX로 서버에서 회원 상세정보 가져오기
    fetch(`\${mypath}/GetMemberInfo.do`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({ mem_mail: email })
    })
    .then(res => {
      if (!res.ok) {
        throw new Error(`HTTP error: ${res.status}`);
      }
      return res.json();
    })
    .then(data => {
      console.log("AJAX 응답 데이터:", data);
      // 서버에서 받아온 데이터로 폼 채우기
      document.getElementById('name').value = data.cust_name || ''; 
      document.getElementById('pass').value = data.mem_pass || ''; 
      document.getElementById('bir').value = data.mem_bir || '';
      document.getElementById('nickname').value = data.mem_nickname || '';
      document.getElementById('tel').value = data.cust_tel || '';
      document.getElementById('zip').value = data.cust_zip || '';
      document.getElementById('add1').value = data.cust_addr1 || '';
      document.getElementById('add2').value = data.cust_addr2 || '';

      if (data.mem_gender === 'M') {
        document.getElementById('gender_m').checked = true;
      } else if (data.mem_gender === 'F') {
        document.getElementById('gender_f').checked = true;
      }
    })
    .catch(() => {
      alert('회원 정보 불러오기에 실패했습니다.');
    });

    modal.style.display = 'block';
});


closeModal.addEventListener('click', () => {
  modal.style.display = 'none';
});

window.addEventListener('click', (e) => {
  if (e.target == modal) {
    modal.style.display = 'none';
  }
});

// 업데이트 버튼 이벤트 (비밀번호 일치 여부 확인 후 서버에 전송)
document.getElementById('update').addEventListener('click', () => {
  // const pass = document.getElementById('pass').value.trim();
  // const passcheck = document.getElementById('passcheck').value.trim();

 /*  if(pass === '' || passcheck === '') {
    passSpan.textContent = '비밀번호를 입력하세요.';
    return;
  }

  if(pass !== passcheck) {
    passSpan.textContent = '비밀번호가 일치하지 않습니다.';
    return;
  }

  passSpan.textContent = ''; */

  // 폼 데이터 전송 (jQuery 사용 시 serialize도 가능)
  const formData = new FormData(document.getElementById('editForm'));

  fetch(`\${mypath}/AdminUpdateProfile.do`, {
    method: 'POST',
    body: new URLSearchParams(formData)
  })
  .then(res => {
    if(res.ok) {
      document.getElementById('updatespan').style.color = 'green';
      document.getElementById('updatespan').textContent = '정보수정이 완료되었습니다.';
      // 모달 닫기 및 새로고침 or 테이블 갱신 가능
      setTimeout(() => modal.style.display = 'none', 1500);
    } else {
      throw new Error('정보수정 실패');
    }
  })
  .catch(() => {
    document.getElementById('updatespan').style.color = 'red';
    document.getElementById('updatespan').textContent = '정보수정 실패';
  });
});

// 회원탈퇴 버튼 이벤트
document.getElementById('secessionn').addEventListener('click', () => {
  if(!confirm('정말 탈퇴하시겠습니까?')) return;

  const email = document.getElementById('mail').value;
  fetch(`\${mypath}/AdminDeleteMember.do`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({ mem_mail: email })
  })
  .then(res => res.json())
  .then(data => {
    if(data.result === 'success') {
      alert('회원탈퇴가 완료되었습니다.');
      modal.style.display = 'none';
      // 필요시 페이지 리로드
      location.reload();
    } else {
      alert('회원탈퇴 실패');
    }
  })
  .catch(() => {
    alert('서버 오류');
  });
});
  
// 회원 등급 갱신 버튼 클릭 이벤트
$(function() {
	
	$('#result-tbody').empty();
	
	// 페이지 로드되자마자 멤버 정보 불러오기
	getMemList();
	
	$('#btnUpgrade').on('click', function() {
		$.ajax({
			url: `\${mypath}/UpdateMemGrade.do`,
			method: 'post',
			dataType: 'json',
			
			success: function(res) {
				if (res.flag == "성공") {
			      resultMessage.style.color = 'green';
			      resultMessage.textContent = "회원 등급 갱신이 완료되었습니다.";
			      
			      /* location.reload(true); */
			    } else {
			      resultMessage.style.color = 'red';
			      resultMessage.textContent = "회원 등급 갱신에 실패했습니다.";
			    }
			},
			error: function(xhr) {
				console.log(xhr.status);
			}
		})
	});
	
	// 검색버튼 클릭 이벤트
	$('#btnSearch').on('click', function() {
		console.log("검색 버튼 클릭")

		getMemList();
		
	}); // 클릭 버튼 이벤트 끝
})
	

</script>
</body>
</html>