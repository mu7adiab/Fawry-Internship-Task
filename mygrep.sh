#!/bin/bash

#print usage instructions
print_usage() {
    echo "Usage: $0 [-n] [-v] search_string filename"
    echo "Options:"
    echo "  -n        Show line numbers for each match."
    echo "  -v        Invert match (show lines that do NOT match)."
    echo "  --help    Show this help message and exit."
}

# checks
if [[ $# -lt 1 ]]; then
    print_usage
    exit 1
fi

# --help
if [[ "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

# تعريف
show_line_numbers=false
invert_match=false

# while & case
while [[ "$1" == -* ]]; do
    case "$1" in
        *n*)
            show_line_numbers=true
            ;;
        *v*)
            invert_match=true
            ;;
        --help)
            print_usage
            exit 0
            ;;
        *)
            echo "Invalid option: $1"
            echo
            print_usage
            exit 1
            ;;
    esac
    shift
done

# Check if searching string 
if [[ -z "$1" ]]; then
    echo "Error: Missing search string."
    echo
    print_usage
    exit 1
fi

search_string="$1"
shift

# Check filename 
if [[ -z "$1" ]]; then
    echo "Error: Missing filename."
    echo
    print_usage
    exit 1
fi

filename="$1"

# Check if the file exist
if [[ ! -f "$filename" ]]; then
    echo "Error: File '$filename' not found."
    exit 1
fi

# check to proces by while
line_number=0
while IFS= read -r line; do
    ((line_number++))
    if echo "$line" | grep -iq "$search_string"; then
        is_match=true
    else
        is_match=false
    fi

    # invert match 
    if $invert_match; then
        if $is_match; then
            is_match=false
        else
            is_match=true
        fi
    fi

    # print if match
    if $is_match; then
        if $show_line_numbers; then
            echo "${line_number}:$line"
        else
            echo "$line"
        fi
    fi
done < "$filename"
