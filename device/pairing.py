import net
from config import config


def enter_pairing_mode():
    print("ENTERING PAIRING MODE!!!")
    net.expose_ap(config.get("device.name"))

    print(config.get("device.name"))