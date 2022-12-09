package server;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Path;
import java.nio.file.Paths;

public class Forecast {
    //TODO return type
    public static void getForecast(double longitude, double latitude) {
        //TODO change url with parameters
        String u = "https://api.met.no/weatherapi/locationforecast/2.0/classic?altitude=2&lat=54.400&lon=10.3833";


        HttpClient client = HttpClient.newHttpClient();
        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create(u))
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
}

