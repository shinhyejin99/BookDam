<%@page import="kr.or.ddit.dam.vo.SearchVO"%>
<%@page import="kr.or.ddit.dam.vo.PageVO"%>
<%@page import="kr.or.ddit.dam.vo.BookVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

 <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" /> -->
 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page session="true" %>


<c:set var="bookList" value="${requestScope.bookList}" />

 <c:if test="${not empty bookList}">
    <table class="result-table">
        <thead>
            <tr>
                <th>선택</th>
                <th>도서코드</th>
                <th>이미지</th>
                <th>도서명</th>
                <th>저자</th>
                <th>출판사</th>
                <th>카테고리</th>
                <th>가격</th>
                <th>출판일</th>
                <th>페이지수</th>
                <th>재고</th>
               
            </tr>
        </thead>
        <tbody>
            <c:forEach var="book" items="${bookList}">
                <tr>
                    <td>
                        <input type="radio" name="select" value="${book.book_no}" />
                    </td>
                    <td>${book.book_no}</td>
                    <td>
                        <img src="${book.cover_img}" width="50" />
                    </td>
                    <td>${book.book_title}</td>
                    <td>${book.book_author}</td>
                    <td>${book.publisher}</td>
                    <td>${book.category}</td>
                    <td>${book.book_price}</td>
                    <td>${(book.book_pubdate).split(" ")[0]}</td>
                    <td>${book.book_page}</td>
                    <td>${book.stock_qty}</td>
                    
                </tr>
            </c:forEach>
        </tbody>
    </table>
</c:if>
<br><br>



<c:set var="vo" value="${requestScope.PageVO}" />
<c:set var="svo" value="${requestScope.SearchVO}" />





<div class="pagination">
    <!-- 이전 버튼 -->
    <c:choose>
        <c:when test="${vo.startPage > 1}">
            <button class="page-btn prev-btn" data-page="prev" id="prev-btn">
                <i class="arrow-left">‹</i>
            </button>
        </c:when>
        <c:otherwise>
            <button class="page-btn prev-btn disabled">
                <i class="arrow-left">‹</i>
            </button>
        </c:otherwise>
    </c:choose>

    <!-- 페이지 번호 반복 -->
    <c:forEach var="i" begin="${vo.startPage}" end="${vo.endPage}">
        <c:choose>
            <c:when test="${i == svo.page}">
                <button class="page-btn page-number active">${i}</button>
            </c:when>
            <c:otherwise>
                <button class="page-btn page-number" data-page="${i}">${i}</button>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <!-- 다음 버튼 -->
    <c:choose>
        <c:when test="${vo.endPage < vo.totalPage}">
            <button class="page-btn next-btn" data-page="next" id="next-btn">
                <i class="arrow-right">›</i>
            </button>
        </c:when>
        <c:otherwise>
            <button class="page-btn next-btn disabled">
                <i class="arrow-right">›</i>
            </button>
        </c:otherwise>
    </c:choose>
</div>


<%-- 
const pageList = (sp, ep, tp) => {

	let pager = `<div class="pagination">`;
	
	// 이전 버튼
	if(sp > 1 ) {
		pager += `<button class="page-btn prev-btn" data-page="prev">
		             <i class="arrow-left">‹</i>
		          </button>`;
	} else {
	    pager += `<button class="page-btn prev-btn disabled">
			         <i class="arrow-left">‹</i>
			      </button>`;
	}
	
	// 페이지 번호
	for(i = sp; i <= ep; i++) {
		if(i == currentPage) {  /*currentPage = bookSearch.jsp에 있음*/
			pager += `<button class="page-btn page-number active">${i}</button>`;
		} else {
			pager += `<button class="page-btn page-number" data-page="${i}">${i}</button>`;
		}
	} 
	
	// 다음 버튼
	if(ep < tp) {
		pager += `<button class="page-btn next-btn" data-page="next">
		             <i class="arrow-right">›</i>
		          </button>`;
	}  else {
		 pager += `<button class="page-btn next-btn disabled">
			         <i class="arrow-right">›</i>
			       </button>`;
	}
	
	pager += `</div>`;
	
	return pager;
} 

 --%>
<%-- 
<ul class="pagination">
    <!-- 이전 페이지 -->
    <c:if test="${vo.startPage > 1}">
        <li class="page-item"><a id="prev" class="page-link">Previous</a></li>
    </c:if>

    <!-- 페이지 번호 반복 -->
    <c:forEach var="i" begin="${vo.startPage}" end="${vo.endPage}">
        <c:choose>
            <c:when test="${i == svo.page}">
                <li class="page-item active">
                    <a class="page-link pageno">${i}</a>
                </li>
            </c:when>
            <c:otherwise>
                <li class="page-item">
                    <a class="page-link pageno">${i}</a>
                </li>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <!-- 다음 페이지 -->
    <c:if test="${vo.endPage < vo.totalPage}">
        <li class="page-item"><a id="next" class="page-link">Next</a></li>
    </c:if>
</ul>

--%>