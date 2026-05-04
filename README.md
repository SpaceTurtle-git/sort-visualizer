# Godot 4 Sorting Visualizer

A real-time sorting algorithm visualizer built with **Godot 4**. This tool allows users to observe the mechanics of various sorting algorithms with granular control over speed, array size, and execution flow.

## Features

   **9 Different Sorting Algorithms**
  * ***Bubble sort***: Repeatedly compares adjacent elements in a list, swapping them if they are in the wrong order until sorted. 
  * ***Quick sort***: Picks a "pivot," partitioning the array into smaller and larger elements, then recursively sorts each sub-array until finished.
  * ***Selection sort***: Repeatedly finds the minimum element from the unsorted portion and moves it to the beginning until the list's sorted.
  * ***Insertion sort***: Builds a sorted array one item at a time by inserting each element into its correct, relative position.
  * ***Shell sort***: Improves insertion sort by comparing elements separated by a gap, gradually reducing the gap until it equals one.
  * ***Bogo sort***: Randomly shuffles elements until they are sorted. It is highly inefficient, relying entirely on luck and extreme persistence.
  * ***Miracle sort***: Hopes for an external event, like a hardware error, to spontaneously reorder the list into perfect sequence.
  * ***Stalin sort***: "Sorts" a list by eradicating any element that is out of order, leaving only a sorted sequence.
  * ***Radix sort***: Radix sort processes integers by grouping them by individual digits, typically from least to most significant, using stable bucket sorting.  
    
   **Functionalities**
  * *Modify the number of bars you want to sort.*
  * *Pause the sorting process.*
  * *Reset and Randomize all bars.*
  * *Change tick speed to increase and decrease sorting speed.*
  * *Change the sorting algorithm.*

---

## Screenshots

### Main Interface
<img width="1284" height="718" alt="image" src="https://github.com/user-attachments/assets/4a835806-4e8f-4c76-9373-a6856187eff1" />

### Bubble Sort in Progress
<img width="1276" height="747" alt="image" src="https://github.com/user-attachments/assets/009d73c1-6b16-45de-a468-d185555a85ed" />

### Quick Sort Partitioning
<img width="1282" height="745" alt="image" src="https://github.com/user-attachments/assets/0e6f6b6b-d65e-44fb-be55-ec7eb7d8c645" />

### Also on Android
<img width="1600" height="702" alt="image" src="https://github.com/user-attachments/assets/d4c62bdc-7062-4dfd-83d3-434b7bee1751" />

---
## How to Use

1.  **Adjust Bars:** Use the slider to set the number of elements to sort.
2.  **Set Speed:** Use the SpinBox to define sorting velocity (Higher = Faster).
3.  **Sort:** Choose an algorithm (default is Bubble Sort) to begin.
4.  **Pause/Reset:** Use the UI buttons to interrupt the process or start fresh at any time.

---

## Planned Improvements

*   **Batch Processing:** Implementing a "swaps-per-frame" system to bypass the 60fps engine limit for ultra-high-speed sorting.
*   **Audio Feedback:** Adding sine-wave synthesis mapped to the value of the bars being sorted.
*   **More Algorithms:** Adding Merge Sort, Heap Sort, and Insertion Sort.

---

## Downloads

*   .exe file for Windows download in relases.
*   .apk file for android in releases.

---
## 📜 License

[Apache 2.0]
