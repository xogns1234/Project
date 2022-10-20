<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">
	function back(){
		document.find_id.action='loginMember.jsp';
		document.find_id.submit();
		
	}
	</script>
<meta charset="UTF-8">

<link rel="stylesheet" href="../css/IdfindMember.css">
<title>아이디 찾기</title>
</head>
<body>
<%
	String findid = "loginform.do?findid=findid";
%>
<jsp:include page="/menu.jsp" />
		<div class="container" align="center">
			<h1 class="display-3">편케팅 아이디 찾기</h1>
		</div>
	<div class="container" align="center">
		<div class="idfind">
			<h3 class="form-signin-heading"> 찾으실 계정의 정보를 입력해 주세요</h3>
		</div>
	</div>
	<form class="form-idfind" name="find_id" action="<%=findid %>" method="post">
		<div class="form-group">
			<label for="inputfindPassword" id="findtext" class="sr-only">비밀번호 힌트</label>
			<input type="text" class="form-control" id="pwfind" placeholder="Password Hint" name="findpass">
		</div>
		<div class="form-group">
			<label for="inputphone" id="findtext" class="sr-only">휴대전화 번호</label>
			<input type="text" class="form-control" id="phone" placeholder="Phone Number" name="phone">
		</div>
	
	<div class="container">
		<div class="bfind"></div>
		<button class="b-find" id="id_find" type="submit">아이디 보기</button>
		<button class="b-back" id="reset" onclick="back();">취소</button>
		</div>
	</div>
	</form>
	

</body>
</html>