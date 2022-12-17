import machine
import time
import net
from api import api
from config import config
from pairing import enter_pairing_mode


def cold_boot():
    if net.is_connected():
        print("Network already connected!")
    elif config.get("network.ssid") is not None:
        print("Connecting to access point...")
        net.connect_to_ap(config.get("network.ssid"),
                          config.get("network.password"))
    elif machine.reset_cause() == machine.SOFT_RESET:
        print("Soft reset, not entering pairing mode!")
    else:
        print("Cold boot & no wifi credentials, entering pairing mode!")
        enter_pairing_mode()
        return

def post_boot():
    me = api.get_me()
    if not me:
        print(
            "Couldn't get /me, probably no connection, entering pairing mode")
        enter_pairing_mode()
        return

    if config.get("ownerToBeRegisteredTo") is not None:
        print("Registering this device to owner with id: ",
                config.get("ownerToBeRegisteredTo"))
        api.register_device(config.get("ownerToBeRegisteredTo"))
        config.set("ownerToBeRegisteredTo", None)

    owner = api.get_owner()
    if owner is None:
        print(
            "Couldn't get owner, probably likey device removed from account or not registered, entering pairing mode"
        )
        enter_pairing_mode()
        return
    print("Device registered to owner: ", owner)

    if net.is_connected() and owner is not None:
        heartbeat_timer = machine.Timer(0)
        heartbeat_timer.init(period=10000,
                                mode=machine.Timer.PERIODIC,
                                callback=lambda t: api.post_heartbeat())
        measurement_timer = machine.Timer(1)
        measurement_timer.init(period=20 * 1000,
                                mode=machine.Timer.PERIODIC,
                                callback=lambda t: api.post_measurement())


if machine.reset_cause() == machine.HARD_RESET:
    print("Hard reset, probably panicked, waiting 5 seconds before continuing")
    time.sleep(5)

print("Starting up...")
cold_boot()
post_boot()