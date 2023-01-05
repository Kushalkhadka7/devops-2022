package router

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"manager/config"
	"net/http"
	"os"
	"os/exec"

	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// Router is a app level router.
type Router struct {
	*gin.Engine
}

type response struct {
	hostname string
}

type Post struct {
	_id  string `bson:"title,omitempty"`
	name string `bson:"body,omitempty"`
}

// New initializes new gin router.
func New(config *config.Config) *Router {
	gin.ForceConsoleColor()
	r := gin.New()

	r.Use(gin.Recovery())

	r.GET("/info", func(c *gin.Context) {
		password, err := ioutil.ReadFile("/data/PASSWORD")
		if err != nil {
			fmt.Println(err)
		}

		userName, err := ioutil.ReadFile("/data/USER_NAME")
		if err != nil {
			fmt.Println(err)
		}

		cmd := exec.Command("hostname", "-i")
		value, err := cmd.Output()
		if err != nil {
			fmt.Println(err)
		}

		c.JSON(200, gin.H{
			"message": "Success",
		})
	})

	

	return &Router{r}
}
