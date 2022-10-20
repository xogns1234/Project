<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../dist/fullpage.css" />
<link rel="stylesheet" type="text/css" href="../css/updateMember.css" />

<%

String a = request.getParameter("a");
String addr = (String)request.getAttribute("addr");
String phone = (String)request.getAttribute("phone");
String name = (String)request.getAttribute("name");
String pwfind = (String)request.getAttribute("pwfind");
%>
<script type="text/javascript">

	function checkForm() {
		if (!document.newMember.id.value) {
			alert("아이디를 입력하세요.");
			return;
		}
		if (!document.newMember.pass.value) {
			alert("비밀번호를 입력하세요.");
			return;
		}
		if (document.newMember.pass.value != document.newMember.pw_confirm.value) {
			alert("비밀번호가 일치하지 않습니다.");
			return;
		}		
		if (!document.newMember.name.value) {
			alert("이름을 입력하세요.");
			return;
		}
		if (!document.newMember.address.value) {
			alert("주소를 입력하세요.");
			return;
		}		
		if (!document.newMember.pwfind.value) {
			alert("힌트를 입력하세요.");
			return;
		}
		if (!document.newMember.phone.value) {
			alert("전화번호를 입력하세요.");
			return;
		}
		document.newMember.submit();
	}
	
	function chkUpdate() {
		document.newMember.action = "updateMemberform.do?chkupdate=chkupdate";
		document.newMember.submit();				
	}	
	setTimeout(function() {
		if('<%=a%>' == 'false'){		
			alert('아이디나 비밀번호가 틀렸습니다.');
		}
	}, 200)
</script>
<% String UserId = (String) session.getAttribute("UserId"); 
a = request.getParameter("a") == null ? "false" : request.getParameter("a");
%>
<sql:setDataSource var="dataSource" url="jdbc:mysql://localhost:3306/marketnavi"
	driver="com.mysql.jdbc.Driver" user="root" password="1234" />
<sql:query dataSource="${dataSource}" var="resultSet" >
	select * from member where id=?
	<sql:param value="<%=UserId %>" />
</sql:query>
<title>회원 수정</title>
</head>
<body>
	<jsp:include page="/menu.jsp" />	
		<div class = "container">
		<%		
			if(a.equals("true")){ 
			%>
					<h1 class = "display-3">회원 수정</h1>
		<form name="newMember" action="updateMemberform.do?update=update" method="post"  
		class="form-horizontal"
		style="margin-bottm:0px; margin-top:25px;">
			<div class="form-group row">				
				<div class="col-sm-3">
				<input type="hidden" name= "id" class="form-control" value="<%=(String)session.getAttribute("UserId") %>" />
					<input type="hidden" class="form-control" placeholder="id"
						value="<c:out value='${row.id}'/>" />
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2">비밀번호</label>
				<div class="col-sm-3">
					<input type="password" name="pass" class="form-control" placeholder="password"
						value="<c:out value='${row.pass}'/>" >
				</div>
			</div>		
			<div class="form-group row">
				<label class="col-sm-2">비밀번호 확인</label>
				<div class="col-sm-3">
					<input type="password" name="pw_confirm" class="form-control" placeholder="password_confirm">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2">성명</label>
				<div class="col-sm-3">
					<input type="text" name="name" class="form-control" placeholder="<%=name %>"
						value="<c:out value='<%=name %>'/>" >
				</div>
			</div>
	
			<div class="form-group row">
				<label class="col-sm-2">주소</label>
				<div class="col-sm-3">
					<input type="text" name="address" class="form-control" placeholder="<%=addr %>"
					value="<c:out value='<%=addr %>'/>">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2">비밀번호 찾기</label>
				<div class="col-sm-3">
					<input type="text" name="pwfind" class="form-control" placeholder="<%=pwfind %>"
					value="<c:out value='<%=pwfind %>'/>">
				</div>
			</div>
		<div class="form-group row">
				<label class="col-sm-2">휴대전화 번호</label>
				<div class="col-sm-3">
					<input type="text" name="phone" class="form-control" placeholder="<%=phone %>"
					value="<c:out value='<%=phone %>'/>">
				</div>
			</div>
			<div class="form-group row">
				<div class="col-sm-offset-2 col-sm-10">
					<input type="button" class="btn btn-primary" id="updatebtn" value="회원수정" onclick="checkForm();">
					<a href="deleteMemberform.do" class="btn btn-primary" id="updatebtn" >회원탈퇴</a>
				</div>
			</div>		
		</form>
		<%}else if(a.equals("false")){ %>
							<h1 class = "display-3">회원 확인</h1>
		<form name="newMember" action="updateMemberform.do" method="post"  
		class="form-horizontal"
		style="margin-bottm:0px; margin-top:25px;">
			<div class="form-group row">
			<label class="col-sm-2">아이디</label>				
				<div class="col-sm-3">
				<input type="text" name="id" class="form-control" placeholder="id"
						value="<c:out value='${row.id}'/>" >
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2">비밀번호</label>
				<div class="col-sm-3">
					<input type="password" name="pass" class="form-control" placeholder="password"
						value="<c:out value='${row.pass}'/>" >
				</div>
			</div>		
			<div class="form-group row">
				<div class="col-sm-offset-2 col-sm-10">
					<input type="button" class="btn btn-primary" id="updatebtn" value="회원 확인" onclick="chkUpdate();">
					<!-- <a href="deleteMemberform.do" class="btn btn-primary" id="updatebtn" >회원탈퇴</a> -->
				</div>
			</div>		
		</form>
		<%} %>
	</div>
</body>
</html>

