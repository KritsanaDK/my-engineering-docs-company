package model

import (
	"time"

	"github.com/google/uuid"
)

type TemplateResponse struct {
	Code    string      `json:"code"`
	Message string      `json:"message"`
	Data    interface{} `json:"data,omitempty"`
}

type Tracking struct {
	Track     string      `json:"track_id"`
	URI       string      `json:"uri"`
	Method    string      `json:"method"`
	Request   interface{} `json:"request,omitempty"`
	Response  interface{} `json:"response,omitempty"`
	StartDate time.Time   `json:"start_date"`
}

func NewTracking(uri, method string, req interface{}) *Tracking {
	return &Tracking{
		Track:     uuid.New().String(),
		URI:       uri,
		Method:    method,
		Request:   req,
		StartDate: time.Now(),
	}
}
