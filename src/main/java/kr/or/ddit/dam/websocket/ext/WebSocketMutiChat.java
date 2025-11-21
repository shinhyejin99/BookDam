package kr.or.ddit.dam.websocket.ext;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import kr.or.ddit.dam.websocket.vo.DditChatVO;

/*
// 컬렉션 동기화 메소드
1) public static <T> Set<T> synchronizedSet(Set<T> s)
2) public static <T> List synchronizedList(List<T> list)
3) public static <K, V> Map<K, V> synchronizedMap(Map<K, V> m)
4) public static <T> Collection<T> synchronizedCollection(Collection<T> c)
 */

@ServerEndpoint("/websocktMultichatExt.do")
public class WebSocketMutiChat {
	
     //2개 이상의 쓰레드가 컬렉션에 동시에 접근한다는 가정이 필요할 땐 동기화를 해주어야 한다.
	//일반적인 대부분의 컬렉션들(ArrayList, HashMap 등)은 동기화가 되어있지 않다.
   	//synchronizedList :  동기화가 되어 있지 않은 컬렉션을 인자로 주면 동기화 기능이 추가된 컬렉션으로 반환한다.
	//유저 집합 리스트
	static List<DditChatVO> sessionUsers = Collections.synchronizedList(new ArrayList<DditChatVO>());
	
	/**
	  * 웹소켓에는 Session객체가 있습니다
	 * Session의 객체는 브라우저로 부터 Socket 접속을 하면 생성이 되고
     * 소켓 세션은 브라우저가 Websocket을 접속했을 때의 커넥션 정보가 있는 것입니다
	 * 웹 소켓이 접속되면 유저리스트에 세션을 넣는다.
	 * session 객체는 endpoint의 annotated lifecycle methods의 파라미터로 사용 가능
	 * @OnOpen , @OnMessage에서  사용
	 * @param userSession 웹 소켓 세션
	 */
	@OnOpen
	public void handleOpen(Session userSession){
		 // 클라이언트가 접속하면 WebSocket세션을 리스트에 저장한다.
		DditChatVO chatVo = new DditChatVO(null, userSession);
		sessionUsers.add(chatVo);
		
		System.out.println(userSession.getId() + "접속\n");
	}
	
	
	/**
	 * 웹 소켓으로부터 메시지가 오면 호출한다.
	 * @param message 메시지
	 * @param userSession
	 * @throws IOException
	 */
	
