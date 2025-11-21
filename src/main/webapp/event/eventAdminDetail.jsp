<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.or.ddit.dam.vo.EventVO" %>
<%
    EventVO vo = (EventVO) request.getAttribute("vo");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>행사 상세보기</title>
   <!--  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"> -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/event/eventmanage.css">

<style>

#main {
    width: 88%;
    flex-grow: 1;
    padding: 40px;
    
    display: flex;
	flex-direction: column;
	
	margin-left: 13%; /* 사이드바 너비보다 살짝 크게 */
}
    
#main h2 {
  font-size: 28px;
  margin-bottom: 20px;
}

/* .container {
	margin: 0 auto;
} */

.text-end {
	margin: 4px;
	display: flex;
	justify-content: flex-end;
}

.btn-secondary {
   margin-top: 15px;
   padding: 10px 20px;
   font-size: 17px;
   background-color: black;
   color: white;
   border: none;
   cursor: pointer;
   border-radius: 5px;
 }
.btn-secondary {
  background-color: #333;
}

/* .mb-4 {
	text-align: center;
} */

/* table th, td {
  border: 1px solid #ccc;
  padding: 11px 10px;
  text-align: center;
  font-size: 16px;
}
 */



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
            <li class="active"><a href="${pageContext.request.contextPath}/EventAdminList.do">행사 등록</a></li>
            <li><a href="${pageContext.request.contextPath}/NoticeAdminList.do">공지사항 등록</a></li>
        </ul>
    </aside>

    <!-- ✅ 본문 -->
    <main id="main">
        <div class="container" style="max-width: 850px;">
            <h2 class="mb-4 border-bottom pb-2">문화행사 상세보기</h2>

            <table class="table table-bordered">
                <tr>
                    <th width="150">제목</th>
                    <td><%= vo.getEventTitle() %></td>
                </tr>
                <tr>
                    <th>유형</th>
                    <td><%= vo.getEventType() %></td>
                </tr>
                <tr>
                    <th>작성일</th>
                    <td><%= vo.getEventDate() %></td>
                </tr>
                <tr>
                    <th>대표 이미지</th>
                    <td>
					<%
					    String imgPath = "/BookDam/images/event/" + vo.getEventType();
					%>
                        <img src="<%= request.getContextPath() %>/images/event/<%= vo.getEventType() %>" style="max-width: 100%; border:1px solid #ccc; padding:5px;">
                    	<%-- <p>이미지 경로 확인: <%= imgPath %></p> --%>
                    </td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td style="white-space: pre-line;"><%= vo.getEventContent() %></td>
                </tr>
            </table>

            <div class="mt-4 text-end">
                <a href="<%= request.getContextPath() %>/EventAdminList.do" class="btn btn-secondary">목록으로</a>
            </div>
        </div>
    </main>
</div>

</body>
</html>
