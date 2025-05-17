#!/bin/bash

# Usage
usage() {
  echo "Usage:"
  echo "  $0 c <output_file.tar.{xz,gz,bz2}> <files_or_dirs...>   # Create archive"
  echo "  $0 x <archive.tar.{xz,gz,bz2}> [destination_dir]        # Extract archive"
  exit 1
}

# Detect compression type from file extension
detect_compression() {
  case "$1" in
    *.tar.xz) echo "xz" ;;
    *.tar.gz) echo "gz" ;;
    *.tar.bz2) echo "bz2" ;;
    *) echo "unknown" ;;
  esac
}

# Create archive with progress
create_archive() {
  OUTPUT_FILE="$1"
  shift
  INPUTS=("$@")

  COMP_TYPE=$(detect_compression "$OUTPUT_FILE")
  if [ "$COMP_TYPE" == "unknown" ]; then
    echo "Error: Unsupported output file extension."
    exit 2
  fi

  for item in "${INPUTS[@]}"; do
    if [ ! -e "$item" ]; then
      echo "Error: '$item' does not exist."
      exit 3
    fi
  done

  TOTAL_SIZE=0
  for item in "${INPUTS[@]}"; do
    SIZE=$(du -sb "$item" | awk '{total += $1} END {print total}')
    TOTAL_SIZE=$((TOTAL_SIZE + SIZE))
  done

  echo "Creating archive '$OUTPUT_FILE' with compression: $COMP_TYPE"
  echo "Total size: $TOTAL_SIZE bytes"

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

# Extract archive with progress
extract_archive() {
  ARCHIVE="$1"
  DEST="${2:-.}"

  COMP_TYPE=$(detect_compression "$ARCHIVE")
  if [ "$COMP_TYPE" == "unknown" ]; then
    echo "Error: Unsupported archive file extension."
    exit 2
  fi

  if [ ! -f "$ARCHIVE" ]; then
    echo "Error: Archive '$ARCHIVE' not found."
    exit 3
  fi

  echo "Extracting '$ARCHIVE' with compression: $COMP_TYPE"
  mkdir -p "$DEST"

  case "$COMP_TYPE" in
    xz)
      UNCOMPRESSED_SIZE=$(xz --robot --list "$ARCHIVE" | awk -F'\t' '/^totals/ {print $5}')
      pv -s "$UNCOMPRESSED_SIZE" "$ARCHIVE" | xz -d | tar -x -C "$DEST"
      ;;
    gz)
      UNCOMPRESSED_SIZE=$(gzip -l "$ARCHIVE" | awk 'NR==2 {print $2}')
      pv -s "$UNCOMPRESSED_SIZE" "$ARCHIVE" | gzip -d | tar -x -C "$DEST"
      ;;
    bz2)
      # bzip2 doesn't support showing uncompressed size; skip progress bar
      echo "⚠️  Progress bar not supported for bzip2 decompression."
      bunzip2 -c "$ARCHIVE" | tar -x -C "$DEST"
      ;;
  esac

  if [ $? -eq 0 ]; then
    echo "✅ Archive extracted successfully."
  else
    echo "❌ Extraction failed."
  fi
}

# Main
if [ $# -lt 2 ]; then
  usage
fi

MODE="$1"
shift

case "$MODE" in
  c) create_archive "$@" ;;
  x) extract_archive "$@" ;;
  *) usage ;;
esac
