package middlewares

import (
	"github.com/gorilla/mux"
	"net/http"
)

func handlePreflight(w http.ResponseWriter, r *http.Request) {
	headers := w.Header()
	headers.Add("Access-Control-Allow-Origin", "*")
	headers.Add("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
	headers.Add("Access-Control-Allow-Headers", "Content-Type")
}

func AllRoutes(r *mux.Router) {
	r.Methods("OPTIONS").HandlerFunc(handlePreflight)
}