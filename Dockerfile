# Source: https://github.com/rebuy-de/golang-template
# Version: 1.3.1

FROM golang:1.11-alpine

RUN apk add --no-cache git make

# Configure Go
ENV GOPATH /go
ENV PATH /go/bin:$PATH
RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

# Install Go Tools
RUN go get -u golang.org/x/lint/golint

# Install Glide
RUN go get -u github.com/Masterminds/glide/...

WORKDIR /go/src/github.com/Masterminds/glide

RUN git checkout v0.12.3
RUN go install

COPY . /go/src/github.com/rebuy-de/aws-nuke
WORKDIR /go/src/github.com/rebuy-de/aws-nuke
RUN CGO_ENABLED=0 make install

WORKDIR /opt

CMD /go/bin/aws-nuke -c config/nuke-config.yaml --access-key-id $AWS_ACCESS_KEY_ID --secret-access-key $AWS_SECRET_ACCESS_KEY