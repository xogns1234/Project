package controller;

import java.io.IOException;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import membership.MemberDAO;
import membership.MemberDTO;



public class deleteMemberform extends HttpServlet {
	
       

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		deleteMemberAction(request, response);
		
	}
	public void deleteMemberAction(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	HttpSession session = request.getSession(); 
	
	request.setCharacterEncoding("utf-8");
	
	String id = (String)session.getAttribute("UserId");
	
	
	MemberDAO dao = new MemberDAO();
	MemberDTO memberDTO = dao.getDeleteMemberDTO(id);
	
	session.invalidate();
	
	response.sendRedirect("/TeamProject/Member/resultMember.jsp");
}
}
