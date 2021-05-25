<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Toast UI test</title>
<style>
.drag-over { background-color: #ff0; }
.thumb { width:200px; padding:5px; float:left; }
.thumb > img { width:100%; }
.thumb > .close { position:absolute; background-color:red; cursor:pointer; }
</style>

</head>
<!-- Editor's Dependecy Style -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.48.4/codemirror.min.css"/>
<!-- Editor's Style --> 
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />

<body>
<div id="editor" style="box-sizing: border-box; height: 500px;"></div>
<!-- onchange 말고 굳이 버튼 이후코드 반영된 코드 보여주고 싶다면  -->
<button onclick="ToView();">test editor</button>
<div id="viewer"></div>

<span> 실제 데이터베이스에 저장될 text </span>
<div id="res">

</div>
<input type="button" id="btnSubmit" value="업로드"/>
<div id="drop" style="border:1px solid black; width:800px; height:300px; padding:3px">
여기로 drag & drop
<div id="thumbnails">
</div>
</div>

<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script>
<script src="https://uicdn.toast.com/editor/2.0.0/toastui-editor-all.min.js"></script>
<script>
		const content = [].join('\n');
        const editor = new toastui.Editor({
            el: document.querySelector('#editor'),
            previewStyle: 'vertical',
            initialEditType: "wysiwyg",
            height: '500px',
            initialValue: content
        });
        const viewer = toastui.Editor.factory({
            el: document.querySelector('#viewer'),
            viewer: true,
            height: '500px',
            initialValue: content
        });

        function ToView()
        {	
//             viewer.setMarkdown(editor.getMarkdown());
        	let text = editor.getMarkdown();
        	$.ajax({
	        	url : "${pageContext.request.contextPath}/view/editor"
	        	, data : {"text" : text}
	        	, success : function(data){
	        		// 이렇게 사용하면 markdown이 먹힌 후로 보임.
	        		viewer.setMarkdown(data);
	        		// 이렇게 사용하면 markdown이 먹히기 전으로 보임.
	        		$("#res").html(data)
	        	}
	        	, error : function(xhr){
	        		console.log(xhr.status);	
	        	} 
	        })
        };
        
        var uploadFiles = [];
        var $drop = $("#drop");
        
        $drop.on("dragenter", function(e) { //드래그 요소가 들어왔을떄
        	$(this).addClass('drag-over');
        }).on("dragleave", function(e) { //드래그 요소가 나갔을때
        	$(this).removeClass('drag-over');
        }).on("dragover", function(e) {
	        e.stopPropagation();
	        e.preventDefault();
        }).on('drop', function(e) { //드래그한 항목을 떨어뜨렸을때
        	e.preventDefault();
	        $(this).removeClass('drag-over');
	        var files = e.originalEvent.dataTransfer.files; //드래그&드랍 항목
	        for(var i = 0; i < files.length; i++) {
		        var file = files[i];
		        var size = uploadFiles.push(file); //업로드 목록에 추가
		        preview(file, size - 1); //미리보기 만들기
        	}
        });
        function preview(file, idx) {
	        var reader = new FileReader();
	        reader.onload = (function(f, idx) {
		        return function(e) {
		        var div = '<div class="thumb"> \
			        <div class="close" data-idx="' + idx + '">X</div> \
			        <img src="' + e.target.result + '" title="' + escape(f.name) + '"/> \
			        </div>';
		        $("#thumbnails").append(div);
        		};
        	})(file, idx);
        	reader.readAsDataURL(file);
        }
        $("#btnSubmit").on("click", function() {
	        var formData = new FormData();
	        $.each(uploadFiles, function(i, file) {
		        if(file.upload != 'disable') //삭제하지 않은 이미지만 업로드 항목으로 추가
		        formData.append('upload-file', file, file.name);
        	});
	        $.ajax({
		        url: '/api/etc/file/upload',
		        data : formData,
		        type : 'post',
		        contentType : false,
		        processData: false,
		        success : function(ret) {
		        	alert("완료");
		        }
	        });
        });
        $("#thumbnails").on("click", ".close", function(e) {
	        var $target = $(e.target);
	        var idx = $target.attr('data-idx');
	        uploadFiles[idx].upload = 'disable'; //삭제된 항목은 업로드하지 않기 위해 플래그 생성
	        $target.parent().remove(); //프리뷰 삭제
        });
</script>
</body>
</html>