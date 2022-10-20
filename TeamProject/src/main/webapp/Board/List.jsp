<%@ page import="java.util.List"%>
<%@ page import="model1.board.BoardDAO"%>
<%@ page import="model1.board.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="../css/List.css">

<meta charset="UTF-8">
<title>회원제 게시판</title>
<script type="text/javascript">
 function changeFunc(){ // 내가쓴글 검색할때 인풋 텍스트 비활성화 스크릡트	
	if(document.optionform.searchField.value == "id2"){
	  document.optionform.searchWord.disabled = true;
	  document.optionform.action = "ListModel.li?List=List"
		  document.optionform.submit();
	}else{
		document.optionform.searchWord.disabled = false;
		  document.optionform.action = "ListModel.li?List=List"
			  document.optionform.submit();
	}	
 }

</script>
</head>
<body>
<%
//String pageNum = request.getParameter("pageNum"); // 페이지 리스트의 넘버
String pageNum = (String)request.getAttribute("pageNum");
String pageLeft = request.getParameter("hdnbt");	// 이전 버튼 동작 여부 확인용
String pageList = request.getParameter("i");		// 지금 시점에서 가장 마지막 페이지의 숫자
String pageRight = request.getParameter("pageRight"); // 다음 버튼 동작 여부 확인용
String pageList_s = request.getAttribute("pageList_s").toString();
String pageList_e = request.getAttribute("pageList_e").toString();
String pageNum_chk_s = request.getAttribute("pageNum_chk_s").toString();
String pageNum_chk_e = request.getAttribute("pageNum_chk_e").toString();
int totalCount = Integer.parseInt(request.getAttribute("totalCount").toString());
List<BoardDTO> boardLists = (List<BoardDTO>)request.getAttribute("boardLists");
%>
<jsp:include page="/menu.jsp"></jsp:include>
    <!-- 검색폼 -->
    <div class="wrap">
    <div class="container box" id="board_list">
    <form method="get" name="optionform" >  
          	  <select name="searchField" id="search1"> 
                <option value="title">제목</option> 
                <option value="content">내용</option>
                <option value="id" >작성자</option>
                <option value="id2">내글보기</option>
           	 </select>
            <input class="form" type="text" name="searchWord" id="search2"/>            
            <input type="button" value="검색하기" id="search3" onclick="changeFunc();"/>  
    </form>
    <script type="text/javascript">
    if("<%=request.getAttribute("searchField")%>" == "id2" ){    	
    	document.querySelector("#search2").attributes.class.ownerElement.disabled = true;
    }
    </script>
    <!-- 게시물 목록 테이블(표) -->     
    <table class="table">
        <!-- 각 칼럼의 이름 --> 
        <tr align="center">
            <th>번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th>조회수</th>
            <th>작성일</th>
        </tr>
        <!-- 목록의 내용 --> 
<%
if (boardLists == null || boardLists.size() == 0) {
    // 게시물이 하나도 없을 때 
%>
        <tr>
            <td colspan="5" align="center">
                등록된 게시물이 없습니다^^*
            </td>
        </tr>
<%
}else {
    // 게시물이 있을 때  
    
   	 for(int i =Integer.parseInt(pageNum_chk_s); i<Integer.parseInt(pageNum_chk_e);i++){          
	%>
      <tr align="center">
          <td><%= totalCount-i%></td>  <!--게시물 번호-->
          <td align="left">  <!--제목(+ 하이퍼링크)-->
              <a href="View.jsp?num=<%= boardLists.get(i).getNum() %>&&pageNum=<%=pageNum %>" style="color: black;"><%= boardLists.get(i).getTitle() %></a> 
          </td>
          <td align="center"><%= boardLists.get(i).getId() %></td>          <!--작성자 아이디-->
          <td align="center"><%= boardLists.get(i).getVisitcount() %></td>  <!--조회수-->
          <td align="center"><%= boardLists.get(i).getPostdate() %></td>    <!--작성일--> 
      </tr>
	<%
		    }
		}
	%>  
    <!--목록 하단의 [글쓰기] 버튼-->
        <tr align="right">            
            <%
				if(session.getAttribute("UserId") != null){
				%>
				<td colspan="5" align="right">
			<button type="button" id="write_btn" onclick="location.href='Write.jsp';">글쓰기</button>
				</td>	
			<%}%>           
        </tr>
    </table>  
    <div>
    <form action="ListModel.li?List=List" name="pageLeftForm" method="post" id="pageform">  
    <%-- <b><%=pageNum %>page</b> --%><br/> 
  </div>
  <div class="wrap">   
    <li>    
    <!-- <a href="List.jsp?pageLeft=L"><<</a> -->
    <input type="hidden" name="hdnbt" />
    <input type="hidden" name="pageNum" value="<%=pageNum%>" />
      <input type="button" name="pageLeft" class="page-link" aria-label="Previous" value="<<" onclick="{document.pageLeftForm.hdnbt.value=this.value;document.pageLeftForm.submit();}">    
    </li>
    
	<%
	for(int i =Integer.parseInt(pageList_s); i<Integer.parseInt(pageList_e); i++){ // 페이지 리스트 버튼 출력		
		%>		
	<li class="pagination box"><a class="active" onmouseover="active_over(<%=i%>);" onmouseout="active_out(<%=i%>);" href="ListModel.li?pageNum=<%=i%>"><%=i %></a></li>			
	<%
	}	
	%>	
	<input type="hidden" name="i" value="<%=pageList_e%>"/>	
	<li class="page-item">      
      <input class="page-link"  type="submit" name="pageRight" value=">>">      
    
    </li>
    </div>
    </form>
    </div>
</body>
<script type="text/javascript">

function active_over(num) {	
	if(num!=<%=pageNum%>){
		document.querySelectorAll('.active')[num-1].style.backgroundColor = 'white';
		document.querySelectorAll('.active')[num-1].style.color = 'tomato';
	}
}
function active_out(num) {
	if(num!=<%=pageNum%>){
		document.querySelectorAll('.active')[num-1].style.backgroundColor ='tomato'; 
		document.querySelectorAll('.active')[num-1].style.color = 'white';
	}
}

document.querySelectorAll('.active')[<%=pageNum%>-1].style.backgroundColor = 'white';
document.querySelectorAll('.active')[<%=pageNum%>-1].style.color = 'tomato';

</script> 
</html>


