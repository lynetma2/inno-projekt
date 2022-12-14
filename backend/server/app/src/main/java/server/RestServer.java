package server;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executor;
import java.util.concurrent.ThreadPoolExecutor;

@RestController
@RequestMapping("/api")
@SpringBootApplication
@EnableAsync
@Service
public class RestServer {
    @GetMapping("/greeting")
    @Async //TODO broken not async https://spring.io/guides/gs/async-method/
    public CompletableFuture<String> greet() {
        System.out.println("new request in thread: " + Thread.currentThread().getName());
        try {
            Thread.sleep(1000*10);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        return CompletableFuture.completedFuture("hello world");
    }

    /**
     *
     * @return json encoded list of (string, id) of the names of all paints.
     */
    @GetMapping("/paints")
    @Async
    public CompletableFuture<String> listPaintNames() {
    	// SELECT name FROM Paints;
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
        // SELECT * FROM Paints WHERE id=UUID;
        System.out.println(longitude);
        return CompletableFuture
                .completedFuture(Forecast.getForecast(longitude, latitude));
    }
}
