<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.GiftVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	List<GiftVO> giftList = (List<GiftVO>)request.getAttribute("giftList");

	Gson gson = new Gson();
	
	String result = gson.toJson(giftList);
	
	out.print(result);
	out.flush();

%>