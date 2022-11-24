import json, urequests, ssl, jwt, os

class API:
    key = None
    baseURL = None
    
    def __init__(self, baseURL = "http://192.168.1.209:3000/bareboard"):
        self.baseURL = baseURL;
        if not ('key' in os.listdir()):
            print("NO KEYFILE ON DEVICE!!")
            raise Exception("NO KEYFILE FOUND ON DEVICE");
        with open("key", "r") as keyfile:
            self.key = keyfile.read()
    
    def request(self, method, url, json=None):
        headers = {
            "Authorization": f"Bearer {self.key}"
        }
        return urequests.request(method, f"{self.baseURL}{url}", json=json, headers=headers);
        
    def post(self, url, json=None):
        return self.request("POST", url, json=json);
    
    def get(self, url, json=None):
        return self.request("GET", url, json=json);

    def post_heartbeat(self):
        req = self.post("/heartbeat");
        req.close()
    
    def register_device(self, ownerId, deviceName = ""):
        payload = {
            "ownerId": ownerId
        }
        req = self.post("/register", json=payload);
        req.close();
    
    def get_me(self):
        req = self.get("/me");
        json = req.json()
        req.close()
        return json;
    
    def get_owner(self):
        req = self.get("/owner");
        if req.status_code == 404:
            return None;
        json = req.json()
        req.close()
        return json

