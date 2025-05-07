// Randomise the theme of helix on startup.
package helix

import "core:fmt"
import "core:math/rand"
import "core:os"
import "core:path/filepath"
import "core:strings"

import utils "../utils"

CONFIG_FILE :: "/.config/helix/config.toml"
THEMES_DIR :: "/.config/helix/themes"

main :: proc() {
	home := utils.get_home()

	configpath := filepath.join({home, CONFIG_FILE})
	config := utils.readfile(configpath)

	themesdir := filepath.join({home, THEMES_DIR})

	themes := make([dynamic]string)
	utils.read_filenames_in_dir_with_suffix(themesdir, ".toml", &themes)

	theme := strings.trim_suffix(rand.choice(themes[:]), ".toml")

	_, _, leftconfig := strings.partition(string(config), "\n")

	themeline := strings.concatenate({"theme = '", theme, "'\n"})

	new_config := strings.concatenate({themeline, leftconfig})

	utils.writefile(configpath, new_config)
}

