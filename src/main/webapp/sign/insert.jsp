<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <%
    
    //Controller에서 값을 꺼내기
    
    int res = (Integer) request.getAttribute("res");
            /* (Integer) = 형변환을 위해 기입 */
    
    if(res > 0){
    %>
    	
    {
    	"flag" : "가입성공"
    	
    	}
   <% 	
    }else{ 
    	%>
    	
    	{
    	"flag" : "가입실패"
    	
    	}
   <% 	
    }
    
    %>