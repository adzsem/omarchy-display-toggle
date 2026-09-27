# Display Toggle for Omarchy

Display Toggle is a replacement for Omarchy's built-in Display bar widget. It adds clear checkboxes to the **Displays** section so connected monitors can be disabled and restored directly from the top bar.

## Features

- Explicit checked/unchecked state for every connected display
- Click a display row or checkbox to disable it
- Restore a disabled display with its configured layout and scale
- Prevents disabling the final active display
- Extends brightness below the monitors’ hardware minimum with software gamma dimming
- Keeps the built-in text-size and scale controls
- Keyboard navigation remains available with `j`/`k` and Enter or Space

## Requirements

- Omarchy Quattro 4.0 or newer
- Hyprland's Lua configuration API
- `hyprsunset`, DDC/CI brightness support, and `jq` (included with current Omarchy)

## Install

```bash
omarchy plugin add https://github.com/adzsem/omarchy-display-toggle.git --enable
```

The plugin replaces the built-in `omarchy.monitor` widget while enabled. If the bar does not refresh immediately after installation, restart only the shell:

```bash
omarchy restart shell
```

## Update

```bash
omarchy plugin update io.github.adzsem.display-toggle
```

## Remove

```bash
omarchy plugin remove io.github.adzsem.display-toggle
```

The built-in Display widget becomes available again after removal.

## Extra-dark brightness

The slider is split into two ranges:

- 1–20: hardware brightness stays at 1%, while `hyprsunset` gamma moves from 5% to 100%
- 21–100: gamma stays at 100%, while hardware brightness moves from 2% to 100%

Brightness state is stored per connector under `~/.local/state/omarchy/brightness-extra-dark/`. Because Hyprland gamma is compositor-wide, values below 20 dim all monitors together even though hardware brightness targets the focused display.

## Safety

Display Toggle refuses to disable the last active monitor. Re-enabling a monitor reloads the user's Hyprland monitor configuration so its saved layout, mode, and scale are restored.

The plugin executes only local Omarchy, Hyprland, and `hyprsunset` commands. It makes no network requests. It stores only the last logical brightness value for each monitor connector.

## Development

Validate a checkout with:

```bash
omarchy plugin validate .
tests/test-mapping.sh
```

The panel is derived from Omarchy's built-in `omarchy.monitor` plugin and retains its canonical IPC identity for compatibility with the existing Display shortcut.

## License

MIT. See [LICENSE](LICENSE) and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
