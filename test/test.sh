sleep 40
if curl app:8000 | grep -q 'You may need to add'; then
  echo "Tests passed!" > testresult
  exit 0
else
  echo "Tests failed!" > testresult
  exit 1
fi
