package cmd

import (
	"bytes"
	"testing"
)

func TestVersionMatchesVersionFile(t *testing.T) {
	want := version
	if want == "" {
		t.Fatal("version is empty; cmd/VERSION must contain MAJOR.MINOR.PATCH")
	}
}

func TestGreet(t *testing.T) {
	cases := map[string]struct {
		args []string
		name string
		caps bool
		want string
	}{
		"positional":     {args: []string{"ada"}, want: "Hello, ada!\n"},
		"default":        {want: "Hello, world!\n"},
		"caps":           {args: []string{"ada"}, caps: true, want: "Hello, ADA!\n"},
		"name flag wins": {args: []string{"arg"}, name: "flag", caps: true, want: "Hello, FLAG!\n"},
	}

	for label, tc := range cases {
		t.Run(label, func(t *testing.T) {
			out := &bytes.Buffer{}
			cmd := newGreetCommand()
			cmd.SetOut(out)
			cmd.SetArgs(nil)
			if tc.name != "" {
				if err := cmd.Flags().Set("name", tc.name); err != nil {
					t.Fatal(err)
				}
			}
			if tc.caps {
				if err := cmd.Flags().Set("caps", "true"); err != nil {
					t.Fatal(err)
				}
			}
			if err := cmd.RunE(cmd, tc.args); err != nil {
				t.Fatalf("RunE: %v", err)
			}
			if got := out.String(); got != tc.want {
				t.Fatalf("got %q, want %q", got, tc.want)
			}
		})
	}
}
