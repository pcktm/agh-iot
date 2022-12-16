import net
from config import config
import machine
from microwebsrv import MicroWebSrv
import time


def pairing_route_handler(httpClient, httpResponse, routeArgs=None):
    print("Got pairing request!")
    if routeArgs is not None:
        print("Route args: ", routeArgs)
    body = httpClient.ReadRequestContentAsJSON()
    print("Request content: ", body)

    
    if not ('ssid' in body and 'password' in body):
        httpResponse.WriteResponseJSONError(400, {
            "message": "Missing ssid or password"
        })
        return
    
    if 'userId' not in body:
        httpResponse.WriteResponseJSONError(400, {
            "message": "Missing userId"
        })
        return
    
    config.set('network.ssid', body['ssid'])
    config.set('network.password', body['password'])
    config.set('ownerToBeRegisteredTo', body['userId'])
    config.save()

    httpResponse.WriteResponseJSONOk({
        "message": "Pairing successful, will reboot!"
    })

    print("Will reboot in 2 seconds!")
    time.sleep(2)
    machine.reset()

route_handlers = [("/pair", "POST", pairing_route_handler)]
mws = MicroWebSrv(routeHandlers=route_handlers)


def enter_pairing_mode():
    print("ENTERING PAIRING MODE!!!")
    net.expose_ap(config.get("device.name"))
    print("Access point exposed, spinning up server...")

    mws.Start(threaded=True)
    print("Waiting for pairing request...")