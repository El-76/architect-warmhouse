#!/bin/bash


#openapi

for F in `find openapi/ -maxdepth 1 -mindepth 1 -type f -! -name openapi.yaml -printf '%p '`; do
    D=`basename -s .yaml $F`

    mkdir -p ./openapi/html/${D}/

    npx @openapitools/openapi-generator-cli generate -i $F -g html2 -o ./openapi/html/${D}/
done


#asyncapi

asyncapi generate fromTemplate asyncapi/*.yaml @asyncapi/html-template@0.28.4 --force-write -o asyncapi/html/



