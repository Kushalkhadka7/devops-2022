package database

import (
	"context"
	"fmt"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/mongo/readpref"
)

// DatabseCreator databse interface.
type DatabseCreator interface {
	CreateClient() (*mongo.Client, error)
	CloseDBConnection(dbClient *mongo.Client) error
	InitializeDatabase(dbClient *mongo.Client) *mongo.Database
}

// MongoDB struct the database.
type MongoDB struct {
	*mongo.Database
	Port       int
	URI        string
	DBName     string
	DBPassword string
}

// New initializes new mongo db instance.
func New(port int, uri, dbName, dbPassword string) *MongoDB {
	return &MongoDB{
		Port:       port,
		URI:        uri,
		DBName:     dbName,
		DBPassword: dbPassword,
	}
}

// CreateClient initializes new mongo db client.
func (db *MongoDB) CreateClient() (*mongo.Client, error) {
	clientOptins := options.Client().ApplyURI(db.URI)
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	client, err := mongo.Connect(ctx, clientOptins)
	if err != nil {
		return nil, util.Error(codes.PermissionDenied, "Unable to close database connection.", err)
	}

	err = client.Ping(ctx, readpref.Primary())
	if err != nil {
		fmt.Println(err)
		return nil, "Unable to ping to database."
	}

	fmt.Println("\n\n\n**************************************")
	fmt.Println("Connected to MongoDB on port : 27017")
	fmt.Println("**************************************")

	return client, nil
}

// InitializeDatabase initializes the database.
func (db *MongoDB) InitializeDatabase(dbClient *mongo.Client) *mongo.Database {
	return dbClient.Database(db.DBName)
}

// CloseDBConnection close dtabase connection.
func (db *MongoDB) CloseDBConnection(dbClient *mongo.Client) error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	err := dbClient.Disconnect(ctx)
	if err != nil {
		return util.Error(codes.PermissionDenied, "Unable to close database connection.", err)
	}

	return nil
}
