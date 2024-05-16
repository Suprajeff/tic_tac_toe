package middlewares

import(
	"fmt"
	"github.com/gorilla/sessions"
	"net/http"
)

func SessionMiddleware(store *sessions.CookieStore) func(next http.Handler) http.Handler {

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
				MaxAge:   30 * 24 * 60 * 60,
				Secure:   false,
				HttpOnly: true,
				SameSite: http.SameSiteLaxMode,
			}

			next.ServeHTTP(w, r)

			err = session.Save(r, w)
			if err != nil {
				fmt.Println("Error when trying to save session")
				fmt.Println(err.Error())
				return
			}
		})
	}
}

