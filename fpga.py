import cv2
import serial
import time
import numpy as np

ser = serial.Serial(
    port='COM15',         # 根据实际情况修改串口号
    baudrate=9600,        # 波特率
    bytesize=serial.EIGHTBITS,   # 数据位 8 位
    parity=serial.PARITY_EVEN,   # 校验位 1 位（可以是 EVEN、ODD 或 NONE）
    stopbits=serial.STOPBITS_ONE, # 停止位 1 位
    timeout=1             # 读取超时时间（秒）
)

# 读取图像
image = cv2.imread('assets/5.jpg')  # 读取图像文件
height, width, _ = image.shape

# 等比例缩放图像，最大边长度为100
max_dim = 100
if width > max_dim or height > max_dim:
    if width > height:
        new_width = max_dim
        new_height = int((max_dim / width) * height)
    else:
        new_height = max_dim
        new_width = int((max_dim / height) * width)
    
    # 保证新的尺寸不会超过100x100
    new_width = min(new_width, max_dim)
    new_height = min(new_height, max_dim)
    
    # 调整图像大小
    image = cv2.resize(image, (new_width, new_height), interpolation=cv2.INTER_LINEAR)
    height, width, _ = image.shape

# 创建一个空的灰度图像
gray_image = np.zeros((height, width), dtype=np.uint8)

# 放大原始图像和灰度图像
enlarged_image = cv2.resize(image, (width * 4, height * 4), interpolation=cv2.INTER_LINEAR)
enlarged_gray_image = cv2.resize(gray_image, (width * 4, height * 4), interpolation=cv2.INTER_LINEAR)

# 遍历每一个像素
for y in range(height):
    for x in range(width):
        b, g, r = image[y, x]

        # 发送BGR通道的值到串口
        ser.write(bytes([b]))
        time.sleep(0.0001)  # 等待一段时间以确保数据传输
        ser.write(bytes([g]))
        time.sleep(0.0001)
        ser.write(bytes([r]))
        time.sleep(0.0001)

        # 发送触发信号
        ser.write(bytes([0xFF]))

        # 阻塞等待下位机返回平均值
        avg_value = ser.read()  # 接收1个字节
        if avg_value:
            gray_image[y, x] = ord(avg_value)  # 将接收到的灰度值填充回灰度图

            # 实时更新放大后的灰度图
            enlarged_gray_image[y*4:(y+1)*4, x*4:(x+1)*4] = ord(avg_value)

        # 实时显示放大的图像
        cv2.imshow('Original Image', enlarged_image)
        cv2.imshow('Grayscale Image', enlarged_gray_image)
        cv2.waitKey(1)  # 等待1ms，以显示图像

# 处理完所有像素后，显示最终的放大后的灰度图
cv2.imshow('Final Grayscale Image', enlarged_gray_image)
cv2.waitKey(0)  # 按任意键退出
cv2.destroyAllWindows()

# 关闭串口
ser.close()
