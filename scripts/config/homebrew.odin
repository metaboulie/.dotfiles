// Keep a record of installments from homebrew
package homebrew

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"

import utils "../utils"

HomebrewConfig :: struct {
	formulae: [dynamic]string,
	casks:    [dynamic]string,
}

// TODO: implement a parser for toml first
read_homebrew_config :: proc(configstr: string) -> (config: ^HomebrewConfig) {
	fmt.print(configstr)
	return
}

main :: proc() {
	home := os.get_env("HOME")
	if home == "" {
		fmt.eprintln("Error: HOME environment variable not set")
		os.exit(1)
	}

	configpath := filepath.join({home, "/.config/homebrew.toml"})
	defer delete(configpath)

	configstr := utils.readfile(configpath)
	defer delete(configstr)

	config := read_homebrew_config(configstr)

	mode := os.args[1]
	names := os.args[2:]

	// NOTE: when recoding, make sure in alphabet order
	for name in names {
	}
}

