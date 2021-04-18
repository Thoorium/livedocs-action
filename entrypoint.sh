#!/bin/sh
set -e

echo "Starting the LiveDocs Generator action."

if [ -n "$INPUT_DOCUMENTATION_FOLDER" ]; then
  echo "Documentation folder is '$GITHUB_WORKSPACE/$INPUT_DOCUMENTATION_FOLDER'."
fi 

APPLICATION_NAME=${GITHUB_REPOSITORY#*/}

if [ -n "$INPUT_APPLICATION_NAME" ]; then
  APPLICATION_NAME="$INPUT_APPLICATION_NAME"
fi 

echo "Application name is '${APPLICATION_NAME}'"

LIVEDOCS_CONFIG_FILENAME="livedocs.json"
LIVEDOCS_ROOT="/LiveDocs"
LIVEDOCS_WORKSPACE_ROOT=".livedocs"

if [ -f "$GITHUB_WORKSPACE/$LIVEDOCS_WORKSPACE_ROOT/$LIVEDOCS_CONFIG_FILENAME" ]; then
    echo "Using LiveDocs configuration file '$GITHUB_WORKSPACE/$LIVEDOCS_WORKSPACE_ROOT/$LIVEDOCS_CONFIG_FILENAME'"
    cp "$GITHUB_WORKSPACE/$LIVEDOCS_WORKSPACE_ROOT/$LIVEDOCS_CONFIG_FILENAME" "${LIVEDOCS_ROOT}/$LIVEDOCS_CONFIG_FILENAME"
fi

dotnet /LiveDocs/LiveDocs.Generator.dll --LiveDocs:ApplicationName "${APPLICATION_NAME}" --LiveDocs:DocumentationFolder "${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}"

echo "Copying LiveDocs website files."

cp -R "${LIVEDOCS_ROOT}/wwwroot/." "${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}/."

if [ -n "$INPUT_THEME_CSS" ]; then
  for i in ${INPUT_THEME_CSS//,/ }
  do
      CSS_FULLPATH="$GITHUB_WORKSPACE/$LIVEDOCS_WORKSPACE_ROOT/${i}"
      if [ -f "$CSS_FULLPATH" ]; then
        echo "Copying theme css file '${CSS_FULLPATH}' to '${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}'."
        cp "${CSS_FULLPATH}" "${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}/${i}"
        echo "Writing theme css '${i}' to '${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}/index.html'."
        sed -i "/THEME_CSS/ a \ \ \ \ <link rel=\"stylesheet\" href=\"${i}\" />" "${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}/index.html"
      else
        echo "Could not find theme css file '${CSS_FULLPATH}'."
        exit 1
      fi
  done
fi

if [ -n "$INPUT_THEME_JS" ]; then
  for i in ${INPUT_THEME_JS//,/ }
  do
      JS_FULLPATH="$GITHUB_WORKSPACE/$LIVEDOCS_WORKSPACE_ROOT/${i}"
      if [ -f "$JS_FULLPATH" ]; then
        echo "Copying theme javascript file '${JS_FULLPATH}' to '${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}'."
        cp "${JS_FULLPATH}" "${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}/${i}"
        echo "Writing theme javascript '${i}' to '${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}/index.html'."
        sed -i "/THEME_JS/ a \ \ \ \ <script src=\"${i}\"><\/script>" "${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}/index.html"
      else
        echo "Could not find theme javascript file '${JS_FULLPATH}'."
        exit 1
      fi
  done
fi

if [ -n "$INPUT_THEME_RESOURCES" ]; then
  for i in ${INPUT_THEME_RESOURCES//,/ }
  do
      RESOURCE_FULLPATH="$GITHUB_WORKSPACE/$LIVEDOCS_WORKSPACE_ROOT/${i}"
      if [ -f "$RESOURCE_FULLPATH" ]; then
        echo "Copying theme resource file '${RESOURCE_FULLPATH}' to '${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}'."
        cp "${RESOURCE_FULLPATH}" "${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}/${i}"
      else
        echo "Could not find resource file '${RESOURCE_FULLPATH}'."
        exit 1
      fi
  done
fi

echo "Updating application path."

sed -i "s/base href=\"\/\"/base href=\"\/"${APPLICATION_NAME}"\/\"/g" "${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}/index.html"

echo "Github pages: Temporary 404 fix."

cp "${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}/index.html" "${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}/404.html"

echo "Disabling jekyll."

touch "${GITHUB_WORKSPACE}/${INPUT_DOCUMENTATION_FOLDER}/.nojekyll"

echo "Done."