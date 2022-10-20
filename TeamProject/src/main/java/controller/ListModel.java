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
		if(request.getParameter("deletePost")!= null) { // get Ÿ���� ������ ���� ��� �ǳ�?
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
		// ����ڰ� �Է��� �˻� ������ Map�� ����		
		Map<String, Object> param = new HashMap<String, Object>();
		String searchField = request.getParameter("searchField");
		request.setAttribute("searchField", searchField);
		String searchWord = request.getParameter("searchWord");
		String pageNum = request.getParameter("pageNum"); // ������ ����Ʈ�� �ѹ�
		String pageLeft = request.getParameter("hdnbt");	// ���� ��ư ���� ���� Ȯ�ο�
		String pageList = request.getParameter("i");		// ���� �������� ���� ������ �������� ����
		String pageRight = request.getParameter("pageRight"); // ���� ��ư ���� ���� Ȯ�ο�
		System.out.println(pageRight);
		if(pageNum == null){ // �ʱ� ���������� null �� ��� 1�� ���� �־���
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
			totalCount = dao.selectCount2(param);  // �Խù� �� Ȯ��
			totalBoard = dao.selectCount2(param);
			boardLists = dao.selectList2(param);  // �Խù� ��� �ޱ�
			dao.close();  // DB ���� �ݱ�
			if(session.getAttribute("UserId") == null){			
			}else{			
			}
		}else{	
			totalCount = dao.selectCount(param);  // �Խù� �� Ȯ��
			totalBoard = dao.selectCount(param);
			boardLists = dao.selectList(param);  // �Խù� ��� �ޱ�
			dao.close();  // DB ���� �ݱ�
		}
		int plusList = 0;
		request.setAttribute("totalCount", totalCount);
	    int pageNum_ = Integer.parseInt(pageNum);
	    int pageNum_chk_s = (pageNum_-1)*10;
	    int pageNum_chk_e = pageNum_chk_s+10;
	    if(pageNum_ == 1) { // 1������ �ʱⰪ ����   	
	    	pageNum_chk_s =0;
	    	pageNum_chk_e = 10;
	    }
	    if(pageNum_chk_e/10 == Math.ceil((double)totalBoard/10)) pageNum_chk_e = totalBoard;  // ������ ���������� +10 ���� ���� �Խù� �� ������ ����� �ǹ�
		

		if(pageRight != null) plusList = Integer.parseInt(pageList)-1;	// ������ ����Ʈ ���� ��ư�� ������ �ʾ��� ���, ������Ʈ �� ���� null �϶� ���� ����
		if(pageLeft != null &&!pageLeft.equals("")) {					// // ������ ����Ʈ ���� ��ư�� ������ �ʾ��� ���, ������Ʈ �� ���� null �϶� ���� ����
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

		int pageList_s = 1 + plusList;	// ������ ����Ʈ ��ư ��ŸƮ
		int pageList_e = pageList_s+5;	// ������ ����Ʈ ��ư ����
		if(pageList_s<1) { // ������ ����Ʈ�� ��ŸƮ ������ 1 ���� �� �� �ʱⰪ ����
			pageList_s = 1;	
			pageList_e = 6;
		}
		if(pageList_e>Math.ceil((double)totalBoard/10)+1){ // ��ư�� ���� �� �Խù�/10 +1�� �ʰ������� 
			pageList_e =(int) Math.ceil((double)totalBoard/10)+1;
			pageList_s =pageList_e-5;		
			if(pageList_s<1){
				pageList_s = 1;
			}
		}	
		if(Integer.parseInt(pageNum)>1 && pageRight == null && pageLeft == null){ // ������ ���� ��ư�� ��������
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
			if(pageList_e>Math.ceil((double)totalBoard/10)+1){	// ������ ����Ʈ�� ������ ��ư�� �� �Խù�/10 +1 �� �ʰ����� ��		
				pageList_e =(int) Math.ceil((double)totalBoard/10)+1;			
				pageList_s =pageList_e-5;			
			}
			if(pageList_s<1){ // ������ ����Ʈ�� ��ŸƮ ������ 1 ���� �� �� �ʱⰪ ����
				pageList_s = 1;
			}
		}
		if(pageList_e<2) { //������ ����Ʈ�� ���� ������ 2 ���� �� �� �ʱⰪ ����(���� �̾߱��ؼ� ���� ���ڰ� ��� �������� ���� �� ������ �߻����� �ʵ��� ���� �ɾ��ִ°�)
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
		String num = request.getParameter("num"); // ��Ȯ�� ������ �� �� ������ null�� String Ÿ������ �޾����´�, ���ڿ��� �޾�����. ���ڵ� �����߿��� �׷��� �Ǵ°ǰ�..? --> ���ԵǸ鼭 �������� �Ѿ��
		BoardDTO Bdto = new BoardDTO();
		BoardDAO Bdao = new BoardDAO();		
		int result = 0;
		if(!num.equals("null")){ // �� ����
			
			Bdto.setTitle(title);
			Bdto.setContent(content);
			Bdto.setNum(num);			
			
			result = Bdao.updateEdit(Bdto);
			if(result>0){
				System.out.println("�Խñ� ���� ����");
				
			}else{
				System.out.println("�Խñ� ���� ����");				
			}			
		}
		else { // �� ���
			
			Bdto.setTitle(title);
			Bdto.setContent(content);
			Bdto.setId(userId);			
			
			result = Bdao.insertWrite(Bdto);
			if(result>0){
				System.out.println("�Խñ� ��� ����");
				
			}else{
				System.out.println("�Խñ� ��� ����");				
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
			System.out.println("�Խñ� ���� ����");
			
		}else{
			System.out.println("�Խñ� ���� ����");		
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