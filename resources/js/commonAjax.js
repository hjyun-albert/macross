/**
 * AJAX 공통소스
 */
function ajaxCallPost(url, param, callbackSuccess, callbackFail){
	console.log("=========================================================")
	console.log("endPoint : " + url);
	console.log(param);
	$.ajax({
		type : "POST",
		url : url,
		contentType : "application/json",
		dataType : "JSON",    //옵션이므로 JSON으로 받을게 아니면 안써도 됨
		data : JSON.stringify(param),
		success : function(res) {
			console.log(res);
    		console.log("=========================================================")
			callbackSuccess(res);
		},
		error : function(xhr, status, error) {
			console.log(error);
    		console.log("=========================================================")
			callbackFail(error);
		}
	});
}

function ajaxCallPostNoParse(url, param, callbackSuccess, callbackFail){
	console.log("=========================================================")
	console.log("endPoint : " + url);
	console.log(param);
	$.ajax({
		type : "POST",
		url : url,
		contentType : "application/json",
		data : JSON.stringify(param),
		success : function(res) {
			console.log(res);
    		console.log("=========================================================")
			callbackSuccess(res);
		},
		error : function(xhr, status, error) {
			console.log(error);
    		console.log("=========================================================")
			callbackFail(error);
		}
	});
}

function ajaxCallGet(url, callbackSuccess, callbackFail){
	console.log("=========================================================")
	console.log("endPoint : " + url);
	$.ajax({
		type : "GET",
		url : url,
		contentType : "application/json",
		success : function(res) {
			console.log(res);
    		console.log("=========================================================")
			callbackSuccess(res);
		},
		error : function(xhr, status, error) {
			console.log(error);
    		console.log("=========================================================")
			callbackFail(error);
		}
	});
}
function ajaxUpload(inputFile, subPash, callback){
	var formData = new FormData();
	formData.append("file", inputFile);
	formData.append("sub_path", subPash);
	jQuery.ajax({
		url : "/api/file/ajaxupload"
			, type : "POST"
				, processData : false
				, contentType : false
				, data : formData
				, success:function(data_url) {
					callback(data_url)
				}
	});
}