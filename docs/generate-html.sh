#!/bin/bash

#asyncapi

asyncapi generate fromTemplate asyncapi/*.yaml @asyncapi/html-template@0.28.4 --force-write -o asyncapi/html/


#openapi

npx @redocly/cli join `find openapi/ -maxdepth 1 -mindepth 1 -type f -! -name openapi.yaml -printf '"%p" '` -o ./openapi/openapi.yaml

npx @openapitools/openapi-generator-cli generate -i openapi/openapi.yaml -g html2 -o ./openapi/html/
