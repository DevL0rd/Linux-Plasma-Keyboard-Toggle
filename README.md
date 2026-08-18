# Linux Plasma Keyboard Toggle

A small KDE Plasma 6 panel widget that shows and hides the on-screen keyboard, and indicates whether it is currently visible.

The icon reflects the real keyboard state rather than only what the widget did. If a text field raises the keyboard on its own, or something else dismisses it, the icon updates to match. State changes are received from KWin over D-Bus signals, so nothing is polled.

Useful when streaming a desktop to a tablet or phone, where the keyboard normally only appears on a touched text field and there is no other way to summon it.

## Requirements

- KDE Plasma 6 on Wayland
- An on-screen keyboard configured in **System Settings - Keyboard - Virtual Keyboard**, such as `plasma-keyboard`
- `busctl`, `gdbus`, and `kpackagetool6`

## Install

```bash
chmod +x install.sh uninstall.sh
./install.sh
```

Then add **Keyboard Toggle** to a panel from the widget list.

## Uninstall

```bash
./uninstall.sh
```

Remove the widget from your panel if it is still shown.

## Behaviour

| Icon | Meaning |
| --- | --- |
| `input-keyboard-virtual-on` | Keyboard is visible; clicking hides it |
| `input-keyboard-virtual-off` | Keyboard is hidden; clicking shows it |

Showing calls `forceActivate` on KWin's virtual keyboard. Hiding disables and immediately re-enables it, which dismisses the keyboard while leaving automatic show-on-touch working.

## Notes

KWin only raises the keyboard automatically when a text field is touched, not when it is clicked with a mouse. That is deliberate upstream behaviour. This widget exists so the keyboard can still be summoned in those cases, including inside XWayland applications that never trigger it.

## License

GPL-3.0-or-later
