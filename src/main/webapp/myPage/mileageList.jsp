<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마일리지 내역</title>
<style>

.container {
	  display: flex;
	  justify-content: center;       /* 가로 중앙 정렬 */
	  align-items: flex-start;       /* 위쪽 정렬 (필요 시 center로 변경) */
	  gap: 40px;                     /* gift-section과 summary 사이 여백 */
	  max-width: 1200px;             /* 최대 너비 제한 */
	  margin: 0 auto;                /* 브라우저에서 가운데 정렬 */
	  padding: 1%;
	}
	
  #mileage-history-section {
    width: 93%;
    padding: 2%;
    background-color: #fff;
    border-radius: 12px;
    
    /* border: 2px solid hotpink; */
    /* box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05); */
  }

  .mileage-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
  }

  .mileage-table th,
  .mileage-table td {
    border: 1px solid #ddd;
    padding: 8px 12px;
    text-align: center;
  }

  .mileage-table th {
    background-color: #f6f6f6;
    font-weight: bold;
  }

  .mileage-table tbody tr:nth-child(even) {
    background-color: #fafafa;
  }
</style>

<script src="../js/jquery-3.7.1.js"></script>
<script>
<%
	MemVO mvo = (MemVO) session.getAttribute("loginOk");
	
	String user = null;
	Gson gson = new Gson();
	if (mvo != null) user = gson.toJson(mvo);
%>

mypath = '<%= request.getContextPath()%>';
logUser = <%= user == null ? "null" : user %>;

console.log(logUser);


$(function() {

	// 회원의 마일리지 내역을 불러오는 메소드 호출
	$.ajax({
		url: `\${mypath}/GetMileageList.do`,
		method : 'get',
		data: {mem_mail : logUser.mem_mail},
		dataType: 'json',
		
		success: function(res) {
			code = "";
			$.each(res, function(index, item) {
				
				// 날짜 부분 추가 및 수정 - 시분초 제거
				let formatDate = new Date(item.mileage_date).toISOString().replace(/T.*/, '');
				// item.mileage_date : "2025-07-03T03:25:30.123Z"
				// T뒤의 모든 문자를 '' 공백으로 바꾼다.
				
				code += `<tr>
					<td>\${index + 1}</td>
					<td>\${item.mileage_type}</td>
					<td>\${(item.mileage_amt).toLocaleString()}</td>
					<td>\${formatDate}</td>
					</tr>`;
			})
			$('#mileage-body').append(code);
			
		},
		error: function(xhr) {
			console.log(xhr.status);
		}
	})
})
</script>

</head>
<body>

<div class="container">
	<!-- 마일리지 내역 섹션 -->
	<div id="mileage-history-section">
	  <h3>📌 마일리지 적립 / 사용 내역</h3>
	
	  <table class="mileage-table">
	    <thead>
	      <tr>
	        <th>순번</th>
	        <th>내역 구분</th>
	        <th>금액 (M)</th>
	        <th>일자</th>
	      </tr>
	    </thead>
	    <tbody id="mileage-body">
	      <!-- 자바스크립트로 동적으로 행 추가 -->
	    </tbody>
	  </table>
	</div>
</div>

</body>
</html>