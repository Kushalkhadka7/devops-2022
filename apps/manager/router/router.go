package router

import (
	"fmt"
	"manager/config"
	"net"
	"os"
	"os/exec"

	"github.com/gin-gonic/gin"

	"context"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// Router is a app level router.
type Router struct {
	*gin.Engine
}

// New initializes new gin router.
func New(config *config.Config) *Router {
	gin.ForceConsoleColor()
	r := gin.New()

	r.Use(gin.Recovery())

	r.GET("/", func(c *gin.Context) {
		cmd := exec.Command("hostname", "-i")
		value, err := cmd.Output()
		if err != nil {
			fmt.Println(err)
		}

		host, _ := os.Hostname()
		addrs, _ := net.LookupIP(host)
		for _, addr := range addrs {
			if ipv4 := addr.To4(); ipv4 != nil {
				fmt.Println("IPv4: ", ipv4)
			}
		}

		c.JSON(200, gin.H{
			"revision":   1,
			"hostname":   value,
			"ip_address": addrs,
			"message":    "Success",
		})
	})

	r.GET("/api/data", func(c *gin.Context) {

		var uri = config.Server.DBUri

		client, err := mongo.Connect(context.TODO(), options.Client().ApplyURI(uri))
		if err != nil {
			panic(err)
		}

		testCollection := client.Database("devops-demo").Collection("test")

		users := []interface{}{
			bson.D{{Key: "fullName", Value: "User 2"}, {Key: "age", Value: 25}},
			bson.D{{Key: "fullName", Value: "User 3"}, {Key: "age", Value: 20}},
			bson.D{{Key: "fullName", Value: "User 4"}, {Key: "age", Value: 28}},
		}

		results, err := testCollection.InsertMany(context.TODO(), users)
		if err != nil {
			panic(err)
		}
		fmt.Println(results.InsertedIDs)

		cursor, err := testCollection.Find(context.TODO(), bson.D{})
		if err != nil {
			c.JSON(200, gin.H{
				"error": "error on fetching data from collection",
			})
		}

		var response []bson.M
		if err = cursor.All(context.TODO(), &response); err != nil {
			panic(err)
		}

		// display the documents retrieved
		fmt.Println("displaying all results in a collection")
		for _, result := range response {
			fmt.Println(result)
		}

		c.JSON(200, gin.H{
			"message": "Successfully fetched data from mongodb database",
			"data":    response,
		})

	})

	return &Router{r}
}
