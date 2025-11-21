<%@page import="kr.or.ddit.dam.vo.CartItemVO"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	// 서블릿에서 request에 저장한 값 꺼내기
	List<CartItemVO> cartList = (List<CartItemVO>)request.getAttribute("cartList");

	Gson gson = new Gson();
	
	// {"book_no" : 13246578, "cart_qty" : 7} 형태로 전송
	String result = gson.toJson(cartList);
	
	out.print(result);
	out.flush();
%>