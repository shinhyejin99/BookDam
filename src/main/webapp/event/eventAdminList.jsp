<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="kr.or.ddit.dam.vo.EventVO" %>
<%
    List<EventVO> eventList = (List<EventVO>) request.getAttribute("eventList");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>문화행사 목록</title>
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
            <li class="active"><a href="${pageContext.request.contextPath}/EventAdminList.do">행사 등록</a></li>
            <li><a href="${pageContext.request.contextPath}/NoticeAdminList.do">공지사항 등록</a></li>
        </ul>
    </aside>
    
	<div class="content">
	    <h2 class="mb-4">문화행사 목록</h2>
	    
		<br>
	    
		<div style="width: 92%;" class="mb-3 text-end">
		    <a href="<%= request.getContextPath() %>/event/eventAdminWrite.jsp" class="btn btn-success">+ 행사 등록</a>
		</div>
		      
	    <div style="display: flex;">
		    <table style="width: 92%;" id="eventsearch-table" class="table table-hover table-bordered text-center align-middle">
		        <thead class="table-dark">
		            <tr>
		                <th>번호</th>
		                <th>제목</th>
		                <th>이미지</th>
		                <th>작성일</th>
		                <th>관리</th>
		            </tr>
		        </thead>
		        <tbody>
		        <%
		            if (eventList != null && !eventList.isEmpty()) {
		                for (EventVO vo : eventList) {
		        %>
		            <tr>
		                <td><%= vo.getEventId() %></td>
		                <td><%= vo.getEventTitle() %></td>
		                <td><%= vo.getEventType() %></td>
		                <td><%= vo.getEventDate().substring(0, 10) %></td>
		                <td>
		                    <a href="<%= request.getContextPath() %>/EventAdminDetail.do?eventId=<%= vo.getEventId() %>" class="event-btn">상세</a>
		                    <a href="<%= request.getContextPath() %>/EventAdminEdit.do?eventId=<%= vo.getEventId() %>" class="event-btn-edit">수정</a>
		                    <a href="<%= request.getContextPath() %>/EventAdminDelete.do?eventId=<%= vo.getEventId() %>" class="event-btn" onclick="return confirm('삭제하시겠습니까?')">삭제</a>
		                </td>
		            </tr>
		        <%
		                }
		            } else {
		        %>
		            <tr>
		                <td colspan="6">등록된 문화행사가 없습니다.</td>
		            </tr>
		        <%
		            }
		        %>
		        </tbody>
		    </table>
	    </div>
	</div>
</div>
</body>
</html>
