// Parse and display fish shell aliases and functions.
package main

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"

import utils "../utils"

Colors :: enum {
	reset,
	bold_green,
	magenta,
	cyan,
}

colors := [Colors]string {
	.reset      = "\033[0m",
	.bold_green = "\033[1;32m",
	.magenta    = "\033[35m",
	.cyan       = "\033[36m",
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

print_inline :: proc(groups: []AliasGroup) {
	fmt.println()
	for group in groups {
		fmt.printf("%s%s:%s ", colors[.bold_green], group.name, colors[.reset])

		if len(group.items) == 0 {
			continue
		}

		items_str := make([dynamic]string)

		for item in group.items {
			str := fmt.aprintf(
				"%s%s%s (%s%s%s)",
				colors[.magenta],
				item.name,
				colors[.reset],
				colors[.cyan],
				item.desc,
				colors[.reset],
			)
			append(&items_str, str)
		}

		fmt.println(strings.join(items_str[:], ", "))
		fmt.println()
	}
}

parse_fish_config :: proc(config_content: string) -> [dynamic]AliasGroup {
	groups := make([dynamic]AliasGroup)

	parts := strings.split(config_content, "###")

	if len(parts) <= 1 {
		fmt.eprintln("Make sure your config file has sections marked with '###' and '##'")
		os.exit(69)
	}

	match := strings.trim_space(parts[1])
	lines := strings.split_lines(match)

	current_group: AliasGroup
	current_item: AliasItem

	for line in lines {
		line := strings.trim_space(line)

		if len(line) == 0 {
			continue
		}

		if strings.has_prefix(line, "##") {
			// Save previous group
			if len(current_group.name) > 0 && len(current_group.items) > 0 {
				append(&groups, current_group)
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

CONFIG_PATH :: "/.config/fish/config.fish"

main :: proc() {
	filepath := filepath.join({utils.get_home(), CONFIG_PATH})
	config_content := utils.readfile(filepath)
	groups := parse_fish_config(config_content)
	print_inline(groups[:])
}

