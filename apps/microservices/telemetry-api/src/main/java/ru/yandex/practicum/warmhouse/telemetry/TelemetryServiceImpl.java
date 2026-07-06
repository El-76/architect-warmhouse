package ru.yandex.practicum.warmhouse;

import org.springframework.stereotype.Service;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

@Service
public class TelemetryServiceImpl implements TelemetryService {
    private final JedisPool jedisPool;

    public TelemetryServiceImpl() {
        jedisPool = new JedisPool("redis", 6379);
    }

    @Override
    public String ping() {
        return "pong";
    }

    @Override
    public String getDeviceTelemetry(int deviceId) {
        try (Jedis jedis = jedisPool.getResource()) {
            return jedis.get(Integer.toString(deviceId));
        }
    }
}
