.PHONY: deps clean build

deps:
	go get -u ./...

clean: 
	rm -rf ./hello-world/hello-world
	
build:
	GOOS=linux GOARCH=amd64 go build -o hello-world/hello-world ./hello-world
	GOOS=linux GOARCH=amd64 go build -o score-register/score-register ./score-register
	GOOS=linux GOARCH=amd64 go build -o score-fetcher/score-fetcher ./score-fetcher

# 追加
package:
	sam package --template-file template.yaml --output-template-file output-template.yaml --s3-bucket sam-template-store-takara --profile takara

# 追加
deploy:
	sam deploy --template-file output-template.yaml --stack-name sam-template-store-takara --capabilities CAPABILITY_IAM --profile takara

dynamodb:
	aws dynamodb create-table --table-name Score --attribute-definitions AttributeName=PersonID,AttributeType=S AttributeName=TestID,AttributeType=S --key-schema AttributeName=PersonID,KeyType=HASH AttributeName=TestID,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 --profile takara