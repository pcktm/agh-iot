import machine
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
        net.expose_ap()
        enter_pairing_mode()


if machine.reset_cause() == machine.HARD_RESET:
    raise Exception("Hard reset, probably panicked, not starting reporter!")
else:
    cold_boot()

    me = api.get_me()
    if not me:
        print(
            "This device does not exist or no internet connection? Entering pairing mode anyway lol"
        )
        enter_pairing_mode()

    owner = api.get_owner()
    if not owner:
        enter_pairing_mode()

    if net.is_connected() and owner is not None:
        heartbeat_timer = machine.Timer(0)
        heartbeat_timer.init(period=10000,
                             mode=machine.Timer.PERIODIC,
                             callback=lambda t: api.post_heartbeat())
        measurement_timer = machine.Timer(1)
        measurement_timer.init(period=20 * 1000,
                               mode=machine.Timer.PERIODIC,
                               callback=lambda t: api.post_measurement())
