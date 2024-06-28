package com.paytm.deposite;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class wallet
 */
@WebServlet("/wallet")
public class wallet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public wallet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
		response.setContentType("text/html");
		int accno=Integer.parseInt(request.getParameter("accno"));
		String holder=request.getParameter("name");
		int isfc=Integer.parseInt(request.getParameter("isfc"));
		String branch=request.getParameter("branch");
		double amount=Double.parseDouble(request.getParameter("amoont"));
		PrintWriter pw=response.getWriter();
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con=DriverManager.getConnection("jdbc:mysql://localhost/paytmproject","root","Gowtham@123");
			String sql="insert into account values(?,?,?,?,?);";
			PreparedStatement pst=con.prepareStatement(sql);
			pst.setInt(1, accno);
			pst.setString(2, holder);
			pst.setInt(3, isfc);
			pst.setString(4, branch);
			pst.setDouble(5, amount);
			int i=pst.executeUpdate();
			if(i!=0) {
				pw.println("<h1>amount adding sucesfully</h1>");
			}
			else {
				pw.println("<h1>failed amount adding:(</h1>");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
	}

}
