## Supported tags and respective `Dockerfile` links

* [`latest`](https://github.com/sona-tar/dockerfile-godevcli)

## What's in this image?

Golang Development Tools on Ubuntu.

### Editor

* Emacs
* Vim

### Language

* Golang
* C/C++
* Perl
* Python
* Ruby


### Github

* [hub](https://github.com/github/hub) - Command-line wrapper for git that makes you better at GitHub.
* [ghq](https://github.com/motemen/ghq) -  Manage remote repository clones
* [ghr](https://github.com/tcnksm/ghr) - Easily ship your project to your user using Github Releases.
* [ghs](https://github.com/sona-tar/ghs) -  search repository in github

### Utils

* [brew](https://github.com/Homebrew/linuxbrew) - Linuxbrew is a fork of Homebrew, the Mac OS package manager, for Linux.
* [peco](https://github.com/peco/peco) - Simplistic interactive filtering tool
* [GNU Global and pygments](http://qiita.com/sona-tar/items/672df1259a76f082ce42) - Source code tagging system. Support Golang, Ruby, Python, C/C++ and more.
* [gorename](http://mattn.kaoriya.net/software/lang/go/20150113141338.htm) Type-safe renaming of identifiers.


### Alias

* [gpi](http://qiita.com/sona-tar/items/c11063cd3671c07b6e0a) - ghs | peco | ghq import


### Global alias

* [General git filters](http://qiita.com/sona-tar/items/fe401c597e8e51d4e243)
```
$ git add F
$ git rebase H
$ git checkout H
```

## Getting Started

### Docker and Docker Compose installation

- CentOS

```
# yum -y install docker python-pip
# pip install docker-compose
# chkconfig docker on
# service docker start
```

- Ubuntu

```
# apt-get install docker.io python-pip
# pip install docker-compose
```


### How to use this image

```
# git clone https://github.com/sona-tar/devtools-dockerfile.git
# cd devtools-dockerfile
```

SSH Login
```
# docker-compose up -d
Pulling dev (sonatar/devtools-dockerfile:latest)...
Creating devtoolsdockerfile_dev_1...

# docker-compose ps
Name                  Command        State           Ports
----------------------------------------------------------------------------
devtoolsdockerfile_dev_1   /usr/sbin/sshd -D   Up      0.0.0.0:10022->22/tcp

# CONTAINERHOST=localhost
# ssh -p 10022 develop@${CONTAINERHOST}
[develop ~]$
```

or docker run zsh
```
$ docker-compose run -u develop dev /usr/bin/zsh
[develop /]$ cd
[develop ~]$
```

### Git settings

```
export GITHUB_USER=YOU
$ git config --global user.name    ${GITHUB_USER}
$ git config --global user.email   username@gmail.com
$ git config --global github.user  ${GITHUB_USER}
$ git config --global github.token ....
$ git config --global push.default simple
```
Get [Github token](https://github.com/settings/tokens)


Let’s get started !!


## Develop examples

### Create Reapository

```
$ mkdir -p ~/src/github.com/${GITHUB_USER}/go-sample
$ cd ~/src/github.com/${GITHUB_USER}/go-sample
$ git init
$ hub create
```

### Write Golang Code
```
cat << '_EOF_' > sample-main.go
package main

func main() {
     SamplePrint("test 1")
     SamplePrint("test 2")
}
_EOF_

cat << '_EOF_' > sample-print.go
package main

import  "fmt"

func SamplePrint(msg string) {
     fmt.Printf("go-sample %s\n", msg)
}
_EOF_

$ go build
$ ./go-sample
go-sample test 1
go-sample test 2
```

### Commit and Push

```
$ git add sample-main.go sample-print.go
$ git commit -m "Add sample-main.go sample-print.go"
$ git tag -a 0.0.1 -m "Release 0.0.1"
$ git push --tag origin master
```

### Release binary

Build for Multi platoforms by gox.


```
$ goxa 0.0.1
```

Release all binary by ghr.

```
$ release_pkg.sh 0.0.1
$ hub release
 (0.0.1)
$ hub browse
```

Create homebrew fomula

```
$ mkdir ~/src/github.com/${GITHUB_UWER}/homebrew-tools
$ cd ~/src/github.com/${GITHUB_UWER}/homebrew-tools
$ git init
$ hub create
```

```
cat << _EOF_ > go-sample.rb
require "language/go"

USER="${GITHUB_USER}"

class GoSample < Formula
  url  "https://github.com/#{USER}/go-sample", :using => :git, :tag => "0.0.1"
  head "https://github.com/#{USER}/go-sample", :using => :git, :branch => "master"

  depends_on "go" => :build
  depends_on :hg => :build

  # If you have dependency package
  # go_resource "github.com/google/go-querystring" do
  #   url "https://github.com/google/go-querystring.git", :branch => "master"
  # end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/#{USER}/go-sample"
    ln_sf buildpath, buildpath/"src/github.com/#{USER}/go-sample"
    Language::Go.stage_deps resources, buildpath/"src"

    # Build and install
    system "go", "build", "-o", "go-sample"
    bin.install "go-sample"
  end
end
_EOF_
```

```
$ git add go-sample.rb
$ git commit -m "First commit"
$ git push origin master
```

Install by homebrew

```
$ brew install ${GITHUB_USER}/tools/go-sample
$ which go-sample
/home/develop/.linuxbrew/bin/go-sample
```
