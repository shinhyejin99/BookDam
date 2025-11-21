<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 문의 현황</title>
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
	
  #qnastatus-section {
    width: 93%;
    padding: 2%;
    background-color: #fff;
    border-radius: 12px;
    
    /* border: 2px solid hotpink; */
    /* box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05); */
  }
  
  #qnastatus-section div {
  	display: flex;
  	flex-direction: row;
  	justify-content: space-between;
  }
  
  table {
  	width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
    margin-bottom: 20px;
  }

  table th,
  table td {
    border: 1px solid #ddd;
    padding: 12px 12px;
    text-align: center;
  }
  
  .qnaCnt {
    font-size: 20px;
  	font-weight: bold;
  	text-align: center;
  }
  
  #goqna-btn {
    padding: 10px 10px;
    width: auto;
    border: none;
    border-radius: 6px;
    /* font-size: 16px; */
    /* font-weight: bold; */
    align-content: center;
    cursor: pointer;
    transition: all 0.3s ease;
    min-width: 100px;
    
    background-color: #F86E6E;
    color: white;
  }
  
  
   #goqna-btn:hover {
   	  color: white;
   	  border: none;
      background-color: #a13737;
   }
  
</style>

<script>
$(function() {
	$.ajax({
		url: `\${mypath}/QnaStatusCnt.do`,
		method: 'get',
		data: {cust_id : logUser.mem_mail},
		dataType: 'json',
		
		success: function(res) {
			console.log(res);
			$('#waitingCnt').text(res.waitingCount + " 건");
			$('#answerCnt').text(res.answeredCount + " 건");
		},
		error: function(xhr) {
			console.log(xhr.status);
		}
	});
	
	$('#goqna-btn').on('click', function() {
		location.href=`\${mypath}/QnaList.do`;
	});
})

</script>
</head>
<body>
	<div class="container">
		<!-- 문의 현황 확인 섹션 -->
		<div id="qnastatus-section">
		  <div><h3>📌 문의현황</h3><button id="goqna-btn">고객센터로 이동</button></div>
		
		  <table>
		  	<tr><td><h3>답변 대기</h3></td>
		  	    <td><h3>답변 완료</h3></td></tr>
		  	
		  	<tr><td class="qnaCnt" id="waitingCnt">0 건</td>
		  	    <td class="qnaCnt" id="answerCnt">0 건</td></tr>
		  	
		  </table>

		 
		      
		    
		</div>
	</div>
</body>
</html>