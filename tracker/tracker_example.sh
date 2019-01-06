#!/bin/bash


echo "Downloading tracker.tar.gz...."
gfileid="1CWRj6RzMb7pZ6eiJ2kBaklvXs777dram"
destination_dir="./"
file_name="tracker.tar.gz"
destination_path="${destination_dir}${file_name}"
curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${gfileid}" > /dev/null
curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${gfileid}" -o ${destination_path}

echo "Inflating....."
tar -zxf $file_name
rm -rf $file_name cookie

echo "Example: "
ls example

echo "Filter out the bounding boxes that lay on the desired areas of the scene"
FOLDER="example/Echabdens_Route_de_la_Gare_5_pred/"
SEG_PATH="example/Echabdens_Route_de_la_Gare_5_cls.npy"
python3 gen_valid_annotation.py -f $FOLDER -sp $SEG_PATH

echo "Run tracking algorithm"
INPUT="example/Echabdens_Route_de_la_Gare_5_pred/Echabdens_Route_de_la_Gare_5_all.txt"
python3 tracker.py -i $INPUT -ci -li

echo "Visaulize the tracking result"
ANNO_PATH="example/Echabdens_Route_de_la_Gare_5_pred/Echabdens_Route_de_la_Gare_5_tracked_all.txt"
IMG_PATH="example/Echabdens_Route_de_la_Gare_5/"
output_path="example/tracked_output/"
CLASS_PATH="example/class.names"
IMG_TMP="Echabdens_Route_de_la_Gare_5_{:06d}.jpg"
OUTPUT_IMG_TMP="Echabdens_Route_de_la_Gare_5_{:06d}.jpg"

python3 plot_tracked_bboxes.py -ap $ANNO_PATH -ip $IMG_PATH -op $output_path -cp $CLASS_PATH -it $IMG_TMP -ot $OUTPUT_IMG_TMP

echo "Combine images into video and save it to example/output.mp4"
ffmpeg -r 25 -pattern_type glob -i "example/tracked_output/*.jpg" example/output.mp4



