package middlewares

import (
	"context"
	"github.com/gorilla/sessions"
	"net/http"
)

var store = sessions.NewCookieStore([]byte("tictactoego"))

func GetSettingsPreferences(next http.Handler) http.Handler {
	
	sessionOptions := &sessions.Options{
		Path:     "/",
		MaxAge:   86400,
		HttpOnly: true,
		Secure:   false,
	}
	
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        
        session, _ := store.Get(r, "tictactoe")
		session.Options = sessionOptions

        darkMode, ok := session.Values["darkMode"].(bool)
		if !ok {
			darkMode = false
		}

		ctx := context.WithValue(r.Context(), "userSettings", map[string]interface{}{
			"darkMode": darkMode,
		})

		next.ServeHTTP(w, r.WithContext(ctx))
		
	})
	
}