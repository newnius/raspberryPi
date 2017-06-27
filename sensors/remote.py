#!/usr/bin/python
# -*- coding:utf-8 -*-
# 红外接收头带屏蔽罩/遥控接收头/遥控

import RPi.GPIO as GPIO
import time
ERROR = 0xFE
PIN = 18
 
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(PIN, GPIO.IN, GPIO.PUD_UP)
 
def getKey():
    byte = [0, 0, 0, 0];
    if IRStart() == False:
        time.sleep(0.11);        # One message frame lasts 108 ms.
        return ERROR;
    else:
        for i in range(0, 4):
            byte[i] = getByte();
        if byte[0] + byte[1] == 0xff and byte[2] + byte[3] == 0xff:
            return byte[2];
        else:
            return ERROR;
def IRStart():
    timeFallingEdge = [0, 0];
    timeRisingEdge = 0;
    timeSpan = [0, 0];
    GPIO.wait_for_edge(PIN, GPIO.FALLING);
    timeFallingEdge[0] = time.time();
    GPIO.wait_for_edge(PIN, GPIO.RISING);
    timeRisingEdge = time.time();
    GPIO.wait_for_edge(PIN, GPIO.FALLING);
    timeFallingEdge[1] = time.time();
    timeSpan[0] = timeRisingEdge - timeFallingEdge[0];
    timeSpan[1] = timeFallingEdge[1] - timeRisingEdge;
    if timeSpan[0] > 0.0085 and \
       timeSpan[0] < 0.0095 and \
       timeSpan[1] > 0.004 and \
       timeSpan[1] < 0.005:
        return True;
    else:
        return False;
def getByte():
    byte = 0;
    timeRisingEdge = 0;
    timeFallingEdge = 0;
    timeSpan = 0;
    for i in range(0, 8):
        GPIO.wait_for_edge(PIN, GPIO.RISING);
        timeRisingEdge = time.time();
        GPIO.wait_for_edge(PIN, GPIO.FALLING);
        timeFallingEdge = time.time();
        timeSpan = timeFallingEdge - timeRisingEdge;
        if timeSpan > 0.0016 and timeSpan < 0.0018:
            byte |= 1 << i;
    return byte;
print('IRM Test Start ...')
try:
    while True:
        key = getKey();
        if(key != ERROR):
            print("Get the key: 0x%02x" %key)
        else:
            print("Get ERROR")
except KeyboardInterrupt:
    GPIO.cleanup();
