# Moonlit Cards Dream Skin

適用於 Windows 官方 Microsoft Store Codex 應用程式的非官方明亮月夜紙牌主題。

![Moonlit Cards 原創桌布](windows/assets/moonlit-cards-original.png)

## 安裝

1. 從 GitHub Releases 下載 `Moonlit-Cards-Dream-Skin-Windows-v1.0.0.zip` 並完整解壓縮。
2. 雙擊 `Install.cmd`。
3. 安裝程式會放到 `%LOCALAPPDATA%\MoonlitCardsDreamSkin`，建立捷徑並啟動 Codex。

安裝不需要系統管理員權限。系統匣監看器會在登入 Windows 後啟動；當 Codex 更新或從一般捷徑開啟時，它會在確認必要後重新啟動一次 Codex 並套用主題。重新啟動可能使尚未送出的文字遺失。

## 移除

執行 `%LOCALAPPDATA%\MoonlitCardsDreamSkin\Uninstall.cmd`。它會還原 Codex 外觀、移除捷徑與自動套用程式，再刪除安裝目錄。

## 驗證與建置

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\windows\tests\run-tests.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build-windows-release.ps1
```

正式 ZIP 旁會產生 `.sha256` 校驗檔。

## 授權與安全

程式與本專案原創生成素材採 MIT License。專案源自 [Fei-Away/Codex-Dream-Skin](https://github.com/Fei-Away/Codex-Dream-Skin)，並保留上游聲明。

本專案不是 OpenAI 官方產品，不包含 Codex 本體、OpenAI 標誌或第三方動漫角色素材。皮膚啟用期間會開啟僅限本機回環位址的 CDP 除錯連線，請勿讓不受信任的本機程式存取。

English instructions: [README.en.md](README.en.md)
