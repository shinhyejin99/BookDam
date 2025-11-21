<!-- bookList.jsp - 전체 상품 관리 화면 (모달 방식) -->
<%@page import="kr.or.ddit.dam.vo.SearchVO"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Optional"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="kr.or.ddit.dam.vo.BookVO"%>
<%@page import="kr.or.ddit.dam.book.service.BookServiceImpl"%>
<%@page import="kr.or.ddit.dam.book.service.IBookService"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%
//controller에서 가져오는 값
String stype = Optional.ofNullable(request.getParameter("stype")).orElse("");
String sword = Optional.ofNullable(request.getParameter("sword")).orElse("");
String category = Optional.ofNullable(request.getParameter("category")).orElse("");
String startDate = request.getParameter("startDate");
String endDate = request.getParameter("endDate");
String minPrice = request.getParameter("minPrice");
String maxPrice = request.getParameter("maxPrice");
String minStock = request.getParameter("minStock");
String maxStock = request.getParameter("maxStock");

String startDateParam = (startDate != null && !startDate.trim().isEmpty()) ? startDate.trim() : null;
String endDateParam = (endDate != null && !endDate.trim().isEmpty()) ? endDate.trim() : null;
Integer minPriceParam = (minPrice != null && !minPrice.trim().isEmpty()) ? Integer.parseInt(minPrice.trim()) : 0;
Integer maxPriceParam = (maxPrice != null && !maxPrice.trim().isEmpty()) ? Integer.parseInt(maxPrice.trim()) : 0;
Integer minStockParam = (minStock != null && !minStock.trim().isEmpty()) ? Integer.parseInt(minStock.trim()) : 0;
Integer maxStockParam = (maxStock != null && !maxStock.trim().isEmpty()) ? Integer.parseInt(maxStock.trim()) : 0;

List<String> categoryList = (List<String>)request.getAttribute("categoryList");
%>

  <!-- Bootstrap CSS -->
  <!--   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" /> -->
  
<style>

.search-btn {
  margin-top: 15px;
  padding: 10px 20px;
  font-size: 17px;
  background-color: black;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 5px;
}
.search-btn:hover {
  background-color: #333;
}


.editBtn {
  padding: 10px 20px;
  font-size: 17px;
  background-color: #007bff;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 5px;
}
.editBtn:hover {
	background-color: #0056b3;
}

#deleteBtn {
  padding: 10px 20px;
  font-size: 17px;
  background-color: red;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 5px;
}
#deleteBtn:hover {
  background-color: #a61919;
}

.registerBtn {
  padding: 10px 20px;
  font-size: 17px;
  background-color: #28a745;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 5px;
}
.registerBtn:hover {
  background-color: #218838;
}

.btns{
  display: flex;
  justify-content: flex-end;
}

.btns button {
  margin: 3px;
}

.result-table {
  font-size: 15px;
  width: 100%;
  table-layout: fixed;
}

.result-table th, .result-table td {
  text-align: center;
}

.result-table th {
  background-color: black;
  color: white;
}

.result-table th:nth-child(1), /* 선택 */
.result-table td:nth-child(1) {
  width: 52px;
}

.result-table th:nth-child(2), /* 선택 */
.result-table td:nth-child(2) {
  width: 140px;
}

.result-table th:nth-child(7), /* 선택 */
.result-table td:nth-child(7),
.result-table th:nth-child(8), /* 선택 */
.result-table td:nth-child(8) {
  width: 110px;
}
.result-table th:nth-child(3), /* 선택 */
.result-table td:nth-child(3),
.result-table th:nth-child(11), /* 선택 */
.result-table td:nth-child(11) {
  width: 80px;
}
.result-table th:nth-child(5), /* 선택 */
.result-table td:nth-child(5),
.result-table th:nth-child(6), /* 선택 */
.result-table td:nth-child(6) {
  width: 230px;
}
.result-table th:nth-child(9), /* 선택 */
.result-table td:nth-child(9) {
  width: 140px;
}
.result-table th:nth-child(10), /* 선택 */
.result-table td:nth-child(10) {
  width: 90px;
}

