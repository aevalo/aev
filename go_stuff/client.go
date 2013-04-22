package main

import "fmt"
import "net"
import "io"

func main() {
	var conn net.Conn
	var err error
	conn, err = net.Dial("tcp", "127.0.0.1:8000")
	if err != nil {
    	fmt.Println("Error occured while connecting...")
   		fmt.Println(err)
	}
	if conn != nil {
		//var n int
		_, err = io.WriteString(conn, "Hello, World!!!")
		if err != nil {
			fmt.Println(err)
		}
		err = conn.Close()
		if err != nil {
			fmt.Println(err)
		}
	}
}

