/**
 *
 */


/*product.addEventListener('click', function(){
	event.preventDefault();
	alert("상품관리");
})
*/
/*$('#member').on('click', function(){
	event.preventDefault();
		alert("회원관리");
})
*/

/*const prodProc = () =>{
	event.preventDefault();

	 $(mainContent).load('/BookDam/BookCategory.do');
}*/




listPageServer = async (event) =>{
	event.preventDefault();

	ff= event.target;

	const a = new FormData(ff);

	fdata = Object.fromEntries(a.entries());
	fdata.page = parseInt(fdata.page) || 1;
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
	  // console.log(datas);

	  $('#bookList').html(datas);
 }