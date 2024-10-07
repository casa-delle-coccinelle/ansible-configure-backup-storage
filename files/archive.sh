#! /usr/bin/env bash

# Backup and archive script
# This script creates archives for all subdirectories in a given source directory

# Function to log messages with a timestamp
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ${1}"
}

# Function to check if arguments are valid
validate_args() {
    if [ "$#" -ne 2 ]; then
        log "Usage: ${0} <source_directory> <destination_directory>"
        exit 1
    fi
}

# Function to create an archive for a given app directory
create_archive() {
    local app_dir="${1}"
    local dest_dir="${2}"
    local dow="${3}"

    local archive_path="${dest_dir}/${dow}.tar.gz"

    log "Creating archive: ${archive_path}"
    tar -czf "${archive_path}" -C "${app_dir}" .

    log "Archive successfully created at: ${archive_path}"
}

# Function to process each app directory and create the destination path
process_app_directory() {
    local top_level_dir="${1}"
    local subdir="${2}"
    local app_dir="${3}"
    local dest_dir="${4}"
    local dow="${5}"

    local top_level_name
    local subdir_name
    local app_name
    top_level_name=$(basename "${top_level_dir}")
    subdir_name=$(basename "${subdir}")
    app_name=$(basename "${app_dir}")

    log "Processing: ${top_level_name}/${subdir_name}/${app_name}"

    # Create corresponding destination directory
    local dest_subdir="${dest_dir}/${top_level_name}/${subdir_name}/${app_name}"
    log "Creating destination subdirectory: ${dest_subdir}"
    mkdir -p "${dest_subdir}"

    # Create archive for the app directory (in parallel)
    create_archive "${app_dir}" "${dest_subdir}" "${dow}" &
}

# Function to process subdirectories and app directories in parallel
process_directories() {
    local source_dir="${1}"
    local dest_dir="${2}"
    local dow="${3}"

    for top_level_dir in "${source_dir}"/*; do
        if [ -d "${top_level_dir}" ]; then
            for subdir in "${top_level_dir}"/*; do
                if [ -d "${subdir}" ]; then
                    for app_dir in "${subdir}"/*; do
                        if [ -d "${app_dir}" ]; then
                            process_app_directory "${top_level_dir}" "${subdir}" "${app_dir}" "${dest_dir}" "${dow}"
                        fi
                    done
                fi
            done
        fi
    done

    # Wait for all parallel jobs to finish
    wait
}

# Main script logic
main() {
    validate_args "$@"

    # Assign arguments to variables
    SOURCE_DIR="${1}"
    DEST_DIR="${2}"

    log "Received source directory: ${SOURCE_DIR}"
    log "Received destination directory: ${DEST_DIR}"

    # Get the current day of the week
    DOW=$(date +%A)
    log "Current day of the week: ${DOW}"

    # Process all directories and create archives in parallel
    process_directories "${SOURCE_DIR}" "${DEST_DIR}" "${DOW}"

    log "All archives successfully created."
}

# Start the script
main "$@"
