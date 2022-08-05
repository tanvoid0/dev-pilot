#!/bin/bash

### Read a file line by line ########
readFile() {
	while IFS= read -r line; do
		echo "$line"
	done < "$1"
}


