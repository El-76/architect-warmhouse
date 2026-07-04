#!/bin/bash

# Exit on any error
set -e

echo "Starting the Smart Home Sensor API..."
echo "Building and starting containers..."
docker-compose up --build -d

echo "Waiting for services to be ready..."

# Wait for PostgreSQL to be ready
for i in {1..30}; do
  if docker exec smarthome-postgres pg_isready -U postgres > /dev/null 2>&1; then
    echo "PostgreSQL is ready!"
    break
  fi
  echo "Waiting for PostgreSQL to start... ($i/30)"
  sleep 1
done

# Check if PostgreSQL is ready
if ! docker exec smarthome-postgres pg_isready -U postgres > /dev/null 2>&1; then
  echo "Error: PostgreSQL did not start within the expected time."
  exit 1
fi


# Wait for Kafka to be ready
for i in {1..30}; do
  if docker exec smarthome-kafka kafka-topics --bootstrap-server localhost:29092 --list > /dev/null 2>&1; then
    echo "Kafka is ready!"
    break
  fi
  echo "Waiting for Kafka to start... ($i/30)"
  sleep 1
done

# Check if Kafka is ready
if ! docker exec smarthome-kafka kafka-topics --bootstrap-server localhost:29092 --list > /dev/null 2>&1; then
  echo "Error: Kafka did not start within the expected time."
  exit 1
fi


# Wait for Redis to be ready
for i in {1..30}; do
  if docker exec smarthome-redis redis-cli ping > /dev/null 2>&1; then
    echo "Redis is ready!"
    break
  fi
  echo "Waiting for Redis to start... ($i/30)"
  sleep 1
done

# Check if Redis is ready
if ! docker exec smarthome-redis redis-cli > /dev/null 2>&1; then
  echo "Error: Redis did not start within the expected time."
  exit 1
fi


echo "All services are up and running!"
echo "The API is available at http://localhost:8080"
echo ""
echo "To view logs, run: docker-compose logs -f"
echo "To stop the services, run: docker-compose down"
