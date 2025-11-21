<%@page import="kr.or.ddit.dam.vo.NoticeVO"%>
<%@page import="kr.or.ddit.dam.vo.EventVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	NoticeVO vo = (NoticeVO) request.getAttribute("notice");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 수정</title>
<!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"> -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/event/eventmanage.css">
<style>
/* .form-container {
    max-width: 700px;
    margin: 50px auto;
} */
    
#main {
  width: 88%;
  flex-grow: 1;
  padding: 40px;
  
  display: flex;
  flex-direction: column;
  margin-left: 260px; /* 사이드바 너비보다 살짝 크게 */
}
    
#main h2 {
  font-size: 28px;
  margin-bottom: 20px;
}

.container {
	/* margin: 0 auto; */
	max-width: 850px;
}

.btn {
   margin-top: 15px;
   padding: 10px 20px;
   font-size: 17px;
   background-color: black;
   color: white;
   border: none;
   cursor: pointer;
   border-radius: 5px;
   background-color: gray;
 }
.btn-primary {
  background-color: #007bff;
}
.btn-primary:hover {
  background-color: #0056b3;
}

/* input[type="text"], input[type="number"], input[type="date"], textarea {
    width: 300px;
    padding: 4px;
    margin-bottom: 10px;
} */

.mb-3 {
	display: flex;
	flex-direction: column;
}

label {
    display: block;
    margin-bottom: 5px;
}

input[type="text"], input[type="number"], input[type="date"], textarea, select {
    width: 70%;
    padding: 1.2%;
    border: 1px solid #ccc;
    border-radius: 4px;
    margin-top: 4px;
    box-sizing: border-box;
    font-size: 16px;
}

input[name="eventTitle"] {
	width: 40%;
}

textarea {
	height: 400px;
}

/* #form-outer-section {
	display: flex;
	justify-content: center;
} */

form {
	width: 100%;
	margin: 0 auto;
}

.btn-warning {
    padding: 10px 15px;
    font-size: 16px;
    border: none;
    border-radius: 5px;
    background-color: orange;
    color: white;
    cursor: pointer;
    margin-left: 10px;
}
.btn-warning:hover {
    background-color: #e69500;
}

.button-wrapper {
    display: flex;
    justify-content: flex-end;
    margin-top: 10px;
    margin-right: 390px; /* ← 여기 숫자 조절 */
    gap: 10px;
}

</style>
</head>
<body>

<div id="wrap">
    <!-- ✅ 사이드 메뉴 -->
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
            <li><a href="${pageContext.request.contextPath}/admin/QnaAdminList.do">1:1 고객센터</a></li>
            <li><a href="${pageContext.request.contextPath}/EventAdminList.do">행사 등록</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/NoticeAdminList.do">공지사항 등록</a></li>
        </ul>
    </aside>


    <main id="main">
        <div class="container" style="min-width: 80%;">
            <h2 class="mb-4 border-bottom pb-2">공지사항 수정</h2>
			
            <form action="${pageContext.request.contextPath}/NoticeAdminEdit.do" method="post">
                <input type="hidden" name="noticeId" value="<%= vo.getNoticeId() %>">

                <!-- 제목 -->
                <div class="mb-3">
                    <label class="form-label">제목</label>
                    <input type="text" name="noticeTitle" class="form-control" value="<%= vo.getNoticeTitle() %>" required>
                </div>

                <!-- 내용 -->
                <div class="mb-3">
                    <label class="form-label">내용</label>
                    <textarea name="noticeContent" class="form-control" rows="6" style="font-family: 'Arial', sans-serif;" required><%= vo.getNoticeContent() %></textarea>
                </div>



                <!-- 버튼 -->
                <div class="button-wrapper">
                    <button type="submit" class="btn btn-primary">수정</button>
                    <a href="${pageContext.request.contextPath}/NoticeAdminList.do" class="btn btn-secondary">취소</a>
                </div>
            </form>
  
        </div>
    </main>
</div>
</body>
</html>