request_date=$(TZ=GMT date "+%a, %d %h %Y %H:%M:%S %Z")
storage_service_version="2015-04-05"
storage_account="stsuse82913"
access_key=""
resource="/${storage_account}/files/hello.txt"
request_method="GET"

headers="x-ms-date:$request_date\nx-ms-version:$storage_service_version"

string_to_sign="${request_method}\n\n\n\n\n\n\n\n\n\n\n\n${headers}\n${resource}"

hex_key="$(echo -n $access_key | base64 -d -w0 | xxd -p -c256)"

signature=$(printf "$string_to_sign" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:$hex_key" -binary | base64 -w0)
authorization_header="SharedKey $storage_account:$signature"

curl -H "x-ms-date:$request_date" \
  -H "x-ms-version:$storage_service_version" \
  -H "Authorization: $authorization_header" \
  "https://${storage_account}.blob.core.windows.net/files/hello.txt"

echo ""
