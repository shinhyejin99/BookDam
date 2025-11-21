<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="http://demofran.com/admin/css/admin.css?ver=20250702094455">
<link rel="shortcut icon" href="http://demofran.com/data/banner/NH1d4b424pD9mLSHg13Z3mc3BS2NMw.ico" type="image/x-icon">

<script>
// 자바스크립트에서 사용하는 전역변수 선언
var tb_url		 = "http://demofran.com";
var tb_bbs_url	 = "http://demofran.com/bbs";
var tb_shop_url  = "http://demofran.com/shop";
var tb_admin_url = "http://demofran.com/admin";
</script>
<script src="http://demofran.com/js/jquery-1.8.3.min.js"></script>
<script src="http://demofran.com/js/jquery-ui-1.10.3.custom.js"></script>
<script src="http://demofran.com/js/common.js?ver=20250702094455"></script>
<script src="http://demofran.com/js/categorylist.js?ver=20250702094455"></script>

</head>
<body>
<header id="hd">
	<div id="hd_wrap">
		<h1>행복을 주는 쇼핑몰!</h1>
		<div id="logo"><a href="http://demofran.com/admin/"><img src="http://demofran.com/admin/img/logo.gif" alt="행복을 주는 쇼핑몰! 관리자"></a></div>
		<div id="tnb">
			<ul>
				<li>분양몰 v2.4.2</li>
				<li>오늘:206, 어제:262, 최대:650, 전체:35369</li>
				<!--li><a href="http://demofran.com/manual/member.php?code=list" target="_blank">관리자메뉴얼</a></li-->
				<li><a href="http://demofran.com/admin/config.php?code=super">관리자정보</a></li>
				<li><a href="http://demofran.com/admin/">관리자홈</a></li>
				<li><a href="http://demofran.com" target="_blank">쇼핑몰</a></li>
				<li id="tnb_logout"><a href="http://demofran.com/bbs/logout.php">로그아웃</a></li>
			</ul>
		</div>

		<nav id="gnb">
			<h2>관리자 주메뉴</h2>
			<ul id="gnb_1dul">
				<li class="gnb_1dli">
					<a href="http://demofran.com/admin/member.php?code=list" class="gnb_1da">회원관리</a>
				</li>
				<li class="gnb_1dli">
					<a href="http://demofran.com/admin/partner.php?code=plist" class="gnb_1da">가맹점관리</a>
				</li>
				<li class="gnb_1dli">
					<a href="http://demofran.com/admin/seller.php?code=list" class="gnb_1da">공급사관리</a>
				</li>
				<li class="gnb_1dli">
					<a href="http://demofran.com/admin/category.php?code=list" class="gnb_1da">카테고리 관리</a>
				</li>
				<li class="gnb_1dli">
					<a href="http://demofran.com/admin/goods.php?code=list" class="gnb_1da">상품관리</a>
				</li>
				<li class="gnb_1dli">
					<a href="http://demofran.com/admin/order.php?code=list" class="gnb_1da">주문관리</a>
				</li>
				<li class="gnb_1dli">
					<a href="http://demofran.com/admin/visit.php?code=hour" class="gnb_1da">통계분석</a>
				</li>
				<li class="gnb_1dli">
					<a href="http://demofran.com/admin/help.php?code=qa" class="gnb_1da">고객지원</a>
				</li>
				<li class="gnb_1dli">
					<a href="http://demofran.com/admin/design.php?code=banner_list" class="gnb_1da">디자인관리</a>
				</li>
				<li class="gnb_1dli">
					<a href="http://demofran.com/admin/config.php?code=default" class="gnb_1da">환경설정</a>
				</li>
			</ul>
		</nav>
	</div>
</header>
<div id="wrapper">
	
