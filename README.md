# Neural network-based battery life prediction model
## Source
https://www.sciencedirect.com/science/article/pii/S0026271417304894

## Introduction
### Objective
This work applies thermography (Thermal infrared imaging) on different kinds of batteries to predict remaining useful life of them (how much time this battery can sustain before its capacity fades to a certain level). The objective is to correlate the initial several minutes of battery surface temperature data to its current cycle life number, or to answer the question, is the tested battery on its 1st, 10th, or 100th cycle?
### Theoretical background
With the continuous charging-discharging of the battery, it would start to age—a series of electrochemistry reactions happened inside of it, causing a capacity fade and gradually increasing of heat generation. So it could be possible to correlate the surface heat signal to its remaining useful life. 

## Algorithm description
![alt text](https://github.com/zhouxf53/Battery-life-estimation/blob/master/fig3.jpg)

## Usage
The program was written in both MATLAB and python, pick **either one** you like. An example of the raw data is stored in [Dropbox link](https://www.dropbox.com/s/txkvwzbc5zy3qkt/datafile.asc?dl=0). 

Double check the raw data file name before run the program.
- For MATLAB, you need neural network, statistical toolboxes
- For python, you need Pandas, tensorflow, keras, scipy, and numpy.

## Citation
If this algorithm is useful for your research, please cite our paper.
