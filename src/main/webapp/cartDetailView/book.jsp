<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.BookVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	BookVO book = (BookVO) request.getAttribute("book");
	
	Gson gson = new Gson();
	
	String result = gson.toJson(book);
	
	out.print(result);
	out.flush();


%>