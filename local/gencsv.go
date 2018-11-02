package main

import (
	"fmt"
	"io"
	"os"
)

func fullArray(f io.Writer, slice int) {
	x := (slice * 1 << 20)
	for i := 0; i < 4096; i++ {
		fmt.Fprintf(f, "0,%d\n", x)
		x += 2
	}
}

func fullRun(f io.Writer, slice int) {
	offset := (slice * 1 << 20)
	for i := 0; i < 2048; i++ {
		for x := offset + 1; x < offset+32; x++ {
			fmt.Fprintf(f, "0,%d\n", i*32+x)
		}
	}
}

func fullBitmap(f io.Writer, slice int) {
	offset := (slice * 1 << 20)
	for i := 0; i < 65536; i += 2 {
		fmt.Fprintf(f, "0,%d\n", i+offset)
	}
}

func values(f io.Writer) {
	for i := 0; i < 100; i++ {
		fmt.Fprintf(f, "0,%d\n", i)
	}
}

func main() {
	f, err := os.Create("full-array.csv")
	if err != nil {
		panic(err)
	}
	defer f.Close()
	fullArray(f, 0)
	fullArray(f, 1)
	fullArray(f, 2)
	fullArray(f, 3)
	fullArray(f, 4)
	fullArray(f, 5)
	fullArray(f, 6)
	fullArray(f, 7)
	fullArray(f, 8)
	fullArray(f, 9)

	f, err = os.Create("full-run.csv")
	if err != nil {
		panic(err)
	}
	defer f.Close()
	fullRun(f, 0)
	fullRun(f, 1)
	fullRun(f, 2)
	fullRun(f, 3)
	fullRun(f, 4)
	fullRun(f, 5)
	fullRun(f, 6)
	fullRun(f, 7)
	fullRun(f, 8)
	fullRun(f, 9)

	f, err = os.Create("full-bitmap.csv")
	if err != nil {
		panic(err)
	}
	defer f.Close()
	fullBitmap(f, 0)
	fullBitmap(f, 1)
	fullBitmap(f, 2)
	fullBitmap(f, 3)
	fullBitmap(f, 4)
	fullBitmap(f, 5)
	fullBitmap(f, 6)
	fullBitmap(f, 7)
	fullBitmap(f, 8)
	fullBitmap(f, 9)

	f, err = os.Create("values.csv")
	if err != nil {
		panic(err)
	}
	defer f.Close()
	values(f)
}
