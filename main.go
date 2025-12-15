package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/api/hello", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello from the Go API!")
	})

	fmt.Println("Go API listening on :10000")
	if err := http.ListenAndServe(":10000", nil); err != nil {
		log.Fatal(err)
	}
}
