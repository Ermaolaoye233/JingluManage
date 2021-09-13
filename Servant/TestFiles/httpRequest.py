import requests
import json

with open('./updatePassword.json', 'r') as f:
    data = json.load(f)
print(data)

r = requests.post("http://127.0.0.1:5000/api/Users/updatePassword", json=data)

print(r.text)
