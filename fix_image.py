from PIL import Image

def make_transparent(input_path, output_path):
    img = Image.open(input_path).convert("RGBA")
    data = img.getdata()

    new_data = []
    for item in data:
        # Average brightness
        gray = int((item[0] + item[1] + item[2]) / 3)
        # If dark, fully transparent. Else use gray as alpha and set color to white.
        if gray < 20:
            new_data.append((255, 255, 255, 0))
        else:
            new_data.append((255, 255, 255, gray))

    img.putdata(new_data)
    img.save(output_path, "PNG")

make_transparent("assets/images/ic_diary.png", "assets/images/ic_diary.png")
print("Python image fix successful!")
