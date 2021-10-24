package infrastructure

import (
	"os"
	"strconv"
)

type appConfig struct {
	Debug bool
}

type dbConfig struct {
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

}

func initApiConf() {
	ApiConf.Addr = "8080"
}
