package main

import "core:fmt"
import "core:os"
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

