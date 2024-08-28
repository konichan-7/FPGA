import cv2

# 读取图像
image = cv2.imread('assets/1.jpg')

# 将图像转换为灰度图
gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# 保存灰度图像为2.jpg
cv2.imwrite('assets/2.jpg', gray_image)

print("图像已成功转换为灰度图，并保存为2.jpg")
