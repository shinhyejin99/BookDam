<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 목록</title>
    <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"> -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/event/eventmanage.css">
</head>
<style>

#eventsearch-table {
	margin-top: 7px;
}

#eventsearch-table thead {
	padding: 8px;
}

.text-end {
	display: flex;
	justify-content: flex-end;
}

.btn-success {
    padding: 10px 15px;
    font-size: 16px;
    border: none;
    border-radius: 5px;
    background-color: #28a745;
    color: white;
    cursor: pointer;
    margin-left: 10px;
}

.btn-success:hover {
    background-color: #218838;
}

</style>
<body>
<div id="wrap">
    <!-- ✅ 관리자 사이드 메뉴 -->
  <aside id="side">
      <h3>
		  <a href="<%=request.getContextPath() %>/main/adminMain.jsp" style="color: white; text-decoration: none;">
		  관리자<br>페이지
		  </a>
	  </h3>
        <ul>
            <li><a href="<%=request.getContextPath() %>/admin/adminMain.jsp">회원관리</a></li>
            <li><a href="<%=request.getContextPath() %>/BookCategory.do">상품관리</a></li>
            <li><a href="<%=request.getContextPath() %>/orderManage/orderManage.jsp">주문관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/QnaAdminList.do">1:1 고객센터</a></li>
            <li><a href="${pageContext.request.contextPath}/EventAdminList.do">행사 등록</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/NoticeAdminList.do">공지사항 등록</a></li>
        </ul>
    </aside>
    
	<div class="content">
	    <h2 class="mb-4">📅 공지사항 목록</h2>
	    
		    <div style="width: 92%;" class="mb-3 text-end">
		        <a href="<%= request.getContextPath() %>/notice/noticeAdminWrite.jsp" class="btn btn-success">+ 공지사항 등록</a>
		    </div>
		    
	    <div style="display: flex;">
		    <table style="width: 92%;" id="eventsearch-table" class="table table-hover table-bordered text-center align-middle">
		        <thead class="table-dark">
		            <tr>
					    <th style="width: 10%;">번호</th>
					    <th style="width: 25%;">제목</th>
					    <th style="width: 50%;">내용</th>
					    <th style="width: 15%;">작성일</th>
		            </tr>
		        </thead>
				<tbody>
				  <c:choose>
				    <c:when test="${not empty noticeList}">
				      <c:forEach var="vo" items="${noticeList}">
				        <tr>
				          <td>${vo.noticeId}</td>
				          <td>
				            <a href="<%=request.getContextPath()%>/NoticeAdminDetail.do?noticeId=${vo.noticeId}" >
				            ${vo.noticeTitle}
				          </a>
				          </td>
				          <td>
				          <c:choose>
				          <c:when test="${fn:length(vo.noticeContent) > 55}">
				          	${fn:substring(vo.noticeContent, 0, 55)}
				          </c:when>
				          <c:otherwise>
				          ${vo.noticeContent}
				          </c:otherwise>
				          </c:choose>
				          </td>
				          <td>${fn:substring(vo.noticeDate, 0, 10)}</td>
				        </tr>
				      </c:forEach>
				    </c:when>
				    <c:otherwise>
				      <tr>
				        <td colspan="4">등록된 공지사항이 없습니다.</td>
				      </tr>
				    </c:otherwise>
				  </c:choose>
				</tbody>
		    </table>
	    </div>
	</div>
</div>
</body>
</html>
