package server;

import java.sql.*;
import java.util.Properties;

public class Database {
    public static void testing() {
        Properties prop = new Properties();
        prop.setProperty("user", "postgres");
        prop.setProperty("password", "bitconnect");
        try {
            Connection db = DriverManager.getConnection("jdbc:postgresql://localhost:5432/", prop);
            boolean b = db.isValid(10);
            PreparedStatement s = db.prepareStatement("SELECT * FROM APIKeys");
            ResultSet r = s.executeQuery();
            r.next(); //returns false if there are no elements in the result
            System.out.println("database is valid: " + b + " " + r.getString(1 ) + r.getInt(2));

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
