# LATAR / CrackMetrics

CrackMetrics is an evaluation metrics library for crack detection methods.
CrackMetrics includes: Threshold independent metrics ( OIS[1], ODS[1], AIU[2], sOIS[3], sODS[3] and avrF[*])
and Threshold dependent metrics ( IoU and F-measure).

[*]: avrF is a new metric calculated in the same way as AIU, however using F-measure instead of IoU.

In OIS and ODS, annotation bias is dealt with by computing the correspondence between detected and ground truth pixels. 
The parameter dmax represents maximum tolerance for the correct match and has the default 0.0075 value.
The rest of the metrics ignore the annotation bias. 
However, to make the metrics robust to the transition between the crack pixels and the non-crack pixels in the subjectively labeled ground truth, we introduced 2-pixel tolerance option.  

CrackMetrics is a work in progress. Let us know of any issues, and feel free to contribute.


# Requirements
MATLAB is required.

# Getting Started

1. Download or clone this repository

2. Add folder $REPO/matlab to Matlab's path

3. Download correspondPixels library for your operating system:

[Windows® (64-bit)](https://github.com/pdollar/edges/blob/master/private/correspondPixels.mexw64)

[Linux® (64-bit)](https://github.com/pdollar/edges/blob/master/private/correspondPixels.mexa64)

[Apple Mac (64-bit)](https://github.com/pdollar/edges/blob/master/private/correspondPixels.mexmaci64)

One can also compile the library from the source code, see https://github.com/pdollar/edges for details

4. Open crack_gui.mlapp from Matlab:

![GUI.png](./GUI.PNG?raw=true "Main window")

5. Select directories with detections and ground truth images. For testing purpose one can use [toy dataset](./data/toy_dataset.zip)

6. There are 3 metrics sections: Threshold independent, Threshold independent with own tolerance, Threshold dependet.
Pressing "Compute" button starts computation of the respective metrics. 

*Note: Depending on the amount of data it may take a long time to calculate.
ODS/OIS are the most time consuming (polynomial time complexity).*


# References

[1] D. Martin, C. Fowlkes, and J. Malik, “Learning to Detect Natural Image Boundaries Using Local Brightness, Color, and Texture Cues”, IEEE Transactions on Pattern Analysis and Machine Intelligence, Vol. 26, No. 1, 2004.

[2] F. Yang, L. Zhang, S. Yu, D. Prokhorov, X. Mei, and H. Ling, “Feature Pyramid and Hierarchical Boosting Network for Pavement Crack Detection” IEEE Trans. Intell. Transp., vol. 21, no. 4, 2020.

[3] V.Polovnikov, D. Alekseev, I. Vinogradov, and G. Lashkia, “DAUNet: Deep Augmented Neural Network for Pavement Crack Segmentation”, IEEE Access, Vol.9, 2021.

