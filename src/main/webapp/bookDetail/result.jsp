<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%

	int res = (Integer)request.getAttribute("result");
	Integer mileage = (Integer)request.getAttribute("mileage");

	if(res == -1) {
%>
	{
	    "flag" : "이미 신고함"
	}
<% 	} else if(res == -2) { %>
	{
    "flag" : "오늘 출석체크 완료함"
	}
<% 	} else if(res > 0) { %>
	{
	    "flag" : "성공",
	    "mileage" : <%= mileage != null ? mileage : res %>
	}
<% 	} else { %>
	{
	    "flag" : "실패"
	}
<%
	}
%>
   