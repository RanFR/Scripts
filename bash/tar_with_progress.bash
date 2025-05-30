#!/bin/bash

# ----------------------
# Human-readable size
# ----------------------
format_bytes() {
  local bytes=$1
  local kib=$((1024))
  local mib=$((1024 * 1024))
  local gib=$((1024 * 1024 * 1024))
  local tib=$((1024 * 1024 * 1024 * 1024))

  if (( bytes >= tib )); then
    printf "%.2f TB" "$(echo "$bytes / $tib" | bc -l)"
  elif (( bytes >= gib )); then
    printf "%.2f GB" "$(echo "$bytes / $gib" | bc -l)"
  elif (( bytes >= mib )); then
    printf "%.2f MB" "$(echo "$bytes / $mib" | bc -l)"
  elif (( bytes >= kib )); then
    printf "%.2f KB" "$(echo "$bytes / $kib" | bc -l)"
  else
    printf "%d bytes" "$bytes"
  fi
}

# ----------------------
# Compression type
# ----------------------
detect_compression() {
  case "$1" in
    *.tar.xz) echo "xz" ;;
    *.tar.gz) echo "gz" ;;
    *.tar.bz2) echo "bz2" ;;
    *) echo "unknown" ;;
  esac
}

# ----------------------
# Archive Creation
# ----------------------
create_archive() {
  OUTPUT_FILE="$1"
  shift
  INPUTS=("$@")

  COMP_TYPE=$(detect_compression "$OUTPUT_FILE")
  if [ "$COMP_TYPE" == "unknown" ]; then
    echo "❌ Unsupported output file extension."
    exit 2
  fi

  for item in "${INPUTS[@]}"; do
    if [ ! -e "$item" ]; then
      echo "❌ Error: '$item' does not exist."
      exit 3
    fi
  done

  TOTAL_SIZE=0
  for item in "${INPUTS[@]}"; do
    SIZE=$(du -sb "$item" | awk '{total += $1} END {print total}')
    TOTAL_SIZE=$((TOTAL_SIZE + SIZE))
  done

  HUMAN_TOTAL=$(format_bytes "$TOTAL_SIZE")
  echo "📦 Creating archive: $OUTPUT_FILE"
  echo "📁 Includes: ${INPUTS[*]}"
  echo "📏 Total size: $TOTAL_SIZE bytes ($HUMAN_TOTAL)"
  echo "⚙️  Compression: $COMP_TYPE"

  case "$COMP_TYPE" in
    xz)
      tar -cf - "${INPUTS[@]}" | pv -s "$TOTAL_SIZE" | xz -c > "$OUTPUT_FILE"
      ;;
    gz)
      tar -cf - "${INPUTS[@]}" | pv -s "$TOTAL_SIZE" | gzip > "$OUTPUT_FILE"
      ;;
    bz2)
      tar -cf - "${INPUTS[@]}" | pv -s "$TOTAL_SIZE" | bzip2 > "$OUTPUT_FILE"
      ;;
  esac

  if [ $? -eq 0 ]; then
    echo "✅ Archive created successfully: $OUTPUT_FILE"
  else
    echo "❌ Archive creation failed."
  fi
}

# ----------------------
# Archive Extraction
# ----------------------
extract_archive() {
  ARCHIVE="$1"
  DEST="${2:-.}"

  COMP_TYPE=$(detect_compression "$ARCHIVE")
  if [ "$COMP_TYPE" == "unknown" ]; then
    echo "❌ Unsupported archive extension."
    exit 2
  fi

  if [ ! -f "$ARCHIVE" ]; then
    echo "❌ Archive '$ARCHIVE' not found."
    exit 3
  fi

  echo "📂 Extracting '$ARCHIVE' → '$DEST'"
  echo "⚙️  Compression: $COMP_TYPE"
  mkdir -p "$DEST"

  case "$COMP_TYPE" in
    xz)
      UNCOMPRESSED_SIZE=$(xz --robot --list "$ARCHIVE" | awk -F'\t' '/^totals/ {print $5}')
      HUMAN_UNCOMPRESSED=$(format_bytes "$UNCOMPRESSED_SIZE")
      echo "📏 Estimated size: $UNCOMPRESSED_SIZE bytes ($HUMAN_UNCOMPRESSED)"
      pv -s "$UNCOMPRESSED_SIZE" "$ARCHIVE" | xz -d | tar -x -C "$DEST"
      ;;
    gz)
      UNCOMPRESSED_SIZE=$(gzip -l "$ARCHIVE" | awk 'NR==2 {print $2}')
      HUMAN_UNCOMPRESSED=$(format_bytes "$UNCOMPRESSED_SIZE")
      echo "📏 Estimated size: $UNCOMPRESSED_SIZE bytes ($HUMAN_UNCOMPRESSED)"
      pv -s "$UNCOMPRESSED_SIZE" "$ARCHIVE" | gzip -d | tar -x -C "$DEST"
      ;;
    bz2)
      echo "⚠️  Progress bar not supported for bzip2 decompression."
      bunzip2 -c "$ARCHIVE" | tar -x -C "$DEST"
      ;;
  esac

  if [ $? -eq 0 ]; then
    echo "✅ Extraction completed successfully."
  else
    echo "❌ Extraction failed."
  fi
}

# ----------------------
# Usage info
# ----------------------
usage() {
  echo "Usage:"
  echo "  $0 -c <output.tar.{xz,gz,bz2}> <files...>        # Create archive"
  echo "  $0 -x <archive.tar.{xz,gz,bz2}> [output_dir]     # Extract archive"
  exit 1
}

# ----------------------
# Entry point with -c/-x options
# ----------------------
if [ $# -lt 2 ]; then
  usage
fi

MODE=""
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -c)
      MODE="create"
      shift
      ;;
    -x)
      MODE="extract"
      shift
      ;;
    -*)
      echo "Unknown option: $1"
      usage
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done

if [ -z "$MODE" ]; then
  echo "❌ Error: Must specify -c (create) or -x (extract)"
  usage
fi

if [ "$MODE" = "create" ]; then
  create_archive "${POSITIONAL_ARGS[@]}"
elif [ "$MODE" = "extract" ]; then
  extract_archive "${POSITIONAL_ARGS[@]}"
else
  usage
fi
