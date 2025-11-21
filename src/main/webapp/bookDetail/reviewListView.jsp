<%@page import="kr.or.ddit.dam.vo.PageVO"%>
<%@page import="kr.or.ddit.dam.vo.ReviewVO"%>
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
	//controller에서 저장한 값 꺼내기
	List<ReviewVO> list = (List<ReviewVO>)request.getAttribute("listvalue");

	//페이지 정보 가져오기 (PageVO 객체로)
	PageVO pageInfo = (PageVO)request.getAttribute("pageInfo");
	
	// 리뷰 수 정보 가져오기 - 추가함! - int는 null X, Integer는 null O
	Integer totalAllCount = (Integer)request.getAttribute("totalAllCount");
	Integer totalBuyerCount = (Integer)request.getAttribute("totalBuyerCount");
	
	
	Gson gson = new GsonBuilder().setPrettyPrinting().create();
	
	JsonObject obj = new JsonObject();
	obj.addProperty("sp", pageInfo.getStart()); // k, v
	obj.addProperty("ep", pageInfo.getEnd()); // k, v
	obj.addProperty("startPage", pageInfo.getStartPage());
	obj.addProperty("endPage", pageInfo.getEndPage());
	obj.addProperty("totalPage", pageInfo.getTotalPage());
	
	// 리뷰 페이지에서 탭에 전제(5), 구매자(2) -> 이런식으로 출력하기 위해 추가함!
	obj.addProperty("totalAllCount", totalAllCount != null ? totalAllCount : 0);
	obj.addProperty("totalBuyerCount", totalBuyerCount != null ? totalBuyerCount : 0);
	
	JsonElement jlist = gson.toJsonTree(list);
	obj.add("datas", jlist);
	
	String memMail = null; 
	
	HttpSession userSession = request.getSession(false);
	if(userSession != null) { // 회원
		MemVO mvo = (MemVO) userSession.getAttribute("member");
		// 로그인 성공하고 memService 메소드 실행 값을 mvo객체에 담고
		// 그 회원의 session에 setAttribute해서 mvo를 value로 담는다.
		
		if (mvo != null) {
			memMail = mvo.getMem_mail(); // MemberVO mem_grade의 getter 메소드
		}
	}
	obj.addProperty("memMail", memMail); //=> js에서 

	out.print(obj);
	out.flush();

%>    