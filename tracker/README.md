# Object Tracker
 
------------
    ├── README.md
    ├── tracker_example.sh              : Script for running the example directly
    ├── tracker_example.ipynb           : Notebook for running the example step by step 
    ├── gen_valid_annotation.py         : Implementation of filtering valid bounding boxes 
    ├── tracker.py                      : Implementation of object tracking
    └── plot_tracked_bboxes.py          : Implementation of visualizing object tracking result
    


# Introduction

**tracker_example.sh** is a shell script thats running the demonstration of the pipeline directly.

To run the script
```
 $ chmod +x  tracker_example.sh
 $ ./tracker_example.sh
```


**Tracker_example.ipynb** provides the small example of the pipeline I used to do the object tracking on the output of YoloV3 model that is trained on aerial dataset

The example.tar.gz is the short video sample of Echabdens_Route_de_la_Gare_5

## Steps:

### 1. Download tracker.tar.gz
There are two directories and two files in tracker.tar.gz
1. Echabdens_Route_de_la_Gare_5/        : frame images from original video 
2. Echabdens_Route_de_la_Gare_5_pred/   : Object detection result
3. Echabdens_Route_de_la_Gare_5_cls.npy : Semantic segmentation meta of the scene
4. class.names                          : List of class names

### 2. Filter out the bounding boxes that lay on the desired areas of the scene
**Script:** `gen_valid_annotation.py`

Use semantic segmentation to remove the objects that are not in 

**Usage:**
```
usage: gen_valid_annotation.py [-h] [--img_w IMG_W] [--img_h IMG_H]
                               [--folder FOLDER] [--seg_path SEG_PATH]
                               [--edge_offset EDGE_OFFSET]
                               [--tolerance_th TOLERANCE_TH]
                               [--save_individually]

optional arguments:
  -h, --help            show this help message and exit
  --img_w IMG_W, -iw IMG_W
                        Image width Default=3480
  --img_h IMG_H, -ih IMG_H
                        Image height Default=2160
  --folder FOLDER, -f FOLDER
                        Folder that contains annotations txt files
  --seg_path SEG_PATH, -sp SEG_PATH
                        Segmentation array in npy format
  --edge_offset EDGE_OFFSET, -e EDGE_OFFSET
                        Ignore bbox which edges are close to bounding of
                        images in pixels Default=25
  --tolerance_th TOLERANCE_TH, -t TOLERANCE_TH
                        Tolerance threshold i.e desired class counts / total
                        pixels Default=0.9
  --save_individually, -si
                        Save annotation separately in {folder_name}_filtered/
```

### 3. Run tracking algorithm
**Script:**  `tracker.py`

Algorithm: Hungarian algorithm using distance matrix among bounding boxes

**Usage**:
```
usage: tracker.py [-h] [--input INPUT] [--img_w IMG_W] [--img_h IMG_H]
                  [--max_distance MAX_DISTANCE] [--max_frame MAX_FRAME]
                  [--start_frame START_FRAME] [--track_cls TRACK_CLS]
                  [--class_infer] [--linear_infer]

optional arguments:
  -h, --help            show this help message and exit
  --input INPUT, -i INPUT
                        Annotation txt file path
  --img_w IMG_W, -iw IMG_W
                        Image width Default=3480
  --img_h IMG_H, -ih IMG_H
                        Image height Default=2160
  --max_distance MAX_DISTANCE, -md MAX_DISTANCE
                        Max distance between consecutive bounding boxes
                        Default=100
  --max_frame MAX_FRAME, -mf MAX_FRAME
                        Max frame to track bounding box Default=20
  --start_frame START_FRAME, -sf START_FRAME
                        Frame number where to start tracking Default=1
  --track_cls TRACK_CLS, -tc TRACK_CLS
                        Class number to track Default="0,1,2,3,4"
  --class_infer, -ci    Infer class within a trajectory
  --linear_infer, -li   Infer missing bounding box within a trajectory
```


### 4. Visualize the tracking result
**Script:**  `plot_tracked_bboxes.py`

Plot the tracking result (i.e. id and class) on the images and combine images into video

**Usage:**
```
usage: plot_tracked_bboxes.py [-h] [--anno_path ANNO_PATH]
                              [--img_path IMG_PATH]
                              [--output_path OUTPUT_PATH]
                              [--class_path CLASS_PATH] [--img_tmp IMG_TMP]
                              [--output_img_tmp OUTPUT_IMG_TMP] [--font FONT]
                              [--font_size FONT_SIZE]
                              [--hide_linear_interpolation]

optional arguments:
  -h, --help            show this help message and exit
  --anno_path ANNO_PATH, -ap ANNO_PATH
                        Annotation txt file path
  --img_path IMG_PATH, -ip IMG_PATH
                        Folder that contains all frames
  --output_path OUTPUT_PATH, -op OUTPUT_PATH
                        Folder that contains output frames
  --class_path CLASS_PATH, -cp CLASS_PATH
                        Class names file
  --img_tmp IMG_TMP, -it IMG_TMP
                        Naming rule of the input images it should be python
                        format string. eg.
                        "Echabdens_Route_de_la_Gare_5_{:06d}.jpg"
  --output_img_tmp OUTPUT_IMG_TMP, -ot OUTPUT_IMG_TMP
                        Naming rule of the output images, it should be python
                        format string. eg.
                        "Echabdens_Route_de_la_Gare_5_{:06d}.jpg"
  --font FONT, -f FONT  The path of text font
                        default=/System/Library/Fonts/Helvetica.ttc (Mac)
  --font_size FONT_SIZE, -fs FONT_SIZE
                        Text size default=30
  --hide_linear_interpolation, -hl
                        Set color the inferred bounding to be identical with
                        the original one
```

## Tracker output format

The output format of the tracker is the following
```
<frame> <cls_no> <id> <xc> <yc> <w> <h> <infer>
```
- frame: frame number
- cls_no: class number (0 -> car, 1 -> truck, 2 -> bus, 3 -> van, 4 -> cyclist, 4 -> pedestrian)
- id: Unique ID of tracked object (Note: ID equals -1 if the object is excluded from tracking, e.g pedestrian class is not tracked by default.)
- xc: The x-coordinate of the center of the bounding box in pixel from the top-left corner
- yc: The y-coordinate of the center of the bounding box in pixel from the top-left corner
- w: the width of the bounding box in pixel
- h: the height of the bounding box in pixel
- infer: Set to 1 if the bounding box is inferred by algorithm.


**Example**
```
1 0 0 2244 1931 57 127 0
1 0 12 1629 1789 82 110 0
1 0 11 1728 1598 55 96 0
1 0 10 2649 349 69 86 0
1 5 -1 1180 943 39 88 0
```
  




