import os, machine, json

default_config = {
    "network": {
        "ssid": None,
        "password": None,
    },
    "device": {
        "name": "Default Device Name"
    }
}


class ConfigStore:

    config = None

    def __init__(self):
        if 'config.json' in os.listdir():
            with open("config.json", "r") as f:
                read_config = json.load(f)
                self.config = read_config
        else:
            print("Config file not found, dumping default")
            self.config = default_config
            with open("config.json", "w") as f:
                json.dump(self.config, f)

    def save(self):
        with open("config.json", "w") as f:
            json.dump(self.config, f)

    def get(self, key):
        # allow nested keys and return null if not found
        if "." in key:
            try:
                keys = key.split(".")
                current = self.config
                for i in range(0, len(keys) - 1):
                    current = current[keys[i]]
                return current[keys[-1]]
            except:
                return None
        else:
            return self.config[key]

    def set(self, key, value):
        if "." in key:
            try:
                keys = key.split(".")
                current = self.config
                for i in range(0, len(keys) - 1):
                    current = current[keys[i]]
                current[keys[-1]] = value
            except:
                print("Error setting config value")
        else:
            self.config[key] = value
        self.save()


config = ConfigStore()