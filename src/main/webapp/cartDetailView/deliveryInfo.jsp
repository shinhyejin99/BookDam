<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.DeliveryVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% DeliveryVO deliveryInfo = (DeliveryVO) request.getAttribute("deliveryInfo");

	Gson gson = new Gson();
	
	// {"cust_name" : "누구", "cust_tel" : "111-222" } 형태로 전송
	String result = gson.toJson(deliveryInfo);
	
	out.print(result);
	out.flush();
%>