package game

import (
	"fmt"
	"github.com/gorilla/mux"
	"go-ttt/app/connections/config"
	"go-ttt/app/connections/infrastructure/database"
	"go-ttt/app/core/database/redis"
	data "go-ttt/app/core/data/implementation/redis"
	"go-ttt/app/core/database/redis/dao"
	repository "go-ttt/app/core/domain"
	service "go-ttt/app/core/service/game"
	"go-ttt/app/delivery/feature/game/controllers"
	"go-ttt/app/delivery/feature/game/endpoints"
	"go-ttt/app/delivery/utils/responses"
	"log"
	"net/http"
	"os"
	"os/signal"
)

func gameLauncher() {

	env := config.GetEnvironment()
	fmt.Println("Session Secret: ", env.SessionSecret)

	// Db Setup
	client := database.NewRedisClient()
	client.Connect()

	redisData := redis.NewRedis(client.Client)

	gameDAO := dao.NewGameDao(redisData)
	gameRepository := data.NewGameRepositoryImpl(gameDAO)

	checker := service.NewGameStateChecker()
	gameLogic := service.NewGameLogic(checker)

	gameUseCases := repository.NewGameUseCases(gameRepository, gameLogic)
	gameResponses := responses.NewGameResponses()

	gameController := controllers.NewGameController(gameUseCases, gameResponses)

	// Router
	r := mux.NewRouter()
	endpoints.GameEndpoints(r, gameController)

	addr := ":8080"
	log.Printf("Starting server on %s", addr)
	fmt.Println("Address: ", addr)

	// Start Server
	err := http.ListenAndServe(addr, r)
	if err != nil {
		return
	}

	// Graceful Shutdown
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	<-c
	fmt.Println("Gracefully shutting down...")
	err = client.Close()
	if err != nil {
		return
	}
	os.Exit(0)

}



