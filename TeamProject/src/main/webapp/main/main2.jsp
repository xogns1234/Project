<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    

<!DOCTYPE html>
<html>
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>오늘의 편케팅!</title>

	<link rel="stylesheet" type="text/css" href="../css/fullpage.css" />
	<link rel="stylesheet" type="text/css" href="../css/main2.css" />
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
	<style>

	.section{
		text-align:center;
	}
	</style>
<meta charset="UTF-8">
<%
	request.setCharacterEncoding("utf-8");
	String UserId = (String)session.getAttribute("UserId");
%>
</head>
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
<body style="top-margin:0; bottom-margin:0; left-margin:0; right-margin:0;">
 <header>
        <div class="logo">
         <a onclick="location.href='main2.jsp'"><img src="../imgs/logo_small.png"/></a>
    
            <nav>
                <ul class="menu">
                <c:choose>
                <c:when test="${empty UserId }">
              <form>
                    <li><a href="../Member/loginMember.jsp">로그인</a></li>
                    <li><a href="../Member/addMember.jsp">회원가입</a></li>
                    <li><a href="../Map.map?outputmap=outputmap" onclick="return chek();">편케팅!</a></li>
                </form>
                </c:when>
                <c:otherwise>
                	<li style="padding-top:7px; color:white; font-size:25px;"><%=UserId %>님</li> 
                	<li><a href="../Member/logoutMember.jsp">로그아웃</a></li>
                	<li><a href="../Member/updateMember.jsp">회원수정</a>
                    <li><a href="../map.jsp">제보하기</a></li>
                    <li><a href="../Map.map?outputmap=outputmap" onclick="return chek();">편케팅!</a></li>
                    <li><a href="../Board/ListModel.li?List=List">건의 게시판</a></li>
                    
                 </c:otherwise>
                 </c:choose>
                </ul>
            </nav>
        </div>
    </header>
    <div id="fullpage">
    
        <div class="section" id="section0"><h1>오늘의<br/>편케팅!</h1></div>
        <div class="section" id="section1">
            <div class="slide" id="slide1"><h1>오늘의 편케팅 소개입니다.</h1></div>
            <div class="slide" id="slide2"><h1>편케팅 소개 2</h1></div>
        </div>
        <div class="section" id="section2">
            <div class="intro">
                <h1 class="member_title">팀원 소개</h1>
                <p>팀원 1 2 3 4</p>
            </div>
        </div>
    <script type="text/javascript" src="fullpage.js"></script>
    
    <script type="text/javascript">
        var myFullpage = new fullpage('#fullpage');
    </script>

</body>
</html>