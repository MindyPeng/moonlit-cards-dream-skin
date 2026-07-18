# Moonlit Cards Dream Skin

An unofficial bright moonlit playing-card theme for the official Microsoft Store Codex app on Windows.

![Original Moonlit Cards wallpaper](windows/assets/moonlit-cards-original.png)

## Install

1. Download and fully extract `Moonlit-Cards-Dream-Skin-Windows-v1.0.0.zip` from GitHub Releases.
2. Double-click `Install.cmd`.
3. The package installs to `%LOCALAPPDATA%\MoonlitCardsDreamSkin`, creates shortcuts, and launches Codex.

No administrator privileges are required. A tray watcher starts when you sign in to Windows. After a Codex update or a normal app launch, it may restart Codex once to reapply the theme. Unsaved input can be lost during that restart.

## Uninstall

Run `%LOCALAPPDATA%\MoonlitCardsDreamSkin\Uninstall.cmd`. It restores the standard appearance, removes shortcuts and auto-apply startup, then deletes the installed files.

## Test and build

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\windows\tests\run-tests.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build-windows-release.ps1
```

The build writes a ZIP and matching `.sha256` file.

## License and security

The software and original generated project artwork are released under the MIT License. This project derives from [Fei-Away/Codex-Dream-Skin](https://github.com/Fei-Away/Codex-Dream-Skin) and preserves upstream notices.

This is not an OpenAI product. It includes no Codex binaries, OpenAI logos, or third-party franchise artwork. While active, the theme uses a loopback-only CDP debugging endpoint. Do not allow untrusted local software to access it.
