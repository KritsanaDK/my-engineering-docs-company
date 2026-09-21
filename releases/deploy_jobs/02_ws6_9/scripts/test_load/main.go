package main

import (
	"flag"
	"fmt"
	"io"
	"net/http"
	"sync"
	"time"
)

func main() {
	concurrencyPtr := flag.Int("concurrency", 20, "Number of concurrent API requests")
	endpointPtr := flag.String("endpoint", "reconcile", "Target test endpoint: 'reconcile' or 'health'")
	flag.Parse()

	concurrency := *concurrencyPtr
	var url string
	switch *endpointPtr {
	case "reconcile":
		url = "https://insurverse-uat-isv-api.insurverse.co.th/api/v1/uam/report/reconcile?date=" + time.Now().Format("2006-01-02")
	default:
		url = "https://insurverse-uat-isv-api.insurverse.co.th/api/v1/purchase/env"
	}

	fmt.Printf("=== WS6-WS9 Automated Concurrency Test Runner ===\n")
	fmt.Printf("Target URL:    %s\n", url)
	fmt.Printf("Concurrency:   %d concurrent requests\n", concurrency)
	fmt.Printf("Test Subject:  Standard Citizen ID 1111111111119 (Rule 4 Compliance)\n\n")

	var wg sync.WaitGroup
	results := make(chan struct {
		statusCode int
		duration   time.Duration
		err        error
	}, concurrency)

	client := &http.Client{
		Timeout: 15 * time.Second,
	}

	startTotal := time.Now()

	for i := 0; i < concurrency; i++ {
		wg.Add(1)
		go func(id int) {
			defer wg.Done()
			reqStart := time.Now()
			req, err := http.NewRequest("GET", url, nil)
			if err != nil {
				results <- struct {
					statusCode int
					duration   time.Duration
					err        error
				}{0, time.Since(reqStart), err}
				return
			}
			req.Header.Set("Content-Type", "application/json")
			req.Header.Set("X-Test-Citizen-ID", "1111111111119")

			resp, err := client.Do(req)
			duration := time.Since(reqStart)
			if err != nil {
				results <- struct {
					statusCode int
					duration   time.Duration
					err        error
				}{0, duration, err}
				return
			}
			defer resp.Body.Close()
			io.Copy(io.Discard, resp.Body)

			results <- struct {
				statusCode int
				duration   time.Duration
				err        error
			}{resp.StatusCode, duration, nil}
		}(i)
	}

	wg.Wait()
	close(results)
	totalDuration := time.Since(startTotal)

	successCount := 0
	var totalReqDuration time.Duration

	for res := range results {
		if res.statusCode >= 200 && res.statusCode < 300 {
			successCount++
		} else {
			fmt.Printf("Failed: code=%d, err=%v\n", res.statusCode, res.err)
		}
		totalReqDuration += res.duration
	}

	avgReqDuration := totalReqDuration / time.Duration(concurrency)
	passRate := (float64(successCount) / float64(concurrency)) * 100

	fmt.Printf("\n--- WS6-WS9 Test Results ---\n")
	fmt.Printf("Total Requests: %d\n", concurrency)
	fmt.Printf("Successful:     %d (%.1f%%)\n", successCount, passRate)
	fmt.Printf("Total Time:     %v\n", totalDuration)
	fmt.Printf("Avg Latency:    %v\n", avgReqDuration)
	if passRate == 100.0 {
		fmt.Printf("Status:         ✅ PASSED (All assertions met)\n")
	} else {
		fmt.Printf("Status:         ❌ FAILED (Some requests did not succeed)\n")
	}
}
