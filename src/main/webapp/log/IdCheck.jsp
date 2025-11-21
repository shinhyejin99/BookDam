<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@page import="com.google.gson.Gson"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <%
    MemVO checkId = (MemVO) request.getAttribute("result");
   if(checkId == null){
	   %>
	   { 
	   
	   "flag" : "사용가능 이메일"
	   
		}
		
	   <% }else{%>  
		   
		   { 
		   
	   "flag" : "사용불가능 이메일"
	   
		} 
    
	 <%	   
   }
    
  %>