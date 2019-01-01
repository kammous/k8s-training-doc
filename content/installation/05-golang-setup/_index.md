+++
menutitle = "Setup Golang"
date = 2018-12-29T17:15:52Z
weight = 9
chapter = false
pre = "<b>- </b>"
+++

# Setup Golang

Download Golang tarball
```shell
$ curl -O https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz
```

Extract the contents
```bash
tar -xvf go1.11.4.linux-amd64.tar.gz
```

Move the contents to /usr/local directory
```bash
sudo mv go /usr/local/
```

Add the environmental variable GOPATH to .profile
```bash
cat <<EOF >>~/.profile
export GOPATH=\$HOME/work
export PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin
EOF
```

Create the work directory
```bash
mkdir $HOME/work
```

Load the profile
```bash
source ~/.profile
```

Verify Golang setup
```bash
go version
```
```console
go version go1.11.4 linux/amd64
```

Create a directory tree to map to a github repository
```bash
mkdir -p $GOPATH/src/github.com/ansilh/golang-demo
```

Create a hello world golang program
```bash
vi $GOPATH/src/github.com/ansilh/golang-demo/main.go
```

Paste below code  
```go
package main
import "fmt"

func main(){  
 fmt.Println("Hello World.!")
}
```

Build and install the program
```bash
go install github.com/ansilh/golang-demo
```

Execute the program to see the output
```bash
golang-demo
```
```console
Hello World.!
```
