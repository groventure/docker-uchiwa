set -e

mkdir -p go
go get github.com/tools/godep
go get github.com/sensu/uchiwa

cd "$GOPATH/src/github.com/sensu/uchiwa"

npm install --production
godep go install

rm -rvf "$GOPATH/src/github.com/tools/godep"
set +e
