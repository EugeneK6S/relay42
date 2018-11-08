package main

import (
	"time"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	date := time.Now().Local().Format("2006-01-02")
	r.GET("/date", func(c *gin.Context) {
		c.String(200, date)
	})
	r.Run(":3333") // listen and serve on 0.0.0.0:8080

}