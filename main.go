package main

import (
	"fmt"
	"net/http"
	"os"
	"strconv"

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
	ech.GET("/:name", hello)

	port, err := strconv.Atoi(os.Getenv("PORT"))
	if err != nil {
		ech.Logger.Fatalf("PORT should be integer :: %v", err)
	}

	// start Server.
	ech.Logger.Fatal(ech.Start(fmt.Sprintf(":%d", port)))
}

// hello is Handler.
func hello(ctx echo.Context) error {
	name := ctx.Param("name")
	if name == "" {
		name = "ping"
	}

	response := struct {
		Ping string `json:"hello"`
	}{
		Ping: name,
	}

	if err := ctx.JSON(http.StatusOK, &response); err != nil {
		return fmt.Errorf("error when responding %w", err)
	}

	return nil
}
