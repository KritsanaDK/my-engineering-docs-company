package main

import (
	"database/sql"
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
	"time"

	_ "github.com/lib/pq"
)

func main() {
	host := flag.String("host", "136.85.102.224", "Database host")
	port := flag.String("port", "5432", "Database port")
	user := flag.String("user", "pgpool", "Database username")
	password := flag.String("password", "UatISV_SecurePass2026!", "Database password")
	dbname := flag.String("dbname", "insurverse", "Database name")
	action := flag.String("action", "backup", "Action: 'backup', 'verify', or 'deploy'")
	sqlFile := flag.String("file", "/Users/kritsanawathaniyanon/Code/Go/deploy_jobs/02_ws6_9/sql/ws6_ws7_combined_renewal_master.sql", "SQL migration file")
	flag.Parse()

	connStr := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable connect_timeout=10", *host, *port, *user, *password, *dbname)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatalf("Connection string error: %v", err)
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		log.Fatalf("Database ping failed on %s:%s: %v", *host, *port, err)
	}
	fmt.Printf("✅ Connected to Database: %s:%s (DB: %s)\n", *host, *port, *dbname)

	switch *action {
	case "backup":
		runBackup(db)
	case "verify":
		runVerify(db)
	case "deploy":
		runBackup(db)
		runDeploy(db, *sqlFile)
		runVerify(db)
	default:
		log.Fatalf("Unknown action: %s. Use 'backup', 'verify', or 'deploy'", *action)
	}
}

// Rule 3: Mandatory Stored Procedure Backup
func runBackup(db *sql.DB) string {
	fmt.Println("\n==> [Rule 3] Extracting Pre-Deployment Stored Procedure Definitions...")
	query := `
		SELECT p.proname, pg_get_functiondef(p.oid) 
		FROM pg_proc p
		JOIN pg_namespace n ON p.pronamespace = n.oid
		WHERE p.proname IN ('fn_policy_renewal', 'fn_format_utc_timestamp_th')
		  AND n.nspname = 'insurverse';
	`
	rows, err := db.Query(query)
	if err != nil {
		log.Fatalf("Failed to extract function definitions: %v", err)
	}
	defer rows.Close()

	var backupContent strings.Builder
	timestamp := time.Now().Format("20060102_150405")
	backupContent.WriteString(fmt.Sprintf("-- Backup of WS6/WS7 functions created on %s\n\n", time.Now().Format(time.RFC3339)))

	count := 0
	for rows.Next() {
		var proname, def string
		if err := rows.Scan(&proname, &def); err != nil {
			log.Fatalf("Error reading function definition: %v", err)
		}
		backupContent.WriteString(fmt.Sprintf("-- -----------------------------------------------------\n-- Function: %s\n-- -----------------------------------------------------\n", proname))
		backupContent.WriteString(def)
		backupContent.WriteString(";\n\n")
		count++
		fmt.Printf("   • Extracted: insurverse.%s (Length: %d bytes)\n", proname, len(def))
	}

	backupDir := "/Users/kritsanawathaniyanon/Code/Go/deploy_jobs/02_ws6_9/sql/backups"
	os.MkdirAll(backupDir, 0755)
	filename := filepath.Join(backupDir, fmt.Sprintf("backup_ws6_ws7_functions_%s.sql", timestamp))
	if err := os.WriteFile(filename, []byte(backupContent.String()), 0644); err != nil {
		log.Fatalf("Failed to write backup file: %v", err)
	}

	fmt.Printf("✅ Backup successfully saved to:\n   👉 %s\n", filename)
	return filename
}

// Rule 6: Mandatory DB Schema & Field Verification
func runVerify(db *sql.DB) {
	fmt.Println("\n==> [Rule 6] Verifying DB Schema & Function Post-Deployment Status...")

	// 1. Check no_cancel_flag column
	var colCount int
	err := db.QueryRow(`
		SELECT count(*) FROM information_schema.columns 
		WHERE table_schema = 'insurverse' AND table_name = 'Policy_Header' AND column_name = 'no_cancel_flag';
	`).Scan(&colCount)
	if err != nil {
		fmt.Printf("   ⚠️ Check no_cancel_flag error: %v\n", err)
	} else if colCount > 0 {
		fmt.Println("   • Policy_Header.no_cancel_flag:  ✅ EXISTS (Ready for WS6 Endorsement)")
	} else {
		fmt.Println("   • Policy_Header.no_cancel_flag:  ❌ NOT FOUND")
	}

	// 2. Check fn_format_utc_timestamp_th
	var fnTestResult string
	err = db.QueryRow(`SELECT insurverse.fn_format_utc_timestamp_th('2026-09-15 03:30:00'::timestamp);`).Scan(&fnTestResult)
	if err != nil {
		fmt.Printf("   • fn_format_utc_timestamp_th:    ⚠️ Error: %v\n", err)
	} else if strings.HasPrefix(fnTestResult, "2026-09-15T10:30:00") {
		fmt.Printf("   • fn_format_utc_timestamp_th:    ✅ PASS (Timezone +7h verified: %s)\n", fnTestResult)
	} else {
		fmt.Printf("   • fn_format_utc_timestamp_th:    ⚠️ Result: %s\n", fnTestResult)
	}

	// 3. Check fn_policy_renewal 90-day guardrail
	var renewalLen int
	var has90Day bool
	err = db.QueryRow(`
		SELECT length(pg_get_functiondef(p.oid)),
		       (pg_get_functiondef(p.oid) LIKE '%90%' AND pg_get_functiondef(p.oid) LIKE '%ER007%')
		FROM pg_proc p
		JOIN pg_namespace n ON p.pronamespace = n.oid
		WHERE p.proname = 'fn_policy_renewal' AND n.nspname = 'insurverse';
	`).Scan(&renewalLen, &has90Day)
	if err != nil {
		fmt.Printf("   • fn_policy_renewal:             ⚠️ Error: %v\n", err)
	} else if has90Day {
		fmt.Printf("   • fn_policy_renewal:             ✅ PASS (90-Day Guardrail 'ER007' Active, Len: %d bytes)\n", renewalLen)
	} else {
		fmt.Printf("   • fn_policy_renewal:             ⚠️ MISSING 90-DAY GUARDRAIL (Len: %d bytes)\n", renewalLen)
	}

	// 4. Check insurverse.promo_code
	var promoCount int
	err = db.QueryRow(`SELECT count(*) FROM insurverse.promo_code;`).Scan(&promoCount)
	if err != nil {
		fmt.Printf("   • insurverse.promo_code:         ⚠️ Error: %v\n", err)
	} else {
		fmt.Printf("   • insurverse.promo_code:         ✅ EXISTS (%d rows available for WS8)\n", promoCount)
	}
}

// Deploy Master SQL
func runDeploy(db *sql.DB, sqlFile string) {
	fmt.Printf("\n==> Deploying Master SQL File: %s\n", sqlFile)
	sqlContent, err := os.ReadFile(sqlFile)
	if err != nil {
		log.Fatalf("Failed to read SQL file: %v", err)
	}

	_, err = db.Exec(string(sqlContent))
	if err != nil {
		log.Fatalf("Migration failed (Transaction rolled back): %v", err)
	}
	fmt.Println("✅ Master SQL Migration executed successfully!")
}
