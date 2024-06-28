package com.paytm.transaction;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class paymentservelet
 */
@WebServlet("/paymentservelet")
public class paymentservelet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action=request.getParameter("action");
		response.setContentType("text/html");
		//PrintWriter pw=response.getWriter();
		if(action.equals("mobilenumber")) {
			RequestDispatcher rd=request.getRequestDispatcher("mobilenumber.jsp");
			rd.forward(request,response);		
		}
		else if(action.equals("account")) {
			RequestDispatcher rd=request.getRequestDispatcher("account.jsp");
			rd.forward(request,response);
		}

	}

}
