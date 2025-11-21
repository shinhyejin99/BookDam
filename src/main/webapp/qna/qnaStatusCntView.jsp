<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.QnaStatusVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	QnaStatusVO qvo = (QnaStatusVO) request.getAttribute("qvo");

	Gson gson = new Gson();
	String result = gson.toJson(qvo, QnaStatusVO.class);
	
	out.print(result);
	out.flush();

%>