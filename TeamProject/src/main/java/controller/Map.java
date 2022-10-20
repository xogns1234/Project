package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.security.auth.message.callback.PrivateKeyCallback.Request;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import membership.UploadDAO;
import membership.UploadDTO;

public class Map extends HttpServlet {
	private static final long serialVersionUID = 1L;
         
    public Map() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		if(request.getParameter("outputmap") != null) {
		try {
			dataUpdate(request, response);
		} catch (ServletException | IOException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			}
		}		
		if(request.getParameter("num")!= null && request.getParameter("id") == null) {
			try {
				deleteData(request, response);
			} catch (ServletException | IOException | SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
		
		if(request.getParameter("num")!= null && request.getParameter("id")!= null) {
			System.out.println("123");
			try {
				reportUser(request, response);
			} catch (ServletException | IOException | SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if(request.getParameter("keyword") != null) {
			try {
				keyWord(request, response);
			} catch (ServletException | IOException | SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");		
		if(request.getParameter("inputmap") != null) {
		try {
			dataUpload(request, response);
		} catch (ServletException | IOException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			}
		}
		if(request.getParameter("keyword") != null) {
			try {
				keyWord(request, response);
			} catch (ServletException | IOException | SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public void dataUpload(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
		UploadDAO dao = new UploadDAO();
		HttpSession session = request.getSession();
		String id = (String) session.getAttribute("UserId");
		String lat = request.getParameter("lat");
		String lon = request.getParameter("lon");
		String memo = request.getParameter("memo");
		String title = request.getParameter("title");
		
		dao.upload(lat, lon, memo, title,id);		
		response.sendRedirect("map.jsp");	
		dao.close();
	}
	
	public void dataUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
		UploadDAO dao = new UploadDAO();		
		
		List<UploadDTO> arr =dao.getUpload();		

		Gson gson = new Gson();
		String listJson = gson.toJson(arr);
//		System.out.println(listJson);
		request.setAttribute("UploadDTO", listJson);
		request.getRequestDispatcher("outputMap.jsp").forward(request, response);
		dao.close();
	}
	public void deleteData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
		String num= request.getParameter("num");		
		
		UploadDAO dao = new UploadDAO();
		dao.deleteUploadData(Integer.parseInt(num));
		
		response.sendRedirect("Map.map?outputmap=outputmap");		
	}
	
	public void reportUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
		int num= Integer.parseInt(request.getParameter("num"));
		String id= request.getParameter("id");
		int count= Integer.parseInt(request.getParameter("count"));
		System.out.println(num+id+count);
		UploadDAO dao = new UploadDAO();
		dao.reportUser(num, id, count);
		
		response.sendRedirect("Map.map?outputmap=outputmap");
	}
	
	public void keyWord(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
		String keyword = request.getParameter("keyword");
		System.out.println(keyword);
		request.getRequestDispatcher("map.jsp").forward(request, response);
		
		
	}
}

