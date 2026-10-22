package cmd

import (
	_ "embed"
	"fmt"
	"os"
	"strings"

	"github.com/spf13/cobra"
)

//go:embed VERSION
var versionRaw string

var version = strings.TrimSpace(versionRaw)

// rename `Use` and `Short` to match the new CLI; the pre-commit hook and CI
// check cmd/VERSION and CHANGELOG.md formats.
var rootCmd = &cobra.Command{
	Use:           "app",
	Short:         "app is a command-line tool built from go-cli-template",
	SilenceErrors: false,
	SilenceUsage:  true,
}

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Print the app version",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println(version)
	},
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}

func init() {
	rootCmd.AddCommand(
		versionCmd,
		newGreetCommand(),
	)
}
