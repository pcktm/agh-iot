import network
import socket
import machine

def connect_to_ap(ssid, password):
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    wlan.config(reconnects=20)
    wlan.connect(ssid, password)
    while not wlan.isconnected():
        pass
    print('network config:', wlan.ifconfig())

def is_connected():
    wlan = network.WLAN(network.STA_IF)
    return wlan.isconnected()

def expose_ap(ssid="iot device", password=""):
    wlan = network.WLAN(network.AP_IF)
    wlan.active(True)
    wlan.config(essid=ssid, password=password)
    print('network config:', wlan.ifconfig())

def busy_wait_for_config():
    addr = socket.getaddrinfo('0.0.0.0', 80)[0][-1]
    s = socket.socket()
    s.bind(addr)
    s.listen(1)

    print('listening on', addr)
    while True:
        cl, addr = s.accept()
        print('client connected from', addr)
        cl_file = cl.makefile('rwb', 0)
        while True:
            line = cl_file.readline()
            print(line)
            if not line or line == b'\r\n':
                break
        cl.send('OK')
        cl.close()

