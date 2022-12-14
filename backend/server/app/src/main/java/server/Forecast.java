package server;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.regex.Pattern;

public class Forecast {
    private final static Pattern sunny = Pattern.compile(".*(clear|fair).*");
    private final static Pattern cloudy = Pattern.compile(".*(cloudy|fog).*");
    private final static Pattern rainy = Pattern.compile(".*(rain|sleet|snow).*");
    public static String getForecast(double longitude, double latitude) {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest req = HttpRequest.newBuilder()
                //TODO handle exceptions
                .uri(getMETAPIURI(longitude, latitude))
                //api.met.no wants contact info
                .header("User-Agent", "universityProject https://github.com/lynetma2/inno-projekt kaspokumu@gmail.com")
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
    public static JSONArray makeJudgement(JSONObject forecast, UUID id){
        //int dryingTime = Database.getPaintDryTime(id);
        int dryingTime = Database.getPaintDryTime(id); //TODO ONLY FOR TESTING
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
                }
                else
                    currentGoodPeriod = 0;

                lastObj = now;
            }

            JSONObject judgementForDay = new JSONObject();
            judgementForDay.put("time", ZonedDateTime.parse(((JSONObject) day.get(0)).getString("time")));
            judgementForDay.put("judgement", longestGoodPeriod >= dryingTime ? 1 : 0);
            JSONArray dataPoints = new JSONArray();

            for (Object time : day) {
                JSONObject jTime = (JSONObject) time;
                JSONObject hourSummary = new JSONObject();
                JSONObject data = jTime.getJSONObject("data");
                JSONObject instant = data.getJSONObject("instant").getJSONObject("details");

                hourSummary.put("rf", instant.getDouble("relative_humidity")/100.);
                //time
                hourSummary.put("time", jTime.getString("time"));
                //temperature
                hourSummary.put("temperature", instant.getDouble("air_temperature"));
                //icon
                String summary = "";
                if (data.has("next_1_hours")) {
                    summary = data.getJSONObject("next_1_hours")
                            .getJSONObject("summary")
                            .getString("symbol_code");
                } else if (data.has("next_6_hours")) {
                    summary = data.getJSONObject("next_6_hours")
                            .getJSONObject("summary")
                            .getString("symbol_code");
                }

                hourSummary.put("icon", decideIcon(summary));

                dataPoints.put(hourSummary);
            }
            judgementForDay.put("dataPoints", dataPoints);
            judgement.put(judgementForDay);
        }
        return judgement;
    }

    private static boolean goodTime(JSONObject timeOfDay){
        JSONObject data = timeOfDay.getJSONObject("data");
        //JSONObject next1Hour = data.getJSONObject("next_1_hour"); only available for 3 days ahead TODO handle this
        JSONObject instant = data.getJSONObject("instant")
                .getJSONObject("details");

        //hacky bugfix, the last time doesn't have next_6_hours...
        if (!data.has("next_6_hours"))
            return false;

        JSONObject next6Hours = data.getJSONObject("next_6_hours")
                .getJSONObject("details");

        //rain check
        if (next6Hours.getDouble("precipitation_amount") > 0.)
            return false;

        //temperature check
        if (next6Hours.getDouble("air_temperature_min") < 7.)
            return false;

        //RF check
        double humidity = instant.getDouble("relative_humidity");
        if (humidity < 40 || humidity > 80)
            return false;
        return true;
    }

    /**
     * Simplifies https://nrkno.github.io/yr-weather-symbols/
     * @param summaryText The weather icon code to be simplified
     * @return -1: unknown, 0: rainy, 1: cloudy, 2: sunny
     */
    private static int decideIcon(String summaryText) {
        String summary = summaryText.toLowerCase();
        //test sunny
        if (sunny.matcher(summary).matches())
            return 2;
        if (cloudy.matcher(summary).matches())
            return 1;
        if (rainy.matcher(summary).matches())
            return 0;

        //unknown weather icon code.
        return -1;
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
    public static URI getMETAPIURI(double longitude, double latitude) {
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

