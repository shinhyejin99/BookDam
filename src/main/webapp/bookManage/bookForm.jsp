<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@page import="kr.or.ddit.dam.vo.BookVO"%>
<%@page import="kr.or.ddit.dam.book.service.BookServiceImpl"%>
<%@ page import="kr.or.ddit.dam.book.service.IBookService" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
	String mode = request.getParameter("mode");
	String bookNoStr = request.getParameter("book_no");
	BookVO book = null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= "edit".equals(mode) ? "도서 수정" : "도서 등록" %></title>
    <!-- <link rel="stylesheet" href="../css/bookmanage.css"> -->
    <!-- <script>  src="https://code.jquery.com/jquery-3.7.1.min.js"></script> -->
    <script src="<%= request.getContextPath()%>/js/jquery.serializejson.min.js"></script>
</head>

<body>


<h2><%= "edit".equals(mode) ? "도서 수정" : "도서 등록" %></h2>

<form id="bookForm">
    <input type="hidden" name="mode" value="<%= mode %>">

    <label>도서번호(ISBN):</label>
    <input name="book_no" type="text" 
           value="<%= book != null ? book.getBook_no() : "" %>"
           <%= "edit".equals(mode) ? "readonly" : "" %> required><br>

    <label>제목:</label>
    <input type="text" name="book_title"  required><br>

    <label>저자:</label>
    <input type="text" name="book_author" required><br>

    <label>출판일:</label>
    <input type="date" name="book_pubdate" required><br>

    <label>설명:</label>
    <textarea name="book_description" rows="4"></textarea><br>

    <label>가격:</label>
    <input type="number" name="book_price" required><br>

    <label>출판사:</label>
    <input type="text" name="publisher" ><br>

    <label>카테고리:</label>
    <input type="text" name="category" ><br>

    <label>이미지 URL:</label>
    <input type="text" name="cover_img" ><br>

    <label>페이지 수:</label>
    <input type="number" name="book_page" ><br>

    <label>재고 수량:</label>
    <input type="number" name="stock_qty" >

    <button type="button" id="submitBtn"><%= "edit".equals(mode) ? "수정" : "등록" %></button>
    <button type="button" id="closeModal">닫기</button>
</form>

<script>

// [2] 등록/수정 버튼 클릭 시 처리
$('#submitBtn').on('click', function () {
    const title = $('input[name=book_title]').val().trim();
    const author = $('input[name=book_author]').val().trim();
    const pubdate = $('input[name=book_pubdate]').val().trim();
    
    if (title === '') {
        alert('제목을 입력하세요.');
        return;
    }
    if (author === '') {
        alert('저자를 입력하세요.');
        return;
    }
    if (pubdate === '') {
        alert('출판일을 선택하세요.');
        return;
    }

    const mode = $('input[name=mode]').val();
    const action = mode === 'edit' ? '수정' : '등록';

    ff = document.querySelector('#bookForm');
    const a = new FormData(ff);
	
	fdata = Object.fromEntries(a.entries());
	console.log(fdata);
		
    
    
    
    if (confirm(`이대로 \${action}하시겠습니까?`)) {
          $.ajax({
            type: 'POST',
            url: '/BookDam/BookManage.do',
            data: JSON.stringify(fdata),
            success: function (msg) {
                alert(msg.flag);
                $('#bookModal').fadeOut();
                //location.reload();  // 모달 닫고 리스트 새로고침- 다시확인 
                if(mode == "insert"){
                	currentPage = 1;
                	$('#page').val(currentPage);
                }
                searchForm.requestSubmit();

            },
            error: function (xhr) {
                alert('오류가 발생했습니다: ' + xhr.responseText);
            },
            dataType : 'json'
        }); 
    }
});

$('#closeModal').on('click', function () {
    $('#bookModal').fadeOut();
});
</script>

</body>
</html>