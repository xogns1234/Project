<%@page import="java.util.List"%>
<%@page import="membership.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link rel="stylesheet" href="../css/login3.css">
	<%
		List<MemberDTO> fw = (List<MemberDTO>)request.getAttribute("dto") ;

		if(fw != null){			

		if(fw.size() != 0){
	%>	
	<script type="text/javascript">
	function dd() {
		alert('비밀번호는 : <%=fw.get(0).getPass()%>');
	}		
	</script>	
	<% }else{%>		
	<script type="text/javascript">	
		function cc() {
		alert("비밀번호를 찾을 수 없습니다.");	
		}		
	</script>
		<%} 
		}
		if(fw != null){			
		
	%>
	<script type="text/javascript">
	//console.log(dd());
		if(typeof dd !== "undefined") setTimeout(dd, 200);
		if(typeof cc !== "undefined") setTimeout(cc, 200);
	</script>
	<%
		}
			
	%>
	

		

	
<title>Login</title>
</head>
<body>
	<jsp:include page="/menu.jsp" />

		<div class="container" align="center">
			<h1 class="display-3">편케팅 로그인</h1>
		</div>
	</div>
	<div class="container" align="center">
		<div class="col-md-4 col-md-offset-4">
			<h3 class="form-signin-heading">Please sign in</h3>
				<%! int cnt=0; %>
			<%
				 
				String error = request.getParameter("error");
				if (error != null) {
					if(cnt == 3 ){
						out.println("<div class='alert alert-danger'>");
						out.println("3회 로그인 실패했습니다. 1분후에 확인해주세요");
						out.println("</div>");
					}else{
					out.println("<div class='alert alert-danger'>");
					out.println("아이디와 비밀번호를 확인해 주세요");
					out.println("</div>");
					
					}
					
				}if(request.getParameter("loginId") != null){
					out.println(" <h2 class='alert'>" + "아이디 혹은 비밀번호가 틀렸습니다.</h2>");
					
				}
				
				cnt++;
			%>
			<%
				String action="loginform.do?log=log";
			%>
			<form class="form-signin" action="<%=action %>" method="post">
		<table> <!-- style="width: 360px;"> -->
			

        <tr>
            <td id="logtext">User Name</td>
            <td><input type="text" class="form-control" id="idlog" placeholder="ID" 
					name='id' required autofocus></td>
        </tr>
        
        <tr>
            <td id="logtext">PassWord</td>
            <td><input type="password" class="form-control" id="idlog" placeholder="Password" 
					name='pass' required></td>
        </tr>
    	
<!--     	 <table border="1"> -->
            
<!--             <tr> -->
<!--                 <td>1 - 1</td> -->
<!--                 <td>1 - 2</td> -->
<!--                 <td>1 - 3</td> -->
<!--             </tr> -->
<!--             <tr> -->
<!--                 <td>2 - 1</td> -->
<!--                 <td>2 - 2</td> -->
<!--                 <td>2 - 3</td> -->
<!--             </tr> -->
<!--             <tr> -->
<!--                 <td>3 - 1</td> -->
<!--                 <td>3 - 2</td> -->
<!--                 <td>3 - 3</td> -->
<!--             </tr> -->
<!--             <tr> -->
<!--                 <td>4 - 1</td> -->
<!--                 <td>4 - 2</td> -->
<!--                 <td>4 - 3</td> -->
<!--             </tr> -->
<!--         </table> -->

    	 <table class="btn_set"><!--  border="1"> -->
            <tr>
                
<!--                 <td rowspan="2" href="/Member/IdfindMember.jsp"> -->
					<td rowspan="2" onclick="location.href='/TeamProject/Member/IdfindMember.jsp';">
        			<button id="idfind" type="submit">아이디 찾기</button>
                </td>
            </tr>
            <tr>
<!--                 <td colspan="1" href="/Member/PwfindMember.jsp"> -->
					<td colspan="1" onclick="location.href='/TeamProject/Member/PwfindMember.jsp';">
        	<button id="pwfind" type="submit" style="width: 130px;">비밀번호 찾기</button>
        		</td>
            	 <td id="loginbtn" colspan="1">
                <button class="login_btn" id="log" type="submit">로그인</button>
        		</td>
                
            </tr>
           
        </table>
    
    	</form>
    </table>
		</div>
	</div>
	
</body>
</html>
