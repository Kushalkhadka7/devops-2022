package config

import (
	"fmt"
	"os"
)

type Config struct {
	Server *serverConfig
}

type serverConfig struct {
	Port     string
	Name     string
	Host     string
	AdminUrl string
	AuthUrl  string
	DBUri    string
}

func New() (*Config, error) {
	port := os.Getenv("PORT")
	name := os.Getenv("NAME")
	host := os.Getenv("HOST")
	adminUrl := os.Getenv("ADMIN_URL")
	authUrl := os.Getenv("MANAGER_URL")
	dbUri := os.Getenv("MONGO_DB_URI")

	fmt.Printf("%s", dbUri)

	return &Config{
		Server: &serverConfig{
			Port:     port,
			Name:     name,
			Host:     host,
			AdminUrl: adminUrl,
			AuthUrl:  authUrl,
			DBUri:    dbUri,
		},
	}, nil
}
