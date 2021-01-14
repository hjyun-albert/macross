<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=no">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<meta property="og:title" content="뉴스타파 20대 국회의원 정치후원금">
<meta property="og:url" content="http://pages.newstapa.org/n2002">
<meta property="og:site_name" content="뉴스타파 20대 국회의원 정치후원금">
<meta property="og:description"
	content="뉴스타파에서 20대 국회의원의 역대 4년간 후원금을 분석했습니다. 국회의원들은 후원금을 얼마나, 누구에게 받았을까요? 궁금한 국회의원을 검색해 내역을 살펴보세요.">
<meta property="og:image"
	content="http://pages.newstapa.org/n2002/static/img/thumb.png">
<link rel="shortcut icon"
	href="http://pages.newstapa.org/n2002/img/favicon.ico">


<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/commonAjax.js"></script>
<script src="https://www.jsviews.com/download/jsrender.js"></script>


<title>뉴스타파 20대 국회의원 정치후원금</title>
<link rel="stylesheet"
	href="http://pages.newstapa.org/n2002/static/multiselect.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">

<!-- Load c3.css -->
<link href="${pageContext.request.contextPath}/resources/css/c3.css" rel="stylesheet">

<!-- Load d3.js and c3.js -->
<script src="${pageContext.request.contextPath}/resources/js/d3-5.8.2.min.js" charset="utf-8"></script>
<script src="${pageContext.request.contextPath}/resources/js/c3.js"></script>


<script type="text/javascript" async=""
	src="https://www.google-analytics.com/analytics.js"></script>
<script async=""
	src="https://www.googletagmanager.com/gtag/js?id=UA-122077396-13"></script>


<script>
	window.dataLayer = window.dataLayer || [];

	function gtag() {
		dataLayer.push(arguments);
	}
	gtag('js', new Date());

	gtag('config', 'UA-122077396-13');
</script>

<link type="text/css" rel="stylesheet"
	href="chrome-extension://eobejphpabbjeehffmbiecckpkggpbai/style.css">
<script type="text/javascript" charset="utf-8"
	src="chrome-extension://eobejphpabbjeehffmbiecckpkggpbai/js/content-script/page_context.js"></script>

</head>


