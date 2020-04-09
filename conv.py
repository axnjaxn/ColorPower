import sys, cv2
import numpy as np

if len(sys.argv) != 2:
    print('Usage: python %s imagefile' % (sys.argv[0]))

img = cv2.imread(sys.argv[1])

h = min(128, img.shape[0])
w = min(128, img.shape[1])
if h < 128 or w < 128:
    expanded = np.ndarray((h, 128, 3), dtype=np.uint8)
    expanded[:h, :w, :] = img
    img = expanded
    w = 128

colors=[
    "000000",
    "1D2B53",
    "7E2553",
    "008751",
    "AB5236",
    "5F574F",
    "C2C3C7",
    "FFF1E8",
    "FF004D",
    "FFA300",
    "FFEC27",
    "00E436",
    "29ADFF",
    "83769C",
    "FF77A8",
    "FFCCAA"
]
for i in range(len(colors)):
    r = int(colors[i][:2], 16)
    g = int(colors[i][2:4], 16)
    b = int(colors[i][4:], 16)
    colors[i] = np.array([b, g, r], dtype=float)

def colorDist(rgb1, rgb2):
    d = np.asarray(rgb1, float) - np.asarray(rgb2, float)
    return d[0] * d[0] + d[1] * d[1] + d[2] * d[2]

def getColor(img, r, c):
    rgb = np.asarray(img[r,c,:], float)
    dbest = 1e99
    for i in range(len(colors)):
        d = colorDist(rgb, colors[i])
        if d < dbest:
            dbest = d
            best = i
    return best

for r in range(h):
    s = ''
    for c in range(w):
        px = getColor(img, r, c)
        s = s + '%1x' % (px)
    print(s)
