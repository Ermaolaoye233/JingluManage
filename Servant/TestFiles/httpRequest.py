import requests
import json

with open('./findOrderByDay.json', 'r') as f:
    data = json.load(f)
print(data)

r = requests.post("http://127.0.0.1:5000/api/Orders/descriptionByDay", json=data)

print(r.text)