</style>

<%-- <link rel="stylesheet" href="<%=request.getContextPath() %>/css/bookSearchCss.css"> --%>
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/bookmanage.css">
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/pageCss.css">

<div id="wrap">

<aside id="side">
        <h3>
        <a href="<%=request.getContextPath() %>/main/adminMain.jsp" style="color: white; text-decoration: none;">
        관리자<br>페이지
        </a>
        </h3>
        <ul>
            <li><a href="<%=request.getContextPath() %>/admin/adminMain.jsp">회원관리</a></li>
            <li class="active"><a href="<%=request.getContextPath() %>/BookCategory.do">상품관리</a></li>
            <li><a href="<%=request.getContextPath() %>/orderManage/orderManage.jsp">주문관리</a></li>
            <li ><a href="${pageContext.request.contextPath}/admin/QnaAdminList.do">1:1 고객센터</a></li>
            <li><a href="${pageContext.request.contextPath}/EventAdminList.do">행사 등록</a></li>
            <li><a href= '<%=request.getContextPath() %>/NoticeAdminList.do'>공지사항 등록</a></li>
        </ul>
    </aside>
    
 <main id="main">
      <h2>전체 상품 관리</h2>
      
        <!-- 검색 영역 -->
      <form method="get" id="searchForm">
        <input type="hidden" name="page" id="page" value="1">
        <table class="search-table">
          <tr class="search-box">
            <!-- 검색 조건 폼 -->
            <td>검색어</td>
            <td>
              <select name="stype" id="stype">
                <option value="">선택 안함</option>
                <option value="book_title" <%=stype.equals("book_title") ? "selected" : ""%>>도서명</option>
                 <option value="book_no" <%=stype.equals("book_no") ? "selected" : ""%>>도서코드</option>
                 <option value="book_author" <%=stype.equals("book_author") ? "selected" : ""%>>저자</option>
                 <option value="publisher" <%=stype.equals("publisher") ? "selected" : ""%>>출판사</option>
               </select>
               <input type="text" id="sword" name="sword" placeholder="검색어 입력" >
             </td>
		  </tr>
			
            <tr class="search-box">
              <td>카테고리</td>
                <td>
                  <select name="category">
                      <option value="" selected>선택 안함</option>
                      <% 
                       if(categoryList != null && categoryList.size() > 0 ){
                    	  for (String cat : categoryList) { %>
                          <option value="<%=cat%>" ><%=cat%></option>
                      <% }
                      }%>
                </select>
              </td>
			</tr>
			
            <tr class="search-box">
              <td>출판일</td>
              <td>
                <input type="date" name="startDate" value="<%=startDateParam != null ? startDateParam: ""%>"> ~
                <input type="date" name="endDate" value="<%=endDateParam != null ? endDateParam : ""%>">
              </td>
            </tr>
            
            <tr class="search-box">
              <td>도서가격</td>
                <td>
                  <input type="number" name="minPrice" placeholder="최소가격" value="<%= minPriceParam != null ? minPriceParam : "" %>"> ~
                  <input type="number" name="maxPrice" placeholder="최대가격" value="<%= maxPriceParam != null? maxPriceParam : ""%>">
              </td>
            </tr>
            
            <tr class="search-box">
            	<td>재고수량</td>
            	<td>
                  <input type="number" name="minStock" placeholder="최소재고" value="<%=minStockParam != null ? minStockParam :""%>"> ~
                  <input type="number" name="maxStock" placeholder="최대재고" value="<%=maxStockParam != null ? maxStockParam :""%>">
                </td>
                <!-- <button type="submit">검색</button> -->
            </tr>
            </table>
            
            
              <button type="button" id="search" class="search-btn">검색</button>
              <button type="reset" class="search-btn">초기화</button>
        </form>
        
     <hr style="margin-top: 2%; margin-bottom: 1%;">
     
    <!-- 리스트 출력  - 페이지 번호 까지   -->    
	<div id="bookList"></div>
	
	<div class="btns">
	    <button type="button" class="editBtn">도서 정보 수정</button>
	    <button type="button" id="deleteBtn">도서 삭제</button>
	    <button type="button" class="registerBtn">신규 등록</button>
	</div>
	
	<!-- 모달 목적 버튼 -->
	<div id="bookModal" style="display:none;">
	    <div id="modalContent"></div>
	</div>
