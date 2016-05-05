/*

mealsonwheels - Chef Demo and Training Environments builder written in Go

Copyright (c) 2016 Ian Henry

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package main
import (
	"log"
	"fmt"
	"time"

	"golang.org/x/net/context"

  "github.com/coreos/etcd/client"

  "github.com/mitchellh/cli"
)

func main() {
  c := cli.NewCLI("mealsonwheels", "1.0.0")
   c.Args = os.Args[1:]
   c.Commands = map[string]cli.CommandFactory{
       "create": createCommandFactory,
       "destroy": destroyCommandFactory,
   }

   exitStatus, err := c.Run()
   if err != nil {
       log.Println(err)
   }

   os.Exit(exitStatus)
}
