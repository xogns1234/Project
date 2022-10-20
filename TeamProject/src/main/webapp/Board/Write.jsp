<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>
<link rel="stylesheet" type="text/css" href="../css/Write.css" />
</head>
<body>
<script type="text/javascript">
	function titlechk(form) {
		if(!form.title.value){			
			alert("제목을 입력하세요.");	
			
			return;
		}
		form.submit();
	}
	</script>
<jsp:include page="/menu.jsp"></jsp:include>
<%
	String num = request.getParameter("num");	
	String action = "ListModel.li?write=write";
%>	
	<div class="write_form">
	<form method="post" name = "WritePform" id="wtform" action="<%=action%>">
	<div class= "InputBox">
	<div class ="form-group1">
		<label>제목</label>
		
             <input type ="text" id="Title" placeholder="제목을 입력하세요." name ="title" maxlength='20'>
         </div>
		<div class ="form-group">
             <textarea id="Contents" rows="20" name ="content" placeholder="내용을 입력하세요."></textarea></div>
		<input type="hidden" name="num" value="<%=num%>">
		<table class="table_rule">
			<tr valign="top">
				<td class="write_rule">
				<span class="pagerule">
					<font color="red">※</font>
				</span>
				<font color="red" > 게시판에 허위사실을 작성할 시에 제제대상이 될 수 있습니다.</font>
				<br>
				<span class="pagerule">※</span>
				게시판 운영원칙에 맞지 않는 글은 운영자에 의해 삭제될 수 있습니다.
				<br>
				<span class="pagerule">※</span>
				다른 사람의 권리를 침해,명예를 훼손하는 게시물은 제재를 받을수 있습니다.
				
				</td>
			</tr>
		</table>	
		<div id="Btn">
		<%//System.out.println(num);
		if(num == null){ %>
		<input type="button" id="btnrule" value="게시글 등록" onclick="titlechk(WritePform);">		
		<%}else{ %>
		<input type="button" id="btnrule" value="게시글 수정" onclick="titlechk(WritePform);">
		<%} %>
		
		</div>
		</div>		
	</form>	
	</div>
</body>
</html>