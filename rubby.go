package main

import (
	"C"
	"fmt"
	"io/ioutil"
	"net/http"
	_ "net/http/pprof"
)

var queue = make(chan string, 100)
var stop = make(chan struct{})

//export queueSize
func queueSize() int {
	return len(queue)
}

//export PushUrl
func PushUrl(str string) {
	queue <- str
}

//export Start
func Start() {

	go func() {
		for {
			select {
			case uri := <-queue:
				go func() {
					fmt.Println(requestUri(uri))
				}()
			case <-stop:
				return
			}
		}
	}()
}

//export Stop
func Stop() {
	stop <- struct{}{}
}

//export StartHTTTPProfiler
func StartHTTTPProfiler() {
	go func() {
		fmt.Println(http.ListenAndServe("127.0.0.1:3000", nil))
	}()
}

func requestUri(uri string) string {
	out := ""
	resp, err := http.Get(uri)

	if err != nil {
		return out
	}

	_, err = ioutil.ReadAll(resp.Body)
	resp.Body.Close()

	if err != nil {
		return out
	}

	return string(resp.Status)
}

func main() {
}
