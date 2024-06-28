package com.pytm.registratiojn;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.paytm.login.*;
public class registerconnection {
	public static boolean validate(Registerbean bean) throws SQLException {
		boolean status=false;
		Connection con=null;
	
	try{  
		con=logindao.getCon();
		String sql="INSERT INTO userdata (username, password, mobilenumber, gender, email, accno, accholder_name, isfc_code, branch) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		              
		try(PreparedStatement ps=con.prepareStatement(sql)){ 
		  
		ps.setString(1,bean.getUsername());  
		ps.setString(2, bean.getPassword());  
		ps.setString(3, bean.getMobilenumber());
		ps.setString(5, bean.getEmail());
		ps.setString(4,bean.getGender());
		ps.setString(6, bean.getAccno());
		ps.setString(7, bean.getHolder());
		ps.setString(8,bean.getIsfc());
		ps.setString(9, bean.getBranch());
		
		              
		int i=ps.executeUpdate();
		if(i!=0) {
			status=true;
		}
		else {
			status=false;
		}
		
		//status=rs.next(); 		              
		}
	catch(Exception e){
		e.printStackTrace();
	}  
		  System.out.println(status);
		//return status;  
		  
	}catch(Exception e) {
		e.printStackTrace();
	}
	return status;
	}

	public static boolean isUsernameExists(String username) throws Exception {
		Connection con = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    boolean exists = false;

	    try {
	        con = logindao.getCon();
	        String sql = "SELECT COUNT(*) FROM userdata WHERE username = ?";
	        ps = con.prepareStatement(sql);
	        ps.setString(1, username);
	        rs = ps.executeQuery();
	        if (rs.next()) {
	            int count = rs.getInt(1);
	            exists = count > 0;
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        // Close resources
	        if (rs != null) rs.close();
	        if (ps != null) ps.close();
	        if (con != null) con.close();
	    }
	    
	    return exists;
	}
	}


	
	
	


