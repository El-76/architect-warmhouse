package main

import (
	"encoding/json"

	"context"
	"log"
	"time"

	"github.com/segmentio/kafka-go"
)

func main() {
	type Event struct {
		ID          int        `json:"id"`
		Value       float64    `json:"value"`
	} 

	ctx := context.Background()

	writer := kafka.Writer{
		Addr:                   kafka.TCP("kafka:29092"),
		Topic:                  "events",
		AllowAutoTopicCreation: true,
	}

	defer writer.Close()

	for {
		event := Event{
			ID: 100,
			Value: 18.0 + float64(time.Now().UnixNano()%10) + float64(time.Now().UnixNano()%100)/100.0,
		}

		jsonData, err := json.Marshal(event)

		if err != nil {
			log.Fatal("Error encoding JSON", err)
		}

		err = writer.WriteMessages(ctx, kafka.Message{
			Value: jsonData,
		})

		if err != nil {
			log.Fatal("Send error:", err)
		}

		log.Println("Sent event:", string(jsonData))

		time.Sleep(1 * time.Second)
	}
}
