package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model1.board.BoardDAO;
import model1.board.BoardDTO;
import model1.board.CommentDAO;
import model1.board.CommentDTO;
import model1.board.ReplyDAO;
import model1.board.ReplyDTO;

@WebServlet("/ListModel")
public class ListModel extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("utf-8");
		if (request.getParameter("List") != null || request.getParameter("pageNum") != null 
				|| request.getParameter("searchWord")!= null || request.getParameter("searchField")!= null) {
			ListPageNation(request, response);
		
		}
		if(request.getParameter("comment") != null) {
			insertComment(request, response);
			
		}
		
		if(request.getParameter("deletePK") != null) {
			deleteComment(request, response);
		}
		if(request.getParameter("replyDelete") != null) {
			deleteReply(request, response);
		}				
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("utf-8");
		if(request.getParameter("pageRight") != null || request.getParameter("hdnbt") != null) ListPageNation(request, response);
	
		if(request.getParameter("write") !=null) {
			write(request, response);			
		}	
		if(request.getParameter("deletePost")!= null) { // get 타입은 별도의 조건 없어도 되나?
			deleteBoard(request, response);
		}
		if(request.getParameter("comment") != null) {
			insertComment(request, response);			
		}
		if(request.getParameter("insertReply") != null) {
			insertReply(request, response);			
		}
		
	}
	
	public void ListPageNation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		BoardDAO dao = new BoardDAO();
		HttpSession session = request.getSession();
		// 사용자가 입력한 검색 조건을 Map에 저장		
		Map<String, Object> param = new HashMap<String, Object>();
		String searchField = request.getParameter("searchField");
		request.setAttribute("searchField", searchField);
		String searchWord = request.getParameter("searchWord");
		String pageNum = request.getParameter("pageNum"); // 페이지 리스트의 넘버
		String pageLeft = request.getParameter("hdnbt");	// 이전 버튼 동작 여부 확인용
		String pageList = request.getParameter("i");		// 지금 시점에서 가장 마지막 페이지의 숫자
		String pageRight = request.getParameter("pageRight"); // 다음 버튼 동작 여부 확인용
		System.out.println(pageRight);
		if(pageNum == null){ // 초기 페이지에서 null 값 대신 1을 집어 넣어줌
			pageNum ="1";
		}
		request.setAttribute("pageNum", pageNum);
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
		int plusList = 0;
		request.setAttribute("totalCount", totalCount);
	    int pageNum_ = Integer.parseInt(pageNum);
	    int pageNum_chk_s = (pageNum_-1)*10;
	    int pageNum_chk_e = pageNum_chk_s+10;
	    if(pageNum_ == 1) { // 1페이지 초기값 설정   	
	    	pageNum_chk_s =0;
	    	pageNum_chk_e = 10;
	    }
	    if(pageNum_chk_e/10 == Math.ceil((double)totalBoard/10)) pageNum_chk_e = totalBoard;  // 마지막 페이지에선 +10 하지 말고 게시물 총 개수를 쓰라는 의미
		

		if(pageRight != null) plusList = Integer.parseInt(pageList)-1;	// 페이지 리스트 이전 버튼을 누르지 않았을 경우, 리퀘스트 된 값이 null 일때 오류 방지
		if(pageLeft != null &&!pageLeft.equals("")) {					// // 페이지 리스트 다음 버튼을 누르지 않았을 경우, 리퀘스트 된 값이 null 일때 오류 방지
			plusList = (Integer.parseInt(pageList)-1);
			int plusListChk =0;
			for(int i=4; i>-1; i--){
				int c = 0;
				if(plusList%5 ==i){
					if(i==0) c = 5;
					plusListChk = plusList-(5+i+c);
				}
			}
			plusList = plusListChk;
		}

		int pageList_s = 1 + plusList;	// 페이지 리스트 버튼 스타트
		int pageList_e = pageList_s+5;	// 페이지 리스트 버튼 엔드
		if(pageList_s<1) { // 페이지 리스트의 스타트 지점이 1 이하 일 때 초기값 설정
			pageList_s = 1;	
			pageList_e = 6;
		}
		if(pageList_e>Math.ceil((double)totalBoard/10)+1){ // 버튼의 수가 총 게시물/10 +1을 초과했을때 
			pageList_e =(int) Math.ceil((double)totalBoard/10)+1;
			pageList_s =pageList_e-5;		
			if(pageList_s<1){
				pageList_s = 1;
			}
		}	
		if(Integer.parseInt(pageNum)>1 && pageRight == null && pageLeft == null){ // 페이지 숫자 버튼을 눌렀을때
			pageList_s = Integer.parseInt(pageNum);
			int listLength = 0;
			for(int i = 0; i<5; i++){
				if(pageList_s%5 == i){
					listLength = i;
					if(i == 0) listLength = 5;
					pageList_s = pageList_s-(listLength)+1;
				}
			}		
			pageList_e = pageList_s+5;
			if(pageList_e>Math.ceil((double)totalBoard/10)+1){	// 페이지 리스트의 마지막 버튼이 총 게시물/10 +1 을 초과했을 때		
				pageList_e =(int) Math.ceil((double)totalBoard/10)+1;			
				pageList_s =pageList_e-5;			
			}
			if(pageList_s<1){ // 페이지 리스트의 스타트 지점이 1 이하 일 때 초기값 설정
				pageList_s = 1;
			}
		}
		if(pageList_e<2) { //페이지 리스트의 엔드 지점이 2 이하 일 때 초기값 설정(쉽게 이야기해서 글의 숫자가 적어서 페이지가 적을 때 오류가 발생하지 않도록 조건 걸어주는것)
			pageList_s =1;
			pageList_e =2;
		}	
		request.setAttribute("pageList_s", pageList_s);
		request.setAttribute("pageList_e", pageList_e);
		request.setAttribute("pageNum_chk_s", pageNum_chk_s);
		request.setAttribute("pageNum_chk_e", pageNum_chk_e);
		request.setAttribute("boardLists", boardLists);
		
		
		request.getRequestDispatcher("List.jsp").forward(request, response);
	}
	
	public void write(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{		
		request.setCharacterEncoding("utf-8"); //
		
		HttpSession session = request.getSession();
		String title = request.getParameter("title");
		String content = request.getParameter("content");
		String userId = session.getAttribute("UserId").toString();
		String num = request.getParameter("num"); // 명확한 이유는 알 수 없으나 null이 String 타입으로 받아져온다, 문자열로 받아진다. 인코딩 과정중에서 그렇게 되는건가..? --> 서밋되면서 공란으로 넘어옴
		BoardDTO Bdto = new BoardDTO();
		BoardDAO Bdao = new BoardDAO();		
		int result = 0;
		if(!num.equals("null")){ // 글 수정
			
			Bdto.setTitle(title);
			Bdto.setContent(content);
			Bdto.setNum(num);			
			
			result = Bdao.updateEdit(Bdto);
			if(result>0){
				System.out.println("게시글 수정 성공");
				
			}else{
				System.out.println("게시글 수정 실패");				
			}			
		}
		else { // 글 등록
			
			Bdto.setTitle(title);
			Bdto.setContent(content);
			Bdto.setId(userId);			
			
			result = Bdao.insertWrite(Bdto);
			if(result>0){
				System.out.println("게시글 등록 성공");
				
			}else{
				System.out.println("게시글 등록 실패");				
			}		
		}		
		Bdao.close();
		response.sendRedirect("ListModel.li?List=List");
	}
	
	public void deleteBoard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String num = request.getParameter("num");
		BoardDAO Bdao = new BoardDAO();
		BoardDTO Bdto = Bdao.selectView(num);
		
		int result =  Bdao.deletePost(Bdto);
		Bdao.close();
		if(result>0){
			System.out.println("게시글 삭제 성공");
			
		}else{
			System.out.println("게시글 삭제 실패");		
		}
		response.sendRedirect("ListModel.li?List=List");
	}
	
	public void insertComment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();		
		String num = request.getParameter("num");
		//String pageNum = request.getParameter("pageNum");
		String content = request.getParameter("comment");
		String id = (String) session.getAttribute("UserId");		
		
		CommentDAO dao = new CommentDAO();
		CommentDTO dto = new CommentDTO();
		dto.setContent(content);
		dto.setId(id);
		dto.setNum(Integer.parseInt(num));		
		dao.insertComment(dto);
		
		response.sendRedirect("View.jsp?num="+num);
		
		dao.close();		
	}
	
	public void deleteComment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();	
		String deletePK = request.getParameter("deletePK");
		String num = request.getParameter("num");
		String id = (String) session.getAttribute("UserId");
		
		CommentDAO dao = new CommentDAO();	
		
		dao.deleteComment(Integer.parseInt(deletePK),id);
		response.sendRedirect("View.jsp?num="+num);
	}
	
	public void insertReply(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();		
		String num = request.getParameter("num");
		String selectPK = request.getParameter("selectPK");
		String content = request.getParameter("content");
		String scroll = request.getParameter("scroll");
		String id = (String) session.getAttribute("UserId");
			
		
		ReplyDAO dao = new ReplyDAO();
		ReplyDTO dto = new ReplyDTO();
		dto.setContent(content);
		dto.setId(id);
		dto.setNum(Integer.parseInt(num));
		dto.setSelectPK(Integer.parseInt(selectPK));
		dao.insertReply(dto);
		
		response.sendRedirect("View.jsp?num="+num+"&&scroll="+scroll);
		
		dao.close();		
	}
	
	public void deleteReply(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();	
		String deletePK = request.getParameter("replyDelete");
		String num = request.getParameter("num");
		String id = (String) session.getAttribute("UserId");
		
		ReplyDAO dao = new ReplyDAO();	
		
		dao.deleteReply(Integer.parseInt(deletePK),id);
		response.sendRedirect("View.jsp?num="+num);
	}
}