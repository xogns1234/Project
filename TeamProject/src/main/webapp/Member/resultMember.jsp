<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="../css/resultMember.css">
<title>회원 정보</title>
</head>
<body>
<jsp:include page="/menu.jsp" />

		<div class = "container">
			<h1 class = "display-3">회원 정보</h1>
		</div>	
	
	<div class = "container" align="center">
	<%
		String msg = request.getParameter("msg");
		String loginId = (String) session.getAttribute("UserId");
		if(msg != null) {
			if (msg.equals("0"))
				out.println(" <h2 class='alert alert-danger'>회원정보가 수정되었습니다.</h2>");
			else if (msg.equals("1"))
				out.println(" <h2 class='alert alert-danger'>회원 가입을 축하드립니다.</h2>");
			else if (msg.equals("2") && loginId != null) {				
				out.println(" <h2 class='alert alert-danger'>" + loginId + "님 환영합니다.</h2>");
			}else if (loginId == null){				
				response.sendRedirect("loginMember.jsp?loginId=loginId");
			}
		} else {
			out.println("<h2 class='alert alert-danger'>회원정보가 삭제되었습니다.</h2>");
		}
	%>
	</div>
</body>
</html>
