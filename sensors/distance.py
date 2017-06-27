#!/usr/bin/python
#-*- coding: utf-8 -*-
# HC-SR04超声波传感器

import time
import RPi.GPIO as GPIO
import os

GPIO.setmode(GPIO.BCM) #使用BCM编码方式
#定义引脚
GPIO_ECHO = 22
GPIO_TRIGGER = 23

#设置引脚为输入和输出
GPIO.setwarnings(False)
GPIO.setup(GPIO_TRIGGER, GPIO.OUT)
GPIO.setup(GPIO_ECHO, GPIO.IN)

def detect():
  GPIO.output(GPIO_TRIGGER, False)
  time.sleep(0.5)

  GPIO.output(GPIO_TRIGGER, True)
  time.sleep(0.00001)

  GPIO.output(GPIO_TRIGGER, False)

  start = time.time()
  while(GPIO.input(GPIO_ECHO))==0: #当有障碍物时，传感器输出低电平，所以检测低电平
    start = time.time()

  while(GPIO.input(GPIO_ECHO))==1: #当有障碍物时，传感器输出低电平，所以检测低电平
    stop = time.time()

  elapsed = stop-start   #计算一共花费多长时间  
  distance = elapsed * 34300  #计算距离，就是时间乘以声速  
  distance = distance / 2  #除以2得到一次的距离而不是来回的距离  
  print "Distance : %.1fcm" % distance  

while True:
  detect()
  time.sleep(1)

GPIO.cleanup()
