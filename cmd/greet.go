package cmd

import (
	"fmt"
	"strings"

	"github.com/spf13/cobra"
)

// greet is an example command showing how to wire flags, arguments, and
// RunE into a subcommand. Delete it and add your own commands in the same
// style, then register them in root.go's init().
func newGreetCommand() *cobra.Command {
	var (
		name  string
		caps  bool
		twice bool
	)

	greet := &cobra.Command{
		Use:               "greet [name]",
		Short:             "Print a greeting (example command)",
		Long:              "greet prints a greeting for the given name. It is an example of argument and flag handling; delete it once real commands exist.",
		Args:              cobra.MaximumNArgs(1),
		SilenceUsage:      true,
		ValidArgsFunction: cobra.NoFileCompletions,
		RunE: func(cmd *cobra.Command, args []string) error {
			who := name
			if who == "" && len(args) > 0 {
				who = args[0]
			}
			if who == "" {
				who = "world"
			}
			if caps {
				who = strings.ToUpper(who)
			}
			fmt.Fprintf(cmd.OutOrStdout(), "Hello, %s!\n", who)
			if twice {
				fmt.Fprintln(cmd.OutOrStdout(), "Hello again!")
			}
			return nil
		},
	}

	greet.Flags().StringVar(&name, "name", "", "name to greet (overrides the positional argument)")
	greet.Flags().BoolVar(&caps, "caps", false, "shout the name in uppercase")
	greet.Flags().BoolVar(&twice, "twice", false, "print a second line")

	return greet
}
