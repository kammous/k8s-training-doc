+++
menutitle = "Build a Demo WebApp"
date = 2018-12-29T17:15:52Z
weight = 10
chapter = false
pre = "<b>- </b>"
+++
# Build a Demo WebApp

- Create a directory for the demo app.

```shell
$ mkdir -p ${GOPATH}/src/github.com/ansilh/demo-webapp
```

- Create demo-webapp.go file

```shell
$ vi ${GOPATH}/src/github.com/ansilh/demo-webapp/demo-webapp.go
```

```go
package main

import (
  "fmt"
  "net/http"
  "log"
)

func demoDefault(w http.ResponseWriter, r *http.Request) {
   fmt.Fprintf(w, "404 - Page not found - This is a dummy default backend") // send data to client side
}

func main() {
  http.HandleFunc("/", demoDefault) // set router
  err := http.ListenAndServe(":9090", nil) // set listen port
   if err != nil {
    log.Fatal("ListenAndServe: ", err)
   }
}
```

- Build a static binary

```shell
$ cd $GOPATH/src/github.com/ansilh/demo-webapp
$ CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o $GOPATH/bin/demo-webapp
```

- Execute the program

```shell
$ demo-webapp
```
Open the browser and check if you can see the response using IP:9090
If you see the output “404 – Page not found – This is a dummy default backend” indicates that the program is working

Press Ctrl+c to terminate the program