</main>
</div>

<script src="/BookDam/js/jquery-3.7.1.js"></script>

<script>

currentPage = 1;
<%-- mypath = '<%= request.getContextPath()%>'; --%>

listPageServer = async (event) =>{
	event.preventDefault();
	
	ff= event.target;
	
	const a = new FormData(ff);
	
	fdata = Object.fromEntries(a.entries());
	console.log(fdata);
		
	  response = await fetch("/BookDam/BookList.do",{
		method : 'post',
		headers : {
			'Content-type' : 'application/json;charset=utf-8'
		},
		body : JSON.stringify(
				Object.fromEntries(a.entries())
		)
	  })
	
	  datas = await response.text();
	  //console.log(datas); 
		
	  $('#bookList').html(datas); 
 }
 
searchForm.addEventListener('submit',listPageServer);

//초기 처음 실행 
searchForm.requestSubmit();

//검색 버튼 클릭 시 유효성 검사 추가
$(document).on('click', "#search", function () {
	// 페이지 초기화
    currentPage = 1;
    $('#page').val(currentPage);

 	// 검색 조건/키워드 값 읽어오기
    const stype  = $('#stype').val(); // select#stype
    const sword  = $('#sword').val().trim(); // input#sword
    const startDate = $('input[name="startDate"]').val();
    const endDate = $('input[name="endDate"]').val();
    const minPrice  = $('input[name="minPrice"]').val().trim();
    const maxPrice  = $('input[name="maxPrice"]').val().trim();
    const minStock  = $('input[name="minStock"]').val().trim();
    const maxStock  = $('input[name="maxStock"]').val().trim();

    // 디버깅 로그 (개발 중 확인용)
    console.log({stype, sword, minPrice, maxPrice, minStock, maxStock});

    // 검색 조건/검색어
    if (!stype && sword) {
        alert("검색 조건을 선택해주세요.");
        return;
    }
    if (stype && !sword) {
        alert("검색어를 입력해주세요.");
        return;
    }

    // 출판일 범위
    if ((startDate && !endDate) || (!startDate && endDate)) {
        alert("출판일의 시작일과 종료일을 모두 입력해주세요.");
        return;
    }

    // 도서가격 범위 검증
    if ((minPrice !== "" && maxPrice === "") ||
        (minPrice === "" && maxPrice !== "")) {
        alert("도서가격의 최소값과 최대값을 모두 입력해주세요.");
        return;
    }

    // 재고수량 범위 검증
    if ((minStock !== "" && maxStock === "") ||
        (minStock === "" && maxStock !== "")) {
        alert("재고수량의 최소값과 최대값을 모두 입력해주세요.");
        return;
    }

    // 모두 통과하면 전송
    searchForm.requestSubmit();
});
 
//이전 버튼 
$(document).on('click', "#prev-btn", function(){
	currentPage = parseInt($('.page-btn.page-number').first().text()) - 1;
	$('#page').val(currentPage);
	searchForm.requestSubmit();
	
})

//다음버튼 
$(document).on('click', "#next-btn", function(){
	currentPage = parseInt($('.page-btn.page-number').last().text()) + 1;
	$('#page').val(currentPage);
	searchForm.requestSubmit();
})
 
