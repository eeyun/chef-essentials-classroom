package command

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strconv"

  "github.com/mitchellh/cli"
  "github.com/mitchellh/colorstring"
)

/ Meta are the meta-options that are available on all or most commands.
type Meta struct {
	Color       bool
	Ui          cli.Ui

	// This can be set by tests to change some directories
	dataDir string

	// Variables for the context (private)
	autoKey       string
	autoVariables map[string]string
	input         bool
	variables     map[string]string

	// Targets for this context (private)
	targets []string

	color bool
	oldUi cli.Ui

	// The fields below are expected to be set by the command via
	// command line flags. See the Apply command for an example.
	//
	// parallelism is used to control the number of concurrent operations
	// allowed when walking the graph
  envType      string


	parallelism  int
}

// Colorize returns the colorization structure for a command.
func (m *Meta) Colorize() *colorstring.Colorize {
	return &colorstring.Colorize{
		Colors:  colorstring.DefaultColors,
		Disable: !m.color,
		Reset:   true,
	}
}

// DataDir returns the directory where local data will be stored.
func (m *Meta) DataDir() string {
	dataDir := DefaultDataDirectory
	if m.dataDir != "" {
		dataDir = m.dataDir
	}

	return dataDir
}

// DataDir returns the directory where local data will be stored.
func (m *Meta) EnvType() string {
	envType := DefaultEnvType
	if m.envType != "" {
		envType = m.envType
	}

	return envType
}
