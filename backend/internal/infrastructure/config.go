package infrastructure

import (
	"os"
	"strconv"
)

type appConfig struct {
	Debug bool
}

type dbConfig struct {
	User string
	Pass string
	Net  string
	Host string
	Port string
	Name string
}

type apiConfig struct {
	Addr string
}

var (
	AppConf appConfig
	DBConf  dbConfig
	ApiConf apiConfig
)

func init() {
	initAppConf()
	initDBConf()
	initApiConf()
}

func initAppConf() {
	debug, err := strconv.ParseBool(os.Getenv("DEBUG"))
	if err != nil {
		AppConf.Debug = false
		return
	}
	AppConf.Debug = debug
}

func initDBConf() {
	DBConf.User = os.Getenv("DB_USER")
	DBConf.Pass = os.Getenv("DB_PASS")
	DBConf.Net = os.Getenv("DB_NET")
	DBConf.Host = os.Getenv("DB_HOST")
	DBConf.Port = os.Getenv("DB_PORT")
	DBConf.Name = os.Getenv("DB_NAME")
}

func initApiConf() {
	ApiConf.Addr = "8080"
}
