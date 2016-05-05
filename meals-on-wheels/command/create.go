package cli

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"os"
	"path"
	"regexp"
	"strconv"
	"strings"
	"time"
	"unicode"

  "github.com/eeyun/chef-essentials-classroom/mealsonwheels"

	"github.com/mitchellh/cli"
)


type rCreateConf struct {
	envType     string

	parallelism int

	accessKey   string
	secretKey   string
	region      string

	trainer     string
	customer    string
	classSize   int
}

// CreateCommand is a Command implementation that creates a dynamic Terraform
// configuration based on its parameters and builds from that configuration.
type CreateCommand struct {
	ShutdownCh <-chan struct{}
	Ui         cli.Ui
	conf       rCreateConf
	stopCh     chan struct{}
}

func (c *CreateCommand) Run(args []string) int {
	cmdFlags := flag.NewFlagSet("create", flag.ContinueOnError)
	cmdFlags.StringVar(&c.Meta.envType, "env-type", DefaultEnvType, "essentials")
	cmdFlags.IntVar(&c.Meta.parallelism, "parallelism", DefaultParallelism, "parallelism")
	cmdFlags.StringVar(&c.Meta.accessKey, "accesskey", "", "AWS_ACCESS_KEY")//&c.Meta.statePath, "state", DefaultStateFilename, "path")
	cmdFlags.StringVar(&c.Meta.secretKey, "secretkey", "", "AWS_SECRET_KEY")//&c.Meta.stateOutPath, "state-out", "", "path")
  cmdFlags.StringVar(&c.Meta.region, "region", "", "us-east-1")//&c.Meta.statePath, "state", DefaultStateFilename, "path")
	cmdFlags.StringVar(&c.Meta.trainer, "trainer", "", "\"Gob Bluth\"")//&c.Meta.backupPath, "backup", "", "path")
  cmdFlags.StringVar(&c.Meta.customer, "customer", "", "\"BluthCo\"")//&c.Meta.backupPath, "backup", "", "path")
  cmdFlags.IntVar(&c.Meta.classSize, "class-size", DefaultClassSize, "15")//&c.Meta.backupPath, "backup", "", "path")

	cmdFlags.Usage = func() { c.Ui.Error(c.Help()) }
	if err := cmdFlags.Parse(args); err != nil {
		return 1
	}

	pwd, err := os.Getwd()
	if err != nil {
		c.Ui.Error(fmt.Sprintf("Error getting pwd: %s", err))
		return 1
	}

	var configPath string
	maybeInit := true
	args = cmdFlags.Args()
	if len(args) > 1 {
		c.Ui.Error("The apply command expects at most one argument.")
		cmdFlags.Usage()
		return 1
	} else if len(args) == 1 {
		configPath = args[0]
	} else {
		configPath = pwd
		maybeInit = false
	}



	c.Ui.Output(c.Colorize().Color(fmt.Sprintf(
		"[reset][bold][green]\n"+
			"Create completed successfully, Guac server exists at %d!", guacServerIp)))
}


func (c *CreateCommand) Help() string {
	helpText := `
Usage: mealsonwheels create [options]
  Executes a training or demo environment creation by programmatically
  generating a terraform plan based on the [options] passed.

Options:
  -env-type=essentials         Training environment type defaults to essentials.
  -parallelism=100             Control concurrent operations, typically 100 for a 15 student
  -accesKey="ABC123XY"         AWS Access key to be used during provisioning.
  -secretKey="foo123bar456etc" AWS Secret key to be used during provisioning.
	-region="us-east-1"          AWS Region to be used during provisioning.
  -trainer="Gob Bluth"         Your name!
  -customer="BluthCo"          Customer the Demo or Training is being delivered to.
  -class-size="15"             If environment is training, how many students are attending.
`
	return strings.TrimSpace(helpText)
}
