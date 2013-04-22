package main

import "fmt"
import "net"

func main() {
	var conn net.Conn
	var err error
	conn, err = net.Dial("tcp", "127.0.0.1:8000")
	if err != nil {
    	fmt.Println("Error occured while connecting...")
   		fmt.Println(err)
	}
	if conn != nil {
		err = conn.Close()
		if err != nil {
			fmt.Println(err)
		}
	}
}

