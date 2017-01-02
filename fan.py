#!/usr/bin/python
#-*- coding: utf-8 -*-
import time, os, datetime
import RPi.GPIO as GPIO

GPIO_OUT = 14
LOG_PATH = '/var/log/fan_control.log'
IS_DEBUG=False

def read_cpu_temperature():
  with open("/sys/class/thermal/thermal_zone0/temp", 'r') as f:
    temperature = float(f.read()) / 1000
  log('DEBUG', 'Current CPU temperature is %s' % temperature)
  return temperature

def start_fan():
  log('INFO', 'power on.')
  GPIO.output(GPIO_OUT, GPIO.HIGH)

def stop_fan():
  log('INFO', 'power off.')
  GPIO.output(GPIO_OUT, GPIO.LOW)
 
def setup_GPIO():
  GPIO.setmode(GPIO.BCM)
  GPIO.setwarnings(False)   
  GPIO.setup(GPIO_OUT, GPIO.OUT) 

def control_fan():
  is_close = True
  try:
    while True:
      temp = read_cpu_temperature()
      if is_close:
        if temp>=50:
          start_fan() 
          is_close = False
      else:
        if temp<=45:
          stop_fan()
          is_close = True    
      time.sleep(10)
  except Exception, e:
    GPIO.cleanup()
    log('WARN', e)

def log(level, msg):
  log_msg = '[%s]: %s (%s)' % (level, msg, datetime.datetime.now() )
  if IS_DEBUG:
    print log_msg
    return 
  if level == 'DEBUG':
    return
  try:
    with open(LOG_PATH, 'a') as f:
      f.write(log_msg+'\n')
  except Exception as e:
    print "Unable to log, %s" % e

if __name__ == '__main__':
  os.environ["TZ"] = 'Asia/Shanghai'
  time.tzset()
  log('INFO', 'started.')
  setup_GPIO()
  control_fan()
  log('INFO', 'quit.')
