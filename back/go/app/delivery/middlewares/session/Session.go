package middlewares

import(
	"github.com/gorilla/sessions"
	"net/http"
)

var (
	sessionKey = []byte("tictacgo")
)

func SessionMiddleware() func(next http.Handler) http.Handler {
	
	store := sessions.NewCookieStore(sessionKey)

	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			session, err := store.Get(r, "tictacgo")
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}

			session.Options = &sessions.Options{
				Domain:   "localhost",
				Path:     "/",
				MaxAge:   1000 * 60 * 60 * 24 * 30,
				Secure:   false,
				HttpOnly: true,
				SameSite: http.SameSiteNoneMode,
			}

			next.ServeHTTP(w, r)

			err = session.Save(r, w)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
		})
	}
}

