# LATAR
# CrackMetrics

CrackMetrics is an evaluation metrics library for crack detection methods.
CrackMetrics includes: Threshold independent metrics ( OIS[1], ODS[1], AIU[2], sOIS[3], sODS[3] and avrF[^1])
and Threshold dependent metrics ( IoU and F-measure).

[^1]avrF is a new metric calculated in the same way as AIU, however using F-measure instead of IoU.

In OIS and ODS, annotation bias is dealt with by computing the correspondence between detected and ground truth pixels. 
The parameter dmax represents maximum tolerance for the correct match and has the default 0.0075 value.
The rest of the metrics ignore the annotation bias. 
However, to make the metrics robust to the transition between the crack pixels and the non-crack pixels in the subjectively labeled ground truth, we introduced 2-pixel tolerance option.  

CrackMetrics is a work in progress. Let us know of any issues, and feel free to contribute.

[1] D. Martin, C. Fowlkes, and J. Malik, “Learning to Detect Natural Image Boundaries Using Local Brightness, Color, and Texture Cues”, IEEE Transactions on Pattern Analysis and Machine Intelligence, Vol. 26, No. 1, 2004.

[2] F. Yang, L. Zhang, S. Yu, D. Prokhorov, X. Mei, and H. Ling, “Feature Pyramid and Hierarchical Boosting Network for Pavement Crack Detection” IEEE Trans. Intell. Transp., vol. 21, no. 4, 2020.

[3] V.Polovnikov, D. Alekseev, I. Vinogradov, and G. Lashkia, “DAUNet: Deep Augmented Neural Network for Pavement Crack Segmentation”, IEEE Access, Vol.9, 2021.

# Requirements
MATLAB is required.

# Getting Started

TBD


