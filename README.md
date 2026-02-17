# Data_Analysis
2024 Data Analysis Project Auth

## Function Naming Convention
The function names in this project were **mandated by the instructor** as part of an assignment. Any unusual naming choices are not arbitrary but follow the given requirements.

This repository contains the implementation of a comprehensive **Data Analysis** project conducted in December 2024 as part of the curriculum at the Aristotle University of Thessaloniki (Auth). The project focuses on analyzing the impact of Transcranial Magnetic Stimulation (TMS) on epileptic discharges (ED).

---

## 🛠 Project Overview

The core objective is to investigate whether external magnetic stimulation (TMS) can effectively reduce the duration of epileptic discharges. The analysis utilizes a dataset of 254 measurements, comparing ED durations under controlled conditions (no TMS) against experimental sessions involving varying TMS parameters like intensity, frequency, and coil shape.

### 📂 Dataset: TMS and EEG Analysis

The dataset includes measurements from 6 different experimental setups and various patients:

* **EDduration**: The total duration of the epileptic discharge.
* **preTMS / postTMS**: Temporal markers indicating when the stimulation was applied and how long the discharge lasted afterward.
* **Experimental Parameters**: Stimuli count, intensity, frequency, and coil shape (Eight-shaped vs. Circular).

---

## 📂 Project Structure & Exercises

The project is divided into 8 key analytical tasks (Issues), implemented across multiple MATLAB programs and functions:

| Task | Analytical Focus |
| --- | --- |
| **Issue 1** | Parametric probability distribution fitting for ED duration (with/without TMS) using Chi-square () tests. |
| **Issue 2** | Goodness-of-fit testing for exponential distributions using **Resampling** (1000 iterations) vs. parametric methods. |
| **Issue 3** | Mean duration analysis across 6 setups using **Parametric** and **Bootstrap** confidence intervals. |
| **Issue 4** | Correlation analysis between `preTMS` and `postTMS` markers using Student's distribution and **Randomization tests**. |
| **Issue 5** | Linear and Polynomial regression of ED duration relative to experimental setup. |
| **Issue 6** | Multiple Linear Regression with variable selection using **Stepwise** and **LASSO** techniques. |
| **Issue 7** | Model validation through randomized **Training/Test set** splitting to evaluate Mean Squared Error (MSE). |
| **Issue 8** | Dimensionality reduction and prediction using **Principal Component Regression (PCR)**. |

---

## 🚀 Technical Requirements & Conventions

### Naming Convention

The filenames in this project follow a **mandatory instructor-mandated convention** to ensure autonomous evaluation:

* **Programs**: `GroupXXExeYProgZ.m` (e.g., `Group37Exe1Prog1.m`).
* **Functions**: `GroupXXExeYFunZ.m` (e.g., `Group37Exe2Fun1.m`).

### Execution

* **Platform**: Developed and tested in MATLAB.
* **Self-Contained**: Programs are designed to load required data files from their local directory automatically.
* **Documentation**: Detailed result explanations and conclusions are provided as comments within each script.

---

## 👤 Authors

* **Marifoglou Apostolos**
* **Isidoros Tsaousis-Seiras**