<script>

   //화면 렌더링 후 자동 실행되는 소스
	var global_list = {};

	$(document).ready(function() {
						getRank('2019');
						ajaxCallGet("/api/v1/n2002/select", function(res) {
							global_list.data = res.data;
							initList(global_list);
						})
               
				function initList(res) {
		            var template = $.templates("#members"); // <!-- 템플릿 선언
		            var htmlOutput = template.render(res); // <!-- 렌더링 진행 -->
		               $(".multiselect__element").html(htmlOutput);
	                    }
						
						
						//검색 셀렉트박스 클릭시 옵션값(국회의원 이름 등) 보여진다
						$(".multiselect__tags").click(function() {
							$(".multiselect__content-wrapper").show();
						})

						//셀렉트박스의 옵션값에 마우스오버시 노란색으로 백그라운드변경
						$(document).on(
										"mouseover",
										".multiselect__option",
										function() {
											if ($(this).attr("class").indexOf(
													"active-hover") == -1) {
												$(".multiselect__option")
														.removeClass(
																"multiselect__option--highlight")
												$(this)
														.addClass(
																"multiselect__option--highlight")

												$(".active-hover")
														.css("background",
																"#f3f3f3")
												$(".active-hover").css(
														"font-weight", "700")
												$(".active-hover").css("color",
														"#1f1f1f")

												var text = $(".active-hover")
														.find(
																"span:first-child")
														.text();
												$(".active-hover")
														.html(
																"<span>"
																		+ text
																		+ "</span><span class='afters'>선택됨</span>")

											}
										})

						//셀렉트박스에서 옵션 선택시, 선택된거 재선택시에는 else로 들어가며 선택취소가 되고, 선택안되거를 선택시에는 if로 들어간다.
						$(document)
								.on(
										"click",
										".multiselect__option, .active-hover",
										function() {
											if ($(this).attr("class").indexOf(
													"active-hover") == -1) {
												var seq = $(this).attr(
														"data-seq")
												var text = $(this).find(
														"span:first-child")
														.text();

												var options = $(".multiselect__option");
												options
														.removeClass("active-hover")
												$(".multiselect__option")
														.removeClass(
																"multiselect__option--highlight")
												for (var i = 0; i < options.length; i++) {
													if (options.eq(i).attr(
															"data-seq") == seq) {
														options.eq(i).css(
																"background",
																"#f3f3f3")
														options.eq(i).css(
																"font-weight",
																"700")
														options
																.eq(i)
																.html(
																		"<span>"
																				+ text
																				+ "</span><span class='afters'>선택됨</span>")
														options.eq(i).addClass(
																"active-hover")
													} else {
														options.eq(i).css(
																"background",
																"white")
														options.eq(i).css(
																"font-weight",
																"normal")
														options.eq(i).css(
																"color",
																"#1f1f1f")
														var sub = options
																.eq(i)
																.find(
																		"span:first-child")
																.text()
														options
																.eq(i)
																.html(
																		"<span>"
																				+ sub
																				+ "</span>")
													}
												}
												$(".multiselect__input").attr(
														"placeholder", text);
												$(".multiselect__placeholder")
														.text(text);
												settingInfo(seq)

											} else {

												//액티브 된 row를 선택 취소하기 위해 클릭 버튼누르면
												$(".multiselect__option")
														.removeClass(
																"active-hover");
												var text = $(this).find(
														"span:first-child")
														.text();
												$(this).html(
														"<span>" + text
																+ "</span>")
												$(this).css("background",
														"white")
												$(this).css("font-weight",
														"normal")
												$(this).css("color", "#1f1f1f")

												$(".multiselect__input").attr(
														"placeholder",
														"국회의원 이름을 입력하세요");
												$(".multiselect__placeholder")
														.text("국회의원 이름을 입력하세요");
											}
											$(".multiselect__content-wrapper")
													.hide();
										})

						//상세의 전체후원금 차트, 연간 300만원 이상 탭 클릭시
						$(".slct-li").click(function() {
							$(".slct-li").removeClass("slct-select");
							$(this).addClass("slct-select");
							var tab = $(this).attr("data-tab");
							if (tab == 1) {
								$("#chart").show();
								$("#chart2").hide();
							} else {
								$("#chart2").show();
								$("#chart").hide();
							}
						})

						//상세에서 도넛 차트의 년도 탭 클릭시
						$(".the21st_tab_title li").click(function() {
							var idx = $(this).index();
							$(".the21st_tab_title li").removeClass("on");
							$(".the21st_tab_title li").eq(idx).addClass("on");
							$(".the21st_tab_cont > div").hide();
							$(".the21st_tab_cont > div").eq(idx).show();
						})

						//후원금순위(랭킹)에서 년도 탭 클릭시
						$(".ranking_tab_title li").click(function() {
							$(".ranking_tab_title li").removeClass("on");
							$(this).addClass("on")
							var year = $(this).attr("data-year");
							getRank(year)
						})

						//검색 셀렉트박스에서 마우스 오버 아웃시 셀렉트박스 숨김
						$(document).on("mouseleave",
								".multiselect__content-wrapper", function() {
									$(".multiselect__content-wrapper").hide();
								})

						// 이름 검색해서 나올 수 있게 하는 기능		  
						$(document).on(
										"keyup",
										".input-name",
										function() {
											var keyword = $(this).val();
											var sub_list = {};
											var subs = [];
											for (var i = 0; i < global_list.data.length; i++) {
												var title = global_list.data[i].name
														+ " "
														+ global_list.data[i].team
														+ " "
														+ global_list.data[i].team_info;
												if (title.indexOf(keyword) > -1) {
													subs
															.push(global_list.data[i])
												}
											}
											sub_list.data = subs;
											initList(sub_list);
										})
										//랭킹에서 이름 누를시 상세로 ui 변경
										$(document).on("click", ".rankTable-name", function(){
											var seq = $(this).attr("data-seq");
											settingInfo(seq);
										})

					})

	function comma(str) {
		str = String(str);
		return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}

	//랭킹 데이터 가져오기
	function getRank(yyyy) {
		ajaxCallGet("/api/v1/n2002/rank/" + yyyy, function(res) {
			var template = $.templates("#rank"); // <!-- 템플릿 선언
			var htmlOutput = template.render(res); // <!-- 렌더링 진행 -->
			$(".rank-tbody").html(htmlOutput);
			$(".minititleText").text(yyyy + "년 국회의원 후원금 순위")
		})
	}

	

	//도넛 차트 셋팅
	function chart_300(id, year, list) {
		var datas = [];
		var data_name = [];
		for (var i = 0; i < list.length; i++) {
			var data = [];
			if (list[i].year == year) {
				data.push(list[i].name);
				data.push(list[i].price_);
				datas.push(data);
			}
		}

		var chart = c3.generate({
			bindto : id,
			data : {
				columns : datas,
				type : 'donut',
				onclick : function(d, i) {
					var congress_seq = global_congress_seq;
					var name = d.id;

					var tabs = $(".the21st_tab_title").find("li");
					var year;
					for (var i = 0; i < tabs.length; i++) {
						console.log(tabs.eq(i).attr("class"))
						if (tabs.eq(i).attr("class").indexOf("on") > -1) {
							year = tabs.eq(i).text().replace("년", "");
						}
					}

					var param = {
						"congress_seq" : congress_seq,
						"name" : name,
						"year" : year
					}

					ajaxCallPost("/api/v1/n2002/detail/info", param, function(res) {
						$(".detail-info-name").text(res.data.name)
						$(".detail-info-price").text(res.data.price)
						$(".detail-info-job").text(res.data.job)
						$(".detail-info-addr").text(res.data.addr)

						var template = $.templates("#info"); // <!-- 템플릿 선언
						var htmlOutput = template.render(res); // <!-- 렌더링 진행 -->
						$(".info-tbody").html(htmlOutput);
						
							$(".detail-info").show();
						if(res.list.length){
							$(".detail-infos").show();
						}else{
							$(".detail-infos").hide();
						}
					})
				}
			}
		});
	}

	//상세 데이터 셋팅
	function settingInfo(seq) {
		ajaxCallGet("/api/v1/n2002/" + seq,function(res) {

					global_congress_seq = seq;

					$(".slct-li").removeClass("slct-select");
					$(".slct-li").eq(0).addClass("slct-select");
					$("#chart").show();
					$("#chart2").show();

					$(".idPhoto-mirae").attr("src", res.data.member_img);
					$(".detail-name").text(res.data.name);
					$(".detail-team").text(
							res.data.team + " | " + res.data.team_info);
					$(".detail-price_total").text(res.data.price_total);

					if (res.data.team == '더불어민주당') {
						$(".idPhoto-mirae").css("border", "2px solid #00BCEF");
						$(".detail-team").css("color", "#00BCEF");
					} else if (res.data.team == '더불어시민당') {
						$(".idPhoto-mirae").css("border", "2px solid #00BCEF");
						$(".detail-team").css("color", "#00BCEF");

					} else if (res.data.team == '미래통합당') {
						$(".idPhoto-mirae").css("border", "2px solid #e84472");
						$(".detail-team").css("color", "#e84472");
					} else if (res.data.team == '미래한국당') {
						$(".idPhoto-mirae").css("border", "2px solid #e84472");
						$(".detail-team").css("color", "#e84472");

					} else if (res.data.team == '정의당') {
						$(".idPhoto-mirae").css("border", "2px solid #FFCE31");
						$(".detail-team").css("color", "#FFCE31");

					} else if (res.data.team == '민생당') {
						$(".idPhoto-mirae").css("border", "2px solid #2b8d50");
						$(".detail-team").css("color", "#2b8d50");

					} else if (res.data.team == '민중당') {
						$(".idPhoto-mirae").css("border", "2px solid #ED6748");
						$(".detail-team").css("color", "#ED6748");

					} else if (res.data.team == '열린민주당') {
						$(".idPhoto-mirae").css("border", "2px solid #888888");
						$(".detail-team").css("color", "#888888");

					} else if (res.data.team == '우리공화단') {
						$(".idPhoto-mirae").css("border", "2px solid #31a650");
						$(".detail-team").css("color", "#31a650");

					} else if (res.data.team == '찬박신당') {
						$(".idPhoto-mirae").css("border", "2px solid #888888");
						$(".detail-team").css("color", "#888888");

					} else if (res.data.team == '한국경제단') {
						$(".idPhoto-mirae").css("border", "2px solid #888888");
						$(".detail-team").css("color", "#888888");

					} else if (res.data.team == '무소속') {
						$(".idPhoto-mirae").css("border", "2px solid #e84472");
						$(".detail-team").css("color", "#e84472");

					} else if (res.data.team == '국민의당') {
						$(".idPhoto-mirae").css("border", "2px solid #28A575");
						$(".detail-team").css("color", "#28A575");

					} else if (res.data.team == '바른미래당') {

					} else if (res.data.team == '새누리당') {
						$(".idPhoto-mirae").css("border", "2px solid #FF364A");
						$(".detail-team").css("color", "#FF364A");

					} else if (res.data.team == '자유한국당') {
						$(".idPhoto-mirae").css("border", "2px solid #FF364A");
						$(".detail-team").css("color", "#FF364A");

					}
					$(".member-detail")
							.slideDown(
									1000,
									function() {
										var years = new Array();
										var prices = new Array();
										var prices2 = new Array();
										years.push("x")
										prices.push("선택한 의원의 후원금")
										prices2.push("1인당 평균 후원금")
										years.push("2016년")
										years.push("2017년")
										years.push("2018년")
										years.push("2019년")
										prices.push(res.data.price_2016_)
										prices.push(res.data.price_2017_)
										prices.push(res.data.price_2018_)
										prices.push(res.data.price_2019_)
										prices2.push(res.data.t_price_2016_)
										prices2.push(res.data.t_price_2017_)
										prices2.push(res.data.t_price_2018_)
										prices2.push(res.data.t_price_2019_)
										var chart = c3
												.generate({
													bindto : '#chart',
													data : {
														x : 'x',
														columns : [ years,
																prices, prices2 ],
														type : 'bar',
														colors : {
															'선택한 의원의 후원금' : '#f4cc00',
															'1인당 평균 후원금' : '#c6c2b3'
														}
													},
													axis : {
														x : {
															type : 'category'
														},
														y : {
															tick : {
																values : [
																		100000000,
																		200000000,
																		300000000,
																		400000000,
																		500000000 ],
																format : function(
																		x) {
																	var val = x
																			+ '';
																	val = comma(val
																			.substring(
																					0,
																					(val.length - 4)))
																			+ "만원";
																	return val;
																},
																count : 5
															},
															max : 500000000
														}
													},
													bar : {
														width : {
															ratio : 0.5
														}
													},
												});

										var prices = new Array();
										prices.push("연간")
										prices.push(res.data.price_2016_300_)
										prices.push(res.data.price_2017_300_)
										prices.push(res.data.price_2018_300_)
										prices.push(res.data.price_2019_300_)
										var chart = c3
												.generate({
													bindto : '#chart2',
													data : {
														x : 'x',
														columns : [ years,
																prices ],
														type : 'bar',
														colors : {
															'연간' : '#f4cc00'
														}
													},
													axis : {
														x : {
															type : 'category'
														},
														y : {
															tick : {
																values : [
																		100000000,
																		200000000,
																		300000000,
																		400000000,
																		500000000 ],
																format : function(
																		x) {
																	var val = x
																			+ '';
																	val = comma(val
																			.substring(
																					0,
																					(val.length - 4)))
																			+ "만원";
																	return val;
																},
																count : 5
															},
															max : 500000000
														}
													},
													bar : {
														width : {
															ratio : 0.5
														}
													}
												});

										//하단 300만원 초과 후원자 명단 맵핑
										//bubbleCanvas2016
										chart_300("#bubbleCanvas2016", "2016",
												res.list)
										chart_300("#bubbleCanvas2017", "2017",
												res.list)
										chart_300("#bubbleCanvas2018", "2018",
												res.list)
										chart_300("#bubbleCanvas2019", "2019",
												res.list)

										$("#chart2").hide();
									});
					$(".members").hide();

				})
	}

	$.views.converters("split1", function(val) {
		return val.split(" ")[1]
	});
