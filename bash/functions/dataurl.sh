#!/usr/bin/env bash

# Create a data URL from a file
function dataurl() {
	local mimeType
	mimeType=$(file -b --mime-type "$1");
	if [[ ${mimeType} == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}
