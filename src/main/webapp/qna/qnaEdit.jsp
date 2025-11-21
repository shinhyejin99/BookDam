<%@page import="com.google.gson.Gson"%>
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의 수정</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/bookSearchCss.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/main/main.css">
  	<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.js"></script>
   <script src="${pageContext.request.contextPath}/js/jquery.serializejson.min.js"></script>
</head>

<script>
  	
  	
  	currentPage = 1;
  	memMail = null;
  	
 <%
	MemVO mvo = (MemVO) session.getAttribute("loginOk");
	
	String user = null;
	Gson gson = new Gson();
	if (mvo != null) user = gson.toJson(mvo);
%>

	logUser = <%= user == null ? "null" : user %>;

	//로그인 확인용 콘솔창
	if(logUser != null) {
		console.log("현재 로그인ID :" + logUser.mem_mail);
		memMail = logUser.mem_mail;
	} else {
		console.log("로그인 상태 : 비회원");
		memMail = null;
	}

	// 로그아웃
	const logout = async () =>{
		
		try{
			response = await fetch('/BookDam/Logout.do');
			if(!response.ok){
				throw new Error('서버오류:' + response.status);
			}
			result = await response.json();
			
			if(result&& result.flag === 'ok') {
				alert("로그아웃 되었습니다.");
				sessionStorage.removeItem('cartArr');
				window.location.href = `\${mypath}/BestBook.do`;
			} else {
				alert("로그아웃 실패");
			}
		}catch(error){
			console.error("로그아웃 요청 실패 : " , error);
			alert("오류발생")
		}
	}
</script>



<body>




<!-- ✅ 헤더 영역 -->
    <header class="header">
        <div class="header-content">
        	<div class="mypage-header">
        		<% if(mvo == null){ %>
                	<a href="<%= request.getContextPath()%>/log/login.jsp" onclick="alert('로그인으로 이동')">로그인</a>
           		<%}else{ %>
           			<a href="javascript:void(0);" onclick="logout()">로그아웃</a>
           		<% } %>
           		<a href="#" onclick="alert('마이페이지로 이동')">마이페이지</a>
        	</div>
        	<div class="top-header">

	            <!-- 검색 영역 -->
		        <section class="search-section">
		        	<div class="search-container">
		        	<!-- <div class="logo">📚 북담</div> -->
		        	<a href="<%= request.getContextPath() %>/BestBook.do" class="logo">
					  <img src="<%= request.getContextPath() %>/images/logo/아.png" alt="BookDam 로고">
					</a>
			            <form class="search-form" onsubmit="handleSearch(event)">
			                <select class="search-category" id="stype">
			                    <option value="all">전체</option>
			                    <option value="title">도서명</option>
			                    <option value="author">저자</option>
			                    <option value="publisher">출판사</option>
			                </select>
			                <input type="text" class="search-input" id="sword"
			                       placeholder="검색할 도서명 또는 저자 또는 출판사를 입력하세요" required>
			                <button id="search-btn" type="button" class="search-btn">🔍</button>
			             </form>
		             
			             <!-- 헤더 아이콘들 -->
			             <div class="header-icons">
			                <button onclick="location.href= mypath + '/order/order_list.jsp'" class="icon-btn" title="찜목록">❤️</button>
			              	<!--<button class="icon-btn" title="장바구니">🛒</button>-->
			                <a href="#" onclick="location.href= mypath + '/cart/cart_page.jsp'" class="icon-btn" title="장바구니" >🛒</a>
			             </div>
		             </div>
		        </section> 
        	</div>
        	
        </div>
    </header>
        	<!-- 네비게이션 메뉴 -->
            <nav class="nav-menu">
                <a href='<%=request.getContextPath() %>/main/map.jsp'>서점이용안내</a>
                <a href="#" onclick="alert('베스트셀러 페이지로 이동')">베스트셀러</a>
                <a href="#" onclick="alert('문화/행사 페이지로 이동')">문화/행사</a>
                <a href= '<%=request.getContextPath() %>/NoticeList.do'>공지사항</a>
                <a href="<%=request.getContextPath() %>/QnaList.do" onclick="alert('고객센터 페이지로 이동')">고객센터</a> 
            </nav>
 
<div class="container mt-5" style="max-width: 700px;">
    <h2 class="mb-4 border-bottom pb-2">1:1 문의 수정</h2>

    <form action="<%=request.getContextPath() %>/QnaEdit.do" method="post" enctype="multipart/form-data" 
      onsubmit="return confirm('수정된 내용을 저장하시겠습니까?');">

        <!-- 숨겨서 원래 QNA ID 전달 -->
        <input type="hidden" name="qnaQid" value="${qna.qnaQid}">

        <div class="mb-3">
            <label for="title" class="form-label">제목</label>
            <input type="text" name="qnaTitle" id="title" class="form-control"
                   value="${qna.qnaTitle}" required>
        </div>

        <div class="mb-3">
            <label for="qnaType" class="form-label">문의 유형</label>
            <select name="qnaType" id="qnaType" class="form-select" required>
                <option value="주문" ${qna.qnaType == '주문' ? 'selected' : ''}>주문</option>
                <option value="환불" ${qna.qnaType == '환불' ? 'selected' : ''}>환불</option>
                <option value="상품문의" ${qna.qnaType == '상품문의' ? 'selected' : ''}>상품문의</option>
                <option value="기타" ${qna.qnaType == '기타' ? 'selected' : ''}>기타</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="content" class="form-label">문의 내용</label>
            <textarea name="qnaContent" id="content" class="form-control" rows="6"
                      required>${qna.qnaContent}</textarea>
        </div>

        <!-- 파일 첨부부분 -->
        <!-- 기존 첨부파일 목록 -->
<%-- 		<c:if test="${not empty qna.atchFileVO}">
		    <div class="mb-3">
		        <label class="form-label">첨부파일 삭제 여부</label>
		        <ul class="list-group">
		            <c:forEach var="file" items="${qna.atchFileVO.atchFileDetailList}">
		                <li class="list-group-item d-flex justify-content-between align-items-center">
		                    <a href="${pageContext.request.contextPath}/download?atchFileId=${file.atchFileId}&fileSn=${file.fileSn}">
		                        ${file.orignlFileNm}
		                    </a>
		                    <button type="submit" name="deleteFileSn" value="${file.fileSn}" class="btn btn-sm btn-danger">삭제</button>
		                    <input type="checkbox" name="deleteFileSn" value="${file.fileSn}"> 삭제
		                    <!-- 첨부파일 전체 삭제 여부 체크박스 -->
							<c:if test="${not empty qna.atchFileVO}">
							    <div class="mb-3">
							        <input type="checkbox" name="delYn" value="Y">
							    </div>
							</c:if>
		                </li>
		            </c:forEach>
		        </ul>
		    </div>
		</c:if> --%>
<!--		새 파일 업로드
		<div class="mb-3">
		    <label for="uploadFile" class="form-label">새 파일 첨부</label>
		    <input type="file" name="uploadFile" id="uploadFile" class="form-control" multiple>
		</div> -->

        <div class="d-grid">
            <button type="submit" class="btn btn-primary btn-lg">수정 저장</button>
        </div>
    </form>
</div>
</body>
</html>