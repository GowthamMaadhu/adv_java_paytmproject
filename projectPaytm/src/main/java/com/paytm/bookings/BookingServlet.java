package com.paytm.bookings;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class BookingServlet
 */
@WebServlet(name = "BookingServlets", urlPatterns = { "/BookingServlets" })
public class BookingServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username=request.getParameter("username");
		System.out.println(username);
		String action=request.getParameter("action");
		//PrintWriter pw=response.getWriter();
		request.setAttribute("username", username);
		if (action.equals("hotel")) {
			RequestDispatcher rd=request.getRequestDispatcher("hoteltickets.jsp");
			rd.forward(request,response);
		}
		else if(action.equals("movie")) {
			RequestDispatcher rd=request.getRequestDispatcher("movietickets.jsp");
			rd.forward(request,response);
			
		}
		else if(action.equals("train")) {
			RequestDispatcher rd=request.getRequestDispatcher("traintickets.jsp");
			rd.forward(request,response);
			
		}
		else if(action.equals("bus")) {
			RequestDispatcher rd=request.getRequestDispatcher("bustickets.jsp");
			rd.forward(request,response);
			
		}
		else if(action.equals("bookinghis")) {
			RequestDispatcher rd=request.getRequestDispatcher("bookinghistory.jsp");
			rd.forward(request,response);
			request.setAttribute("username", username);

			
		}
	}

}
