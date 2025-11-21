<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MileageVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	List<MileageVO> mileageList = (List<MileageVO>) request.getAttribute("mileageList");

	Gson gson = new Gson();
	
	String result = gson.toJson(mileageList);
	
	out.print(result);
	out.flush();

%>