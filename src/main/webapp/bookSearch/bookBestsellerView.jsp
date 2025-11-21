<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.BookVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
<%
	// 컨트롤러에서 값 가져오기
	List<BookVO> list = (List<BookVO>)request.getAttribute("listValue");
	
	//베스트셀러 응답 구조
	Map<String, Object> map = new HashMap<>();
	map.put("datas", list);

	//Gson gson = new GsonBuilder().setPrettyPrinting().create();
	
	//JsonObject obj = new JsonObject();
	
	String memGrade = "비회원"; 
	double mileageRate = 0;
	
	HttpSession userSession = request.getSession(false);
	if(userSession != null) { // 회원
		MemVO mvo = (MemVO) userSession.getAttribute("loginOk");
		// 로그인 성공하고 memService 메소드 실행 값을 mvo객체에 담고
		// 그 회원의 session에 setAttribute해서 mvo를 value로 담는다.
		
		if (mvo != null) {
			memGrade = mvo.getMem_grade(); // MemberVO mem_grade의 getter 메소드
			if("일반등급".equals(memGrade)) mileageRate = 0.05;
			else if("실버등급".equals(memGrade)) mileageRate = 0.07;
			else if("골드등급".equals(memGrade)) mileageRate = 0.08;
			else if("다이아몬드등급".equals(memGrade)) mileageRate = 0.1;
		}
	}
	
	map.put("memGrade", memGrade);
	map.put("mileageRate", mileageRate);
	
	Gson gson = new GsonBuilder().setPrettyPrinting().create();
	String result = gson.toJson(map);

	out.print(result);
	out.flush();

%>    