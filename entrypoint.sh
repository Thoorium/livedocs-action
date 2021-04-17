#!/bin/sh
set -e

echo "Starting the LiveDocs Generator action."

if [ -n "$INPUT_DOCUMENTATION_FOLDER" ]; then
  echo "Documentation folder is '$GITHUB_WORKSPACE/$INPUT_DOCUMENTATION_FOLDER'."
fi 

IN="$GITHUB_REPOSITORY"
arrIN=(${IN//\// })
APPLICATION_NAME = ${arrIN[1]}

if [ -n "$INPUT_APPLICATION_NAME" ]; then
  APPLICATION_NAME = "$INPUT_APPLICATION_NAME"
fi 

echo "Application name is '${APPLICATION_NAME}'"

dotnet /LiveDocs/LiveDocs.Generator.dll --LiveDocs:ApplicationName "${APPLICATION_NAME}" --LiveDocs:DocumentationFolder "${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}"