package com.paytm.deposite;
import java.sql.*;

public class emp {

	public static void main(String[] args) throws Exception {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con=DriverManager.getConnection("jdbc:msql://localhost/paytmproject","root","Gowtham@123");
		String sql="select accno from account";
		Statement st=con.createStatement();
		ResultSet rs=st.executeQuery(sql);
		while(rs.next()) {
			System.out.println(rs.getInt(1));
		}
		
		

	}

}
