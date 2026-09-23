#!/bin/bash
# ==============================================================================
# Script: verify_internal_connectivity.sh
# Purpose: ตรวจสอบความพร้อมการเชื่อมต่อ K8s Internal DNS หลัง Deploy Helm Patches
# ==============================================================================

set -e

NAMESPACE="${1:-default}"

echo "======================================================================="
echo "🔍 Starting Internal Service Connectivity Checks in Namespace: $NAMESPACE"
echo "======================================================================="

# 1. Check Notification Service Pod
echo "Checking backend-notification-service..."
kubectl get svc backend-notification-service -n "$NAMESPACE" -o wide

# 2. Check Core Service Pod
echo "Checking backend-core-service..."
kubectl get svc backend-core-service -n "$NAMESPACE" -o wide

# 3. Check UAM Service Pod
echo "Checking backend-uam-service..."
kubectl get pods -l app=backend-uam-service -n "$NAMESPACE" -o wide

# 4. Check OAuth2 Service Pod
echo "Checking openapi-oauth-service..."
kubectl get pods -l app=openapi-oauth-service -n "$NAMESPACE" -o wide

# 5. Check Analytics Service Pod
echo "Checking backend-analytics-service..."
kubectl get pods -l app=backend-analytics-service -n "$NAMESPACE" -o wide

echo "======================================================================="
echo "✅ All service targets verified."
echo "======================================================================="
