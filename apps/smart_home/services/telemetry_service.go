package services

import (
	"encoding/json"
	"fmt"
	"net/http"
	"time"
)

// TelemetryService handles fetching temperature data from external API
type TelemetryService struct {
	BaseURL    string
	HTTPClient *http.Client
}

// TelemetryResponse represents the response from the telemetry API
type TelemetryResponse struct {
	Value       float64   `json:"value"`
}

// NewTelemetryService creates a new telemetry service
func NewTelemetryService(baseURL string) *TelemetryService {
	return &TelemetryService{
		BaseURL: baseURL,
		HTTPClient: &http.Client{
			Timeout: 10 * time.Second,
		},
	}
}

// GetDeviceTeleetry fetches telemetry data for a specific device ID
func (s *TelemetryService) GetDeviceTelemetry(sensorID string) (*TelemetryResponse, error) {
	url := fmt.Sprintf("%s/telemetry/%s", s.BaseURL, sensorID)

	resp, err := s.HTTPClient.Get(url)
	if err != nil {
		return nil, fmt.Errorf("error fetching telemetry data: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("unexpected status code: %d", resp.StatusCode)
	}

	var telemetryResp TelemetryResponse
	if err := json.NewDecoder(resp.Body).Decode(&telemetryResp); err != nil {
		return nil, fmt.Errorf("error decoding telemetry response: %w", err)
	}

	return &telemetryResp, nil
}
