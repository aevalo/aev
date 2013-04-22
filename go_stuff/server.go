package main

import "fmt"
import "net"
//import "io"
import "bytes"
import "sync"

var wg sync.WaitGroup

func handleConnection(conn net.Conn) {
	var err error
	if conn != nil {
		fmt.Println("Handling connection...")
		data := make([]byte, 512)
		//_, err = io.ReadFull(conn, data)
		_, err = conn.Read(data)
		if err != nil {
			fmt.Println(err)
		}
		buf := bytes.NewBuffer(data)
		fmt.Println(buf.String())
		err = conn.Close()
		if err != nil {
			fmt.Println(err)
		}
	}
	// Decrement the counter.
	wg.Done()
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
		conn, err = ln.Accept()
		if err != nil {
			fmt.Println("Error occured while accepting connection...")
		} else {
			// Increment the WaitGroup counter
			wg.Add(1)
			// Start the coroutine to handle connection
			go handleConnection(conn)
			// Wait for the handler to complete
			wg.Wait()
		}
	}
}


