package main

import (
	"fmt"
	"html"
	"log"
	"net/http"
)

func main() {

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, %q from Scratch Demo!", html.EscapeString(r.URL.Path))
	})

	log.Fatal(http.ListenAndServeTLS(":443", "server.crt", "server.key", nil))
}
