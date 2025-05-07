package utils

import "core:fmt"
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
		os.exit(69)
	}
}

read_filenames_in_dir_with_suffix :: proc(
	dirpath: string,
	suffix: string,
	filenames: ^[dynamic]string,
) {
	f, err := os.open(dirpath)
	if err != os.ERROR_NONE {
		fmt.eprintln("Could not open directory for reading", err)
		os.exit(69)
	}

	fis: []os.File_Info
	fis, err = os.read_dir(f, -1) // -1 reads all file infos
	if err != os.ERROR_NONE {
		fmt.eprintln("Could not read directory", err)
		os.exit(69)
	}

	for fi in fis {
		_, name := filepath.split(fi.fullpath)
		if strings.has_suffix(name, suffix) {
			append(filenames, name)
		}
	}
}

