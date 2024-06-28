package com.pytm.registratiojn;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.paytm.login.Dao;

/**
 * Servlet implementation class register
 */
@WebServlet("/registerservelet")
public class register extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		String username=request.getParameter("username");
		String password=request.getParameter("password");
		String mobilenumber=request.getParameter("mobilenumber");
		String email=request.getParameter("email");
		String gender=request.getParameter("gender");
		String accno=request.getParameter("accno");
		String holder=request.getParameter("name");
		String isfc=request.getParameter("isfc");
		String branch=request.getParameter("branch");
		
		PrintWriter pw=response.getWriter();
		Registerbean rb=new Registerbean();
		rb. setUsername(username);
		rb.setPassword(password);
		rb.setMobilenumber(mobilenumber);
		rb.setEmail(email);
		rb.setGender(gender);
		rb.setAccno(accno);
		rb.setHolder(holder);
		rb.setBranch(branch);
		rb.setIsfc(isfc);
		
		
		//request.setAttribute("rb",bean);
		 boolean status = false;
	        String message = "";
	        try {
	            // Check if username already exists
	            if (registerconnection.isUsernameExists(username)) {
	                // Username already exists
	                message = "Username " + username + " already exists. Please try with another username.";
	            } else {
	                status = registerconnection.validate(rb);
	                if (status) {
	                    message = "Registration successful! Please login.";
	                    RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
	                    rd.include(request, response);
	                } else {
	                    message = "Registration failed. Please try again.";
	                }
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            message = "An error occurred. Please try again.";
	        }

	        // Include the message in a hidden input field
	        pw.println("<html>");
	        pw.println("<head>");
	        pw.println("<script type='text/javascript'>");
	        pw.println("function showMessage() {");
	        pw.println("    var message = document.getElementById('message').value;");
	        pw.println("    if (message) {");
	        pw.println("        alert(message);");
	        pw.println("    }");
	        pw.println("}");
	        pw.println("</script>");
	        pw.println("</head>");
	        pw.println("<body onload='showMessage()'>");
	        pw.println("<input type='hidden' id='message' value='" + message + "'>");
	        /*RequestDispatcher rd = request.getRequestDispatcher("register.jsp");
	        rd.include(request, response);*/
	        pw.println("</body>");
	        pw.println("</html>");
	    }
	}
