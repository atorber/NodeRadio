import sys
try:
    from PIL import Image, ImageDraw, ImageFilter, ImageFont
except ImportError:
    print("Pillow not found, installing...")
    import subprocess
    subprocess.check_call([sys.executable, "-m", "pip", "install", "Pillow"])
    from PIL import Image, ImageDraw, ImageFilter, ImageFont

def create_neon_icon(size=1024):
    # Background (dark surface)
    img = Image.new('RGB', (size, size), color='#0e0e11')
    draw = ImageDraw.Draw(img)

    # Calculate dimensions
    center_x, center_y = size // 2, size // 2

    # Outer glowing circle (Primary dim #7e51ff)
    radius_outer = size * 0.4
    circle_bbox_outer = [center_x - radius_outer, center_y - radius_outer,
                         center_x + radius_outer, center_y + radius_outer]

    # Draw multiple rings for glow effect
    for i in range(15):
        alpha = int(100 - (i * 6.6))
        offset = i * 2
        glow_bbox = [circle_bbox_outer[0] - offset, circle_bbox_outer[1] - offset,
                     circle_bbox_outer[2] + offset, circle_bbox_outer[3] + offset]
        draw.ellipse(glow_bbox, outline='#7e51ff', width=3)

    draw.ellipse(circle_bbox_outer, outline='#b6a0ff', width=12)

    # Inner triangle (play button style) or equalizers
    # Let's draw an equalizer icon (similar to the graphic_eq used in the app)
    # Secondary color: #00d4ec

    bar_width = size * 0.08
    spacing = size * 0.04
    total_width = (3 * bar_width) + (2 * spacing)
    start_x = center_x - (total_width / 2)

    heights = [size * 0.2, size * 0.4, size * 0.25]

    for i, h in enumerate(heights):
        x = start_x + i * (bar_width + spacing)
        y = center_y - (h / 2)
        bar_bbox = [x, y, x + bar_width, y + h]

        # Glow for bars
        for g in range(8):
            g_offset = g * 3
            g_bbox = [bar_bbox[0] - g_offset, bar_bbox[1] - g_offset,
                      bar_bbox[2] + g_offset, bar_bbox[3] + g_offset]
            draw.rectangle(g_bbox, outline='#00d4ec', width=1)

        draw.rectangle(bar_bbox, fill='#00d4ec')

    # Apply slight blur to the whole image to blend glows better
    # blur_img = img.filter(ImageFilter.GaussianBlur(radius=2))

    # Draw crisp inner shapes on top
    draw.ellipse(circle_bbox_outer, outline='#fcf8fd', width=4)
    for i, h in enumerate(heights):
        x = start_x + i * (bar_width + spacing)
        y = center_y - (h / 2)
        bar_bbox = [x, y, x + bar_width, y + h]
        draw.rectangle(bar_bbox, fill='#26e6ff')

    img.save('assets/app_icon.png', 'PNG')

create_neon_icon()
print("Icon generated successfully at assets/app_icon.png")
