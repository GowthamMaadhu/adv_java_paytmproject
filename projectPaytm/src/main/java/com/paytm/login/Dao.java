package com.paytm.login;
import java.sql.*;
import static com.paytm.login.connection.*;


public class Dao {
	
	public static boolean validate(LoginBean bean) throws SQLException {
		boolean status=false;
	
	try(Connection con=logindao.getCon()){  
		String sql="SELECT username,password FROM userdata WHERE username = ? AND password = ?";
		              
		try(PreparedStatement ps=con.prepareStatement(sql)){ 
		  
		ps.setString(1,bean.getUser());  
		ps.setString(2, bean.getPassword());  
		              
		ResultSet rs=ps.executeQuery();
		
		while(rs.next()) {
		
			status=true;
		}
		
		}
	catch(Exception e){
		e.printStackTrace();
	}  
		  System.out.println(status);
		//return status;  
		  
		}catch(Exception e){
			e.printStackTrace();
		} 
	return status; 

}
	
}