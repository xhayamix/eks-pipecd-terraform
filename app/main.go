package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/go-redis/redis/v8"
	_ "github.com/go-sql-driver/mysql"
)

// グローバルなRedisクライアントとSQLデータベースを定義
var (
	rdb *redis.Client
	db  *sql.DB
	ctx = context.Background()
)

// RDS MySQLへの接続を初期化
func initDB() error {
	// 環境変数から接続情報を取得
	rdsHost := os.Getenv("RDS_HOST")
	rdsPort := "3306"
	rdsUser := os.Getenv("RDS_USER")
	rdsPassword := os.Getenv("RDS_PASSWORD")
	rdsDBName := os.Getenv("RDS_DB_NAME")

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", rdsUser, rdsPassword, rdsHost, rdsPort, rdsDBName)
	var err error
	db, err = sql.Open("mysql", dsn)
	if err != nil {
		return err
	}
	for {
		err := db.Ping()
		if err == nil {
			log.Println("db ok")
			break
		}
		log.Print(err)
		time.Sleep(time.Second * 2)
	}

	return db.Ping()
}

// Redisへの接続を初期化
func initRedis() error {
	redisHost := os.Getenv("REDIS_HOST")
	redisPort := os.Getenv("REDIS_PORT")

	rdb = redis.NewClient(&redis.Options{
		Addr: fmt.Sprintf("%s:%s", redisHost, redisPort),
	})

	_, err := rdb.Ping(ctx).Result()
	for {
		_, err = rdb.Ping(ctx).Result()
		if err == nil {
			log.Println("redis ok")
			break
		}
		log.Print(err)
		time.Sleep(time.Second * 2)
	}
	return err
}

// ヘルスチェックハンドラ
func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "OK")
}

func main() {
	log.Println("Starting server...")

	// RDSとRedisへの接続を初期化
	if err := initDB(); err != nil {
		log.Fatalf("Failed to initialize DB: %v", err)
	}
	defer db.Close()

	if err := initRedis(); err != nil {
		log.Fatalf("Failed to initialize Redis: %v", err)
	}
	defer rdb.Close()

	http.HandleFunc("/health", healthHandler) // ヘルスチェック用エンドポイント
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, World!")
	})

	log.Fatal(http.ListenAndServe(":8080", nil))
}
