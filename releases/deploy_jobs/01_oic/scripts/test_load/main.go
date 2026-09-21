package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"net/http"
	"sync"
	"time"
)

func main() {
	concurrencyPtr := flag.Int("concurrency", 20, "Number of concurrent API requests")
	flag.Parse()
	concurrency := *concurrencyPtr

	url := "https://insurverse-uat-isv-api.insurverse.co.th/api/v1/premium/actAPI"
	payload := map[string]interface{}{
		"fn": "loadActPremium",
		"data": map[string]interface{}{
			"Comp_Code": "1.10",
		},
	}
	body, _ := json.Marshal(payload)

	var wg sync.WaitGroup
	results := make(chan struct {
		statusCode int
		duration   time.Duration
		err        error
		status     bool
	}, concurrency)

	client := &http.Client{
		Timeout: 10 * time.Second,
	}

	startTotal := time.Now()

	for i := 0; i < concurrency; i++ {
		wg.Add(1)
		go func(id int) {
			defer wg.Done()
			reqStart := time.Now()
			req, err := http.NewRequest("POST", url, bytes.NewBuffer(body))
			if err != nil {
				results <- struct {
					statusCode int
					duration   time.Duration
					err        error
					status     bool
				}{0, time.Since(reqStart), err, false}
				return
			}
			req.Header.Set("Content-Type", "application/json")

			resp, err := client.Do(req)
			duration := time.Since(reqStart)
			if err != nil {
				results <- struct {
					statusCode int
					duration   time.Duration
					err        error
					status     bool
				}{0, duration, err, false}
				return
			}
			defer resp.Body.Close()

			respBody, _ := io.ReadAll(resp.Body)
			var respMap map[string]interface{}
			json.Unmarshal(respBody, &respMap)
			status, _ := respMap["status"].(bool)

			results <- struct {
				statusCode int
				duration   time.Duration
				err        error
				status     bool
			}{resp.StatusCode, duration, nil, status}
		}(i)
	}

	wg.Wait()
	close(results)
	totalDuration := time.Since(startTotal)

	successCount := 0
	var totalReqDuration time.Duration

	for res := range results {
		if res.statusCode >= 200 && res.statusCode < 300 && res.status {
			successCount++
		} else {
			fmt.Printf("Failed: code=%d, err=%v, status=%v\n", res.statusCode, res.err, res.status)
		}
		totalReqDuration += res.duration
	}

	avgReqDuration := totalReqDuration / time.Duration(concurrency)
	passRate := (float64(successCount) / float64(concurrency)) * 100

	fmt.Printf("\n--- %d Concurrent Load Test Results ---\n", concurrency)
	fmt.Printf("Total Requests: %d\n", concurrency)
	fmt.Printf("Successful:     %d (%.1f%%)\n", successCount, passRate)
	fmt.Printf("Total Time:     %v\n", totalDuration)
	fmt.Printf("Avg Latency:    %v\n", avgReqDuration)
}
