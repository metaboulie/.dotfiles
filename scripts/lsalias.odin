/*
Parse and display fish shell aliases and functions.

Options:
- `-f, --file PATH` : Path to fish config file (relative to HOME)
- `--format FORMAT` : Display format for aliases (grid or inline)
- `--compact`       : Don't print empty lines between groups
- `-h, --help`      : Show help message
*/
package main

import "core:fmt"
import "core:io"
import "core:os"
import "core:path/filepath"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:time"
import "core:unicode/utf8"

// ANSI color codes
Colors :: struct {
	reset:      string,
	bold_blue:  string,
	bold_green: string,
	yellow:     string,
	magenta:    string,
	cyan:       string,
	gray:       string,
}

colors := Colors {
	"\033[0m",
	"\033[1;34m",
	"\033[1;32m",
	"\033[33m",
	"\033[35m",
	"\033[36m",
	"\033[90m",
}

ViewFormat :: enum {
	Grid,
	Inline,
}

AliasItem :: struct {
	name: string,
	desc: string,
}

AliasGroup :: struct {
	name:  string,
	items: [dynamic]AliasItem,
}

add_item :: proc(group: ^AliasGroup, item: AliasItem) {
	append(&group.items, item)
}

AliasView :: struct {
	groups:  []AliasGroup,
	format:  ViewFormat,
	compact: bool,
}

print_grid :: proc(view: AliasView) {
	for group in view.groups {
		// Print group name in bold blue
		fmt.printf("%s%s%s\n", colors.bold_blue, group.name, colors.reset)
		fmt.printf("%s%s%s\n", colors.gray, strings.repeat("-", 40), colors.reset)

		if len(group.items) == 0 {
			fmt.println("No items in this group")
			if !view.compact {
				fmt.println()
			}
			continue
		}

		// Find the longest name for padding
		max_name_len := 0
		for item in group.items {
			max_name_len = max(max_name_len, len(item.name))
		}

		// Print each item
		for item in group.items {
			name_part := fmt.aprintf("%s%s%s", colors.yellow, item.name, colors.reset)
			padded_name := fmt.aprintf("%-*s", max_name_len + 10, name_part)
			fmt.printf(
				"%s%s|%s %s%s%s\n",
				padded_name,
				colors.magenta,
				colors.reset,
				colors.cyan,
				item.desc,
				colors.reset,
			)
		}

		if !view.compact {
			fmt.println() // Empty line between groups
		}
	}
}

print_inline :: proc(view: AliasView) {
	for group in view.groups {
		fmt.printf("%s%s:%s ", colors.bold_green, group.name, colors.reset)

		if len(group.items) == 0 {
			fmt.println("No items")
			continue
		}

		items_str := make([dynamic]string)
		defer delete(items_str)

		for item in group.items {
			str := fmt.aprintf(
				"%s%s%s (%s%s%s)",
				colors.magenta,
				item.name,
				colors.reset,
				colors.cyan,
				item.desc,
				colors.reset,
			)
			append(&items_str, str)
		}

		fmt.println(strings.join(items_str[:], ", "))
		if !view.compact {
			fmt.println() // Empty line between groups
		}
	}
}

pprint :: proc(view: AliasView) {
	switch view.format {
	case .Grid:
		print_grid(view)
	case .Inline:
		print_inline(view)
	case:
		fmt.eprintln("Unknown format")
	}
}

parse_config :: proc(config_content: string) -> [dynamic]AliasGroup {
	groups := make([dynamic]AliasGroup)

	// Look for content after the "###" marker
	parts := strings.split(config_content, "###")
	defer delete(parts)

	if len(parts) <= 1 {
		return groups
	}

	match := strings.trim_space(parts[1])
	lines := strings.split_lines(match)
	defer delete(lines)

	current_group: AliasGroup
	current_item: AliasItem

	for line in lines {
		line := strings.trim_space(line)

		if len(line) == 0 {
			continue
		}

		if strings.has_prefix(line, "##") {
			// Save previous group if it has a name and items
			if len(current_group.name) > 0 && len(current_group.items) > 0 {
				append(&groups, current_group)
				current_group.items = make([dynamic]AliasItem)
			} else if current_group.items.allocator.procedure != nil {
				delete(current_group.items)
			}

			// Start a new group
			current_group = AliasGroup {
				name  = strings.trim_space(line[2:]),
				items = make([dynamic]AliasItem),
			}
		} else if strings.has_prefix(line, "#") {
			// This is a description line for the next alias
			current_item = AliasItem {
				desc = strings.trim_space(line[1:]),
			}
		} else if strings.has_prefix(line, "alias") || strings.has_prefix(line, "function") {
			// This is an alias or function definition
			parts := strings.split(line, " ")
			defer delete(parts)

			if len(parts) > 1 {
				current_item.name = strings.trim_space(parts[1])
				add_item(&current_group, current_item)
				current_item = AliasItem{} // Reset for next item
			}
		}
	}

	// Add the last group if it has a name and items
	if len(current_group.name) > 0 && len(current_group.items) > 0 {
		append(&groups, current_group)
	}

	return groups
}

main :: proc() {
	// Default config file path
	default_config := "/.config/fish/config.fish"

	// Set default format
	format := ViewFormat.Inline
	compact := false

	// Process command line arguments (simple version)
	args := os.args[1:]
	config_path := default_config

	i := 0
	for i < len(args) {
		if args[i] == "-f" || args[i] == "--file" {
			if i + 1 < len(args) {
				config_path = args[i + 1]
				i += 2
				continue
			}
		} else if args[i] == "--format" {
			if i + 1 < len(args) {
				if args[i + 1] == "grid" {
					format = .Grid
				} else if args[i + 1] == "inline" {
					format = .Inline
				}
				i += 2
				continue
			}
		} else if args[i] == "--compact" {
			compact = true
			i += 1
			continue
		} else if args[i] == "-h" || args[i] == "--help" {
			fmt.println("lsalias - List and display fish shell aliases in a colorful format")
			fmt.println("Options:")
			fmt.println("  -f, --file PATH   Path to fish config file (relative to HOME)")
			fmt.println("  --format FORMAT   Display format for aliases (grid or inline)")
			fmt.println("  --compact         Don't print empty lines between groups")
			fmt.println("  -h, --help        Show this help message")
			return
		}
		i += 1
	}

	// Get the HOME environment variable
	home := os.get_env("HOME")
	if home == "" {
		fmt.eprintln("Error: HOME environment variable not set")
		os.exit(1)
	}

	// Build the full path to the config file
	if strings.has_prefix(config_path, "/") {
		config_path = config_path[1:]
	}

	filepath := filepath.join({home, config_path})

	// Try to read the config file
	config_content, ok := os.read_entire_file(filepath)
	if !ok {
		fmt.eprintf("Error reading config file: %s\n", filepath)
		os.exit(1)
	}
	defer delete(config_content)

	// Parse the config file and extract aliases
	groups := parse_config(string(config_content))
	defer {
		for group in groups {
			delete(group.items)
		}
		delete(groups)
	}

	if len(groups) == 0 {
		fmt.printf("No alias groups found in %s\n", filepath)
		fmt.println("Make sure your config file has sections marked with '###' and '##'")
		return
	}

	// Display the aliases
	view := AliasView {
		groups  = groups[:],
		format  = format,
		compact = compact,
	}
	pprint(view)
}
