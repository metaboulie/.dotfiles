package utils

import "core:fmt"
import "core:os"

get_home :: proc() -> string {
	home := os.get_env("HOME")
	if home == "" {
		fmt.eprintln("Error: HOME environment variable not set")
		os.exit(69)
	}
	return home
}

