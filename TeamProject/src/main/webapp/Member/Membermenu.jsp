<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



<%
	request.setCharacterEncoding("utf-8");
	String UserId = (String)session.getAttribute("UserId");
%>

<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"> <!-- 참조  -->
	<nav class = "navbar navbar-expand navbar-dark bg-dark">
		<div class = "container">
			<div class = "navbar-header">
				<a class = "navbar-brand" href="../main/home.html">Home</a>
			</div>
			<div>
				<ul class = "navbar-nav mr-auto">
				<c:choose>
					<c:when test ="${empty UserId}">
						<li class = "nav-item"><a class="nav-link" href='<c:url value="loginMember.jsp" />'>로그인</a> </li>
						<li class = "nav-item"><a class="nav-link" href='<c:url value="addMember.jsp" />'>회원가입</a> </li>
						<li class="nav-item"><a class="nav-link" href='<c:url value="../Map.map?outputmap=outputmap" />'>편의점 보기</a></li>
					</c:when>
					<c:otherwise>
						<li style="padding-top:7px; color:white;">[<%=UserId %>님]</li>
						<li class="nav-item"><a class="nav-link" href='<c:url value="logoutMember.jsp" />'>로그아웃</a></li>
						<li class="nav-item"><a class="nav-link" href='<c:url value="updateMember.jsp" />'>회원수정</a></li>
						<li class="nav-item"><a class="nav-link" href='<c:url value="../map.jsp" />'>편의점 등록</a></li>
						<li class="nav-item"><a class="nav-link" href='<c:url value="../Map.map?outputmap=outputmap" />'>편의점 보기</a></li>
						<li class="nav-item"><a class="nav-link" href='<c:url value="../Board/ListModel.li?List=List" />'>건의 게시판</a></li>
					</c:otherwise>
					</c:choose>
				</ul>				
			</div>
			</div>	
	</nav>

