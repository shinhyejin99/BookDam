<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.AttendanceVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
<%
	// 컨트롤러 데이터 꺼내기
	List<String> list = (List<String>)request.getAttribute("listValue");

	Gson gson = new Gson();
	JsonObject obj = new JsonObject(); // 자바 객체
	JsonArray jsonArray = gson.toJsonTree(list).getAsJsonArray(); // json배열에 list 담기
	obj.add("attendanceDateList", jsonArray);
	
	String result = gson.toJson(obj); // 자바 객체 배열 result에 담기
	
	out.print(result); // 자바 객체 배열 jsp로 출력
	out.flush();
	
	/* 
	  {
		"attendanceDateList" = [ "2025-06-01", "2025-06-03", ...] 
	  }
	*/


%>