</script>

<script type="text/x-jsrender" id="members">
{{for data}}
				<span class="multiselect__option" data-seq="{{:congress_seq}}" >
					<span>{{:name}} | {{:team}} | {{split1:team_info}}</span><br>
				</span> 
{{/for}}
</script>


<script type="text/x-jsrender" id="rank">
{{for data}}
												<tr>
													<td class="rankTable-rank">{{:#index+1}}</td>
													<td class="rankTable-center"><img src="{{:member_img}}" alt="photo" class="rankTable-photo"></td>
													<td class="rankTable-name" data-seq="{{:congress_seq}}">{{:name}}</td>
													<td class="rankTable-center">{{:team}}</td>
													<td class="rankTable-center">{{:team_info}}</td>
													<td class="rankTable-number">{{:price}}</td>
												</tr>
{{/for}}
</script>

<script type="text/x-jsrender" id="info">
{{for list}}
									<tr>
										<td>{{:year}}</td> 
										<td>{{:team}}</td> 
										<td>{{:team_info}}</td> 
										<td>{{:name}}</td> 
										<td>{{:price}}</td>
									</tr>
{{/for}}
</script>



<body naver_screen_capture_injected="true">

	<header class="header">
		<a href="https://newstapa.org/" target="_blank"> <img
			src="https://storage.googleapis.com/media.newstapa.org/static/bundle/korean/assets/img/logo.svg"
			alt="Newstapa logo" class="header__logo">
		</a>
	</header>

	<div class="main">
		<div>
			<img src="http://pages.newstapa.org/n2002/static/img/mainicon.png"
				alt="아이콘" class="main-icon">
			<h1 class="title">20대 국회의원 정치후원금</h1>
			<p class="main-paragraph">뉴스타파에서 20대 국회의원의 역대 4년간 후원금을 분석했습니다.
				국회의원들은 후원금을 얼마나, 누구에게 받았을까요? 궁금한 국회의원을 검색해 내역을 살펴보세요.</p>
		</div>

	</div>


	<div class="section">
		<div id="app">
			<div class="canvas">
				<p class="canvas-title">조회할 국회의원을 선택하세요</p>


                <!-- 국회의원 이름 검색 : s -->
				<div tabindex="-1" class="multiselect">
					<div class="multiselect__select"></div>
					<div class="multiselect__tags">
						<div class="multiselect__tags-wrap" style="display: none;"></div>
						<!---->
						<div class="multiselect__spinner" style="display: none;"></div>
						<input name="" type="text" autocomplete="nope"
							placeholder="국회의원 이름을 입력하세요" tabindex="0"
							class="multiselect__input input-name"
							style="position: absolute; padding: 0px;">
						<!---->
						<span class="multiselect__placeholder"> 국회의원 이름을 입력하세요 </span>
					</div>
					<div tabindex="-1" class="multiselect__content-wrapper"
						style="max-height: 200px; display: none;">
						<ul class="multiselect__content" style="display: inline-block;">
							<!---->
							<li class="multiselect__element"></li>
						</ul>
					</div>
				</div>
				<!-- 국회의원 이름 검색 :e -->


				<!-- 후원금 순위:s -->
				<div>
					<div class="canvas-mini members">
						<div class="canvas-box canvas-box-border">
							<p class="minititle minititleText"></p>
							<div>
								<ul class="ranking_tab_title">
									<li data-year="2016">2016년</li>
									<li data-year="2017">2017년</li>
									<li data-year="2018">2018년</li>
									<li data-year="2019" class="on">2019년</li>
								</ul>
								<div class="ranking_tab_cont">
									<div class="on">
										<table class="rankTable">
											<thead>
												<th class="rankTable-center" colspan="2">순위</th>
												<th class="rankTable-center">이름</th>
												<th class="rankTable-center">정당</th>
												<th class="rankTable-center">선거구</th>
												<th class="rankTable-number">금액</th>
											</thead>
											<tbody class="rank-tbody">
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<p class="remark-except">※ 2018년, 2017년, 2016년도는 공직선거가 있는 해로서
								평년 모금액(1억 5천만원)의 2배인 3억원까지 모금 가능</p>
						</div>
						<div class="canvas-box popup">
							<p class="paragraph">데이터 : 최윤원, 임송이 | 데이터 시각화 : 임송이</p>
						</div>
					</div>
				</div>
				<!-- 후원금순위 : e -->
				
				<!-- 국회의원상세보기 : s -->
				<div class="canvas-mini member-detail" style="display: none;">
					<div class="canvas-box canvas-box-border"
						style="text-align: center;">
						<img src="" alt="photo" class="idPhoto idPhoto-mirae">
						<p class="minititle detail-name"></p>
						<p class="remark mirae detail-team"></p>
						<p class="remark">후원금 총액</p>
						<p class="number detail-price_total"></p>
					</div>
					<div class="canvas-box canvas-box-border">
						<p class="minititle">4년간 후원금 변화</p>
						<ul class="slct">
							<li class="slct-li slct-select" data-tab="1"><input
								type="radio" value="total"> <label for="pickTotal">전체후원금</label>
							</li>
							<li class="slct-li" data-tab="2"><input type="radio"
								value="high"> <label for="pickHigh">연간 300만원 이상</label>
							</li>
						</ul>
						<div id="chart"></div>
						<div id="chart2"></div>
						<div id="barCanvas">
							<!-- 그래프-->
						</div>
						<p class="remark-except">※ 2018년, 2017년, 2016년도는 공직선거가 있는 해로서
							평년 모금액(1억 5천만원)의 2배인 3억원까지 모금 가능</p>
					</div>
					<div class="canvas-box canvas-box-border">
						<p class="minititle">2019년 300만 원 초과 후원자 명단</p>
						<p class="remark">클릭하면 후원자 세부 정보를 볼 수 있습니다.</p>
						<div>
							<ul class="the21st_tab_title">
								<li class="">2016년</li>
								<li class="">2017년</li>
								<li class="">2018년</li>
								<li class="on">2019년</li>
							</ul>
							<div class="the21st_tab_cont">
								<!--16년 : s -->
								<div>
									<p class="remark">
										<span style="color: rgb(68, 0, 255);">■ 21대 총선 출마자</span><br>
										<span style="color: #999; font-size: 1.2rem">※ 도넛형태
											그래프는 각 후원자들 후원금이 전체 금액에서 차지하는 비율을 나타낸 것입니다.<br>그래프가 표시한
											색깔 영역 또는 숫자로 마우스를 이동하고 클릭하세요.<br>'후원금 ~%를 차지하고 있는 후원자의
											인적사항과 금액'을 확인할 수 있습니다.
										</span>
									</p>
									<p class="error-text" style="display: none;">검색 결과가 없습니다</p>
									<div id="bubbleCanvas2016">
										<!--원형-->
									</div>
								</div>
								<!--16년 : e -->

								<!--17년 : s -->
								<div>
									<p class="remark">
										<span style="color: rgb(68, 0, 255);">■ 21대 총선 출마자</span><br>
										<span style="color: #999; font-size: 1.2rem">※ 도넛형태
											그래프는 각 후원자들 후원금이 전체 금액에서 차지하는 비율을 나타낸 것입니다.<br>그래프가 표시한
											색깔 영역 또는 숫자로 마우스를 이동하고 클릭하세요.<br>'후원금 ~%를 차지하고 있는 후원자의
											인적사항과 금액'을 확인할 수 있습니다.
										</span>
									</p>
									<p class="error-text" style="display: none;">검색 결과가 없습니다</p>
									<div id="bubbleCanvas2017">
										<!--원형-->
									</div>
								</div>
								<!--17년 : e -->

								<!--18년 : s -->
								<div>
									<p class="remark">
										<span style="color: rgb(68, 0, 255);">■ 21대 총선 출마자</span><br>
										<span style="color: #999; font-size: 1.2rem">※ 도넛형태
											그래프는 각 후원자들 후원금이 전체 금액에서 차지하는 비율을 나타낸 것입니다.<br>그래프가 표시한
											색깔 영역 또는 숫자로 마우스를 이동하고 클릭하세요.<br>'후원금 ~%를 차지하고 있는 후원자의
											인적사항과 금액'을 확인할 수 있습니다.
										</span>
									</p>
									<p class="error-text" style="display: none;">검색 결과가 없습니다</p>
									<div id="bubbleCanvas2018">
										<!--원형-->
									</div>
								</div>
								<!--18년 : e -->

								<!--19년 : s -->
								<div class="on">
									<p class="remark">
										<span style="color: rgb(68, 0, 255);">■ 21대 총선 출마자</span><br>
										<span style="color: #999; font-size: 1.2rem">※ 도넛형태
											그래프는 각 후원자들 후원금이 전체 금액에서 차지하는 비율을 나타낸 것입니다.<br>그래프가 표시한
											색깔 영역 또는 숫자로 마우스를 이동하고 클릭하세요.<br>'후원금 ~%를 차지하고 있는 후원자의
											인적사항과 금액'을 확인할 수 있습니다.
										</span>
									</p>
									<p class="error-text" style="display: none;">검색 결과가 없습니다</p>
									<div id="bubbleCanvas2019">
										<!--원형-->
									</div>
								</div>
								<!--19년 : e -->
							</div>
						</div>
					</div>

					<!-- 21대 총선 출마자 상세보기 : s -->
					<div class="detail-info" style="display: none;">
						<div class="canvas-box canvas-box-border popup">
							<p class="minititle">후원자 정보</p>
							<table class="table">
								<tbody>
									<tr>
										<td class="tbold">이름</td>
										<td class="detail-info-name"></td>
									</tr>
									<tr>
										<td class="tbold">총 후원금 금액</td>
										<td class="detail-info-price"></td>
									</tr>
									<tr>
										<td class="tbold">직업</td>
										<td class="detail-info-job"></td>
									</tr>
									<tr>
										<td class="tbold">주소</td>
										<td class="detail-info-addr"></td>
									</tr>
								</tbody>
							</table>
						</div>

						<div class="canvas-box canvas-box-border popup detail-info">
							<p class="minititle">
								<strong class="detail-info-name"></strong> 후원자가 후원한 의원 명단
							</p>
							<table class="table">
								<tbody>
									<tr>
										<td class="tbold">후원연도</td>
										<td class="tbold">정당</td>
										<td class="tbold">선거구</td>
										<td class="tbold">국회의원</td>
										<td class="tbold">금액</td>
									</tr>
								<tbody class="info-tbody"></tbody>
								</tbody>
							</table>
						</div>
					</div>
					<!-- 21대 총선 출마자 상세보기 : e-->

					<div class="canvas-box canvas-box-border popup">
						<p class="paragraph">데이터 : 최윤원, 임송이 | 데이터 시각화 : 임송이</p>
					</div>
					<div class="canvas-box popup close">
						<p class="close-title">처음으로 돌아가기</p>
					</div>
				</div>
				<!-- 국회의원상세보기 : e -->


			</div>
		</div>
	</div>
	<footer class="footer">
		<div class="footer__box">
			<img
				src="https://storage.googleapis.com/media.newstapa.org/static/bundle/korean/assets/img/logo-bright.svg"
				alt="logo white version" class="footer__logo">
			<div class="footer__info">
				<div class="footer__info__margin">
					<ul>
						<li><a href="https://jebo.newstapa.org">제보</a> <span
							class="sep">|</span></li>
						<li><a href="https://goo.gl/forms/qSkAChcxDfPNcsgj2">인터뷰,
								강의, 견학 요청</a> <span class="sep">|</span></li>
						<li><a href="https://kcij.org/contact">제휴, 협력 문의</a> <span
							class="sep">|</span></li>
						<li><a
							href="https://download.newstapa.org/common/html/terms5.html">청소년
								보호정책</a> <span class="sep">|</span></li>
						<li><a href="https://kcij.org/faq">자주 묻는 질문(FAQ)</a> <span
							class="sep">|</span></li>
						<li><a href="https://newstapa.org/using">콘텐츠 사용원칙</a></li>
					</ul>
				</div>
				<div class="footer__info__margin">
					<p>서울특별시 중구 퇴계로 212-13(04625)</p>
					<p>사업자등록번호 : 117-82-66835 | 인터넷신문등록번호 : 서울,아02778 (2013년 8월
						21일)</p>
					<p>대표자: 김용진 | 발행인/편집인:김용진 | 개인정보관리 책임자 : 김성근</p>
					<p>전화 : 02-2038-0977 팩스번호 : 02-2038-0978 제보 전화 : 02-2038-8029 |
						webmaster@newstapa.org</p>
				</div>
				<div class="footer__info__margin">
					<p>Copyright © KCIJ, All Rights Reserved.</p>
				</div>
			</div>
			<div class="footer__keep">
				<div class="footer__social">
					<ul>
						<li><a href="https://www.facebook.com/NEWSTAPA"> <img
								src="https://storage.googleapis.com/media.newstapa.org/static/bundle/korean/assets/img/social/icon-follow-facebook.svg"
								alt="facebook logo">
						</a></li>
						<li><a href="https://twitter.com/newstapa"> <img
								src="https://storage.googleapis.com/media.newstapa.org/static/bundle/korean/assets/img/social/icon-follow-twitter.svg"
								alt="twitter logo">
						</a></li>
						<li><a href="https://story.kakao.com/ch/newstapa"> <img
								src="https://storage.googleapis.com/media.newstapa.org/static/bundle/korean/assets/img/social/icon-follow-kakaostory.svg"
								alt="kakaostory logo">
						</a></li>
						<li><a href="https://www.youtube.com/user/newstapa"> <img
								src="https://storage.googleapis.com/media.newstapa.org/static/bundle/korean/assets/img/social/icon-follow-youtube.svg"
								alt="youtube logo">
						</a></li>
					</ul>
				</div>
			</div>
		</div>
	</footer>




</body>

<audio src="" id="naver_dic_audio_controller" controls="controls"
	style="display: none;"></audio>
</html>

