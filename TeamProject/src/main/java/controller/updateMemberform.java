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

import java.util.*;



public class updateMemberform extends HttpServlet {



	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		if(request.getParameter("update")!= null) {
			updateMemberAction(request, response);	
		}		
		if(request.getParameter("chkupdate")!= null) {
			chkUpdateMember(request, response);
		}
	}
	
	public void updateMemberAction(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {	
		
		String id = request.getParameter("id");
		String pass = request.getParameter("pass");
		String name = request.getParameter("name");
		String address = request.getParameter("address");
		String pwfind = request.getParameter("pwfind");
		String phone = request.getParameter("phone");
		
		Date currentDatetime = new Date(System.currentTimeMillis());
		java.sql.Date sqlDate = new java.sql.Date(currentDatetime.getTime());
		java.sql.Timestamp timestamp = new java.sql.Timestamp(currentDatetime.getTime()); 
		
		MemberDAO dao = new MemberDAO();		
		MemberDTO memberDTO = dao.getupdateMemberDTO(id, pass, name, address, pwfind, phone);
		
		response.sendRedirect("/TeamProject/Member/resultMember.jsp?msg=0");
		
		//request.getRequestDispatcher("/member/updatgeMember.jsp").forward(request, response);
	}
	
	public void chkUpdateMember(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		String id = request.getParameter("id");
		String pass = request.getParameter("pass");
		String id_chk = (String)session.getAttribute("UserId");
		//String pass_chk = (String)session.getAttribute("UserPw");
		MemberDAO dao = new MemberDAO();
		MemberDTO dto = dao.getMemberDTO(id, pass);		
		
		if(dto.getPass() != null && id.equals(id_chk)) {
			request.setAttribute("addr", dto.getAddress());
			request.setAttribute("phone", dto.getPhone());
			request.setAttribute("pwfind", dto.getPwfind());
			request.setAttribute("name", dto.getName());			
			/* response.sendRedirect("/TeamProject/Member/updateMember.jsp?a=true"); */
			request.getRequestDispatcher("updateMember.jsp?a=true").forward(request, response);
		}		
		else {
			response.sendRedirect("/TeamProject/Member/updateMember.jsp?a=false");
		}
		
		
	}
		
}
