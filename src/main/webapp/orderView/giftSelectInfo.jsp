<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.GiftVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	GiftVO gvo = (GiftVO) request.getAttribute("giftInfo");

	Gson gson = new Gson();
	
	String result = gson.toJson(gvo);
	
	out.print(result);
	out.flush();
%>