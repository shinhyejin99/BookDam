<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@page import="com.google.gson.JsonElement"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.BookVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
    
<%
	// controller에서 저장한 값 꺼내기
	List<BookVO> list = (List<BookVO>)request.getAttribute("listvalue");

	// 페이지 정보 꺼내기
	int sp = (Integer)request.getAttribute("spage");
	int ep = (Integer)request.getAttribute("epage");
	int tp = (Integer)request.getAttribute("tpage");
	
	int totalCount = (Integer)request.getAttribute("totalCount");

	// JSON 데이터 만들기 - 한 줄로 나오는 걸 예쁜 형태로 -> 직렬화 전송 (board.jsp로)
	Gson gson = new GsonBuilder().setPrettyPrinting().create();
	//String result = gson.toJson(list);--> 페이지 정보를 못 넣음 ㅠ 그래서 안 씀
	
	JsonObject obj = new JsonObject();
	obj.addProperty("sp", sp); // k, v
	obj.addProperty("ep", ep); // k, v
	obj.addProperty("tp", tp); // k, v
	
	obj.addProperty("totalCount", totalCount);
	
	JsonElement jlist = gson.toJsonTree(list);
	obj.add("datas", jlist);
	
	//-▲도서 정보&페이지 정보   ▼ 마일리지관련------------
	// 회원 등급별로 다른 마일리지 적립률을 위해
	// 세션에서 회원 정보 가져오기
	
	// MemberVO 완성되면 실행
	String memGrade = "비회원"; 
	double mileageRate = 0;
	
	
	// 로그인 기능을 담당하는 서블릿에서 저장함!!!!!!!!!)-----------
	// 로그인 메소드 실행하고! 그 결과를 MemberVO 객체에 담는다!
	/*
			MemberVO loginMember = memberService.login(id, password);
			// != null 이라는 건 로그인을 한 회원이라는 뜻이고!
			if (loginMember != null) {
			    HttpSession session = request.getSession();
			    //
			    session.setAttribute("member", loginMember);
			}*/
	//-----------------------------------------
	
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
	obj.addProperty("memGrade", memGrade); //=> js에서 비회원, 회원 판단할 때 필요
	obj.addProperty("mileageRate", mileageRate); 

	out.print(obj);
	out.flush();
	
	/* sp, ep는 페이지번호 출력
	datas는  도서 검색 결과 리스트 출력
	
	/* 한 줄로 나옴 (이해하기 쉽게 나눠서 정리함!)
	{
		 "sp":1,"ep":5,"tp":18, "totalCount":22, "memGrade":"일반", "mileageRate":0.05
		 "datas": [
		           {
		        	   "book_no":9791199246607,"book_title":"Stained Glass","book_author":"안명아 (지은이)","book_pubdate":"2025-05-30 00:00:00","book_price":10000,"publisher":"앙상블비플랫","category":"에세이","cover_img":"https://image.aladin.co.kr/product/36636/5/coversum/k462030888_1.jpg","book_page":57,"stock_qty":0,"avgRating":0.0,"reviewCount":0,"totalSales":0
		           },
		           {
		        	   "book_no":9791199227835,"book_title":"팝콘 밥 4 : 디저트 요리 대회에서 우승하라","book_author":"마랑케 링크 (지은이), 마르테인 판데르린덴 (그림), 신동경 (옮긴이)","book_pubdate":"2025-06-19 00:00:00","book_price":14400,"publisher":"판퍼블리싱","category":"어린이","cover_img":"https://image.aladin.co.kr/product/36627/70/coversum/k472030679_1.jpg","book_page":232,"stock_qty":0,"avgRating":0.0,"reviewCount":0,"totalSales":0
		        	} , 
		           ....
		          ]
	}
	 
	 */

%>    