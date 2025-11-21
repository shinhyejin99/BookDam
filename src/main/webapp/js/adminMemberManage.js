/**
 * 
 */

const getMemList = () => {
	$('#result-tbody').empty();
	
	$.ajax({
		url: `${mypath}/MemberSearch.do`,
		method: 'post',
		data: $('#search-form').serialize(),
		dataType: 'json',
		
		success: function(res) {
			console.log(res);
			
			code = "";
			$.each(res, function(index, item) {
		        code += `<tr>
		          <td>${item.mem_mail}</td>
		          <td>${item.cust_name}</td>
		          <td>${item.mem_nickname}</td>
		          <td>${item.cust_tel}</td>
		          <td>${item.cust_addr1} ${item.cust_addr2}</td>
		          <td>${item.mem_bir}</td>
		          <td>${item.mem_join}</td>
		          <td>${item.mem_grade}</td>
		          <td>
		            <button type="button" class="editBtn" data-email= ${item.mem_mail}>수정</button>
		          </td>
		        </tr>`;
			})
			$('#result-tbody').append(code);
		},
		error: function(xhr) {
			console.log(xhr.status);
		}
	}); // ajax 끝
}