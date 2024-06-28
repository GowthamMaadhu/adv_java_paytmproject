package com.paytm.login;
import java.sql.*;
import static com.paytm.login.connection.*;

public class logindao {
   

    public static Connection getCon() throws Exception {
        Connection con = null;
        try {
            Class.forName(driver);
            con = DriverManager.getConnection(url, name, pwd);
        } catch (Exception e) {
            e.printStackTrace();
            throw e; // Rethrow the exception to propagate it to the caller
        }
        return con;
    }
}
 
