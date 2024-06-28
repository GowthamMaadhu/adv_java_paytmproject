package com.paytm.moneytransfer;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class acctransferservelet
 */
@WebServlet("/acctransferservelet")
public class acctransferservelet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		String username=request.getParameter("username");
		String accnumber=request.getParameter("accountnumber");
		String name=request.getParameter("accountholder");
		String ifsc=request.getParameter("ifsccode");
		int money=Integer.parseInt(request.getParameter("money"));
		PrintWriter pw=response.getWriter();
		pw.println("<!DOCTYPE html>");
		pw.println("<html lang=\"en\">");
		pw.println("<head>");
		pw.println("<meta charset=\"UTF-8\">");
		pw.println("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
		pw.println("<title>Withdrawal Status</title>");
		// Bootstrap CSS link
		pw.println("<link rel='stylesheet' href='css/bootstrap.css'>");
		pw.println("</head>");
		pw.println("<body>");
		pw.println("<div class=\"container\">");
		pw.println(username);
		 Connection con = null;
		    try {
		        Class.forName("com.mysql.cj.jdbc.Driver");
		        con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");

		        int balance1 = checkBalance(con, username);
		        System.out.println(balance1);
		        if (money <= balance1) {
		            int finalAmount = balance1 - money;
		            withdraw(con, username, finalAmount);
		            recordTransaction( con, username,  accnumber, name , ifsc, money);
		            pw.println("<div class=\"alert alert-success\" role=\"alert\">");
		            pw.println("Withdrawal of " + money + " successful. New balance: " + finalAmount);
		            pw.println("</div>");
		        } else {
		        	 pw.println("<div class=\"alert alert-danger\" role=\"alert\">");
		             pw.println("Insufficient funds. Please check your balance.");
		             pw.println("</div>");
		        }

		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        try {
		            if (con != null) {
		                con.close(); // Close the connection
		            }
		        } catch (SQLException ex) {
		            ex.printStackTrace();
		        }
		    }
		    pw.println("</div>"); // Close container
		    pw.println("</body>");
		    pw.println("</html>");
		}
	 private int checkBalance(Connection con,String username) throws Exception{
	        int balance=0;
	       // BigInteger balance=BigInteger.ZERO;
	        try {
	           // Class.forName("com.mysql.cj.jdbc.Driver");
	           //Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");
	            PreparedStatement stmt = con.prepareStatement("SELECT balance FROM userdata WHERE username = ?");
	            stmt.setString(1, username);
	            //stmt.setInt(2, balance);
	            ResultSet rs = stmt.executeQuery();
	            if (rs.next()) {
	                balance = rs.getInt(1);
	                System.out.println(balance);
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return balance;
	    }
	  private void withdraw(Connection con,String username,  int finalamount) throws SQLException {
	        PreparedStatement stmt = con.prepareStatement("UPDATE userdata SET balance = ? WHERE username = ?");
	        stmt.setInt(1, finalamount);
	        stmt.setString(2, username);
	        stmt.executeUpdate();
	       
	    }
	  private void recordTransaction(Connection con,String username, String accnumber, String name ,String ifsc, int money) throws SQLException {
	        PreparedStatement stmt = con.prepareStatement(
	                "INSERT INTO payment_history (username,timestamp,accountnumber,accountholdername,ifsccode,transationamount_account) VALUES (?,NOW(),?,?,?,?)");
	        stmt.setString(1, username);
	        stmt.setString(2, accnumber);		        
	        stmt.setString(3, name);
	        stmt.setString(4, ifsc);
	        stmt.setInt(5, money);
	        stmt.executeUpdate();
	    }
	 
	
	}


