<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/admin/qna/bookmanage.css">
<!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet"> -->
<style>
#main {
    width: 88%;
    flex-grow: 1;
    padding: 40px;
    
    margin-left: 260px; /* 사이드바 너비보다 살짝 크게 */
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
    background-color: #FFA500;
    color: white;
    cursor: pointer;
    margin-left: 10px;
 }
 
.btn-danger:hover {
    background-color: #FF8C00;
}
.btn-warning {
    padding: 10px 15px;
    font-size: 16px;
    border: none;
    border-radius: 5px;
    background-color: #1E90FF;
    color: white;
    cursor: pointer;
    margin-left: 10px;
}
.btn-warning:hover {
    background-color: #4169E1;
}

.button-wrapper {
    display: flex;
    justify-content: flex-end;
    margin-top: 20px;
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
            <li><a href="${pageContext.request.contextPath}/admin/QnaAdminList.do">1:1 고객센터</a></li>
            <li><a href="${pageContext.request.contextPath}/EventAdminList.do">행사 등록</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/NoticeAdminList.do">공지사항 등록</a></li>
        </ul>
    </aside>

	<main id="main">
        <div class="container" style="max-width: 800px; min-height: 700px;">
            <h2>공지사항 상세보기</h2>
            <form>
                <input type="hidden" name="noticeId" value="${notice.noticeId}">

                <div class="search-box">
                    <label>제목</label>
                    <input type="text" value="${notice.noticeTitle}" readonly>
                </div>

                <div class="search-box">
                    <label>내용</label>
                    <textarea readonly rows="5">${notice.noticeContent}</textarea>
                </div>

                <div class="search-box">
                    <label>작성일</label>
                    <input type="text" value="${fn:substring(notice.noticeDate, 0, 10)}" readonly>
                </div>
            </form>

            <!-- ✅ 버튼 우측 하단 배치 -->
            <div class="button-wrapper">
                <!-- 삭제 -->
                <form action="<%=request.getContextPath() %>/NoticeAdminDelete.do" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');" style="display:inline;">
                    <input type="hidden" name="noticeId" value="${notice.noticeId}">
                    <button type="submit" class="btn btn-danger">삭제</button>
                </form>

                <!-- 수정 -->
                <form action="<%=request.getContextPath() %>/NoticeAdminEdit.do" method="get" style="display:inline;">
                    <input type="hidden" name="noticeId" value="${notice.noticeId}">
                    <button type="submit" class="btn btn-warning">수정</button>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>