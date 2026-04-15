# Diabetic Retinopathy Detection and Classification

Detection and classification of Diabetic Retinopathy (DR) stages from retinal fundus images using GLCM texture feature extraction, Student's T-test feature selection, and Support Vector Machine (SVM) classifiers with 6 kernel functions.

**Best result: 91.1% test accuracy · 95% AUC** (Severe NPDR vs PDR classification)

---

## Background

Diabetic Retinopathy is the leading cause of blindness in working-age adults, estimated to affect over 93 million people worldwide. Early detection is critical but currently requires trained clinicians and specialist equipment. This project builds an automated screening pipeline to classify DR severity directly from retinal fundus images.

---

## DR Stages Covered

| Stage | Description |
|---|---|
| Normal | No signs of diabetic retinopathy |
| Moderate NPDR | Non-proliferative DR, moderate stage |
| Severe NPDR | Non-proliferative DR, severe stage |
| PDR | Proliferative DR — most advanced stage, high risk of blindness |

---

## Pipeline

```
Fundus Images
     |
     v
Preprocessing
(flip → grayscale → crop into 3 segments)
     |
     v
GLCM Feature Extraction
(22 second-order texture features per image)
     |
     v
Feature Selection — Student's T-test
(3 most significant features per classification pair, p < 0.001)
     |
     v
SVM Classification
(6 kernel functions tested per binary classification problem)
     |
     v
Results — Accuracy, AUC, Confusion Matrix, ROC Curve
```

---

## Implementation Steps

### 1. Preprocessing

Three sequential steps applied to all fundus images:

- **Flipping** — Images flipped along the vertical axis so the optic disc is consistently aligned across all images
- **RGB to Grayscale** — Colour channels reduced to single channel for GLCM computation
- **Cropping** — Each image divided into 3 overlapping segments (upper, middle, lower) to exclude the optic disc region and focus on lesion areas

### 2. Feature Extraction — GLCM

Grey Level Co-occurrence Matrix (GLCM) computes second-order statistical texture features by measuring how often pairs of pixels with specific values occur in a specified spatial relationship.

22 features extracted per image including:

- Autocorrelation
- Contrast
- Correlation
- Cluster Prominence and Shade
- Dissimilarity
- Energy
- Entropy
- Homogeneity
- Maximum Probability
- Sum Average, Sum Variance, Sum Entropy
- Difference Variance, Difference Entropy
- Information Measures of Correlation (1 and 2)
- Inverse Difference Normalized
- Inverse Difference Moment Normalized

### 3. Feature Selection — Student's T-test

T-test applied to all 22 features to identify statistically significant discriminators between each pair of DR classes. The 3 features with the lowest p-value (p < 0.001) were selected as predictors for the SVM model.

| Classification | Top 3 features selected |
|---|---|
| Normal vs Abnormal | Maximum Correlation, Auto Correlation, Difference Variance |
| Normal vs Moderate | Maximum Correlation Coefficient, Difference Variance, Auto Correlation |
| Normal vs Severe | Sum Variance, Energy, Sum Average |
| Normal vs PDR | Auto Correlation, Sum of Squares, Difference Variance |
| Moderate vs Severe | Sum Entropy, Sum Variance, Sum Average |
| Moderate vs PDR | Sum Variance, Correlation, Sum Entropy |
| Severe vs PDR | Sum Entropy, Sum Variance, Energy |

### 4. SVM Classification

SVM trained using MATLAB's Classification Learner App with 6 kernel functions tested per classification problem: Linear, Quadratic, Cubic, Fine Gaussian, Medium Gaussian, and Coarse Gaussian. 70% training / 30% testing split with cross-validation.

---

## Results

| Classification | Best Kernel | Test Accuracy | AUC |
|---|---|---|---|
| Normal vs Abnormal | Medium Gaussian | 81.7% | 76% |
| Normal vs Moderate NPDR | Medium Gaussian | 82.2% | 87% |
| Normal vs Severe NPDR | Fine Gaussian | 81.7% | 89% |
| Normal vs PDR | Cubic (3rd degree) | 76.7% | 82% |
| Moderate vs Severe NPDR | Quadratic | 75.6% | 85% |
| Moderate vs PDR | Linear | 73.3% | 69% |
| **Severe NPDR vs PDR** | **Medium Gaussian** | **91.1%** | **95%** |

---

## File Structure

```
├── flip_images.m              # Step 1 — flip images for optic disc alignment
├── rgb_to_grayscale.m         # Step 2 — convert RGB fundus images to grayscale
├── crop_segments.m            # Step 3 — crop each image into 3 segments
├── extract_glcm_features.m    # Step 4 — extract GLCM features and export to Excel
├── GLCM_Features4.m           # GLCM feature computation function (22 features)
```

---

## Tech Stack

MATLAB 2021a · Image Processing Toolbox · Classification Learner App · GLCM · SVM

---

## Dataset

Retinal fundus images sourced from: https://zenodo.org/record/4647952

Classes: Normal, Moderate NPDR, Severe NPDR, PDR

---

## Team

Group project — B.Tech Electronics and Communication Engineering
MS Ramaiah University of Applied Sciences, Bengaluru (June 2021)
Supervised by Ms. Christy Bobby, Department of ECE
