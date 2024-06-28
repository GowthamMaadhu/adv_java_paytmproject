package com.paytm.login;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class login
 */
@WebServlet("/loginservelet")
public class login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		String username=request.getParameter("User");
		String Password=request.getParameter("password");
		PrintWriter pw=response.getWriter();
		LoginBean bean=new LoginBean();
		bean.setUser(username);
		bean.setPassword(Password);
		request.setAttribute("bean",bean);
		boolean status = false;
		try {
			status = Dao.validate(bean);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		request.setAttribute("username", username);
		if (status!=false) {
			RequestDispatcher rd=request.getRequestDispatcher("loginSuccess.jsp");
			rd.forward(request,response);
		}
		else {
			RequestDispatcher rd=request.getRequestDispatcher("loginerror.jsp");
			pw.println(username);
			rd.forward(request,response);
			System.out.println(username);
			
		}
		
	}

}
