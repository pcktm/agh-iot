import json, os, machine, dht
import net
from api import API
from config import ConfigStore

config = ConfigStore().config

def cold_boot():
    if net.is_connected():
        print("Network already connected!");  
    elif config["network"]["ssid"] is not None:
        print("Connecting to access point...");
        net.connect_to_ap(config["network"]["ssid"],
                          config["network"]["password"])
    elif machine.reset_cause() == machine.SOFT_RESET:
        print("Soft reset, not entering pairing mode!");
    else:
        print("Cold boot & no wifi credentials, entering pairing mode!");
        net.expose_ap()
        # config = net.busy_wait_for_config()
        # with open('config.json', 'w') as f:
        #     json.dump(config, f);
        # machine.reset()

if machine.reset_cause() == machine.HARD_RESET:
    print("Hard reset, not entering cold boot!");
else:
    cold_boot();
    api_instance = API();
    print(api_instance.get_me().json())
    
    res = api_instance.register_device("30678218-8763-4b2a-bb60-6c6fa6fd570e")

