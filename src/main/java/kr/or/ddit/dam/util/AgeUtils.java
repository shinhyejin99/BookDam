package kr.or.ddit.dam.util;

import java.time.LocalDate;

public class AgeUtils {

	/**
	 * 생년월일 문자열로 연령대를 계산해주는 메서드
	 * @param birthDateStr - "19901215" 형식
	 * @return 연령대 문자열, ex) "20대", "30대"
	 */
	public static String getAgeGroup(String birthDateStr) {
		
		//현재 년도 구하기
		int currentYear = LocalDate.now().getYear();
		
		//출생년도 추출
		int birthYear = Integer.parseInt(birthDateStr.substring(0,4));
		
		//나이 계산
		int age = currentYear - birthYear + 1;
		
		//연령대 계산
		int ageGroup = (age / 10) * 10;
		
		return ageGroup + "대";
		
	}
	public static void main(String[] args) {
		System.out.println(getAgeGroup("19901215")); //30대
		System.out.println(getAgeGroup("20051231")); //20대
	}
	
}
