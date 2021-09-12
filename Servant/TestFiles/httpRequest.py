import requests
import json

with open('./order.json', 'r') as f:
    data = json.load(f)
print(data)

r = requests.post("http://127.0.0.1:5000/api/Orders/addOrder", json=data)

print(r.text)
