# Segmentation Meta
```
    ├── README.md                         
    ├── plot_segmentation.ipynb         : Visualize segmentation meta from Labelbox  and convert it to 2-D numpy array
    ├── plot_trajectory.ipynb           : Plot trajectory on the image of semantic segmentation
    ├── Example_tracked_all.txt         : Example of annotation that is used by  plot_trajectory.ipynb
    ├── segmentation_meta_labelbox.json : Segmentation meta from Labelbox that is used by plot_segmentation.ipynb 
    ├── trajectory_output/              : Output folder of plot_trajectory.ipynb
    └── segmentation_output/            : Output folder of plot_segmentation.ipynb
```  
# Introduction

**1. plot_segmentation.ipynb** converts annotations of   semantic segmentation which are in polygon coordinates to color images and 2-D numpy array that could be used as input of metadata while training a model.

#### Example of color image:
<img src="segmentation_output/example_color.jpg"  width="800">

**2. plot_trajectory.ipynb** plots the trajectory of tracked object on the color image of semantic segmentation.

Note: `example.gif` in `trajectory_output` was created by other application.

#### Example of the output:
<img src="trajectory_output/example.gif" width="800">