	//Session.getBagicRemote는 blocking method,
 //Session.getAsyncRemote 는 nonblocking method로 RemoteEndpoint를 리턴
	@OnMessage
	public void handleMessage(String message, Session userSession) throws IOException{
		
		System.out.println("handleMessage  message==" + message );
		
		
		//최초 실행시에는   username 값이 없음
		//Session.getUserProperties 메소드는 유저 특성을 저장할 수 있는 map을 제공한다.
		//최초실행시에는 map에 저장한 적이 없기 때문에 get을 이용하여 꺼내도 값이 없음.
		String username = (String)userSession.getUserProperties().get("username");
		System.out.println("handleMessage  username==" + username );
		
		
		// 세션 프로퍼티에 username이 없으면 username을 선언하고 해당 세션으로 메시지를 보낸다.(json 형식이다.)
		// 최초 접속시  메시지는 username설정- 
		if(username == null){ //처음 접속하기 실행
			
			for(DditChatVO chatVo : sessionUsers){
				
				//첫번쩨 111 접속은 for- 1회수행. if true
				//두번째 222 접속은 for- 2회수행. if-false/true
				//세번째 333 접속은 for- 3회 수행. if-false/false/true
				if(userSession.equals(chatVo.getSession())){
					
					//최초 실행시 메세지는 username 이다  
					chatVo.setName(message);
					System.out.println("message=>" + message );
					
					//Session.getUserProperties 메소드는 유저 특성을 저장할 수 있는 map을 제공한다.
					//처음 접속시 username을 설정 -두번째 메세지 부터 else에서 일반 대화저리
					userSession.getUserProperties().put("username", message);
					
					// 로그인한 본인에게 보내는 메시지
					//Session.getBagicRemote는 blocking method,  RemoteEndpoint를 리턴
					//상대방에게 메세지를 보내기 위해 remoteEndpoint 사용
					//---buildJsonData에서 클라이언트로 보낼 json형식의 데이타로 직렬화 ------
					//buildJsonData(String username, String message)
					//buildJsonData("System", message + "님 연결 성공!!");
					userSession.getBasicRemote().sendText(buildJsonData("System", message + "님 연결 성공!!"));
					
					// 현재 본인한테 미리 본인보다 먼저 입장한 사람의 정보 =============
					//없으면 내창에는 나만 찍힘.
					for(DditChatVO chVo : sessionUsers) {
						//---buildJsonData에서 클라이언트로 보낼 json형식의 데이타로 직렬화 ------
						//buildJsonData(String username, String message)
						//buildJsonData("System",  111 + "님 입장!!")
						userSession.getBasicRemote().sendText(buildJsonData("System", chVo.getName() + "님 입장!!"));
					}
					
					for(DditChatVO chVo : sessionUsers) {
						// 본인 이외의 다른 모든 사람에게 나의 입장 메시지 보내기-
						//---buildJsonData에서 클라이언트로 보낼 json형식의 데이타로 직렬화 ------
						//buildJsonData(String username, String message)
						//buildJsonData("System",  222 + "님 입장!!")
						
					    if(!chVo.getSession().equals(chatVo.getSession())){
					         chVo.getSession().getBasicRemote().sendText(buildJsonData("System",message +
				             	"님 입장!!"));
					     } 
					 }
					
					 return;
				  }
			}
		}//if -username == null
		
		//처음 접속시username == null 일때 이미 연결 또는 입장 메세지  전송이 되었기때문에 
		//여기는 일반 대화 메세지가 전송되는 부분-else가 없어도 됨
		//username : 접속 id,  message:대화내용
		//-----------------------------------------
		//그럼 여기에서 db 저장- 종료 했다가 다시 들어왔을때
		//이전 대화내용을 다시 나타나게 하고 싶다
		//그랗다면 db저장항목은 ?? - username, message, 
		//나중에 chat클라이안트 창에 출력은 메세지 발생 순서대로 여야 하는데
		//그렇담?????
		 sendToAll(username, message); 
	}
	
	
	public void sendToAll(String username, String message) throws IOException{
		System.out.println("보냄..." );
		System.out.println("보냄.username ==" + username );
		System.out.println("보냄.username ==" + message );
		// 전체에게 메시지를 보낸다.
		for(DditChatVO chatVo : sessionUsers){
			//buildJsonData에서 클라이언트로 보낼 json 형식의  직렬화데이타 생성-----
			chatVo.getSession().getBasicRemote().sendText(buildJsonData(username,message));
		}
	}
	
	
	/**
	 * 웹소켓을 닫으면 해당 유저를 유저리스트에서 뺀다.
	 * @param userSession
	 
	 * @throws IOException */
	
	@OnClose
	public void handleClose(Session userSession) throws IOException{
		System.out.println(userSession.getId() + "접속 종료...");
		String delName = null;
		Iterator<DditChatVO> chatIter = sessionUsers.iterator();
		while(chatIter.hasNext()){
			DditChatVO chatVo = chatIter.next();
			if(userSession.equals(chatVo.getSession())){
				delName = chatVo.getName();
				//sessionUsers.remove(chatVo);
				chatIter.remove();
			}
		}
			
		sendToAll("System", delName + "님이 퇴장했습니다.");

	}
	
	/**
     * 웹 소켓이 에러가 나면 호출되는 이벤트
     * @param t
     */
    @OnError
    public void handleError(Throwable t){
        t.printStackTrace();
    }
    
	
	/**
	 * json타입의 메시지 만들기
	 * @param username
	 * @param message
	 * @return
	 */
	public String buildJsonData(String username,String message){
		Gson gson = new Gson();
		Map<String, String> jsonMap = new HashMap<String, String>();
		jsonMap.put("message", username+" : "+message);
		String strJson = gson.toJson(jsonMap);
		
		System.out.println("strJson = " + strJson);

		return strJson;
	}
}