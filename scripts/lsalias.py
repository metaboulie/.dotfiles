"""
List and display fish shell aliases in a colorful, structured format.
"""

import os
import sys
from argparse import ArgumentParser
from dataclasses import dataclass, field
from pathlib import Path
from typing import Literal

ViewFormat = Literal["grid", "inline"]

# ANSI color codes
COLORS = {
    "reset": "\033[0m",
    "bold_blue": "\033[1;34m",
    "bold_green": "\033[1;32m",
    "yellow": "\033[33m",
    "magenta": "\033[35m",
    "cyan": "\033[36m",
    "gray": "\033[90m",
}


@dataclass
class AliasItem:
    """Represents a single alias with its name and description."""

    name: str = ""
    desc: str = ""


@dataclass
class AliasGroup:
    """A group of related aliases."""

    name: str = ""
    items: list[AliasItem] = field(default_factory=list)

    def add_item(self, item: AliasItem) -> None:
        """Add an alias item to this group."""
        self.items.append(item)


@dataclass
class AliasView:
    """Handles the display of alias groups."""

    groups: list[AliasGroup]
    format: ViewFormat

    def pprint(self) -> None:
        """Print aliases in the specified format.

        Raises:
            ValueError: If the format is unknown
        """
        if self.format == "grid":
            self._print_grid()
        elif self.format == "inline":
            self._print_inline()
        else:
            msg = f"Unknown format: {self.format}"
            raise ValueError(msg)

    def _print_grid(self) -> None:
        """Print aliases in a grid format."""
        for group in self.groups:
            # Print group name in bold blue
            print(f"{COLORS['bold_blue']}{group.name}{COLORS['reset']}")
            print(f"{COLORS['gray']}{'-' * 40}{COLORS['reset']}")

            if not group.items:
                print("No items in this group")
                print()
                continue

            # Find the longest name for padding
            max_name_len = max(len(item.name) for item in group.items)

            # Print each item
            for item in group.items:
                name_part = f"{COLORS['yellow']}{item.name}{COLORS['reset']}".ljust(
                    max_name_len + 10
                )
                print(
                    f"{name_part}{COLORS['magenta']}|{COLORS['reset']} {COLORS['cyan']}{item.desc}{COLORS['reset']}"
                )

            print()  # Empty line between groups

    def _print_inline(self) -> None:
        """Print aliases in a compact inline format."""
        for group in self.groups:
            print(f"{COLORS['bold_green']}{group.name}:{COLORS['reset']}", end=" ")

            if not group.items:
                print("No items")
                continue

            items_str = [
                f"{COLORS['magenta']}{item.name}{COLORS['reset']} ({COLORS['cyan']}{item.desc}{COLORS['reset']})"
                for item in group.items
            ]

            print(", ".join(items_str))
            print()  # Empty line between groups


def parse_config(config_content: str) -> list[AliasGroup]:
    """
    Parse fish config file content and extract alias groups.

    The function looks for sections marked with '###' and then processes
    groups marked with '##' containing aliases or functions.

    Returns:
        list[AliasGroup]: List of alias groups found in the config file
    """
    _, _, match = config_content.partition("###")
    if not match:
        return []

    groups = []
    current_group = AliasGroup()
    current_item = AliasItem()

    for line in match.strip().split("\n"):
        line = line.strip()  # noqa: PLW2901

        if not line:
            continue

        if line.startswith("##"):
            # Save previous group if it has a name and items
            if current_group.name and current_group.items:
                groups.append(current_group)

            # Start a new group
            current_group = AliasGroup(name=line.removeprefix("## ").strip())

        elif line.startswith("#"):
            # This is a description line for the next alias
            current_item = AliasItem(desc=line.removeprefix("# ").strip())

        elif line.startswith(("alias", "function")):
            # This is an alias or function definition
            try:
                current_item.name = line.split(" ")[1].strip()
                current_group.add_item(current_item)
                current_item = AliasItem()  # Reset for next item
            except IndexError:
                # Skip malformed lines
                continue

    # Add the last group if it has a name and items
    if current_group.name and current_group.items:
        groups.append(current_group)

    return groups


def main() -> int:
    """Main entry point for the script.

    Returns:
        int: 0 on success, 1 on error
    """
    parser = ArgumentParser(
        prog="lsalias",
        description="List and display fish shell aliases in a colorful format",
        epilog="Looks for aliases defined after '###' marker in your fish config",
    )
    parser.add_argument(
        "-f",
        "--file",
        default="/.config/fish/config.fish",
        help="Path to fish config file (relative to HOME)",
    )
    parser.add_argument(
        "--format",
        choices=["grid", "inline"],
        default="inline",
        help="Display format for the aliases",
    )

    args = parser.parse_args()

    # Build the full path to the config file
    home = os.getenv("HOME")
    if not home:
        print("Error: HOME environment variable not set", file=sys.stderr)
        return 1

    filepath = Path(home) / args.file.lstrip("/")

    # Try to read the config file
    try:
        config_content = filepath.read_text(encoding="utf-8")
    except (FileNotFoundError, PermissionError) as e:
        print(f"Error reading config file: {e}", file=sys.stderr)
        return 1

    # Parse the config file and extract aliases
    groups = parse_config(config_content)

    if not groups:
        print(f"No alias groups found in {filepath}")
        print("Make sure your config file has sections marked with '###' and '##'")
        return 0

    # Display the aliases
    view = AliasView(groups=groups, format=args.format)
    view.pprint()

    return 0


if __name__ == "__main__":
    sys.exit(main())
