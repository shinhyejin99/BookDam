<%@page import="kr.or.ddit.mybatis.config.MybatisUtil"%>
<%@page import="org.apache.ibatis.session.SqlSession"%>
<%@page import="kr.or.ddit.dam.vo.OrdersVO"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%
  SqlSession sqlSession = MybatisUtil.getInstance();
  List<MemVO> memList = sqlSession.selectList("member.selectRecentMembers");
  List<OrdersVO> orderList = sqlSession.selectList("orders.selectRecentOrders");
  sqlSession.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 메인</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bookmanage.css">
<style>

	section th, section td {
		font-size: 17px;
	}
	
	main-section{
		padding: 0;
	}
	
	#newuser-table {
		wdith: 70%;
	}
	
</style>
</head>

<body>
<div id="wrap">
	<!-- ✅ 사이드바 -->
	<aside id="side">
      <h3>
	  <a href="<%=request.getContextPath() %>/main/adminMain.jsp" style="color: white; text-decoration: none;">
	  <img alt="지렁.png" src="<%=request.getContextPath() %>/images/logo/지렁.png" style="width: 100px; vertical-align: middle;">
	  <br>관리자 페이지
	  </a>
	  </h3>
        <ul>
            <li><a href="<%=request.getContextPath() %>/admin/adminMain.jsp">회원관리</a></li>
            <li><a href="${pageContext.request.contextPath}/BookCategory.do">상품관리</a></li> 
            <li><a href="<%=request.getContextPath() %>/orderManage/orderManage.jsp">주문관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/QnaAdminList.do">1:1 고객센터</a></li>
            <li><a href="${pageContext.request.contextPath}/EventAdminList.do">행사 등록</a></li>
            <li><a href="${pageContext.request.contextPath}/NoticeAdminList.do">공지사항 등록</a></li>
        </ul>
	</aside>

	<!-- ✅ 본문 -->
	<main id="main">
	  <h1>관리자 메인 대시보드</h1>
	
		<div style="display: flex; flex-direction: column; justify-content: center;">
		  <!-- 🧑‍💻 최근 회원가입 -->
		  <section class="main-section">
		    <h2>🧑‍💻 최근 회원가입</h2>
		    <table class="main-table" id="newuser-table">
		      <tr>
		        <th>이메일</th>
		        <th>닉네임</th>
		        <th>가입일</th>
		      </tr>
		      <%
		        for(int i = 0; i < memList.size(); i++) {
		          MemVO mem = memList.get(i);
		      %>
		      <tr>
		        <td><%= mem.getMem_mail() %></td>
		        <td><%= mem.getMem_nickname() %></td>
		        <td><%= mem.getMem_join() %></td>
		      </tr>
		      <% } %>
		    </table>
		  </section>
		
		  <!-- 🛒 최근 주문 -->
		  <section class="main-section">
		    <h2>🛒 최근 주문</h2>
		    <table class="main-table" id="neworder-table">
		      <tr>
		        <th>주문번호</th>
		        <th>회원ID</th>
		        <th>총 금액</th>
		        <th>주문 상태</th>
		        <th>비회원 여부</th>
		      </tr>
		      <%
		        for(int i = 0; i < orderList.size(); i++) {
		          OrdersVO order = orderList.get(i);
		      %>
		      <tr>
		        <td><%= order.getOrder_no() %></td>
		        <td><%= order.getCust_id() %></td>
		        <td><%= String.format("%,d", order.getTotal_amt()) %></td>
		        <td><%= order.getOrder_status() %></td>
		        <td><%= "Y".equals(order.getNmem_check()) ? "비회원" : "회원" %></td>
		      </tr>
		      <% } %>
		    </table>
		  </section>
		  </div>
		</main>
	 </div>
</body>
</html>
