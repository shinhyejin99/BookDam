package kr.or.ddit.dam.vo;

public class AttendanceVO {

	private String attendance_date; // 출석일(date)
	private String mem_mail; // 회원 이메일(id)
	private int attendance_mileage_amt; // 출석 마일리지
	
	public AttendanceVO() {
		// TODO Auto-generated constructor stub
	}

	public String getAttendance_date() {
		return attendance_date;
	}

	public void setAttendance_date(String attendance_date) {
		this.attendance_date = attendance_date;
	}

	public String getMem_mail() {
		return mem_mail;
	}

	public void setMem_mail(String mem_mail) {
		this.mem_mail = mem_mail;
	}

	public int getAttendance_mileage_amt() {
		return attendance_mileage_amt;
	}

	public void setAttendance_mileage_amt(int attendance_mileage_amt) {
		this.attendance_mileage_amt = attendance_mileage_amt;
	}
}