//페이지번호 
//$(document).on('click', ".pageno", function(){
$(document).on('click', ".page-btn.page-number", function(){
	currentPage = parseInt($(this).text()) ;
	$('#page').val(currentPage);
	searchForm.requestSubmit();
})

//-----------------------------------------------
//신규등록 - //도서수정
$('.editBtn, .registerBtn').on('click', function () {
	
    const selected = $('input[name=select]:checked').val();
    
    const mode = $(this).hasClass('editBtn') ? 'edit' : 'insert';
    console.log(selected , mode  );
    
    if (mode === 'edit' && !selected) {
        alert("수정할 도서를 선택하세요.");
        return;
    }
    
    //수정할 레코드의 각 항목 데이타 가져오기 - 모달창에 출력 
    if (mode === 'edit'){
    	    // 선택된 라디오 버튼
    	    const selectedRadio = document.querySelector('input[name="select"]:checked');
    	  
    	    // 선택된 라디오 버튼의 가장 가까운 조상 tr을 찾음
    	    const selectedRow = selectedRadio.closest('tr');
    	    
    	    // 각 td 요소 가져오기
    	    const tds = selectedRow.querySelectorAll('td');

    	    // 필요한 정보 꺼내기
    	    bookInfo = {
    	        book_no: tds[1].textContent.trim(),
    	        cover_img: tds[2].querySelector('img').getAttribute('src'),
    	        book_title: tds[3].textContent.trim(),
    	        book_author: tds[4].textContent.trim(),
    	        publisher: tds[5].textContent.trim(),
    	        category: tds[6].textContent.trim(),
    	        book_price: tds[7].textContent.trim(),
    	        book_pubdate: tds[8].textContent.trim(),
    	        book_page: tds[9].textContent.trim(),
    	        stock_qty: tds[10].textContent.trim()
    	    };

    	    console.log(bookInfo);
    	    // 이후 bookInfo를 이용해 수정 폼을 채우거나, 수정 로직 수행 가능
    }
    
     const url = `/BookDam/bookManage/bookForm.jsp?mode=\${mode}` + (selected ? `&book_no=\${selected}` : '');
   
     $('#modalContent').load(url, function () {
         $('#bookModal').fadeIn();
        
	      if(mode == 'edit'){
	      // form에 값 채우기 
	 	    const form = document.querySelector('#bookModal #bookForm');
	 	    form.book_no.value = bookInfo.book_no;
	 	    form.cover_img.value = bookInfo.cover_img;
	 	    form.book_title.value = bookInfo.book_title;
	 	    form.book_author.value = bookInfo.book_author;
	 	    form.publisher.value = bookInfo.publisher;
	 	    form.category.value = bookInfo.category;
	 	    form.book_price.value = bookInfo.book_price;
	 	    form.book_pubdate.value = bookInfo.book_pubdate?.split(' ')[0] || '';
	 	    form.book_page.value = bookInfo.book_page;
	 	    form.stock_qty.value = bookInfo.stock_qty;
	    } 
   });  //load
});

 $('#deleteBtn').on('click', function () {
    const selected = $('input[name=select]:checked').val();
    
    if (!selected) {
        alert("삭제할 도서를 선택하세요.");
        return;
    }
    if (confirm("해당 도서 정보를 삭제하시겠습니까?")) {
    	
    	$.ajax({
            type: 'get',
            url: '/BookDam/BookManage.do',
            data: { cmd : "delete",
            	   book_no : selected
            	},
            success: function (msg) {
                alert(msg.flag);
                
                //currentPage = 1;
               // $('#page').val(currentPage);
                searchForm.requestSubmit();
            },
            error: function (xhr) {
                alert('오류가 발생했습니다: ' + xhr.responseText);
            },
            dataType : 'json'
        }); 
    	
       // location.href = BookManage.do?cmd=delete&book_no=${selected};
    }
}); 

$('#modalContent').on('click', '#closeModal', function () {
    $('#bookModal').fadeOut();

});
</script>