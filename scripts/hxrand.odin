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
		os.exit(69)
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

	themesdir := filepath.join({home, "/.config/helix/themes"})

	f, err := os.open(themesdir)
	defer os.close(f)

	if err != os.ERROR_NONE {
		fmt.eprintln("Could not open directory for reading", err)
		os.exit(2)
	}

	fis: []os.File_Info
	defer os.file_info_slice_delete(fis)

	fis, err = os.read_dir(f, -1) // -1 reads all file infos
	if err != os.ERROR_NONE {
		fmt.eprintln("Could not read directory", err)
		os.exit(3)
	}

	themes := make([dynamic]string)

	for fi in fis {
		_, name := filepath.split(fi.fullpath)
		append(&themes, strings.trim_suffix(name, ".toml"))
	}

	theme := rand.choice(themes[:])

	_, _, leftconfig := strings.partition(string(config), "\n")

	themeline := strings.concatenate({"theme = '", theme, "'\n"})
	defer delete(themeline)

	new_config := strings.concatenate({themeline, leftconfig})
	defer delete(new_config)

	writefile(configpath, new_config)
}

