package server;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.json.JSONArray;
import org.json.JSONObject;

import java.sql.*;

import java.util.UUID;

public class Database {

    public static final HikariDataSource ds;

    static {
        // from https://github.com/brettwooldridge/HikariCP#rocket-initialization
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:postgresql://localhost:5432/");
        config.setUsername("postgres");
        config.setPassword(System.getenv("POSTGRES_PASSWORD"));
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

        ds = new HikariDataSource(config);
    }

    /**
     *
     * @param id A UUID
     * @return A json encoding String of the Paint with the given UUID.
     */
    public static String getPaint(UUID id) {
        try (Connection con = ds.getConnection()) {
            PreparedStatement p = con.prepareStatement("SELECT * FROM Paints WHERE id=?;");
            p.setObject(1, id);
            ResultSet r = p.executeQuery();
            String json = convertPaintToJSONObj(r).toString(3);
            return json;
        }
        catch (SQLException e) {
            //maybe not the best option
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return "";
    }

    /**
     *
     * @return A json encoding String of all paint names and their id.
     */
    public static String getAllPaints() {
        try (Connection con = ds.getConnection()) {
            PreparedStatement p = con.prepareStatement("SELECT name, id, imgURL FROM Paints;");
            ResultSet r = p.executeQuery();
            String json = convertToJSONArray(r).toString(3);
            return json;
        }
        catch (SQLException e) {
            //maybe not the best option
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return "";
    }
    //credit: https://stackoverflow.com/questions/36562487/resultset-to-json-using-gson
    public static JSONArray convertToJSONArray(ResultSet resultSet)
            throws Exception {
        JSONArray jsonArray = new JSONArray();
        while (resultSet.next()) {
            int total_columns = resultSet.getMetaData().getColumnCount();
            JSONObject obj = new JSONObject();

            for (int i = 0; i < total_columns; i++) {
                obj.put(resultSet.getMetaData().getColumnLabel(i + 1).toLowerCase(), resultSet.getObject(i + 1));
            }
            jsonArray.put(obj);
        }
        return jsonArray;
    }

    public static JSONObject convertPaintToJSONObj(ResultSet resultSet)
            throws Exception {
        if (resultSet.next()) {
            int total_columns = resultSet.getMetaData().getColumnCount();
            JSONObject obj = new JSONObject();
            for (int i = 0; i < total_columns; i++) {
                obj.put(resultSet.getMetaData().getColumnLabel(i + 1).toLowerCase(), resultSet.getObject(i + 1));
            }
            return obj;
        }
        return null;
    }
}
