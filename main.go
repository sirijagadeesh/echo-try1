package main

import (
	"fmt"
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	// Echo Instance.
	ech := echo.New()

	// Middleware.
	ech.Use(middleware.Logger())
	ech.Use(middleware.Recover())

	// routes.
	ech.GET("/", hello)
	ech.GET("/{name}", hello)

	// start Server.
	ech.Logger.Fatal(ech.Start(":8080"))
}

// hello is Handler.
func hello(ctx echo.Context) error {
	response := struct {
		Ping string `json:"ping"`
	}{
		Ping: "Pong",
	}

	if err := ctx.JSON(http.StatusOK, &response); err != nil {
		return fmt.Errorf("error when responding %w", err)
	}

	return nil
}
