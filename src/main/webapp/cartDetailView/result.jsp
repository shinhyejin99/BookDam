<%@page import="kr.or.ddit.dam.vo.DelCartVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	int cnt = (Integer) request.getAttribute("cnt");

	if (cnt > 0) {
%>

	{  "flag" : "성공"	}
	
<%
	} else {
%>
	
	{  "flag" : "실패" }
	
<%	
	}
%>