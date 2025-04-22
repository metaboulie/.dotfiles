/*
Randomise the theme of helix on startup.
*/
package main

import "core:fmt"
import "core:math/rand"
import "core:os"
import "core:path/filepath"
import "core:strings"

readfile :: proc(filepath: string) -> string {
	content, ok := os.read_entire_file(filepath)
	if !ok {
		fmt.eprintf("Error reading config file: %s\n", filepath)
		os.exit(1)
	}
	defer delete(content)

	str := strings.trim_space(string(content))
	return strings.clone(str)
}

writefile :: proc(filepath: string, content: string) {
	bytcontent := transmute([]byte)(content)
	if !os.write_entire_file(filepath, bytcontent) {
		fmt.println("Error writing file")
	}
}

main :: proc() {
	home := os.get_env("HOME")
	if home == "" {
		fmt.eprintln("Error: HOME environment variable not set")
		os.exit(1)
	}

	configpath := filepath.join({home, "/.config/helix/config.toml"})
	defer delete(configpath)
	config := readfile(configpath)
	defer delete(config)

	themepath := filepath.join({home, "/.config/helix/themes"})
	defer delete(themepath)
	themes := strings.split(readfile(themepath), ",")
	defer delete(themes)

	theme := rand.choice(themes[:])

	_, _, leftconfig := strings.partition(string(config), "\n")

	themeline := strings.concatenate({"theme = '", theme, "'\n"})
	defer delete(themeline)

	new_config := strings.concatenate({themeline, leftconfig})
	defer delete(new_config)

	writefile(configpath, new_config)
}

