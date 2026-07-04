package ru.yandex.practicum.warmhouse;

import java.math.BigDecimal;
import org.json.*;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

@Service
public class TelemetryServiceKafkaConsumer {
    private final JedisPool jedisPool;

    public TelemetryServiceKafkaConsumer() {
        jedisPool = new JedisPool("redis", 6379);
    }

    @KafkaListener(topics = "events", id = "telemetry-api", containerFactory = "kafkaListenerContainerFactory")
    public void consume(String message) {
        System.out.println("Consumed message: " + message);

        try {
            JSONObject obj = new JSONObject(message);

            int id = obj.getInt("id");
            BigDecimal value = obj.getBigDecimal("value");

            try (Jedis jedis = jedisPool.getResource()) {
                jedis.set(Integer.toString(id), value.toString());
            }
        } catch (JSONException ex) {
            ex.printStackTrace();
        }
    }
}
