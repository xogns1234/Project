<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<link rel="stylesheet" type="text/css" href="../dist/fullpage.css" />
<link rel="stylesheet" type="text/css" href="../css/addMember.css" />
<script type="text/javascript">
	function checkForm() {
		if(!document.newMember.id.value) {
			alert("아이디를 입력하세요.");
			return;
		}
		if(!document.newMember.pass.value) {
			alert("비밀번호를 입력하세요.");
			return;
		}
		if(document.newMember.pass.value != document.newMember.pw_confirm.value) {
			alert("비밀번호가 일치하지 않습니다.");
			return;
		}
		document.newMember.submit();
	}
</script>
<title>회원 가입</title>
</head>
<body>
<header>
<!--         <div class="logo"> -->
<!--          <a href='../main/main2.html'><img src="../imgs/logo_small.png"/></a>  -->
<!-- 			<a a href="../main/main2.html"><img src="../imgs/logo_small.png"/></a> -->

	<jsp:include page="/menu.jsp" />
	
	
	<div class="container">
	
	<h1 class = "display-3">회원 가입</h1>
	
		<form name="newMember" action="addMemberform.do" method="post"  
		class="form-horizontal" style="
    margin-bottom: 0px; margin-top:25px;">
    
			<div class="form-group row">
				<label class="col-sm-2">아이디</label>
				<div class="col-sm-3">
					<input type="text" name="id" class="form-control" placeholder="Id">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2">비밀번호</label>
				<div class="col-sm-3">
					<input type="password" name="pass" class="form-control" placeholder="Password">
				</div>
			</div>		
			<div class="form-group row">
				<label class="col-sm-2">비밀번호 확인</label>
				<div class="col-sm-3">
					<input type="password" name="pw_confirm" class="form-control" placeholder="Password Confirm">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2">성명</label>
				<div class="col-sm-3">
					<input type="text" name="name" class="form-control" placeholder="Name">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2">주소</label>
				<div class="col-sm-3">
					<input type="text" name="address" class="form-control" placeholder="Address">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2">비밀번호 찾기</label>
				<div class="col-sm-3">
					<input type="text" name="pwfind" class="form-control" placeholder="Password Hint">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2">휴대전화 번호</label>
				<div class="col-sm-3">
					<input type="text" name="phone" class="form-control" placeholder="Phone Number">
				</div>
			</div>
			<div class="form-group row">
				<div class="col-sm-offset-2 col-sm-10"> 
					<input type="button" class="btn btn-primary"  id="addbtn" value="등록" onclick="checkForm();">
					<input type="reset" class="btn btn-primary"  id="addbtn" value="취소" onclick="reset()">
				</div>
			</div>		
		</form>
	</div>
	</header>
</body>
</html>
