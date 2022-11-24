import json, os, machine, dht
import net
from api import API
from config import ConfigStore

config = ConfigStore().config
api_instance = API();

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
    raise Exception("Hard reset, probably panicked, not starting reporter!");
else:
    cold_boot();
    print(api_instance.get_me())
    
    owner = api_instance.get_owner()
    if not owner:
        api_instance.register_device("30678218-8763-4b2a-bb60-6c6fa6fd570e")
        owner = api_instance.get_owner()
    
    print(owner)
    
    if net.is_connected() and owner is not None:
        heartbeat_timer = machine.Timer(0)
        heartbeat_timer.init(period=10000, mode=machine.Timer.PERIODIC, callback=lambda t: api_instance.post_heartbeat())
        measurement_timer = machine.Timer(1)
        measurement_timer.init(period=20 * 1000, mode=machine.Timer.PERIODIC, callback=lambda t: api_instance.post_measurement())
    

