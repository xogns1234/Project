<%@page import="java.nio.file.attribute.UserPrincipalLookupService"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="model1.board.BoardDAO"%>
<%@ page import="model1.board.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// DAO를 생성해 DB에 연결
/* BoardDAO dao = new BoardDAO(application); */
BoardDAO dao = new BoardDAO();

// 사용자가 입력한 검색 조건을 Map에 저장
Map<String, Object> param = new HashMap<String, Object>(); 
String searchField = request.getParameter("searchField");
String searchWord = request.getParameter("searchWord");
String pageNum = request.getParameter("pageNum"); // 페이지 리스트의 넘버
String num = request.getParameter("num");
String pageLeft = request.getParameter("hdnbt");	// 이전 버튼 동작 여부 확인용
String pageList = request.getParameter("i");		// 지금 시점에서 가장 마지막 페이지의 숫자
String pageRight = request.getParameter("pageRight"); // 다음 버튼 동작 여부 확인용

if(pageNum == null){ // 초기 페이지에서 null 값 대신 1을 집어 넣어줌
	pageNum ="1";
}
if(searchField != null && searchField.equals("id2")){
	//searchField = "id";
	if(session.getAttribute("UserId") == null){
		searchWord = null;
	}else{
	searchWord = session.getAttribute("UserId").toString();
	}
}
if (searchWord != null) {
    param.put("searchField", searchField);
    param.put("searchWord", searchWord);
}
int totalCount = 0;
int totalBoard = 0;
List<BoardDTO> boardLists = null;
System.out.println(searchField);
if(searchField != null && searchField.equals("id2")){	
	searchField = "id";
	totalCount = dao.selectCount2(param);  // 게시물 수 확인
	totalBoard = dao.selectCount2(param);
	boardLists = dao.selectList2(param);  // 게시물 목록 받기
	dao.close();  // DB 연결 닫기
	if(session.getAttribute("UserId") == null){			
	}else{			
	}
}else{	
	totalCount = dao.selectCount(param);  // 게시물 수 확인
	totalBoard = dao.selectCount(param);
	boardLists = dao.selectList(param);  // 게시물 목록 받기
	dao.close();  // DB 연결 닫기
}
/* int totalCount = dao.selectCount(param);  // 게시물 수 확인
int totalBoard = dao.selectCount(param);
List<BoardDTO> boardLists = dao.selectList(param);  // 게시물 목록 받기
dao.close();  // DB 연결 닫기 */
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원제 게시판</title>
<script type="text/javascript">
 function changeFunc(){
	//alert(document.optionform.searchField.value);
	if(document.optionform.searchField.value == "id2"){
	  document.optionform.searchWord.disabled = true;	
	}else{
		document.optionform.searchWord.disabled = false;
	}		
 }
</script> 
</head>
<body>
    <!-- 검색폼 --> 
    <div class="search_form">
    <form method="get" name="optionform">  
   		<div>
    		<div>
          	  <select name="searchField" onchange="changeFunc();" id="search1"> 
                <option value="title" >제목</option> 
                <option value="content">내용</option>
                <option value="id" >작성자</option>
                <option value="id2">내글보기</option>
           	 </select>
           	 <input type="hidden" name="num" value="<%=num%>">
            <input class="form-control form-control-sm" type="text" name="searchWord" id="search2"/>            
            <input type="submit" value="검색하기" id="search3" /></div>
    	</div>
    </form>
    </div>
    <!-- 게시물 목록 테이블(표) --> 
    
    <table class="li_table">
        <!-- 각 칼럼의 이름 --> 
        <tr align="center" style="height:50px;">
            <th>번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th>조회수</th>
            <th>작성일</th>
        </tr>
        <!-- 목록의 내용 --> 
