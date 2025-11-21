<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate" %>
<%
    String today = LocalDate.now().toString();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문화행사 등록</title>

<!-- 부트스트랩 & 커스텀 CSS -->
<!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"> -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/event/eventmanage.css">
<style>

#main {
  width: 88%;
  flex-grow: 1;
  padding: 40px;
  
  display: flex;
  flex-direction: column;
  margin-left: 13%; /* 사이드바 너비보다 살짝 크게 */
}
    
#main h2 {
  font-size: 28px;
  margin-bottom: 20px;
}

.container {
	/* margin: 0 auto; */
	max-width: 850px;
}


/* /////// 사이드 /////// */
#side {
	position: fixed;
	height: 100vh; /* 화면 전체 높이 */
    width: 12%;
    background-color: #1a1a1a;
    color: #fff;
    padding: 20px;
    box-sizing: border-box;
}

#side h3 {
    margin-top: 0;
    font-size: 20px;
    line-height: 1.5;
    margin-bottom: 20px;
}

#side ul {
    list-style: none;
    padding: 0;
}

#side ul li {
    margin-bottom: 10px;
}

#side ul li a {
    color: #ccc;
    text-decoration: none;
    display: block;
    padding: 5px 10px;
    border-radius: 4px;
}

#side ul li.active a,
#side ul li a:hover {
    background-color: #444;
    color: #fff;
}
/* ///////////////////// */

.mb-3 {
	display: flex;
	flex-direction: column;
}

label {
    display: block;
    margin-bottom: 5px;
}

input[type="text"], input[type="number"], input[type="date"], textarea, select {
    width: 100%;
    padding: 1.5%;
    border: 1px solid #ccc;
    border-radius: 4px;
    margin-top: 4px;
    box-sizing: border-box;
    font-size: 16px;
}

.btn-success {
   margin-top: 15px;
   padding: 10px 20px;
   font-size: 17px;
   background-color: #28a745;
   color: white;
   border: none;
   cursor: pointer;
   border-radius: 5px;
 }
 
.btn-success:hover {
    background-color: #218838;
}

.d-grid {
	display: flex;
	justify-content: flex-end;
}

</style>
</head>
<body>

<div id="wrap">
  <!-- ✅ 사이드 메뉴 -->
  <aside id="side">
      <h3>
		  <a href="<%=request.getContextPath() %>/main/adminMain.jsp" style="color: white; text-decoration: none;">
		  관리자<br>페이지
		  </a>
	  </h3>
        <ul>
            <li><a href="<%=request.getContextPath() %>/admin/adminMain.jsp">회원관리</a></li>
            <li><a href="<%=request.getContextPath() %>/bookManage/index.jsp">상품관리</a></li>
            <li><a href="<%=request.getContextPath() %>/orderManage/orderManage.jsp">주문관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/QnaAdminList.do">1:1 고객센터</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/EventAdminList.do">행사 등록</a></li>
            <li><a href="${pageContext.request.contextPath}/NoticeAdminList.do">공지사항 등록</a></li>
        </ul>
    </aside>

    <!-- ✅ 본문 영역 -->
    <main id="main">
        <div class="container" style="max-width: 800px;">
            <h2 class="mb-4 border-bottom pb-2">문화행사 등록</h2>

            <form action="${pageContext.request.contextPath}/EventAdminWrite.do" method="post">
                <!-- 제목 -->
                <div class="mb-3">
                    <label for="title" class="form-label">행사 제목</label>
                    <input type="text" name="title" id="title" class="form-control" required placeholder="제목을 입력하세요">
                </div>

                <!-- 내용 -->
                <div class="mb-3">
                    <label for="content" class="form-label">행사 내용</label>
                    <!-- <textarea style="font-family: 'Arial', sans-serif; name="content" id="content" class="form-control" rows="6" required placeholder="내용을 입력하세요"></textarea> -->
                	<textarea style="font-family: 'Arial', sans-serif;" name="content" id="content" class="form-control" rows="6" required placeholder="내용을 입력하세요"></textarea>
                </div>

                <!-- 작성일 -->
                <div class="mb-3">
                    <label for="eventDate" class="form-label">작성일</label>
                    <input type="date" style="font-family: 'Arial', sans-serif; name="eventDate" id="eventDate" class="form-control" value="<%= today %>" readonly>
                </div>

                <!-- 이미지 선택 -->
                <div class="mb-3">
                    <label for="imgFile" class="form-label">대표 이미지</label>
                    <select name="imgFile" id="imgFile" class="form-select" onchange="previewImage()">
                        <option value="모험.png">모험.png</option>
                        <option value="무브먼트.png">무브먼트.png</option>
                        <option value="문해력.png">문해력.png</option>
                        <option value="숙영의노래.png">숙영의노래.png</option>
                        <option value="욘포세.png">욘포세.png</option>
                        <option value="우숙영.png">우숙영.png</option>
                        <option value="이규태.png">이규태.png</option>
                        <option value="책속의한마디.png">책속의한마디.png</option>
                        <option value="커즈와일.jpg">커즈와일.jpg</option>
                        <option value="꽁지.png">꽁지.png</option>
                        <option value="자주묻는질문.png">자주묻는질문.png</option>
                        <option value="컨닝.png">컨닝.png</option>
                        <option value="질문.png">질문.png</option>
                        <option value="해리포터.png">해리포터.png</option>
                        <option value="chatevent.png">chatevent.png</option>
                        <option value="대덕개발자만남.png">대덕개발자만남.png</option>
                    </select>
                </div>

                <!-- 제출 버튼 -->
                <div class="d-grid">
                    <button type="submit" class="btn btn-success btn-lg">등록하기</button>
                </div>
            </form>
        </div>
    </main>
</div>

<!-- ✅ 이미지 미리보기 스크립트 -->
<script>
    function previewImage() {
        const select = document.getElementById("imgFile");
        const preview = document.getElementById("previewImg");
        preview.src = "/BookDam/images/event/" + select.value;
    }
</script>

</body>
</html>
