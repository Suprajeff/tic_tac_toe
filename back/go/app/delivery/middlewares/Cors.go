package middlewares

import (
	"net/http"
	"os"
)

func CorsMiddleware() func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

			// Get the CORS origin from the environment variable or set a default value
			corsOrigin := os.Getenv("CORS_ORIGIN")
			if corsOrigin == "" {
				corsOrigin = "http://localhost:8080" // Default value
			}

			w.Header().Set("Access-Control-Allow-Origin", corsOrigin)
			w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
			w.Header().Set("Access-Control-Allow-Headers", "Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization")
			w.Header().Set("Access-Control-Allow-Credentials", "true")

			// If it's a preflight (OPTIONS) request, then stop here
			if r.Method == http.MethodOptions {
				println("this is a preflight")
				w.WriteHeader(http.StatusOK)
				return
			}

			// Otherwise, proceed to the next middleware or handler
			next.ServeHTTP(w, r)
		})
	}
}