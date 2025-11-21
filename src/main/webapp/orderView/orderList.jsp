<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.OrdersVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% 
	List<OrdersVO> orderList = (List<OrdersVO>) request.getAttribute("orderList");
	
	// 직렬화
	Gson gson = new Gson();
	
	String result = gson.toJson(orderList);
	
	out.print(result);
	out.flush();

%>