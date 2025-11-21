<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>행사 등록 관리</title>
    <link rel="stylesheet" href="./eventmanage.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="<%=request.getContextPath() %>/js/adminEventManage.js"></script>
</head>
<body>
<div id="wrap">
    <!-- <div id="side">
        <h3>관리자 페이지</h3>
        <ul>
            <li><a href="/adminMemberList.do">회원관리</a></li>
            <li><a href="/adminProductList.do">상품관리</a></li>
            <li><a href="/adminOrderList.do">주문관리</a></li>
            <li><a href="/adminQnaList.do">1:1 고객센터</a></li>
            <li><a href="/adminNoticeList.do">공지사항 등록</a></li>
            <li class="active"><a href="/adminEventList.do">행사 등록</a></li>
        </ul>
    </div> -->
      <aside id="side">
      <h3>
		  <a href="<%=request.getContextPath() %>/main/adminMain.jsp" style="color: white; text-decoration: none;">
		  관리자<br>페이지
		  </a>
	  </h3>
        <ul>
            <li><a href="<%=request.getContextPath() %>/admin/adminMain.jsp">회원관리</a></li>
            <li><a href="${pageContext.request.contextPath}/BookCategory.do">상품관리</a></li>
            <li><a href="<%=request.getContextPath() %>/orderManage/orderManage.jsp">주문관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/QnaAdminList.do">1:1 고객센터</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/EventAdminList.do">행사 등록</a></li>
            <li><a href="${pageContext.request.contextPath}/NoticeAdminList.do">공지사항 등록</a></li>
        </ul>
    </aside>
    <div id="main">
        <h2>행사 등록</h2>
        <form id="eventForm">
            <label>제목</label>
            <input type="text" name="eventTitle" required><br>

            <label>행사 분류</label>
            <select name="eventType" required>
                <option value="nomal">일반 행사 / 토론</option>
                <option value="chat">채팅</option>
            </select><br>

            <label>내용</label>
            <textarea name="eventContent" required></textarea><br>

            <label>채팅방 링크</label>
            <input type="text" name="eventChatLink"><br>

            <label>오픈 날짜</label>
            <input type="datetime-local" name="eventOpenDate"><br>

            <label>참여 인원</label>
            <input type="number" name="eventChatCapacity"><br>

            <button type="submit">등록</button>
        </form>

        <table>
            <thead>
            <tr>
                <th>선택</th><th>번호</th><th>행사분류</th><th>제목</th><th>작성일</th><th>오픈일</th><th>채팅방 링크</th><th>관리</th>
            </tr>
            </thead>
            <tbody id="eventTableBody">
            <!-- JS로 동적 로딩 -->
            </tbody>
        </table>
    </div>
</div>

<script>

mypath = '<%=request.getContextPath()%>';

// 초기 로딩 시 리스트 출력
$(function () {
    loadEventList();

    // 등록 처리
    //백틱에서 J/S변수 사용 시 역슬러시 필요함
    $('#eventForm').on('submit', function (e) {
        e.preventDefault();
        
        let eventTitle = $("input[name='eventTitle']").val();
        let eventType = $("select[name='eventType']").val();
        let eventContent = $("textarea[name='eventContent']").val();
        let eventChatLink = $("input[name='eventChatLink']").val();
        let eventOpenDate = $("input[name='eventOpenDate']").val();
        let eventChatCapacity = $("input[name='eventChatCapacity']").val();
        
        //JSON Object
        let data = {
        	"eventTitle":eventTitle,
        	"eventType":eventType,
        	"eventContent":eventContent,
        	"eventChatLink":eventChatLink,
        	"eventOpenDate":eventOpenDate,
        	"eventChatCapacity":eventChatCapacity
        }
        
        console.log("data : ", data);
        
      //JSON Object -> JSON String
        $.ajax({
            url: `\${mypath}/adminEventInsert.do`,
            method: 'POST',
            data:JSON.stringify(data),
            success: function () {
                alert('등록 완료');
                $('#eventForm')[0].reset();
                loadEventList();
            },
            error: function(xhr){
            	console.log("xhr : ", xhr);
            }
        });//end ajax
    });//end eventForm
});//end 달러function

function loadEventList() {
     $.ajax({
        url: '/eventListAjax.do',
        method: 'GET',
        dataType: 'json',
        success: function (data) {
            const tbody = $('#eventTableBody');
            tbody.empty();
            data.forEach(event => {
                tbody.append(`
                    <tr>
                        <td><input type="checkbox" value="${event.eventId}"></td>
                        <td>${event.eventId}</td>
                        <td>${event.eventType == 'chat' ? '채팅' : '일반'}</td>
                        <td>${event.eventTitle}</td>
                        <td>${event.createDate || '-'}</td>
                        <td>${event.eventOpenDate || '-'}</td>
                        <td>${event.eventChatLink || '-'}</td>
                        <td>
                            <button onclick="editEvent(${event.eventId})">수정</button>
                            <button onclick="deleteEvent(${event.eventId})">삭제</button>
                        </td>
                    </tr>
                `);
            });
        }
    }); 
}

function deleteEvent(id) {
    if (!confirm('삭제하시겠습니까?')) return;
    $.post('/adminEventDelete.do', { eventId: id }, function () {
        alert('삭제 완료');
        loadEventList();
    });
}

function editEvent(id) {
    // 수정은 추후 모달 방식으로 추가 가능
    alert('수정 기능은 개발 예정입니다.');
}
</script>
</body>
</html>