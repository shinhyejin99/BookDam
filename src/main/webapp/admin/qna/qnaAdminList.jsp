<%@page import="java.util.Optional"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="kr.or.ddit.dam.qna.service.QnaServiceImpl"%>
<%@page import="kr.or.ddit.dam.qna.service.IQnaService"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
.qna-btn {
    padding: 5px 10px;
    background-color: #5c7cfa;
    color: white;
    border: none;
    border-radius: 5px;
    font-size: 14px;
    text-decoration: none;
    transition: background-color 0.3s ease;
}

.qna-btn:hover {
    background-color: #4c6ef5;
}
.qna-btn-complete {
    padding: 5px 10px;
    background-color: #ced4da;
    color: #495057;
    border: none;
    border-radius: 5px;
    font-size: 14px;
    text-decoration: none;
    pointer-events: none;  /* 클릭 비활성화 */
    opacity: 0.8;
}
/* main#main {
    max-width: 1300px;  event 목록과 동일하게
    margin: 0 auto;     가운데 정렬
}

table td, table th {
   padding: 10px !important; 셀 패딩 줄이기
    }    
.section-title {
    font-size: 24px;
    font-weight: 700;
    font-family: 'Segoe UI', sans-serif;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 8px;
} */
</style>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 고객센터(관리자용)</title>
<!-- <link rel="stylesheet" href="./bookmanage.css"> -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/admin/qna/bookmanage.css">
<!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"> -->
</head>
<body>
<div id="wrap">
    <%-- <aside id="side">
        <h3>관리자<br>페이지</h3>
        <ul>
            <li><a href="#">회원관리</a></li>
            <li><a href="#">상품관리</a></li>
            <li><a href="#">주문관리</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/QnaAdminList.do">1:1 고객센터</a></li>
            <li><a href="#">공지사항 등록</a></li>
            <li><a href="${pageContext.request.contextPath}/EventAdminList.do">문화/행사</a></li>
        </ul>
    </aside> --%>
    
     <aside id="side">
        <!-- <h3>관리자<br>페이지</h3> -->
      <h3>
		  <a href="<%=request.getContextPath() %>/main/adminMain.jsp" style="color: white; text-decoration: none;">
		  관리자<br>페이지
		  </a>
	  </h3>
        <ul>
            <li><a href="<%=request.getContextPath() %>/admin/adminMain.jsp">회원관리</a></li>
            <li><a href="${pageContext.request.contextPath}/BookCategory.do">상품관리</a></li>
            <li><a href="<%=request.getContextPath() %>/orderManage/orderManage.jsp">주문관리</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/QnaAdminList.do">1:1 고객센터</a></li>
            <li><a href="${pageContext.request.contextPath}/EventAdminList.do">행사 등록</a></li>
            <li><a href="${pageContext.request.contextPath}/NoticeAdminList.do">공지사항 등록</a></li>
        </ul>
    </aside>

    <main id="main">
        <h2 class="section-title">1:1 문의 목록 (관리자용)</h2>
		
		<!-- 검색 필터 영역 -->
         <form method="get" action="${pageContext.request.contextPath}/admin/QnaAdminList.do" id="searchForm">
  		  <table class="search-box">
  		  <tr>
	        <td>검색어</td>
		        <td>
		        <select name="stype">
		            <option value="">선택 안함</option>
		            <option value="title" ${stype == 'title' ? 'selected' : ''}>제목</option>
		            <option value="qid" ${stype == 'qid' ? 'selected' : ''}>번호</option>
	      		</select>
       			<input type="text" name="sword" placeholder="검색어 입력" value="${sword}">
       			</td>
       		</tr>

	        <td>상태</td>
	        <td>
	        <select name="status">
	            <option value="">전체</option>
	            <option value="답변대기" ${status == '답변대기' ? 'selected' : ''}>답변대기</option>
	            <option value="답변완료" ${status == '답변완료' ? 'selected' : ''}>답변완료</option>
	        </select>
	    	</td>
	   </table>
	<button id="search-btn" type="submit">검색</button>
	</form>  
	
	<hr style="margin-top: 2%; margin-bottom: 1%;">
	
	<div style="display: flex; justify-content: center;">
	<table style="width: 94%;" id="result-table" class="table table-hover table-bordered text-center align-middle">
	    <thead class="table-dark">
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>유형</th>
                    <th>상태</th>
                    <th>등록일</th>
                    <th>답변</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="qna" items="${qnaList}">
                    <tr>
                        <td>${qna.qnaQid}</td>
                        <td><a href="<%=request.getContextPath() %>/admin/QnaAnswerDetail.do?qnaQid=${qna.qnaQid}" class="text-decoration-none">${qna.qnaTitle}</a></td>
                        <td>${qna.qnaType}</td>
                        <td>
                            <c:choose>
                                <c:when test="${qna.qnaStatus == '답변완료'}">
                                    <span style="color: green; font-weight: bold;">
                                        ${qna.qnaStatus}
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: orange;">
                                        ${qna.qnaStatus}
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${qna.qnaDate}</td>
                        <td>
                            <c:if test="${qna.qnaStatus == '답변대기'}">
                                <a href="${pageContext.request.contextPath}/admin/QnaAnswerWrite.do?qnaQid=${qna.qnaQid}"
                                   class="qna-btn">답변 작성</a>
                            </c:if>
                            <c:if test="${qna.qnaStatus != '답변대기'}">
                                <span style="color: #888" class="qna-btn-complete">답변 완료</span>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        </div>

    </main>
</div>
</body>
</html>