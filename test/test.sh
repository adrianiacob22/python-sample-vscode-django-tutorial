sleep 40
if curl app:8000 | grep -q 'You may need to add'; then
  echo "Tests passed!"
  exit 0
else
  echo "Tests failed!"
  exit 1
fi
