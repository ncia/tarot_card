from PIL import Image

def restore_black_bg(input_path, output_path):
    img = Image.open(input_path).convert("RGBA")
    data = img.getdata()

    new_data = []
    for item in data:
        # If it is transparent (alpha = 0), make it black (0,0,0,255)
        if item[3] == 0:
            new_data.append((0, 0, 0, 255))
        else:
            new_data.append((item[0], item[1], item[2], 255))

    img.putdata(new_data)
    img.save(output_path, "PNG")

restore_black_bg("assets/images/ic_diary.png", "assets/images/ic_diary.png")
print("Image restored to black background!")
