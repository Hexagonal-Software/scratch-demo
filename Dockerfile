# base stap to build the executable
FROM golang:latest as build_phase

COPY ./ /project

WORKDIR /project

RUN CGO_ENABLED=0 go build -ldflags="-extldflags=-static" -o dist/demoexe .
RUN chmod +x ./dist/demoexe

# build the production final image
FROM scratch as PROD

LABEL "Maintainer"="Denis Rendler <connect@rendler.net>" \
      "App"="Scratch Demo"

# copy self-signed certs
COPY --chown=1000 ./server.key /scratch-demo/server.key
COPY --chown=1000 ./server.crt /scratch-demo/server.crt

# copy the executable from previous step
COPY --from=build_phase /project//dist/demoexe /scratch-demo/demoexe
# necessary in order to enable https
COPY --from=build_phase /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

WORKDIR /scratch-demo

ARG https_port=443
EXPOSE 443/tcp

USER 1000

ENTRYPOINT ["/scratch-demo/demoexe"]
