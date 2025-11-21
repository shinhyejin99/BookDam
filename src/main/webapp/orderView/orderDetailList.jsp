<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.OrdersDetailVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	List<OrdersDetailVO> orderDetailList = (List<OrdersDetailVO>)request.getAttribute("orderDetailList");
	
	Gson gson = new Gson();
	
	String result = gson.toJson(orderDetailList);
	
	out.print(result);
	out.flush();
%>