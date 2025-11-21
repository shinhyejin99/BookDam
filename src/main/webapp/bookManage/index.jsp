<!-- bookList.jsp - 전체 상품 관리 화면 (모달 방식) -->
<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 관리 페이지(관리자용)</title>
   
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
   <!-- <link rel="stylesheet" href="http://localhost/BookDam/css/bookmanage.css"> -->
   <link rel="stylesheet" href="<%=request.getContextPath() %>/css/bookmanage.css">

<script>
/* $(function() {
	listPageServer();
}) */
</script>
    
    
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
            <li class="active"
            ><a href="<%=request.getContextPath() %>/bookManage/index.jsp" onclick="prodProc()">상품관리</a></li>
            <li><a href="<%=request.getContextPath() %>/orderManage/orderManage.jsp">주문관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/QnaAdminList.do">1:1 고객센터</a></li>
            <li><a href="${pageContext.request.contextPath}/EventAdminList.do">행사 등록</a></li>
            <li><a href="${pageContext.request.contextPath}/NoticeAdminList.do">공지사항 등록</a></li>
        </ul>
    </aside>
    <section id="mainCont">
    </section>
</div>
 
<script>
mypath = '<%= request.getContextPath()%>';

mainContent = document.querySelector('#mainCont');
</script>

 <script src="<%=request.getContextPath()%>/js/book.js"></script> 

</body>
</html>