/**
 * 
 */

// 유틸: yyyy-MM-dd → yyyyMMdd 로 변환하는 함수
function formatDate(dateStr) {
  return dateStr?.replaceAll('-', '');
}

$(function () {
  const contextPath = $('script[src*="orderManage.js"]').attr('src').split('/js')[0];
  
  // 페이지 들어오자마자 실행
  const page = 1; // 검색 시 항상 1페이지부터
  loadOrderList(page);

  // ✅ 주문 목록 조회
  $('#btnSearch').on('click', function (e) {
    e.preventDefault();

    const rawStart = $('#startDate').val();
    const rawEnd = $('#endDate').val();

    // 날짜 입력 필수 처리
    if ((rawStart && !rawEnd) || (!rawStart && rawEnd)) {
      alert('주문 날짜를 모두 입력해주세요.');
      return;
    }

    const page = 1; // 검색 시 항상 1페이지부터
    loadOrderList(page);
  });

  // ✅ 주문 상태 변경
  $('#btnUpdateOrderStatus').on('click', function () {
    const selectedOrder = $('input[name="selectedOrder"]:checked').val();
    const newStatus = $('input[name="newOrderStatus"]:checked').val();

    if (!selectedOrder) {
      alert('주문을 선택해주세요.');
      return;
    }

    if (!newStatus) {
      alert('변경할 주문 상태를 선택해주세요.');
      return;
    }

    $.ajax({
      url: `${contextPath}/updateOrderStatus.do`,
      type: 'POST',
      data: {
        orderNo: selectedOrder,
        orderStatus: newStatus
      },
      success: function (res) {
        alert(res.message);
        if (res.success) {
          const currentPage = $('.page-number.active').data('page') || 1;
          loadOrderList(currentPage);
        }
      },
      error: function () {
        alert('서버 통신 중 오류 발생');
      }
    });
  });
});

// ✅ 주문 목록 비동기 로딩 함수
function loadOrderList(page = 1) {
  const contextPath = $('script[src*="orderManage.js"]').attr('src').split('/js')[0];

  const rawStart = $('#startDate').val();
  const rawEnd = $('#endDate').val();

  const data = {
    searchType: $('#searchType').val(),
    searchWord: $('#searchWord').val(),
    startDate: rawStart ? formatDate(rawStart) : null,
    endDate: rawEnd ? formatDate(rawEnd) : null,
    bookTitle: $('#bookTitle').val(),
    orderStatus: $('#orderStatus').val(),
	paymentStatus: $('#paymentStatus').val(),
    page: page,
	perPage: 10
  };

  $.ajax({
    url: `${contextPath}/orderManage.do`,
    type: 'POST',
    data: data,
    success: function (res) {
      console.log("응답 결과:", res);

      $('#orderTableBody').empty();
      $('#orderCount').text(res.totalCount);

      if (!res.orderList || res.orderList.length === 0) {
        $('#orderTableBody').append('<tr><td colspan="13">조회된 주문이 없습니다.</td></tr>');
        $('#pagingArea').empty();
        return;
      }

/*      $.each(res.orderList, function (i, item) {
        console.log("아이템 확인:", item);
        console.log("주문번호 확인:", item.orderNo);

        let tr = `
          <tr>
            <td><input type="radio" name="selectedOrder" value="${item.orderNo}" data-status="${item.orderStatus}"></td>
            <td>${item.orderNo}</td>
            <td>${item.custId}</td>
            <td>${item.bookTitle}</td>
            <td>${item.orderQty}</td>
            <td>${Number(item.orderPrice).toLocaleString()}</td>
            <td>${Number(item.totalAmt).toLocaleString()}</td>
            <td>${item.orderName}</td>
            <td>${item.orderZip}</td>
            <td>${item.orderAddr1} ${item.orderAddr2}</td>
            <td>${item.orderStatus}</td>
			<td>${item.paymentStatus}</td>
          </tr>
        `;
        $('#orderTableBody').append(tr);
      });*/
	  
	  // ✅ 주문번호 기준 그룹화 후 rowspan 적용
	  const grouped = {};
	  res.orderList.forEach(order => {
	    if (!grouped[order.orderNo]) grouped[order.orderNo] = [];
	    grouped[order.orderNo].push(order);
	  });

	  let html = '';
	  for (const orderNo in grouped) {
	    const group = grouped[orderNo];
	    const rowspan = group.length;

	    group.forEach((item, idx) => {
	      html += '<tr>';

	      if (idx === 0) {
	        html += `<td rowspan="${rowspan}"><input type="radio" name="selectedOrder" value="${item.orderNo}" data-status="${item.orderStatus}"></td>`;
	        html += `<td rowspan="${rowspan}">${item.orderNo}</td>`;
	        html += `<td rowspan="${rowspan}">${item.custId}</td>`;
	      }

	      html += `<td class="book-title">${item.bookTitle}</td>`;
	      html += `<td>${item.orderQty}</td>`;
	      html += `<td>${Number(item.orderPrice).toLocaleString()}</td>`;

	      if (idx === 0) {
	        html += `<td rowspan="${rowspan}">${Number(item.totalAmt).toLocaleString()}</td>`;
	        html += `<td rowspan="${rowspan}">${item.orderName}</td>`;
	        html += `<td rowspan="${rowspan}">${item.orderZip}</td>`;
	        html += `<td rowspan="${rowspan}">${item.orderAddr1} ${item.orderAddr2}</td>`;
	        html += `<td rowspan="${rowspan}">${item.orderStatus}</td>`;
	        html += `<td rowspan="${rowspan}">${item.paymentStatus}</td>`;
	      }

	      html += '</tr>';
	    });
	  }

	  $('#orderTableBody').html(html);

      makePaging(res.totalCount, page, 10); // 10개씩 페이징
    }
  });
}

// ✅ 페이징 생성 함수
function makePaging(totalCount, currentPage, perPage) {
  const totalPage = Math.ceil(totalCount / perPage);
  let html = '';

  for (let i = 1; i <= totalPage; i++) {
    html += `<span class="page-btn page-number ${i === currentPage ? 'active' : ''}" data-page="${i}">${i}</span>`;
  }

  $('#pagingArea').html(html);

  // 페이지 클릭 이벤트
  $('.page-number').on('click', function () {
    const selectedPage = $(this).data('page');
    loadOrderList(selectedPage);
  });
}