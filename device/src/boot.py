import json, os, machine
import net


def read_config():
    if 'config.json' in os.listdir():
        with open('config.json', 'r') as f:
            return json.load(f)
    else:
        raise Exception('config.json not found')


def cold_boot():
    config = read_config()
    if config["network"]["ssid"] is not None:
        net.connect_to_ap(config["network"]["ssid"],
                          config["network"]["password"])
    else:
        net.expose_ap()
        config = net.busy_wait_for_config()
        with open('config.json', 'w') as f:
            json.dump(config, f)
        machine.reset()


cold_boot()