<%
if (boardLists.isEmpty()) {
    // 게시물이 하나도 없을 때 
%>
        <tr>
            <td colspan="5" align="center">
                등록된 게시물이 없습니다^^*
            </td>
        </tr>
<%
}
else {
    // 게시물이 있을 때 
    int virtualNum = 0;  // 화면상에서의 게시물 번호
    //for (BoardDTO dto : boardLists)
    int pageNum_ = Integer.parseInt(pageNum);
    int pageNum_chk_s = (pageNum_-1)*10;
    int pageNum_chk_e = pageNum_chk_s+10;
    if(pageNum_ == 1) {    	
    	pageNum_chk_s =0;
    	pageNum_chk_e = 10;
    }    
    if(pageNum_chk_e/10==Math.ceil((double)totalBoard/10)) pageNum_chk_e = totalBoard;
    
   	 for (int i =pageNum_chk_s; i<pageNum_chk_e;i++)
    {
        //virtualNum = totalCount--;  // 전체 게시물 수에서 시작해 1씩 감소    
%>
        <tr align="center" style="height:35px;" >
            <td><%= totalCount-i%></td>  <!--게시물 번호-->
            <td align="left">  <!--제목(+ 하이퍼링크)-->
                <a href="View.jsp?num=<%= boardLists.get(i).getNum() %>" style="color: black;"><%= boardLists.get(i).getTitle() %></a> 
            </td>
            <td align="center"><%= boardLists.get(i).getId() %></td>          <!--작성자 아이디-->
            <td align="center"><%= boardLists.get(i).getVisitcount() %></td>  <!--조회수-->
            <td align="center"><%= boardLists.get(i).getPostdate() %></td>    <!--작성일-->
        </tr>
<%
    }
}
%>
    </table>
    
    <!--목록 하단의 [글쓰기] 버튼-->
    <table id="com_t">
        <tr>
            
            <%
				if(session.getAttribute("UserId") != null){
				%>
				<td style="border: none;">
			<button type="button" class="com_btn" onclick="location.href='Write.jsp';">글쓰기</button>
				</td>	
				<%} %>            
            
        </tr>
    </table>
    </div>
    
    <div id="page">
    <form action="ListModel.li" name="pageLeftForm" method="post">
    <%-- <b><%=pageNum %>page</b> --%><br/>
    <div class="wrap">    
        <!-- <div aria-label="Page navigation example" class="nav_not"> -->
        
  <ul class="pagination">
  
  <!-- <div class="wrap">  -->  
    <li>    
    <!-- <a href="List.jsp?pageLeft=L"><<</a> -->
    <input type="hidden" name="hdnbt" />
    <input type="hidden" name="pageNum" value="<%=pageNum%>" />
      <input type="button" name="pageLeft" class="page-link" aria-label="Previous" value="<<" onclick="{document.pageLeftForm.hdnbt.value=this.value;document.pageLeftForm.submit();}">    
    </li>
    <%-- <input type="button" name="pageLeft" value="<<" onclick="{document.pageLeftForm.hdnbt.value=this.value;document.pageLeftForm.submit();}" > --%>
	<%
	int plusList = 0;

	if(pageRight != null) plusList = Integer.parseInt(pageList)-1;	
	if(pageLeft != null &&!pageLeft.equals("")) {
		plusList = (Integer.parseInt(pageList)-1);
		int plusListChk =0;
		if(plusList%5 ==4){
			plusListChk = plusList-9;
		}
		else if(plusList%5 ==3){
			plusListChk = plusList-8;
		}
		else if(plusList%5 ==2){
			plusListChk = plusList-7;
		}
		else if(plusList%5 ==1){
			plusListChk = plusList-6;
		}
		else if(plusList%5 ==0){
			plusListChk = plusList-10;
		}
		plusList = plusListChk;
	}

	int pageList_s = 1 + plusList;	
	int pageList_e = 6 + plusList;
	if(pageList_s<1) {
		pageList_s = 1;	
		pageList_e = 6;
	}
	if(pageList_e>Math.ceil((double)totalBoard/10)+1){
		pageList_e =(int) Math.ceil((double)totalBoard/10)+1;
		pageList_s =pageList_e-(int) Math.ceil((double)totalBoard/10)%5;
		if(pageList_s<1){
			pageList_s = 1;
		}
	}	
	if(Integer.parseInt(pageNum)>1 && pageRight == null && pageLeft == null){
		pageList_s = Integer.parseInt(pageNum);
		if(pageList_s%5 == 2){
			pageList_s = pageList_s-1;
		}
		if(pageList_s%5 == 3){
			pageList_s = pageList_s-2;
		}
		if(pageList_s%5 == 4){
			pageList_s = pageList_s-3;
		}
		if(pageList_s%5 == 0){
			pageList_s = pageList_s-4;
		}
		pageList_e = pageList_s+5;
		if(pageList_e>Math.ceil((double)totalBoard/10)+1){			
			pageList_e =(int) Math.ceil((double)totalBoard/10)+1;
			pageList_s =pageList_e-(int) Math.ceil((double)totalBoard/10)%5;
			
		}
		if(pageList_s<1){
			pageList_s = 1;
		}
	}
	if(pageList_e<2) {
		pageList_s =1;
		pageList_e =2;
	}
	for(int i =pageList_s; i<pageList_e; i++){	
		
		%>		
	<li class="pagination box"><a class="active" onmouseover="active_over(<%=i%>);" onmouseout="active_out(<%=i%>);" href="ListModel.li?pageNum=<%=i %>"><%=i %></a></li>			
	<%
	}
	/* System.out.println(pageLeft + ":" + pageRight+":" + pageNum); */
	%>
	<!-- <a href="List.jsp?pageRight=R">>></a> -->	
	<input type="hidden" name="i" value="<%=pageList_e%>">	
<li class="page-item">      
      <input class="page-link"  type="submit" name="pageRight" value=">>">      
    
    </li>
    </li>
    
  </ul>
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
