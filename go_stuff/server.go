package main

import "fmt"
import "net"

func handleConnection(conn net.Conn) {
	var err error
	if conn != nil {
		fmt.Println("Handling connection...")
		err = conn.Close()
		if err != nil {
			fmt.Println(err)
		}
	}
}

func main() {
	var ln net.Listener
	var conn net.Conn
	var err error
	ln, err = net.Listen("tcp", "127.0.0.1:8000")
	if err != nil {
    	fmt.Println("Error occured while listening for connections...")
   		fmt.Println(err)
	}
	if ln != nil {
		for {
			conn, err = ln.Accept()
			if err != nil {
    			fmt.Println("Error occured while accepting connection...")
				continue
			}
			go handleConnection(conn)
			break
		}
	}
}

