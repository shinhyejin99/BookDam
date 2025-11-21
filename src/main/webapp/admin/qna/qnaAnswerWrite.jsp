<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    
    
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
    font-size: 16px;
    font-family: 'Arial', sans-serif
}

.qna-small {
	width: 100%;
	padding: 1%;
    border: 1px solid #ccc;
    border-radius: 4px;
    margin-top: 4px;
    box-sizing: border-box;
    font-size: 16px;
}

textarea[name="qnaContent"] {
	height: 400px;
}

.btn-secondary {
    padding: 10px 15px;
    font-size: 16px;
    border: none;
    border-radius: 5px;
    background-color: #28a745;
    color: white;
    cursor: pointer;
    margin-left: 10px;
 }
.btn-secondary:hover {
    background-color: #218838;
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
            <li class="active"><a href="${pageContext.request.contextPath}/admin/QnaAdminList.do">1:1 고객센터</a></li>
            <li><a href="${pageContext.request.contextPath}/EventAdminList.do">행사 등록</a></li>
            <li><a href="${pageContext.request.contextPath}/NoticeAdminList.do">공지사항 등록</a></li>
        </ul>
    </aside>

    <main id="main">
    	<div class="container" style="max-width: 800px; min-height: 700px;">
        <h2>1:1 문의 답변하기</h2>
        <!-- 디버깅용: qna가 JSP에 잘 전달되는지 확인 -->
<%-- 		<p style="color:red;">
		  qna 객체: ${qna}<br>
		  qna.qnaQid: ${qna.qnaQid}
		</p> --%>
        <form action="<%=request.getContextPath() %>/admin/QnaAnswerWrite.do" method="post"
              onsubmit="return confirm('답변을 저장하고 상태를 변경하시겠습니까?');" enctype="multipart/form-data">

            <input type="hidden" name="qnaQid" value="${qna.qnaQid}">

            <div class="search-box">
                <label>문의 제목</label>
                <input class="qna-small" type="text" value="${qna.qnaTitle}" readonly>
            </div>

            <div class="search-box">
                <label>문의 유형</label>
                <input class="qna-small" type="text" value="${qna.qnaType}" readonly>
            </div>

			<div class="search-box">
			    <label>문의 내용</label>
			   <textarea readonly rows="5">${qna.qnaContent}</textarea>
			</div>
<%-- 
 			<div class="search-box">
			    <label>첨부 파일</label>
			   <textarea readonly rows="5" style="width:80%;">${file.atchFileId}</textarea>
			</div>  --%>

 			<div class="mb-3">
		  <label class="form-label fw-bold">첨부파일</label>
		  <div class="d-flex flex-column gap-2">
		    <c:forEach var="file" items="${qna.atchFileVO.atchFileDetailList}">
<%-- 			${qna.atchFileVO} --%>
<%-- 			<div>
    		<b>qna.atchFileVO.atchFileId:</b> ${file.atchFileId}<br>
    		<b>qna.atchFileVO.fileSn:</b> ${file.fileSn}
    		<p>atchFileVO: ${qna.atchFileVO}</p>
			<p>atchFileDetailList 크기: ${fn:length(qna.atchFileVO.atchFileDetailList)}</p>
			</div> --%>
		      <div>
		        <a href="${pageContext.request.contextPath}/qna/download.do?atchFileId=${file.atchFileId}&fileSn=${file.fileSn}">
		            ${file.orignlFileNm}
		        </a>
		      </div>
		    </c:forEach>
		  </div>
		</div>
		
		<br>
		<hr style="border: none; height: 1px; background-color: #bbb">
		<br>
            <div class="search-box">
                <label>답변 내용</label>
                <textarea name="qnaContent" placeholder="답변 내용을 작성해주세요" required></textarea>
            </div>

            <div class="btns">
                <button class="btn-secondary" type="submit">답변 저장</button>
            </div>
        </form>
        </div>
    </main>
</div>
</body>
</html>