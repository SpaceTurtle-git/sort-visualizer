# Godot 4 Sorting Visualizer

A real-time sorting algorithm visualizer built with **Godot 4**. This tool allows users to observe the mechanics of various sorting algorithms with granular control over speed, array size, and execution flow.

## 🚀 Features

*   **Real-time Speed Manipulation:** Uses an inverse-mapped SpinBox (1–1000) to control sorting delays from **1.0s** down to **0.001s**.
*   **Dynamic Array Scaling:** Adjustable bar counts that regenerate the dataset on the fly.
*   **Interactive Controls:** Full support for **Pause/Resume** and **Instant Reset** logic.
*   **Safety-First Architecture:** Implements "Kill Switch" flags to prevent "Zombie Sort" crashes when resetting during active execution.
*   **Visual Feedback:** Distinct color states for **Active** (comparing), **Sorted**, and **Idle** elements.

---

## 📸 Screenshots

### Main Interface
<img width="1284" height="718" alt="image" src="https://github.com/user-attachments/assets/4a835806-4e8f-4c76-9373-a6856187eff1" />

### Bubble Sort in Progress
<img width="1291" height="751" alt="image" src="https://github.com/user-attachments/assets/ce4ceca7-da4e-4120-88b6-8779e82f316d" />

### Quick Sort Partitioning
<img width="1282" height="745" alt="image" src="https://github.com/user-attachments/assets/0e6f6b6b-d65e-44fb-be55-ec7eb7d8c645" />

### Also on Android
<img width="1600" height="702" alt="image" src="https://github.com/user-attachments/assets/d4c62bdc-7062-4dfd-83d3-434b7bee1751" />

---
## 📖 How to Use

1.  **Adjust Bars:** Use the slider to set the number of elements to sort.
2.  **Set Speed:** Use the SpinBox to define sorting velocity (Higher = Faster).
3.  **Sort:** Choose an algorithm (Bubble Sort/Quick Sort) to begin.
4.  **Pause/Reset:** Use the UI buttons to interrupt the process or start fresh at any time.

---

## 🏗 Planned Improvements

*   **Batch Processing:** Implementing a "swaps-per-frame" system to bypass the 60fps engine limit for ultra-high-speed sorting.
*   **Audio Feedback:** Adding sine-wave synthesis mapped to the value of the bars being sorted.
*   **More Algorithms:** Adding Merge Sort, Heap Sort, and Insertion Sort.

---

## 🟩Downloads

*   .exe file for Windows download in relases.
*   .apk file for android in exe.

---
## 📜 License

[MIT](https://choosealicense.com/licenses/mit/)
