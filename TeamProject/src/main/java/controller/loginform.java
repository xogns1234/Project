package controller;

import java.io.IOException;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.taglibs.standard.lang.jstl.test.beans.PublicBean1;

import java.util.*;
import com.mysql.cj.Session;

import membership.*;

//@WebServlet("/control/loginform.do")
public class loginform extends HttpServlet {
//	private static final long serialVersionUID = 1L;
//       
//
//    public loginform() {
//        super();
//        
//    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
	
//		loginAction.getRequestDispatcher("/member.loginMeber.jsp").forward(request, response);
		
		if(request.getParameter("log") != null) {
		loginAction(request, response);
		}
		
		if(request.getParameter("fpw") != null) {
			FindAction(request, response);
		}
		
		if(request.getParameter("findid") != null) {
			FindIdAction(request,response);
		}

		
	}
	

	public void loginAction(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		HttpSession session = request.getSession(); 
		request.setCharacterEncoding("UTF-8");
		
		
		String id = request.getParameter("id");
		String pass = request.getParameter("pass");
		
	
		
		MemberDAO dao = new MemberDAO();
		MemberDTO memberDTO = dao.getMemberDTO(id, pass);
		
		session.setAttribute("UserId", memberDTO.getId());
		session.setAttribute("UserPw", memberDTO.getPass());
		
		response.sendRedirect("/TeamProject/Member/resultMember.jsp?msg=2");
		
		//request.getRequestDispatcher("/member/loginMember.jsp").forward(request, response);
		
		dao.close();
		
		
	}
	
	public void FindAction(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {		
		
		
		
		String id = request.getParameter("id");
		String findpw = request.getParameter("findpass");
		
		MemberDAO dao = new MemberDAO();
		List<MemberDTO> list = null;
		list=dao.getpwfindDTO(id, findpw);
		
		request.setAttribute ("dto", list);
		request.getRequestDispatcher("loginMember.jsp").forward(request, response);
		
		
	}
	
	public void FindIdAction(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {		
		
		String findpw = request.getParameter("findpass");
		String phone = request.getParameter("phone");
		
		MemberDAO dao = new MemberDAO();
		List<MemberDTO> list = null;
		list=dao.getIdfindDTO(findpw, phone);
		
		request.setAttribute("dtto", list);
		request.getRequestDispatcher("PwfindMember.jsp").forward(request, response);
	}
	


}
