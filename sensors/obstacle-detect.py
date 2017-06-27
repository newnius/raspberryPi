#!/usr/bin/python
#-*- coding: utf-8 -*-
# 避障传感器 壁障小车 黑白线识别

import time
import RPi.GPIO as GPIO
import os

GPIO.setmode(GPIO.BCM) #使用BCM编码方式
#定义引脚
GPIO_1 = 1
GPIO_2 = 2
GPIO_3 = 3
GPIO_4 = 4
GPIO_16 = 16
GPIO_21 = 21
GPIO_23 = 23
GPIO_24 = 24

led = 21
#设置引脚为输入和输出
GPIO.setwarnings(False)
#设置23针脚为输入，接到红外避障传感器模块的out引脚
GPIO.setup(GPIO_23,GPIO.IN)

#GPIO.setup(led,GPIO.OUT)

def warn():   #亮灯来作为有障碍物时发出的警告
#    GPIO.output(led,GPIO.HIGH)
#    time.sleep(0.5)
#    GPIO.output(led,GPIO.LOW)
     time.sleep(0.5)
     print "warn"

while True:
    #GPIO.input(GPIO_23)==0: #当有障碍物时，传感器输出低电平，所以检测低电平
    print GPIO.input(GPIO_23) #当有障碍物时，传感器输出低电平，所以检测低电平
GPIO.cleanup()