<div id="main_wrap">
	<section>
		<h2>전체 주문통계<a href="http://demofran.com/admin/order.php?code=list" class="btn_small">주문내역 바로가기</a></h2>
		<div class="order_vbx">
			<dl class="od_bx1">
				<dt>전체 주문현황</dt>
				<dd>
					<p class="ddtit">총 주문건수</p>
					<p>6</p>
				</dd>
				<dd class="total">
					<p class="ddtit">총 주문액</p>
					<p>1,533,200</p>
				</dd>
			</dl>

			<dl class="od_bx2">
				<dt>주문상태 현황</dt>
				<dd>
					<p class="ddtit">입금대기</p>
					<p>0</p>
				</dd>
				<dd>
					<p class="ddtit">입금완료</p>
					<p>0</p>
				</dd>
				<dd>
					<p class="ddtit">배송준비</p>
					<p>0</p>
				</dd>
				<dd>
					<p class="ddtit">배송중</p>
					<p>0</p>
				</dd>
				<dd>
					<p class="ddtit">배송완료</p>
					<p>1</p>
				</dd>
			</dl>
			<dl class="od_bx2">
				<dt>구매확정/클래임 현황</dt>
				<dd>
					<p class="ddtit">구매미확정</p>
					<p>0</p>
				</dd>
				<dd>
					<p class="ddtit">취소</p>
					<p>5</p>
				</dd>
				<dd>
					<p class="ddtit">환불</p>
					<p>0</p>
				</dd>
				<dd>
					<p class="ddtit">반품</p>
					<p>0</p>
				</dd>
				<dd>
					<p class="ddtit">교환</p>
					<p>0</p>
				</dd>
			</dl>
		</div>
	</section>

	<section class="sidx_head01">
		<h2>최근 주문내역<a href="http://demofran.com/admin/order.php?code=list" class="btn_small">주문내역 바로가기</a></h2>
		<table>
		<thead>
		<tr>
			<th scope="col">주문번호</th>
			<th scope="col">주문자명</th>
			<th scope="col">수령자명</th>
			<th scope="col">전화번호</th>
			<th scope="col">결제방법</th>
			<th scope="col">총주문액</th>
			<th scope="col">주문일시</th>
		</tr>
		</thead>
		<tbody>
				<tr class="tr_alignc">
			<td>25032009552090</td>
			<td>한글만</td>
			<td>한글만</td>
			<td>010-1111-1111</td>
			<td>무통장</td>
			<td>89,000</td>
			<td>2025-03-20 09:55 (목)</td>
		</tr>
				<tr class="tr_alignc">
			<td>25032009244976</td>
			<td>두글만</td>
			<td>두글만</td>
			<td>010-2222-2222</td>
			<td>무통장</td>
			<td>35,000</td>
			<td>2025-03-20 09:25 (목)</td>
		</tr>
				<tr class="tr_alignc">
			<td>25031113403850</td>
			<td>가맹점몰</td>
			<td>가맹점몰</td>
			<td>010-3026-3093</td>
			<td>무통장</td>
			<td>615,600</td>
			<td>2025-03-11 13:40 (화)</td>
		</tr>
				<tr class="tr_alignc">
			<td>25010716241290</td>
			<td>관리자</td>
			<td>관리자</td>
			<td>010-0000-0000</td>
			<td>무통장</td>
			<td>89,000</td>
			<td>2025-01-07 16:25 (화)</td>
		</tr>
				<tr class="tr_alignc">
			<td>24122316544816</td>
			<td>관리자</td>
			<td>관리자</td>
			<td>010-0000-0000</td>
			<td>무통장</td>
			<td>89,000</td>
			<td>2024-12-23 16:57 (월)</td>
		</tr>
				</tbody>
		</table>
	</section>

	<section class="sidx_head01">
		<h2>최근 회원가입<a href="http://demofran.com/admin/member.php?code=list" class="btn_small">회원관리 바로가기</a></h2>
		<table>
		<thead>
		<tr>
			<th scope="col">이름</th>
			<th scope="col">아이디</th>
			<th scope="col">레벨</th>
			<th scope="col">이메일</th>
			<th scope="col">접속횟수</th>
			<th scope="col">추천인</th>
			<th scope="col">가입일시</th>
		</tr>
		</thead>
		<tbody>
				<tr class="tr_alignc">
			<td>가맹점몰</td>
			<td>submall</td>
			<td>가맹점</td>
			<td>spmallnara@naver.com</td>
			<td>16</td>
			<td>admin</td>
			<td>2024-12-16 06:14 (월)</td>
		</tr>
				<tr class="tr_alignc">
			<td>세글만</td>
			<td>test3</td>
			<td>일반회원</td>
			<td>test3@gmail.com</td>
			<td>71</td>
			<td>test1</td>
			<td>2020-10-04 18:05 (일)</td>
		</tr>
				<tr class="tr_alignc">
			<td>두글만</td>
			<td>test2</td>
			<td>일반회원</td>
			<td>test2@gmail.com</td>
			<td>804</td>
			<td>admin</td>
			<td>2020-10-04 18:05 (일)</td>
		</tr>
				<tr class="tr_alignc">
			<td>한글만</td>
			<td>test1</td>
			<td>가맹점</td>
			<td>test1@gmail.com</td>
			<td>938</td>
			<td>admin</td>
			<td>2020-10-04 18:04 (일)</td>
		</tr>
				</tbody>
		</table>
	</section>
</div>

</div>
<div id="ft">
	<p>Copyright &copy; 행복을 주는 쇼핑몰!. All rights reserved.</p>
</div>


<div id="ajax-loading"><img src="http://demofran.com/img/ajax-loader.gif"></div>
<div id="anc_header"><a href="#anc_hd"><span></span>TOP</a></div>

<script src="http://demofran.com/admin/js/admin.js?ver=20250702094455"></script>

<script src="http://demofran.com/js/wrest.js"></script>
</body>
</html>