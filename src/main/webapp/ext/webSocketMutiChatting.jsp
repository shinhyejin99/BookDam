<!-- chatWindow.jsp -->
<%@page import="kr.or.ddit.dam.vo.MemVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.google.gson.Gson" %>
<!DOCTYPE html>
<html>
<head>
  <title>BookDam - 채팅</title>
  
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/webSocketMutiChatting.css">
  
</head>
<body>

	<!-- <div id="connectionEnd">❌</div> -->

  <div id="container">
  
	  	<!-- 접속자 목록 영역 추가함 -->
	  	<div id="userListArea">
	  		<div class="userlist-header">
	  			<h3>👥 접속자 목록</h3>
	  			<div class="user-count" id="userCount">0명 접속중</div>
	  		</div>
	  		<div id="userList">
	  			<!-- 접속자 목록이 여기에 추가됨 -->
	  		</div>
	  	</div>
	  	
	  	<!-- 채팅 영역임 -->
	    <div id="chatArea">
	    	<!-- 추가함 -->
			<div class="chat-header">
				<h2>👨‍🏫 송찬중 작가님과 함께하는 북Talk 📚</h2>
			</div>
     		<div id="messageTextArea">
     			<div id="messageContainer">
     			<!-- 메시지들이 여기에 추가됨 -->
     			</div>
     		</div>
	     		
	     	<!-- 추가 및 수정함 -->
			<div class="chat-input">
		       <textarea id="messageText" rows="2" cols="35"></textarea>
		       <input type="button" value="Send" id="btnSend"> 
		       <!-- <input type="button" value="접속종료" id="btnClose"> -->
			</div>      
	    </div>
  </div>

  <script>
  <%
	// 세션에서 loginOk 값을 가져와 로그인 여부 확인
	MemVO mvo = (MemVO) session.getAttribute("loginOk");
	
	String user = null;
	Gson gson = new Gson();
	// 만약 loginOk 값이 있다면 mvo 객체를 user에 대입
	if (mvo != null) user = gson.toJson(mvo);
	%>

  // 로그인 유저 객체
  logUser = <%= user == null ? "null" : user %>;

    if (!logUser || logUser === null) {
        alert("로그인이 필요합니다.");
        window.close();
    }

    let userNickname = logUser.mem_nickname; // 채팅방에서 사용할 닉네임 - 회원정보에서 가져옴
    let webSocket = null;
    let messageTextArea = null;
    let messageText = null;
    let ptag = null;
    let messageContainer = null; // 수정: messageContainer 변수 추가 - 메세지 추가
    
    //+ 추가했습니다~
    let userList = null; // 왼쪽 패널에 추가할 접속자들 목록
    let userCount = null; // 접속자 인원
    let connectedUsers = new Set(); // Set? -> 순서가 없는, 중복되지 않는 데이터의 집합!

    window.onload = () => {
        messageTextArea = document.getElementById("messageTextArea");
        messageText = document.getElementById("messageText");
        messageContainer = document.getElementById("messageContainer"); // 수정: messageContainer 초기화 추가 + 메세지가 추가될 공간
      
        // + 왼쪽 패널 영역 
        userList = document.getElementById("userList");
        userCount = document.getElementById("userCount");
        console.log("userCount 요소:", userCount); // null이면 문제!
      
        user = logUser.mem_nickname;
        connectWebSocket(); // 웹 소켓 연결
        addEventListeners(); // 버튼 클릭 이벤트들
    };

    function connectWebSocket() {
    	
        const nickName = logUser.mem_nickname;
        webSocket = new WebSocket(`ws://192.168.146.75:8080/BookDam/websocktMultichatExt.do`);

        webSocket.onopen = () => {
	        messageContainer.innerHTML = "";
	        // 접속자 목록 초기화
	        clearUserList();
	        document.getElementById("chatArea").style.display = "block";
	        webSocket.send(nickName);
        };

        // 입장 메세지 출력 부분
        webSocket.onmessage = (message) => {
          const jsonData = JSON.parse(message.data);    // System : 가나디님 입장!!
          const idx = jsonData.message.indexOf(" : ");
          const me = jsonData.message.substring(0, idx); // System
          const msgContent = jsonData.message.substring(idx + 3); // 가나디님 입장!!

          if (me === "System") {
       		  // + 왼쪽 접속자 패널 처리
       		  // 시스템 메시지 처리 및 접속자 목록 업데이트
        	  handleSystemMessage(jsonData.message);
        	
          	  // 시스템 메세지 css
		      const systemSpan = document.createElement("span");
		      systemSpan.style.display = "inline-block";
		      systemSpan.style.background = "rgba(0, 123, 255, 0.1)"; // 연한 파란색 투명배경
		      systemSpan.style.color = "#007AFF"; // 파란색 글씨
		      systemSpan.style.padding = "8px 16px";
		      systemSpan.style.borderRadius = "20px";
		      systemSpan.style.fontSize = "13px";
		      systemSpan.style.fontWeight = "500";
		      systemSpan.style.margin = "8px 0";
		      //systemSpan.innerHTML = jsonData.message;
		      systemSpan.innerHTML = msgContent; // 원래는> System : 가나디님 입장!!, 수정> 가나디님 입장!!

		      // 가운데 정렬을 위한 컨테이너
		      const centerDiv = document.createElement("div");
		      centerDiv.style.textAlign = "center";
		      centerDiv.appendChild(systemSpan);

		      messageContainer.appendChild(centerDiv);
		      messageTextArea.scrollTop = messageTextArea.scrollHeight;
          	
          	  return;
          }

          // 대화메세지 css 만들기-------------------------
          ptag = document.createElement("p");
          ptag.style.height = "auto";

          const spantag = document.createElement("span");
          spantag.style.display = "inline-block";
          spantag.style.height = "100%";
          spantag.style.padding = "12px 16px";
          spantag.style.borderRadius = "18px";
          spantag.style.maxWidth = "70%";
          spantag.style.wordWrap = "break-word";
          spantag.style.position = "relative";
          spantag.style.boxShadow = "0 2px 4px rgba(0,0,0,0.15)";
          spantag.innerHTML = msgContent.replaceAll("\n", "<br>");

          // 말풍선 - 수정하기
          // 나!
          if (me === userNickname) {
	          ptag.style.textAlign = "right";
	          ptag.style.color = "white";
	          spantag.style.background = "#54d35d";
	          spantag.style.marginLeft = "auto";
	          spantag.style.marginTop = "5px";

	       	  // 오른쪽 꼬리(삼각형 만들기)
	          spantag.style.borderBottomRightRadius = "4px";
          
	      // 다른 사람들!
          } else {
	          ptag.style.textAlign = "left";
	          
	       	  // 닉네임 표시 추가
	          const nicknameSpan = document.createElement("span");
	          nicknameSpan.innerHTML = me; // 상대방 닉네임
	          nicknameSpan.style.display = "block";
	          nicknameSpan.style.fontSize = "12px";
	          nicknameSpan.style.color = "#666";
	          nicknameSpan.style.marginTop = "10px";
	          nicknameSpan.style.marginBottom = "4px";
	          nicknameSpan.style.marginLeft = "8px";
	          nicknameSpan.style.fontWeight = "500";
	          
	          // 닉네임을 ptag에 먼저 추가
	          ptag.appendChild(nicknameSpan);
	            
	          spantag.style.background = "#eaeaea";
	          spantag.style.color = "#333";
	          spantag.style.marginRight = "auto";
	       	  // 왼쪽 꼬리
	          spantag.style.borderBottomLeftRadius = "4px";
          }

          ptag.appendChild(spantag);
          messageContainer.appendChild(ptag); // 메세지 추가되면서 올라갑니다
        
     	  // 수정 - 메세지 추가 후 스크롤을 맨 아래로
          messageTextArea.scrollTop = messageTextArea.scrollHeight;
          
      }; // webSocket.onmessage 끝

      webSocket.onerror = (event) => {
        alert("오류 : " + event.data);
      };

      webSocket.onclose = () => {
        messageContainer.innerHTML = "";
        messageText.value = "";
        // + 접속자 목록 초기화
        clearUserList();
        document.getElementById("chatArea").style.display = "none";
      };
    }
    
    // + 시스템 메시지 처리 함수 = 메세지에서 닉네임만 뽑아내서 왼쪽 패널 영역에 추가하기 위한 함수입니다!!
    function handleSystemMessage(message) {
    	console.log("시스템 메시지 처리: ", message);
    	
    	// 연결 성공 시 메세지에서 닉네임 뽑기 (나에게만 보이는)
    	if(message.includes("님 연결 성공!!")) {
    		const nickname = message.split(" : ")[1].replace("님 연결 성공!!", ""); // 이거 메세지는 WebSocketMutiChat 문구랑 같아야 함! 밑에도 마찬가지
    		console.log("연결 성공:", nickname);
    		addUser(nickname);
    	} 
    	// 입장 메세지 처리 (다른 사람들에게 보이는)
    	else if(message.includes("님 입장!!")) {
    		const nickname = message.split(" : ")[1].replace("님 입장!!", "");
    		console.log("입장:", nickname);
    		addUser(nickname);
    	}
    	// 퇴장 메세지 처리
    	else if(message.includes("님이 퇴장했습니다.")){
    		const nickname = message.split(" : ")[1].replace("님이 퇴장했습니다.", "");
    		removeUser(nickname);
    		console.log("사용자 제거됨:", nickname);
    	}
    }
    
    // 접속자 패널에 추가하는 함수
    function addUser(nickname) {
    	console.log("addUser 호출됨:", nickname);
    	if(!connectedUsers.has(nickname)) {
    		connectedUsers.add(nickname);
    		updateUserList();
    		console.log("사용자 추가 완료:", nickname);
    	} else {
    		console.log("이미 존재하는 사용자:", nickname);
    	}
    }
    
    // 접속자 패널에서 제거하는 함수
    function removeUser(nickname) {
    	if(connectedUsers.has(nickname)) {
            connectedUsers.delete(nickname);
            updateUserList();
            console.log("사용자 제거됨:", nickname);
        }
    }
   
 	// 접속자 목록 업데이트 함수
    function updateUserList() {
    	console.log("updateUserList 호출. 현재 사용자 수:", connectedUsers.size);
    	
    	// userList가 제대로 있는지 확인
        if (!userList) {
            console.error("userList 찾을 수 없음!");
            return;
        }
        
        // userCount가 제대로 있는지 확인
        if (!userCount) {
            console.error("userCount 요소를 찾을 수 없음!");
            return;
        }
    	
    	userList.innerHTML = "";
      
    	// 유저 리스트 반복문으로 하나씩 꺼내서 패널에 추가하기!!
      	connectedUsers.forEach(nickname => {
	        const userItem = document.createElement("div");
	        userItem.className = "user-item";
	        
	        const htmlContent = `
	          <span class="user-icon"></span>
	          <span class="user-name">\${nickname}</span>
	        `;
	        // ㅋㅋ... \ 잊지 말자^^...
	
	        userItem.innerHTML = htmlContent;

	        // 접속사 리스트에 자식으로 추가한다 (접속자들 이름을)
	        userList.appendChild(userItem);
	        console.log("접속자 추가 확인 : ", nickname);
      });
      
      // 접속자 수 업데이트
      const userCountText = connectedUsers.size + "명 접속중";

      userCount.textContent = userCountText;
    }

    // 접속자 목록 초기화 함수
    function clearUserList() {
        connectedUsers.clear();
        userList.innerHTML = "";
        userCount.textContent = "0명 접속중";
    }

    // 엔터키, 전송하기 버튼, 접속종료 버튼 이벤트 모음집
    function addEventListeners() {
        document.getElementById("btnSend").addEventListener("click", sendMessage, false);
        //document.getElementById("btnClose").addEventListener("click", closing, false);
    
     	// 엔터키 전송 - 추가함!
        document.getElementById("messageText").addEventListener("keydown", function(event) {
            // 엔터키 눌렀을 때 (keyCode 13 또는 key === "Enter")
            if (event.key === "Enter") {
                if (event.shiftKey) {
                    return; // 줄바꿈 - Shift + Enter
                }
                // 그냥 Enter: 메시지 전송
                else {
                    event.preventDefault(); // 기본 동작(줄바꿈) 방지
                    sendMessage(); // 메시지 전송
                }
            }
        });	
    }

    // 메세지 보내기
    function sendMessage() {
        if (messageText.value.trim() === "") {
          messageText.focus();
          return;
        }
        webSocket.send(messageText.value.trim());
        messageText.value = "";
    }

    function closing() {
      if (webSocket) {
        webSocket.close();
        window.close();
      }
    }

    window.onbeforeunload = () => {
      closing();
    };
  </script>
</body>
</html>
