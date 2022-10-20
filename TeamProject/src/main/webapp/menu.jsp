<%@page import="membership.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../css/boardMenu.css" />
<meta charset="UTF-8">
</head>
<%
	request.setCharacterEncoding("utf-8");
	String UserId = (String)session.getAttribute("UserId");
	
	MemberDAO dao = new MemberDAO();
	String name = dao.getMemberName(UserId);
%>
<%String id_chek = (String)session.getAttribute("UserId"); %>
<script type="text/javascript">
	function chek() {		
		var id =<%=id_chek%>;
		if(id == null){
			alert("로그인 해주세요");
			return false;
		}
		else{
			return true;
		}
	}
</script>

<body >
<header>
	<nav>
		<div class = "top-bar">
						
				<a class = "logo" href='<c:url value="/main/main2.jsp" />'><img src='<c:url value="/imgs/logo_small.png"/>'></a>
				

				
				<ul class = "menu">
				<c:choose>
					<c:when test ="${empty UserId}">
						<li class = "nav-item"><a class="nav-link" href='<c:url value="/Member/loginMember.jsp" />'>로그인</a> </li>
						<li class = "nav-item"><a class="nav-link" href='<c:url value="/Member/addMember.jsp" />'>회원가입</a> </li>
						<li class="nav-item"><a class="nav-link" href='<c:url value="/Map.map?outputmap=outputmap" />'onclick="return chek();">편의점 보기</a></li>
					</c:when>
					<c:otherwise>
						<li>[<%=name %>님]</li>
						<li class="nav-item"><a class="nav-link" href='<c:url value="/Member/logoutMember.jsp" />'>로그아웃</a></li>
						<li class="nav-item"><a class="nav-link" href='<c:url value="/Member/updateMember.jsp" />'>회원수정</a></li>
						<li class="nav-item"><a class="nav-link" href='<c:url value="/map.jsp" />'>편의점 등록</a></li>
						<li class="nav-item"><a class="nav-link" href='<c:url value="/Map.map?outputmap=outputmap" />'>편의점 보기</a></li>
						<li class="nav-item"><a class="nav-link" href='<c:url value="/Board/ListModel.li?List=List" />'>건의 게시판</a></li>
						<!-- 절대 경로로 하이퍼링크 설정 -->
					</c:otherwise>
					</c:choose>
				</ul>
		</div>			
	</nav>
			
</header>
</body>
</html>