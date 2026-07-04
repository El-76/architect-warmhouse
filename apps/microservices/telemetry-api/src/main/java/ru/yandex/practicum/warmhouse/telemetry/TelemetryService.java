package ru.yandex.practicum.warmhouse;

public interface TelemetryService {
    String ping();
    String getDeviceTelemetry(int deviceId);
}
