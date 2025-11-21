package kr.or.ddit.dam.util;

public class StringUtils {
	public static boolean isNotBlank(String text) {
		return text!=null && text.trim().length()>0;
	}
}
