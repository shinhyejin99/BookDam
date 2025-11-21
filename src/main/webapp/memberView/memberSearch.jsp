<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
<%
	List<MemVO> memList = (List<MemVO>) request.getAttribute("memList");

	Gson gson = new Gson();
	String result = gson.toJson(memList);
	
	out.println(result);
	out.flush();
	
%>