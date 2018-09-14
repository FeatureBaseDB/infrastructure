package main

import (
	"encoding/json"
	"fmt"
	"os"

	"github.com/jaffee/commandeer/cobrafy"
	"github.com/pkg/errors"
)

func main() {
	err := cobrafy.Execute(NewCommand())
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

type Command struct {
	Inventory string `help:"Name of inventory file to write."`
	Variables string `help:"Name of variable file to write."`
}

func NewCommand() *Command {
	return &Command{
		Inventory: "ans_inventory.ini",
		Variables: "ans_variables.yml",
	}
}

type tfOutput map[string]tfVal

type tfVal struct {
	Sensitive bool
	Type      string
	Value     interface{}
}

// Run runs.
func (c *Command) Run() error {
	invF, err := os.Create(c.Inventory)
	if err != nil {
		return errors.Wrap(err, "opening inventory")
	}
	defer invF.Close()
	varF, err := os.Create(c.Variables)
	if err != nil {
		return errors.Wrap(err, "opening variables")
	}
	defer varF.Close()

	dec := json.NewDecoder(os.Stdin)
	output := make(tfOutput)
	err = dec.Decode(&output)
	if err != nil {
		return errors.Wrap(err, "decoding json")
	}
	vars := make(map[string]string)
	for k, v := range output {
		if v.Type == "list" {
			_, err := fmt.Fprintf(invF, "[%s]\n", k)
			if err != nil {
				return errors.Wrap(err, "printing inventory")
			}
			for _, val := range v.Value.([]interface{}) {
				_, err := fmt.Fprintf(invF, "%s\n", val)
				if err != nil {
					return errors.Wrap(err, "printing inventory")
				}
			}
			_, err = fmt.Fprintln(invF)
			if err != nil {
				return errors.Wrap(err, "printing inventory")
			}
		}
		if v.Type == "string" {
			vars[k] = v.Value.(string)
		}
	}

	for name, val := range vars {
		_, err := fmt.Fprintf(varF, `%s: "%s"
`, name, val)
		if err != nil {
			return errors.Wrap(err, "printing vars")
		}
	}

	return nil
}
