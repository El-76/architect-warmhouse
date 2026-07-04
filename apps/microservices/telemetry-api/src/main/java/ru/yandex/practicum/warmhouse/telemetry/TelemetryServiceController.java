package ru.yandex.practicum.warmhouse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/")
public class TelemetryServiceController {
    @Autowired
    private TelemetryService telemetryService;

    @GetMapping("/")
    public String home() {
        return "Welcome to the Telemetry API!";
    }

    @GetMapping("/ping")
    public String ping() {
        return telemetryService.ping();
    }

    @GetMapping("/telemetry/{deviceId}")
    public String getDeviceTelemetry(@PathVariable int deviceId) {
        return "{\"value\":" + telemetryService.getDeviceTelemetry(deviceId) + "}";
    }
}
