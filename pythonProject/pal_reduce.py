import sys
from PIL import Image

# Define the palette of colors to reduce to
PALETTE = [(255, 255, 255), (169, 169, 169), (84, 84, 84), (0, 0, 0)]
BASE_PATH = "C:\\Users\\Alexander\\Desktop\\Code\\Projects\\pokered_random\\gfx\\pokemon\\"

def closest_color(color, palette):
    """
    Find the closest color from the palette to the given color.
    Uses Euclidean distance in RGB space.
    """
    r, g, b = color
    closest = min(palette, key=lambda p: (p[0] - r)**2 + (p[1] - g)**2 + (p[2] - b)**2)
    return closest

def reduce_palette(image_path):
    """
    Reduces the palette of an image to the defined four colors.
    Saves the resulting image with "_reduced" appended to the filename.
    """
    try:
        # Open the image
        img = Image.open(image_path)
        img = img.convert("RGB")  # Ensure it's in RGB mode

        # Process every pixel
        pixels = img.load()
        for y in range(img.height):
            for x in range(img.width):
                original_color = pixels[x, y]
                pixels[x, y] = closest_color(original_color, PALETTE)

        # Save the result
        output_path = image_path.rsplit('.', 1)[0] + ".png"
        img.save(output_path)
        print(f"Image saved to {output_path}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 palette_reduce.py <image_path>")
    else:
        reduce_palette(sys.argv[1])
