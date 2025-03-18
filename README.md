# Hardware-Accelerated MLP for Iris Dataset

##  Course Information
- **Course Name:** Accelerated Hardware Programming  
- **Department:** Faculty of Engineering and Computer Science  
- **University:** Shahid Beheshti University  
---

## Project Overview
This project focuses on designing and implementing a Multi-Layer Perceptron (MLP) for the Iris dataset. The implementation consists of two phases:

1. **Software Implementation**: Using Python and machine learning libraries to build and train the neural network.
2. **Hardware Implementation**: Implementing the trained network using Verilog/VHDL and Systolic Array architecture.

---

## Table of Contents
- [Dataset](#dataset)
- [Software Implementation](#software-implementation)
- [Hardware Implementation](#hardware-implementation)
- [Evaluation Metrics](#evaluation-metrics)
- [Tools & Dependencies](#tools--dependencies)

---

## Dataset
The Iris dataset is used for classification of iris flowers into three species based on four features:
- Sepal length
- Sepal width
- Petal length
- Petal width

Download the dataset from:
[UCI Machine Learning Repository - Iris Dataset](https://archive.ics.uci.edu/dataset/53/iris)

---

## Software Implementation
1. Load the dataset and preprocess the data.
2. Implement an MLP using one of the following Python frameworks:
   - TensorFlow/Keras
   - PyTorch
   - Scikit-learn
3. Configure the network architecture using one of the following structures:
   - (4,4,3)
   - (4,3,3,3)
   - (4,5,3)
4. Use **ReLU** as the activation function and **Stochastic Gradient Descent (SGD)** for optimization.
5. Train the model and evaluate accuracy on a test set (10% of the dataset).
6. Save the trained weights for hardware implementation.

---

## Hardware Implementation
The hardware implementation involves designing a **Systolic Array**-based inference engine:

### **Phase 1: Single-Dimensional Systolic Array**
- Implement matrix-vector multiplication using a one-dimensional systolic array.
- Use the trained weights from the software model.
- Ensure correct computations.

### **Phase 2: Two-Dimensional Systolic Array** (Bonus)
- Implement a two-dimensional systolic array for parallel computation.
- Optimize data flow and register usage.
- Implement pipelining for efficient processing.

Use **Verilog/VHDL** for HDL implementation.

---

## Evaluation Metrics
Each implementation is evaluated based on:
- **Classification Accuracy**
- **Clock Speed**
- **Number of Clock Cycles**
- **Chip Area Utilization**

Tools: Use **Vivado/ISE Xilinx/Synopsis Design Compiler** for synthesis and evaluation.

---

## Tools & Dependencies
- Python 3.x
- TensorFlow/Keras or PyTorch
- Verilog/VHDL for hardware implementation
- Vivado/ISE Xilinx/Synopsis Design Compiler

---
