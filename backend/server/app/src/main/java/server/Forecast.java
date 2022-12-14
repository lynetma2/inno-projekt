package server;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;

public class Forecast {
    public static String getForecast(double longitude, double latitude) {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest req = HttpRequest.newBuilder()
                //TODO handle exceptions
                .uri(getMETAPIURI(longitude, latitude))
                //api.met.no wants contact info
                .header("User-Agent", "universityProject kaspokumu@gmail.com")
                .build();
        try {
            HttpResponse<String> r = client.send(req, HttpResponse.BodyHandlers.ofString());
            return r.body();
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
    public static JSONArray makeJudgement(JSONObject forecast, int id){
        //int dryingTime = Database.getPaintDryTime(id);
        int dryingTime = id; //TODO ONLY FOR TESTING
        JSONObject prop = forecast.getJSONObject("properties");
        JSONArray timeSeries = prop.getJSONArray("timeseries");

        List<JSONArray> daySeries = splitByDay(timeSeries);
        // find a period = dryingTime hours with good conditions.
        // TODO exclude night
        JSONArray judgement = new JSONArray();
        for (JSONArray day : daySeries) {
            //check if there are dryingTime contiguous good hours in day. If yes judgement = 1, otherwise 0.
            long longestGoodPeriod = 0;
            long currentGoodPeriod = 0;
            Iterator<Object> iter = day.iterator();
            JSONObject lastObj = (JSONObject) day.get(0);
            while(iter.hasNext()) {
                JSONObject now = (JSONObject) iter.next();
                if (goodTime(lastObj) && goodTime(now)) {
                    ZonedDateTime lastTime = ZonedDateTime.parse(((JSONObject)lastObj).getString("time"));
                    ZonedDateTime nowTime = ZonedDateTime.parse(((JSONObject)now).getString("time"));
                    currentGoodPeriod += lastTime.until(nowTime, ChronoUnit.HOURS);
                    if (currentGoodPeriod > longestGoodPeriod)
                        longestGoodPeriod = currentGoodPeriod;
                    //FDKSAOPFDÆKSAFODÆSKAF SÆDFKSAØÆF MWOEFW
                }
            }
            for (Object time : day) {
                JSONObject jTime = (JSONObject) time;
            }
        }
        return judgement;
    }

    private static boolean goodTime(JSONObject timeOfDay){
        JSONObject data = timeOfDay.getJSONObject("data");
        //JSONObject next1Hour = data.getJSONObject("next_1_hour"); only available for 3 days ahead TODO handle this
        JSONObject instant = data.getJSONObject("instant")
                .getJSONObject("details");
        JSONObject next6Hours = data.getJSONObject("next_6_hours")
                .getJSONObject("details");

        //rain check
        if (next6Hours.getDouble("precipitation_amount") > 0.)
            return false;

        //temperature check
        if (next6Hours.getDouble("air_temperature_min") < 7.)
            return false;

        //RF check
        double humidity = next6Hours.getDouble("relative_humidity");
        if (humidity < 40 || humidity > 80)
            return false;
        return true;
    }

    /**
     * Splits timeseries JSONArray by day.
     * Precondition: Array is sorted by time.
     * @param array
     * @return
     */
    private static List<JSONArray> splitByDay(JSONArray array) {
        List<JSONArray> list = new ArrayList<>();
        int index = 0;
        JSONArray curr = new JSONArray();
        ZonedDateTime time = ZonedDateTime.parse(array.getJSONObject(0).getString("time"));
        for (Object obj : array) {
            ZonedDateTime objTime = ZonedDateTime.parse(((JSONObject)obj).getString("time"));
            if (time.getDayOfMonth() == objTime.getDayOfMonth())
                curr.put(obj);
            else {
                list.add(curr);
                curr = new JSONArray();
                curr.put(obj);
                time = objTime;
            }
        }
        list.add(curr);
        return list;
    }
    /**
     * @param latitude
     * @param longitude
     * @throws IllegalArgumentException if either parameter is not finite.
     * @return URI for api.met.no location forecast (classic) at the given coordinates.
     */
    public static URI getMETAPIURI(double latitude, double longitude) {
        if (!Double.isFinite(latitude))
            throw new IllegalArgumentException("latitude must be finite");
        if (!Double.isFinite(longitude))
            throw new IllegalArgumentException("longitude must be finite");
        //TODO maybe check for valid coordinates
        String baseURL = "https://api.met.no/weatherapi/locationforecast/2.0/complete?altitude=2&lat=%.4f&lon=%.4f";
        //locale = US to ensure correct decimal separator.
        String queryString = String.format(Locale.US,baseURL, latitude, longitude);
        return URI.create(queryString);
    }
}

