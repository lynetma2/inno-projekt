package server;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;

public class Forecast {
    //TODO return type
    public static void getForecast(double longitude, double latitude) {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest req = HttpRequest.newBuilder()
                //TODO handle exceptions
                .uri(getMETAPIURI(longitude, latitude))
                //api.met.no wants contact info
                .header("User-Agent", "universityProject kaspokumu@gmail.com")
                .build();
        try {
            //TODO send async
            //TODO handle response
            HttpResponse<Path> r = client.send(req, HttpResponse.BodyHandlers.ofFile(Paths.get("response.txt")));
            System.out.println(r.body());
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
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
        String baseURL = "https://api.met.no/weatherapi/locationforecast/2.0/classic?altitude=2&lat=%.4f&lon=%.4f";
        //locale = US to ensure correct decimal separator.
        String queryString = String.format(Locale.US,baseURL, latitude, longitude);
        return URI.create(queryString);
    }
}

