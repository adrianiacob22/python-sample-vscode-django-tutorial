sleep 20
if curl http://app:8000 | grep -q 'Home'; then
  echo "Tests passed!" > testresult
  exit 0
else
  echo "Tests failed!" > testresult
  exit 1
fi
# curl -X GET -i -o /dev/null -s -w "%{http_code}\n" http://app:8000
