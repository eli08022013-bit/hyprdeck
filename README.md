# Hyprdeck

Hyprdeck is a modular, opt-in Hyprland configuration designed to be clean, readable, and maintainable.

It is **not** a one-file dump and it does **not** overwrite user configurations by default.  
Hyprdeck is structured as a standalone profile that can be sourced, tested, and removed safely.

---

## Goals

- Fully modular Hyprland configuration
- Single entrypoint with explicit load order
- No forced overrides of existing configs
- Easy to read, extend, and debug
- Suitable for daily use and long-term maintenance

Hyprdeck is built against modern Hyprland releases and follows upstream best practices.

---

## Project Structure

Hyprdeck lives entirely in its own directory:
```
~/.config/hyprdeck/
├── hyprdeck.conf # Main entrypoint
├── env.conf # Environment variables
├── variables.conf # Shared variables
├── monitors.conf
├── input.conf
├── general.conf
├── decorations.conf
├── animations.conf
├── rules.conf
├── binds.conf
└── autostart.conf
```

Hyprland itself continues to load `~/.config/hypr/hyprland.conf`.  
Hyprdeck is enabled only if the user explicitly sources it.

---

## Enabling Hyprdeck (Manual, Recommended)

Back up your existing configuration first.

Edit (or create): `~/.config/hypr/hyprland.conf`


Add:

```
source = ~/.config/hyprdeck/hyprdeck.conf
```

Restart Hyprland.

This method does not delete or replace your configuration — it simply sources Hyprdeck as a profile.

## Try Without Installing

Hyprdeck can be tested without modifying any files:

`Hyprland -c ~/.config/hyprdeck/hyprdeck.conf`

Official reference:
https://wiki.hyprland.org/Configuring/Hyprland/#running-hyprland-with-a-custom-config

## Installer (Optional)

Hyprdeck provides an optional install script.

- The installer never runs automatically

- Overriding hyprland.conf requires multiple confirmations

- Existing configs are backed up to:

    `~/.config/hypr/backup/`

Manual setup is always supported and recommended.

## Compatibility

- Hyprland ≥ 0.49

- Wayland only

- Designed and tested on Fedora (portable to other distributions)

## Hyprland

- Website: https://hyprland.org

- GitHub: https://github.com/hyprwm/Hyprland

- Wiki: https://wiki.hyprland.org


## License

Hyprdeck is licensed under the MIT License.

You are free to use, modify, and redistribute this configuration.

## Disclaimer

Hyprdeck is a personal configuration project shared for educational and practical use.
It makes no assumptions about your system and does not attempt to manage your entire environment.

If something breaks, your original configuration remains intact.