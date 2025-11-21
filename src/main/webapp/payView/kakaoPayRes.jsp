<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.KakaoPayReadyResVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% 
	KakaoPayReadyResVO readyResponse = (KakaoPayReadyResVO) request.getAttribute("readyResponse");
	
	Gson gson = new Gson();
	
	String result = gson.toJson(readyResponse);
	
	out.print(result);
	out.flush();
%>