package com.paytm.transaction;

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
 * Servlet implementation class BalanceServlet
 */
@WebServlet("/BalanceServlet")
public class BalanceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username=(String) request.getAttribute("username");
		PrintWriter pw=response.getWriter();
		pw.println(username);
	try {
		 Class.forName("com.mysql.cj.jdbc.Driver");
         Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");
         PreparedStatement stmt = conn.prepareStatement("SELECT balance FROM userdata WHERE username = ?");
         ResultSet rs=stmt.executeQuery();
         while (rs.next()) {
       	int balance=rs.getInt(1);
       	System.out.println(balance); 
       	pw.println(balance);
	}
	}catch(Exception e) {
   	 e.printStackTrace();
    }
	}
}

	

