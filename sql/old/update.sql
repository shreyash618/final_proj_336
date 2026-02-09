USE tech_barn;

-- Add image_path column to Item table
--ALTER TABLE Item ADD COLUMN image_path VARCHAR(255);

-- Update image paths for Phones (category_id = 1)
-- Format: brand_color.extension
-- Map each phone to its specific image file
UPDATE Item SET image_path = 'Images/item_photos/phones/iphone_pink.jpg' WHERE item_id = 1;  -- Apple iPhone 15 Pro, Pink
UPDATE Item SET image_path = 'Images/item_photos/phones/iphone_red.png' WHERE item_id = 2;  -- Apple iPhone 14, Red
UPDATE Item SET image_path = 'Images/item_photos/phones/samsung_titanium_gray.jpg' WHERE item_id = 3;  -- Samsung Galaxy S24 Ultra, Titanium Gray
UPDATE Item SET image_path = 'Images/item_photos/phones/samsung_phantom_black.jpeg' WHERE item_id = 4;  -- Samsung Galaxy S23, Phantom Black
UPDATE Item SET image_path = 'Images/item_photos/phones/google_obsidian.jpeg' WHERE item_id = 5;  -- Google Pixel 8 Pro, Obsidian
UPDATE Item SET image_path = 'Images/item_photos/phones/google_pixel_snow.jpg' WHERE item_id = 6;  -- Google Pixel 7, Snow
UPDATE Item SET image_path = 'Images/item_photos/phones/oneplus_pink.jpg' WHERE item_id = 7;  -- OnePlus 12, Pink
UPDATE Item SET image_path = 'Images/item_photos/phones/oneplus_titan_black.jpg' WHERE item_id = 8;  -- OnePlus 11, Tit Black
UPDATE Item SET image_path = 'Images/item_photos/phones/iphone_blue.jpg' WHERE item_id = 9;  -- Apple iPhone 13, Blue
UPDATE Item SET image_path = 'Images/item_photos/phones/samsung_orange.png' WHERE item_id = 10;  -- Samsung Galaxy S22, Orange

-- Update image paths for TVs (category_id = 2)
-- Format: brand_tv.extension
UPDATE Item SET image_path = 'Images/item_photos/tvs/samsung_qled.jpg' WHERE item_id = 11;  -- Samsung QLED 65"
UPDATE Item SET image_path = 'Images/item_photos/tvs/lg_tv.jpeg' WHERE item_id = 12;  -- LG OLED 55"
UPDATE Item SET image_path = 'Images/item_photos/tvs/sony_tv.jpg' WHERE item_id = 13;  -- Sony Bravia 75"
UPDATE Item SET image_path = 'Images/item_photos/tvs/tcl_tv.png' WHERE item_id = 14;  -- TCL Roku TV 50"
UPDATE Item SET image_path = 'Images/item_photos/tvs/vizio_tv.png' WHERE item_id = 15;  -- Vizio Smart TV 43"
UPDATE Item SET image_path = 'Images/item_photos/tvs/samsung_qled.jpg' WHERE item_id = 16;  -- Samsung QLED 55"
UPDATE Item SET image_path = 'Images/item_photos/tvs/lg_tv.jpeg' WHERE item_id = 17;  -- LG OLED 65"
UPDATE Item SET image_path = 'Images/item_photos/tvs/sony_tv.jpg' WHERE item_id = 18;  -- Sony X90L 85"
UPDATE Item SET image_path = 'Images/item_photos/tvs/hisense_tv.jpg' WHERE item_id = 19;  -- Hisense ULED 58"
UPDATE Item SET image_path = 'Images/item_photos/tvs/panasonic_tv.jpg' WHERE item_id = 20;  -- Panasonic OLED 48"

-- Update image paths for Headphones (category_id = 3)
-- Format: brand_wireless/wired_color.extension
-- Join with Headphones table to get isWireless attribute
UPDATE Item i
INNER JOIN Headphones h ON i.item_id = h.item_id
SET i.image_path = CASE i.item_id
    WHEN 21 THEN 'Images/item_photos/headphones/sony_wireless_blue.jpg'  -- Sony WH-1000XM5 - wireless, blue
    WHEN 22 THEN 'Images/item_photos/headphones/apple_wireless_white.jpeg'  -- Apple AirPods 2 - wireless, white
    WHEN 23 THEN 'Images/item_photos/headphones/bose_wireless_black.jpg'  -- Bose QuietComfort 45 - wireless, black
    WHEN 24 THEN 'Images/item_photos/headphones/seinheisser_wired_black.jpg'  -- Sennheiser HD 660S - wired, black
    WHEN 25 THEN 'Images/item_photos/headphones/sony_wireless_black.jpeg'  -- Sony WF-1000XM5 - wireless, black
    WHEN 26 THEN 'Images/item_photos/headphones/apple_wireless_max.jpg'  -- Apple AirPods Max - wireless, starlight
    WHEN 27 THEN 'Images/item_photos/headphones/bose_wired_black.jpg'  -- Bose 700 - wired, black
    WHEN 28 THEN 'Images/item_photos/headphones/jbl_wireless_red.jpg'  -- JBL Tune 770NC - wireless, red
    WHEN 29 THEN 'Images/item_photos/headphones/beats_wireless_purple.jpg'  -- Beats Studio Pro - wireless, purple
    WHEN 30 THEN 'Images/item_photos/headphones/sony_wired_black.jpg'  -- Sony WH-1000XM4 - wired, black
    WHEN 31 THEN 'Images/item_photos/headphones/audio_technica_wired_blue.jpg'  -- Audio-Technica ATH-M50xBT2 - wired, blue
    WHEN 32 THEN 'Images/item_photos/headphones/sennheiser_wireless_white.jpg'  -- Sennheiser Momentum 4 - wireless, white
    WHEN 33 THEN 'Images/item_photos/headphones/sony_wired_blue.jpg'  -- Sony WH-XB910N - wired, blue
    WHEN 34 THEN 'Images/item_photos/headphones/apple_wired_white.jpg'  -- Apple EarPods - wired, white
    WHEN 35 THEN 'Images/item_photos/headphones/bose_wireless_black2.jpg'  -- Bose Sport Earbuds - wireless, black
    ELSE i.image_path
END
WHERE i.item_id IN (21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35);
