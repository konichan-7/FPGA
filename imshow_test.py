import cv2

image = cv2.imread('assets/1.jpg')

if image is None:
    print("Image not found or unable to read.")
else:
    height, width = image.shape[:2]

    # 放大图像，尺寸扩大四倍
    enlarged_image = cv2.resize(image, (width * 4, height * 4), interpolation=cv2.INTER_LINEAR)

    # 显示放大后的图像
    cv2.imshow('Enlarged Image', enlarged_image)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
