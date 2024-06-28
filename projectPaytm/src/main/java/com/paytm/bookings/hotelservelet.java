package com.paytm.bookings;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class hotelservelet
 */
@WebServlet("/hotelservelet")
public class hotelservelet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public hotelservelet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html");
		PrintWriter pw=response.getWriter();
		pw.println("<table align='center'border='1'> ");          
		pw.println(" <tr>");
		 pw.println("  <th>Hotel_Name</th>");
		 pw.println("  <th>Price</th>");
		 pw.println("   <th>Book</th>");
		 pw.println("</tr>");
		
		String city=request.getParameter("cityname");
		pw.println(city);
		String user=request.getParameter("username");
		pw.println(user);
		try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con=DriverManager.getConnection("jdbc:mysql://localhost/paytmproject","root","Gowtham@123");
		String sql="select hotelname,price from hotelbookings where city=?";
		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, city);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()){	
		
			pw.println("<tr>");
			pw.println("<td>");
		rs.getString("hotelname");
		pw.println("</td><td>");
		rs.getInt("price");
		pw.println("</td><td>");
		String hotelName = rs.getString("hotelname");

		// Assuming you're using PrintWriter pw to write output
		pw.println("<a href='bookings.jsp?hotelname=" + hotelName + "'>");
		pw.print(" Book");
		 pw.println("</a></td>");
		pw.println("</tr>");
		
		}
		}catch(Exception e) {
			e.printStackTrace();
		}
		

		pw.println("</table>");
}
}