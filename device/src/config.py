import os, machine, json

default_config = {
    "network": {
        "ssid": None,
        "password": None,
    },
    "device": {
        "name": None
    }
}

class ConfigStore:
    
    config = None;
    
    def __init__(self):
        if 'config.json' in os.listdir():
            with open("config.json", "r") as f:
                read_config = json.load(f);
                self.config = read_config;
        else:
            print("Config file not found, dumping default");
            self.config = default_config;
            with open("config.json", "w") as f:
                json.dump(self.config, f);
