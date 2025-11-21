<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>





 <%
    MemVO  vo = (MemVO)session.getAttribute("loginok");
    
    if(vo != null){  //로그인 성공
 %>
 
    	{
    	   "flag"  : "ok"
    	}
    	
  <%  }else{ //로그인 실패  %>
  
        {
    	   "flag"  : "no"
    	}
    	
  <%  	
    }
  %> 