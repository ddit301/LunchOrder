<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Toast UI test</title>
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
        
</script>
</body>
</html>