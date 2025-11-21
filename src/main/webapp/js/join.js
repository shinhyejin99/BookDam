$(document).ready(() => {

	function isValidEmail(email) {
	    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	    return regex.test(email);
	}
	// 초기에는 인증번호 입력칸과 버튼 숨기기
	$('#otp').hide();
	  $('#otpcheck').hide();
	  
	// 1. 이메일 중복검사
	$('#mailcheck').on('click', () => {
		const email = $('#mem_mail').val().trim();
		const mailspanText = $('#mailspan').text();
		
		if (!email) {
			alert('이메일을 입력하세요.');
			return;
		}
		if (!isValidEmail(email)) {
		        alert('올바른 이메일 형식이 아닙니다.');
		        return;
		    }
			
		fetch(`/BookDam/IdCheck.do?mem_mail=${encodeURIComponent(email)}`)
			.then(res => res.json())
			.then(result => {
				$('#mailspan')
					.text(result.flag)
					.css('color', result.flag.includes('사용가능') ? 'green' : 'red');
					
					// 이메일 중복검사 후 버튼 글씨 빨간색으로 변경
					      $('#mailcheck').css('color', 'red');
					      
					      // 인증번호 입력칸 숨기기 (중복검사 다시 할 때 초기화)
					      $('#otp').hide();
					      $('#otpcheck').hide();
					      $('#otpspan').text('');
					    })
				     .catch(e => {
				       console.error(e);
				       alert('이메일 중복 검사 중 오류가 발생했습니다.');
				     });
				 });
		
				 
				 
	// 2. 이메일 인증번호 요청
	$('#emailcheck').on('click', () => {
		console.log('이메일 인증 버튼 클릭됨.')
		const email = $('#mem_mail').val().trim();
		const mailspanText = $('#mailspan').text();
		
		if (!email) {
			alert('이메일을 입력하세요.');
			return;
		
		}
		   if (!isValidEmail(email)) {
		       alert('올바른 이메일 형식이 아닙니다.');
		       return;
		   }
		   
		if (!mailspanText.includes('사용가능')) {
			alert('먼저 이메일 중복검사를 통과해야 합니다.');
			return;
		}
		
		// 인증번호 입력칸, 인증완료 버튼 보이기
		   $('#otp').show();
		   $('#otpcheck').show();
		   $('#otpContainer').show();
		   
		   const contextPath = '/' + location.pathname.split('/')[1];
		   $.ajax({
		     url: contextPath + '/emailAuth',
		     method: 'POST',
		     data: {
		       action: 'sendCode',
		       userEmail: email
		     },
		     dataType: 'json',
		     success: data => {
		       $('#mailspan').text(data.msg).css('color', data.success ? 'green' : 'red');
		     },
		     error: () => {
		       alert('이메일 인증 요청 중 오류가 발생했습니다.');
		     }
		   });
		 });
		 
		 $('#otp').hide();
		  $('#otpcheck').hide();

		  
		  // 인증번호 검증
		  $('#otpcheck').on('click', () => {
		    const code = $('#otp').val().trim();
		    if (!code) {
		      alert('인증번호를 입력하세요.');
		      return;
		    }


		const contextPath = '/' + location.pathname.split('/')[1];
			
		$.ajax({
		      url: contextPath + '/emailAuth',
		      method: 'POST',
		      data: {
		        action: 'verifyCode',
		        authCode: code
		      },
		      dataType: 'json',
		      success: data => {
		        $('#otpspan').text(data.msg).css('color', data.success ? 'green' : 'red');
		        if (data.success) {
					
		          // 인증완료되면 이메일 인증 버튼 글씨 빨간색으로 변경
		          $('#emailcheck').css('color', 'red');
		        }
		      },
		      error: () => {
		        alert('인증번호 확인 중 오류가 발생했습니다.');
		      }
		    });
		  });


	// 비밀번호 passcheck
	// click가 아니라 blur 또는 input 이벤트에 사용
	// blur : 다른 곳으로 포커스가 바뀔 때 자동으로 체크하게 하기 위함
	// input : 입력하는 도중이 실시간으로 체크할 수 있음
	// 에를들어 나중에 비밀번호 8자 이상 입력해야하는 조건을 넣고 싶을땐 
	// input으로 실시간으로 8자 이상 되는지 확인하는 용도로도 사용할 수 있음. 
	$('#passcheck').on('input', () => {
		const pass = $('#pass').val().trim();
		const passcheck = $('#passcheck').val().trim();
			if (pass !== passcheck){
				$('#passspan').text('비밀번호가 일치하지 않습니다.').css('color','red')
			}else{
				$('#passspan').text('비밀번호가 일치합니다.').css('color','green')
			}
		});

		// 닉네임 체크
		$('#nickcheck').on('click', () => {
			const nickname = $('#nickname').val().trim();
			if (!nickname) {
				alert('닉네임을 입력하세요.');
				return;
			}
			fetch(`/BookDam/NickCheck.do?mem_nickname=${encodeURIComponent(nickname)}`)
				.then(res => res.json())
				.then(result => {
					console.log('닉네임 중복 검사 결과:',result);
					$('#nickspan')
						.text(result.flag)
						.css('color', result.flag.includes('사용가능') ? 'green' : 'red');
						if(result.flag.includes('사용가능')){
						          // 닉네임 인증 완료 시 버튼 글씨 빨간색으로
						          $('#nickcheck').css('color', 'red');
						        }
						      })
				.catch(e => {
					console.error(e);
					alert('닉네임 중복 검사 중 오류가 발생했습니다.');
				});
		});	
		
		// 6. 우편번호 검색 (카카오 주소 API 사용)
		   $('#zipbtn').on('click', () => {
		       new daum.Postcode({
		           oncomplete: function(data) {
		               $('#zip').val(data.zonecode);          // 우편번호
		               $('#add1').val(data.roadAddress);      // 기본주소
		               $('#add2').focus();                    // 상세주소로 포커스 이동
		           }
		       }).open();
		   });
		   
		   $('#join').on('click', () => {
		       const pass = $('#pass').val();
		       const passcheck = $('#passcheck').val();

		       if (pass !== passcheck) {
		           alert('비밀번호가 일치하지 않습니다.');
		           return;
		       }
			   
			   let birth = $('#bir').val();
			     if (birth) {
			         birth = birth.replace(/-/g, ''); // 하이픈 제거
			         $('#bir').val(birth); // 다시 input에 설정 (formData에 반영되도록)
			     }

		       const form = $('#ff')[0];
		       const formData = new FormData(form);
		       const params = new URLSearchParams(formData);

		       fetch(`/BookDam/InsertCust.do`, {
		           method: 'POST',
		           headers: {
		               'Content-Type': 'application/x-www-form-urlencoded'
		           },
		           body: params.toString()
		       })
		       .then(res => {		    
		           console.log('응답 상태:', res.status);
		           return res.text();  // 일단 text로 받기
		       })
		       .then(text => {
		           console.log('응답 내용:', text);
		           return JSON.parse(text);  // JSON 변환 시도
		       })
		       .then(data => {
		           console.log(data.flag);
		           if (!data.flag.includes('성공')) {
		               $('#joinspan').text(data.flag).css('color', 'red');
		               return Promise.reject('고객 등록 실패');
		           } else {
		               alert('회원가입을 축하드립니다!\n마일리지 +1000이 지급되었습니다.');
		               location.href = '../log/login.jsp'; // 로그인 페이지 경로
		           }
		       })
		       .catch(err => {
		           console.error('에러 발생:', err);
		       });
		   });
	 });			
				
				   