#!/usr/bin/env bash
set -euo pipefail

version="4.4.0"
install_dir="/usr/local/bin"
bin_path="${install_dir}/cheat"

usage() {
  echo "Usage: $0 [--version X.Y.Z]"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      version="${2:-}"
      [[ -n "$version" ]] || { echo "Missing value for --version"; exit 1; }
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unrecognized option: $1"
      usage
      exit 1
      ;;
  esac
done

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing dependency: $1"
    exit 10
  }
}

download() {
  local url="$1"
  local out="$2"

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$out"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$out" "$url"
  else
    echo "Need curl or wget to download files."
    exit 11
  fi
}

detect_arch() {
  case "$(uname -m)" in
    x86_64|amd64) echo "amd64" ;;
    aarch64|arm64) echo "arm64" ;;
    armv7l|armv7) echo "armv7" ;;
    *)
      echo "Unsupported architecture: $(uname -m)" >&2
      exit 12
      ;;
  esac
}

installed_cheat_version() {
  # Normalize to just X.Y.Z if possible
  # handles outputs like: "cheat version 4.4.0" or "4.4.0"
  cheat --version 2>/dev/null | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -n1 || true
}

install_and_upgrade() {
  local ver="$1"
  local arch
  arch="$(detect_arch)"

  need_cmd gzip
  need_cmd sudo

  local tmpdir
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT

  local asset="cheat-linux-${arch}.gz"
  local url="https://github.com/cheat/cheat/releases/download/${ver}/${asset}"
  local gz_path="${tmpdir}/${asset}"
  local out_path="${tmpdir}/cheat"

  echo "Downloading ${url}"
  download "$url" "$gz_path"

  gzip -dc "$gz_path" > "$out_path"
  chmod +x "$out_path"

  sudo install -m 0755 "$out_path" "$bin_path"
  echo "Installed cheat to ${bin_path}"
}

if command -v cheat >/dev/null 2>&1; then
  inst_ver="$(installed_cheat_version)"
  echo "cheat already installed, version: ${inst_ver:-unknown}"
  if [[ "$inst_ver" != "$version" ]]; then
    echo "Update cheat to version $version"
    install_and_upgrade "$version"
    echo "cheat successfully updated to version $version"
  fi
else
  echo "no cheat installation found. Install ..."
  install_and_upgrade "$version"
  echo "cheat successfully installed, version: $version"
fi

need_cmd git

repository_url="git@github.com:cheat/cheatsheets.git"
repository_dir="$HOME/.config/cheat/cheatsheets/community"

mkdir -p "$(dirname "$repository_dir")"

if [[ -d "${repository_dir}/.git" ]]; then
  echo "Repo exists. Pull for updates ..."
  git -C "$repository_dir" pull --ff-only >/dev/null
  echo "Repo successfully updated."
else
  echo "Repository does not exist. Clone ..."
  git clone "$repository_url" "$repository_dir" >/dev/null
  echo "Repository successfully cloned."
fi

