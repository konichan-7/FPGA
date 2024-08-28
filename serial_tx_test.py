import serial
import time

ser = serial.Serial(
    port='COM15',         # 根据实际情况修改串口号
    baudrate=9600,        # 波特率
    bytesize=serial.EIGHTBITS,   # 数据位 8 位
    parity=serial.PARITY_EVEN,   # 校验位 1 位（可以是 EVEN、ODD 或 NONE）
    stopbits=serial.STOPBITS_ONE, # 停止位 1 位
    timeout=1             # 读取超时时间（秒）
)

for x in range(255):
    ser.write(bytes([x]))
    time.sleep(0.1)
    if(x%4==0):
        avr=ser.read(1)
        print(avr)

ser.close()