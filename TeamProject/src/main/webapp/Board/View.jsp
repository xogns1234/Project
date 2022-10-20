<%@page import="model1.board.ReplyDTO"%>
<%@page import="model1.board.ReplyDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model1.board.BoardDTO" %>
<%@ page import="model1.board.BoardDAO" %>
<%@ page import="model1.board.CommentDTO" %>
<%@ page import="model1.board.CommentDAO" %>
<%
	String num = request.getParameter("num");	
	//String pageNum = request.getParameter("pageNum");	
	//System.out.println("페이지 넘 : " + pageNum);
	BoardDAO dao = new BoardDAO();
	dao.updateVisitCount(num); // 조회수 카운트
	
	BoardDTO dto = dao.selectView(num);	
	CommentDAO cdao = new CommentDAO();
	ReplyDAO rdao = new ReplyDAO();
	
	List<CommentDTO> list = cdao.selectComment(num);
	List<ReplyDTO> ReplyList = rdao.selectReply(num);
	dao.close();
	//System.out.println("리스트 크기 : "+list.size());
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link rel="stylesheet" href="../css/View.css">
<link rel="stylesheet" href="../css/BotList.css">
<link rel = "stylesheet" href="../resource/css/NewFile.css">

<title>회원 게시판</title>
<script type="text/javascript">	
	function deletePost() {
		var confirmed = confirm("정말로 삭제하시겠습니까?");
		if(confirmed){
			var form = document.writeFrm;
			form.method = "post";
			form.action = "ListModel.li?deletePost=chk"
			form.submit();
		}
	}
</script>

</head>
<body>
<jsp:include page="/menu.jsp"></jsp:include>

<div class="view_form">
<form name="writeFrm">
	<input type="hidden" name="num" value="<%=num%>">		
			<table class="view_table">
		<tr style="height:35px;">
			<td>번호</td>
			<td><%=dto.getNum() %></td>
			<td>작성자</td>
			<td><%=dto.getId() %></td>			
		</tr>
		<tr>
			<td>작성일</td>
			<td><%=dto.getPostdate()%></td>
			<td>조회수</td>
			<td><%=dto.getVisitcount()%></td>		
		</tr>
		<tr>
			<td>제목</td>
			<td colspan="3"><%=dto.getTitle()%></td>
		</tr>
		<tr>
			<td>내용</td>
			<td colspan="3" height="100"><%=dto.getContent().replaceAll("\r\n", "<br/>")%></td>		
		</tr>
		<tr>
			<td colspan="4" align="center" style="height:35px;">
				<%
				if(session.getAttribute("UserId") != null && session.getAttribute("UserId").toString().equals(dto.getId())){
				%>
				<button class="sm" type="button" onclick="location.href='Write.jsp?num=<%=dto.getNum()%>';">수정하기</button>
				<button class="sm" type="button" onclick="deletePost();">삭제하기</button>
				<%} %>
				<button class="sm" type="button" onclick="location.href='ListModel.li?List=List';">목록보기</button>
			</td>			
		</tr>		
	</table>
</form>
</div>
<div class="c_write">
<form action="ListModel.li">
<textarea name="comment" class="txt1"></textarea>
<input type="hidden" name="num" value="<%=num%>">
</br>
<input class="comt" type="submit" value="댓글 쓰기">	
</form>	
</br>
</div>
<div>
<table class="c_table">

<%for(int i=0; i<list.size(); i++){ %> 	
		<tr>
			<td class="selectReply"><%=list.get(i).getId() %></td>
			<td class="selectReply" colspan="3"><%=list.get(i).getContent().replaceAll("\r\n", "<br/>")%>
				<%				
				for(int j=0; j<ReplyList.size(); j++){	
					String id_hidden = ReplyList.get(j).getId();
					if(list.get(i).getDeletePK()==ReplyList.get(j).getSelectPK()){					
				%>
					 <div id="reply">ㄴ<%=ReplyList.get(j).getId()%> : <%=ReplyList.get(j).getContent().replaceAll("\r\n", "<br/><a style=\"visibility:hidden;\">ㄴ"+id_hidden+" : </a>")%>
					 <%if(session.getAttribute("UserId") != null && session.getAttribute("UserId").toString().equals(ReplyList.get(j).getId())){ %>
					 <a class="del" href="ListModel.li?replyDelete=<%=ReplyList.get(j).getDeletePK()%>&&num=<%=num%>">삭제</a>
					 <%} %>					 
					 </div>					 
				<%}}%>
				<div class="reply close">
					<form name="frm" method="post" action="ListModel.li?insertReply=insertReply">
						<textarea class="txt2" name="content"></textarea>						
						<input type="hidden" name="selectPK" value="<%=list.get(i).getDeletePK()%>">
						<input type="hidden" name="num" value="<%=num%>">
						<input type="hidden" name="i" value="<%=i%>">						
						<input class="cmt_btn" type="submit" value="답글 달기">
						<!-- <input class="btn btn-danger " type="button" name="close" value="닫기" onclick="replyClose();"> -->
					</form>
				</div>
				<br>
				<a class="cursor" onclick="replyOpen(event);">[열기]</a>
				<a class="cursor" onclick="replyClose(event);">[닫기]</a>
			</td>	
			<%if(session.getAttribute("UserId").toString().equals(list.get(i).getId())){ %>
			<td><a class="del" href="ListModel.li?deletePK=<%=list.get(i).getDeletePK()%>&&num=<%=num%>">삭제</a></td>	
		<%} %>
		</tr>
<%} %></table></div></div>
<jsp:include page="BotList.jsp" />

<script type="text/javascript">
	scrollTo(0,sessionStorage.scroll);	
	var select = document.querySelectorAll(".selectReply");
	var reply = document.querySelectorAll(".reply");
	
	window.addEventListener('scroll',()=> {	
		//console.log(window.scrollY);
				sessionStorage.scroll = window.scrollY; 
	})
	
	function replyOpen() {		
		
		for(var i = 0; i<select.length; i++){		
			select[i].addEventListener("click" , function(e) {							
				console.log(this.children[this.children.length-4]);
				this.children[this.children.length-4].classList.remove('close');				
			});	
		}	
	}
	function replyClose() {
		
		for(var i=0; i<select.length; i++){
			//console.log(reply);			
			select[i].addEventListener("click" , function(e) {
				//console.log(this.children[this.children.length-4]);
				this.children[this.children.length-4].classList.add('close');				
			});
		}
	}
	</script>
</body>
</html>