+++
menutitle = "Setup Golang"
date = 2018-12-29T17:15:52Z
weight = 9
chapter = false
pre = "<b>- </b>"
+++

# Setup Golang

* Download Golang tarball
```
curl -O https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz
```

* Extract the contents
```
tar -xvf go1.11.4.linux-amd64.tar.gz
```

* Move the contents to /usr/local directory
```
sudo mv go /usr/local/
```

* Add the environmental variable GOPATH to .profile
```
cat <<EOF >>~/.profile
export GOPATH=\$HOME/work
export PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin
EOF
```

* Create the work directory
```
mkdir $HOME/work
```

* Load the profile
```
source ~/.profile
```

* Verify Golang setup
```
go version
```
```
 go version go1.11.4 linux/amd64
```

* Create a directory tree to map to a github repository
```
mkdir -p $GOPATH/src/github.com/ansilh/golang-demo
```

* Create a hello world golang program
```
vi $GOPATH/src/github.com/ansilh/golang-demo/main.go
```

* Paste below code

  ```
package main
import "fmt"

func main(){  
 fmt.Println("Hello World.!")
}
```

* Build and install the program
```
go install github.com/ansilh/golang-demo
```

* Execute the program to see the output
```
golang-demo
```
```
Hello World.!
```
