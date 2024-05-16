package game

import (
	"github.com/gorilla/mux"
	"github.com/gorilla/sessions"
	"go-ttt/app/core/database/redis"
	"go-ttt/app/connections/infrastructure/database"
	data "go-ttt/app/core/data/implementation/redis"
	"go-ttt/app/core/database/redis/dao"
	repository "go-ttt/app/core/domain"
	service "go-ttt/app/core/service/game"
	"go-ttt/app/delivery/feature/game/controllers"
	"go-ttt/app/delivery/feature/game/endpoints"
	"go-ttt/app/delivery/utils/responses"
)

func LaunchGameFeature(client *database.Client, router *mux.Router, store *sessions.CookieStore) {

	redisData := redis.NewRedis(client.Client)

	gameDAO := dao.NewGameDao(redisData)
	gameRepository := data.NewGameRepositoryImpl(gameDAO)

	checker := service.NewGameStateChecker()
	gameLogic := service.NewGameLogic(checker)

	gameUseCases := repository.NewGameUseCases(gameRepository, gameLogic)
	gameResponses := responses.NewGameResponses()

	gameController := controllers.NewGameController(gameUseCases, gameResponses, store)

	endpoints.GameEndpoints(router, gameController)

}



