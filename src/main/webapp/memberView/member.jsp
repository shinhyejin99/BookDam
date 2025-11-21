<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	MemVO mvo = (MemVO) request.getAttribute("mvo");

	Gson gson = new Gson();
	String result = gson.toJson(mvo);
	
	out.print(result);
	out.flush();
	
%>