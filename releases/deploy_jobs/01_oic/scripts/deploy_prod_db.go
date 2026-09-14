package main

import (
	"database/sql"
	"flag"
	"fmt"
	"log"
	"os"

	_ "github.com/lib/pq"
)

func main() {
	host := flag.String("host", "", "Database host (e.g. 10.x.x.x or Cloud SQL IP)")
	port := flag.String("port", "5432", "Database port")
	user := flag.String("user", "pgpool", "Database username")
	password := flag.String("password", "", "Database password")
	dbname := flag.String("dbname", "insurverse", "Database name")
	sqlFile := flag.String("file", "/Users/kritsanawathaniyanon/Code/Go/deploy_jobs/01_oic/sql/ws1_ws5_concurrency_safe_master.sql", "SQL migration file")
	flag.Parse()

	if *host == "" || *password == "" {
		fmt.Println("Usage: go run deploy_prod_db.go -host <DB_HOST> -password <DB_PASSWORD> [-port 5432] [-user pgpool] [-dbname insurverse]")
		os.Exit(1)
	}

	connStr := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable", *host, *port, *user, *password, *dbname)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatalf("Connection error: %v", err)
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		log.Fatalf("Database ping failed: %v", err)
	}
	fmt.Printf("✅ Connected to Database: %s:%s (%s)\n", *host, *port, *dbname)

	sqlContent, err := os.ReadFile(*sqlFile)
	if err != nil {
		log.Fatalf("Failed to read SQL file: %v", err)
	}

	fmt.Println("==> Executing Production Migration (WS1 & WS5 Concurrency Hardening)...")
	_, err = db.Exec(string(sqlContent))
	if err != nil {
		log.Fatalf("Migration failed (automatically rolled back): %v", err)
	}
	fmt.Println("✅ Migration executed successfully!")

	fmt.Println("\n==> Verifying Concurrency Status of Functions...")
	rows, err := db.Query(`
		SELECT 
			p.proname AS function_name,
			CASE 
				WHEN pg_get_functiondef(p.oid) LIKE '%pg_advisory_xact_lock%' 
				 AND pg_get_functiondef(p.oid) LIKE '%LOOP%' THEN '✅ CONCURRENCY SAFE'
				ELSE '⚠️ LEGACY / UNSAFE'
			END AS concurrency_status,
			LENGTH(pg_get_functiondef(p.oid)) AS def_length
		FROM pg_proc p
		JOIN pg_namespace n ON p.pronamespace = n.oid
		WHERE p.proname IN ('fn_lead_to_car_act', 'fn_policy_to_car_act', 'fn_policy_invoiceno_iia', 'fn_policy_quatationno_iia') 
		  AND n.nspname = 'insurverse'
		ORDER BY p.proname;
	`)
	if err != nil {
		log.Fatalf("Verification query failed: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var name, status string
		var length int
		rows.Scan(&name, &status, &length)
		fmt.Printf("%-28s | %-20s | %d bytes\n", name, status, length)
	}
}
