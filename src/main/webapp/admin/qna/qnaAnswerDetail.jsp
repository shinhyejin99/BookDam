<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의 답변하기</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/admin/qna/bookmanage.css">
<!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet"> -->
<style>
#main {
    width: 88%;
    flex-grow: 1;
    padding: 40px;
    
    margin-left: 13%; /* 사이드바 너비보다 살짝 크게 */
}
    
#main h2 {
  font-size: 28px;
  margin-bottom: 20px;
}

.mb-3 {
	display: flex;
	flex-direction: column;
}

label {
    display: block;
    margin-bottom: 5px;
}

textarea{
    width: 100%;
    padding: 1%;
    border: 1px solid #ccc;
    border-radius: 4px;
    margin-top: 4px;
    box-sizing: border-box;
    font-size: 17px;
    font-family: 'Arial', sans-serif
}

.search-box input[type="text"] {
	width: 100%;
	padding: 1.5%;
    border: 1px solid #ccc;
    border-radius: 4px;
    margin-top: 4px;
    margin-bottom: 10px;
    
    box-sizing: border-box;
    font-size: 17px;
}

textarea[name="qnaContent"] {
	height: 400px;
}

.btn-danger {
    padding: 10px 15px;
    font-size: 16px;
    border: none;
    border-radius: 5px;
    background-color: red;
    color: white;
    cursor: pointer;
    margin-left: 10px;
 }
 
.btn-danger:hover {
    background-color: #ba1a1a;
}

</style>
</head>
<body>
<div id="wrap">
      <aside id="side">
	  <h3>
	  <a href="<%=request.getContextPath() %>/main/adminMain.jsp" style="color: white; text-decoration: none;">
	  관리자<br>페이지
	  </a>
	  </h3>
        <ul>
            <li><a href="<%=request.getContextPath() %>/admin/adminMain.jsp">회원관리</a></li>
            <li><a href="<%=request.getContextPath() %>/bookManage/index.jsp">상품관리</a></li>
            <li><a href="<%=request.getContextPath() %>/orderManage/orderManage.jsp">주문관리</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/QnaAdminList.do">1:1 고객센터</a></li>
            <li><a href="${pageContext.request.contextPath}/EventAdminList.do">행사 등록</a></li>
            <li><a href="${pageContext.request.contextPath}/NoticeAdminList.do">공지사항 등록</a></li>
        </ul>
    </aside>

    <main id="main">
    	<div class="container" style="max-width: 800px; min-height: 700px;">
        <h2>1:1 문의 상세보기</h2>
        <%-- <form action="<%=request.getContextPath() %>/admin/QnaAnswerDetail.do" method="post"
              onsubmit="return confirm('답변을 저장하고 상태를 변경하시겠습니까?');"> --%>
		<form>
            <input type="hidden" name="qnaQid" value="${qna.qnaQid}">

            <div class="search-box">
                <label>문의 제목</label>
                <input type="text" value="${qna.qnaTitle}" readonly>
            </div>

            <div class="search-box">
                <label>문의 유형</label>
                <input type="text" value="${qna.qnaType}" readonly>
            </div>

			<div class="search-box">
			    <label>문의 내용</label>
			   <textarea readonly rows="5">${qna.qnaContent}</textarea>
			</div>

		<br>
		<hr style="border: none; height: 1px; background-color: #bbb">
		<br>
		
            <div class="search-box">
                <label>답변 내용</label>
               <!--  <textarea name="qnaContent" placeholder="답변 내용을 작성해주세요" required></textarea> -->
            	<input type="text" value="${answer.qnaContent}" readonly>
            </div>
         </form>
            
            <!-- 페이지 제일 아래 부분 -->
			<div class="d-flex justify-content-end mt-4">
			    <form action="<%=request.getContextPath() %>/admin/QnaAnswerDelete.do" method="post" style="display:inline;" 
			           onsubmit="return confirm('정말 삭제하시겠습니까?');">
			        <input type="hidden" name="qnaQid" value="${qna.qnaQid}">
			        <div class="btns">
			        	<button type="submit" class="btn btn-danger btn">삭제</button>
			        </div>
			    </form>
			</div>

<!--         </form> -->
		</div>
    </main>
</div>
</body>
</html>