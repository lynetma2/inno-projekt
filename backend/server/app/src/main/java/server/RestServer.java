package server;

import org.json.JSONObject;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;

import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;
import java.util.concurrent.CompletableFuture;


@RestController
@RequestMapping("/api")
@SpringBootApplication
@EnableAsync
@Service
public class RestServer {
    /**
     *
     * @return json encoded list of (string, id) of the names of all paints.
     */
    @GetMapping("/paints")
    @Async
    public CompletableFuture<String> listPaintNames() {
	    return CompletableFuture.completedFuture(Database.getAllPaints());
    }

    /**
     *
     * @return json encoded list of (string, id) of the names of all paints.
     */
    @GetMapping("/paint/{uuid}")
    @Async
    public CompletableFuture<String> getPaintInfo(@PathVariable String uuid) {
        // SELECT * FROM Paints WHERE id=UUID;
        return CompletableFuture
                .completedFuture(Database.getPaint(UUID.fromString(uuid)));
    }
    @GetMapping("/forecast/{uuid}")
    @Async
    public CompletableFuture<String> getForecast(@PathVariable String uuid, @RequestParam double longitude
            , @RequestParam double latitude) {
        System.out.println("Getting forecast");
        String f = Forecast.getForecast(longitude, latitude);
        System.out.println(f);
        JSONObject forecast = new JSONObject(f);
        return CompletableFuture
                .completedFuture(Forecast.makeJudgement(forecast, UUID.fromString(uuid)).toString(3));
    }
}
