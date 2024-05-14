package middlewares

import (
	"fmt"
	"net/http"
	"os"
)

func CorsMiddleware() func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

			fmt.Println("Setting CORS y")

			corsOrigin := os.Getenv("CORS_ORIGIN")
			if corsOrigin == "" {
				corsOrigin = "http://localhost:8085"
			}

			w.Header().Set("Access-Control-Allow-Origin", corsOrigin)
			w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
			w.Header().Set("Access-Control-Allow-Headers", "hx-target, hx-current-url, hx-trigger, hx-request, hx-boost, hx-ext, hx-get, hx-swap, Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization")
			w.Header().Set("Access-Control-Allow-Credentials", "true")

			if r.Method == http.MethodOptions {
				println("this is a preflight")
				w.WriteHeader(http.StatusOK)
				return
			}

	
			next.ServeHTTP(w, r)
		})
	}
}