<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <title>전체 주문 목록 관리</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="<%=request.getContextPath()%>/js/orderManage.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/orderManage.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/pageCss.css">
    
</head>
<body>

<div id="admin-wrapper">   <!-- .container -->

     <aside id="side">
      <h3>
		  <a href="<%=request.getContextPath() %>/main/adminMain.jsp" style="color: white; text-decoration: none;">
		  관리자<br>페이지
		  </a>
	  </h3>
       <ul>
           <li><a href="<%=request.getContextPath() %>/admin/adminMain.jsp">회원관리</a></li>
           <li><a href="${pageContext.request.contextPath}/BookCategory.do">상품관리</a></li>
           <li class="active"><a href="<%=request.getContextPath() %>/orderManage/orderManage.jsp">주문관리</a></li>
           <li><a href="${pageContext.request.contextPath}/admin/QnaAdminList.do">1:1 고객센터</a></li>
           <li><a href="${pageContext.request.contextPath}/EventAdminList.do">행사 등록</a></li>
           <li><a href="${pageContext.request.contextPath}/NoticeAdminList.do">공지사항 등록</a></li>
       </ul>
   </aside>

 <!-- 오른쪽: 본문 -->
  <div class="content">
    <main class="admin-content">
        <h2>전체 주문 목록 관리</h2>

        <!-- 검색 영역 -->
        <form id="searchForm">
        <!-- <section class="filter-section"> -->
            <!-- <div class="filter-row"> -->
            <table class="search-table">
            	<tr>
	                <td>검색어</td>
	                <td>
		                <select id="searchType" name="searchType">
		                    <option value="">선택안함</option>
		                    <option value="orderNo">주문번호</option>
		                    <option value="custId">고객ID</option>
		                    <option value="orderName">성함</option>
		                    <option value="orderAddr">주소</option>
		                </select>
		                <input type="text" id="searchWord" name="searchWord" placeholder="검색어 입력">
	                </td>
            <!-- </div> -->
            	</tr>

				<tr>
	           <!--  <div class="filter-row"> -->
	                <td>주문 날짜</td>
	                <td>
		                <input type="date" id="startDate" name="startDate"> ~ 
		                <input type="date" id="endDate" name="endDate">
		           </td>
	            <!-- </div> -->
            	</tr>

				<tr>
	           <!--  <div class="filter-row"> -->
	                <td>도서명</td>
	                <td>
	                	<input type="text" id="bookTitle" name="bookTitle" placeholder="도서 이름 입력">
	                </td>
	            <!-- </div> -->
	            </tr>

            	<tr>
	                <td>배송 상태</td>
	                <td>
	                <select id="orderStatus" name="orderStatus">
	                    <option value="전체">전체</option>
	                    <option value="배송 전">배송 전</option>
	                    <option value="배송 중">배송 중</option>
	                    <option value="배송 완료">배송 완료</option>
	                </select>
	                </td>
            	</tr>
            	
            	<tr>
				    <td>결제 상태</td>
				    <td>
				        <select id="paymentStatus" name="paymentStatus">
				            <option value="전체">전체</option>
				            <option value="결제완료">결제완료</option>
				            <option value="취소/반품">취소/반품</option>
				        </select>
				    </td>
				</tr>
			</table>
            <button type="submit" id="btnSearch"> 검색 </button>
       <!--  </section> -->
        </form>

		<hr style="margin-top: 2%; margin-bottom: 1%;">

        <!-- 검색 결과 출력 -->
        <div class="order-list-summary">
            <h3>검색 결과 전체 : <span id="orderCount">0</span> 건</h3>
        </div>

        <table class="order-table">
            <thead>
                <tr>
                    <th>선택</th>
                    <th>주문번호</th>
                    <th>고객ID</th>
                    <th>도서명</th>
                    <th>수량</th>
                    <th>가격</th>
                    <th>총 금액</th>
                    <th>성함</th>
                    <th>우편번호</th>
                    <th>주소</th>
                    <th>배송상태</th>
                    <th>결제상태</th>
                </tr>
            </thead>
            <tbody id="orderTableBody">
                <!-- JS 로 등록 -->
            </tbody>
        </table>
        
         <!-- 페이징 영역 -->
        <div class="paging pagination" id="pagingArea">
            <!-- JS 동적 페이징 생성 -->
        </div>

		<div class="status-update-section">
		    <h4>선택한 주문의 상태를 변경하세요</h4>
		    <div class="status-radio-group">
		        <label><input type="radio" name="newOrderStatus" value="배송 전">배송 전</label>
		        <label><input type="radio" name="newOrderStatus" value="배송 중">배송 중</label>
		        <label><input type="radio" name="newOrderStatus" value="배송 완료">배송 완료</label>
		    </div>
		    <button id="btnUpdateOrderStatus" class="update-button">수정</button>
		</div>

    </main>
    </div>
</div>
</body>
</html>