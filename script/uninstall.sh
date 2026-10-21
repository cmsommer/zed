#!/usr/bin/env sh
set -eu

# Uninstalls Zcode that was installed using the install.sh script

check_remaining_installations() {
    platform="$(uname -s)"
    if [ "$platform" = "Darwin" ]; then
        # Check for any Zcode variants in /Applications
        remaining=$(ls -d /Applications/Zcode*.app 2>/dev/null | wc -l)
        [ "$remaining" -eq 0 ]
    else
        # Check for any Zcode variants in ~/.local
        remaining=$(ls -d "$HOME/.local/zed"*.app 2>/dev/null | wc -l)
        [ "$remaining" -eq 0 ]
    fi
}

prompt_remove_preferences() {
    printf "Do you want to keep your Zcode preferences? [Y/n] "
    read -r response
    case "$response" in
        [nN]|[nN][oO])
            rm -rf "$HOME/.config/zcode"
            echo "Preferences removed."
            ;;
        *)
            echo "Preferences kept."
            ;;
    esac
}

main() {
    platform="$(uname -s)"
    channel="${ZED_CHANNEL:-stable}"

    if [ "$platform" = "Darwin" ]; then
        platform="macos"
    elif [ "$platform" = "Linux" ]; then
        platform="linux"
    else
        echo "Unsupported platform $platform"
        exit 1
    fi

    "$platform"

    echo "Zcode has been uninstalled"
}

linux() {
    suffix=""
    if [ "$channel" != "stable" ]; then
        suffix="-$channel"
    fi

    appid=""
    db_suffix="stable"
    case "$channel" in
      stable)
        appid="dev.zcode.Zcode"
        db_suffix="stable"
        ;;
      nightly)
        appid="dev.zcode.Zcode-Nightly"
        db_suffix="nightly"
        ;;
      preview)
        appid="dev.zcode.Zcode-Preview"
        db_suffix="preview"
        ;;
      dev)
        appid="dev.zcode.Zcode-Dev"
        db_suffix="dev"
        ;;
      *)
        echo "Unknown release channel: ${channel}. Using stable app ID."
        appid="dev.zcode.Zcode"
        db_suffix="stable"
        ;;
    esac

    # Remove the app directory
    rm -rf "$HOME/.local/zed$suffix.app"

    # Remove the binary symlink
    rm -f "$HOME/.local/bin/zcode"
    rm -f "$HOME/.local/bin/zed"

    # Remove the .desktop file
    rm -f "$HOME/.local/share/applications/${appid}.desktop"

    # Remove the database directory for this channel
    rm -rf "$HOME/.local/share/zcode/db/0-$db_suffix"

    # Remove socket file
    rm -f "$HOME/.local/share/zcode/zed-$db_suffix.sock"

    # Remove the entire Zcode directory if no installations remain
    if check_remaining_installations; then
        rm -rf "$HOME/.local/share/zcode"
        prompt_remove_preferences
    fi

    rm -rf $HOME/.zed_server
}

macos() {
    app="Zcode.app"
    db_suffix="stable"
    app_id="dev.zcode.Zcode"
    case "$channel" in
      nightly)
        app="Zcode Nightly.app"
        db_suffix="nightly"
        app_id="dev.zcode.Zcode-Nightly"
        ;;
      preview)
        app="Zcode Preview.app"
        db_suffix="preview"
        app_id="dev.zcode.Zcode-Preview"
        ;;
      dev)
        app="Zcode Dev.app"
        db_suffix="dev"
        app_id="dev.zcode.Zcode-Dev"
        ;;
    esac

    # Remove the app bundle
    if [ -d "/Applications/$app" ]; then
        rm -rf "/Applications/$app"
    fi

    # Remove the binary symlink
    rm -f "$HOME/.local/bin/zcode"
    rm -f "$HOME/.local/bin/zed"

    # Remove the database directory for this channel
    rm -rf "$HOME/Library/Application Support/Zcode/db/0-$db_suffix"

    # Remove app-specific files and directories
    rm -rf "$HOME/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/$app_id.sfl"*
    rm -rf "$HOME/Library/Caches/$app_id"
    rm -rf "$HOME/Library/HTTPStorages/$app_id"
    rm -rf "$HOME/Library/Preferences/$app_id.plist"
    rm -rf "$HOME/Library/Saved Application State/$app_id.savedState"

    # Remove the entire Zcode directory if no installations remain
    if check_remaining_installations; then
        rm -rf "$HOME/Library/Application Support/Zcode"
        rm -rf "$HOME/Library/Logs/Zcode"
        prompt_remove_preferences
    fi
}

main "$@"
