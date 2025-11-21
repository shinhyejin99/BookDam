package kr.or.ddit.dam.util;

import java.io.BufferedReader;

import jakarta.servlet.http.HttpServletRequest;

public class StreamData {

	
	public static String getChange(HttpServletRequest request) {

		StringBuffer strbuf = new StringBuffer();
		
		try {

			// getParameter로 못받아서 bufferedReader
			BufferedReader buf = request.getReader();
			

			// 직렬화된 데이터 읽기 - 전송 데이터인 {id : vid, name : vname, mail : vmail} 를 읽는다.
			String line = null;
			while (true) {
				line = buf.readLine();
				if (line == null)
					break;

				strbuf.append(line);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		String req = strbuf.toString();
		
		return req;
	}

}
