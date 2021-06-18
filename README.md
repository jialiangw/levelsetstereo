# Let Set Stereo for Coorperative Grouping with Occlusion

Localizing stereo boundaries is difficult because matching cues are absent in the occluded regions that are adjacent to them. 
We introduce an energy and level-set optimizer that improves boundaries by encoding the essential geometry of occlusions: 
The spatial extent of an occlusion must equal the amplitude of the disparity jump that causes it. 
In a collection of figure-ground scenes from Middlebury and Falling Things stereo datasets, 
the model provides more accurate boundaries than previous occlusion-handling techniques. 

The paper has been accepted to the International Conference on Image Processing (ICIP), 2021

[[arXiv]](https://arxiv.org/pdf/2006.16094.pdf) <br /><br />

### Directory Layout


    .
    ├── results                 # Folder to store results
    ├── stereo_test_images      # Test scenes used in the paper, from Middlebury and Falling Things datasets
    ├── optimization.m          # The alternating descent update rules described in the paper
    ├── main.m                  # The main script
    ├── utils                   # Tools and utilities
    └── README.md

<br />

### Getting Started
run `main.m`

Change `stereo_ind` in `main.m` for a different test scene (1-15)  <br /> <br />


### Environment Tested
MATLAB_R2019b and Mac OS version 11.4.  <br /><br />


### Testing Scenes and References
The testing scenes used in our paper come from the Middlebury 2006 dataset and the Falling Things dataset.
Please cite the appropriate papers in below:

Middlebury 2006:

* D. Scharstein and C. Pal. Learning conditional random fields for stereo, CVPR 2007.

* H. Hirschmüller and D. Scharstein. Evaluation of cost functions for stereo matching, CVPR 2007.

Falling Things:

* J. Tremblay, T. To and S. Birchfield. Falling Things: A Synthetic Dataset for 3D Object Detection and Pose Estimation, CVPR Workshop, 2018 

<br />

### Citation:

```
@article{wang2020level,
  title={Level Set Stereo for Cooperative Grouping with Occlusion},
  author={Wang, Jialiang and Zickler, Todd},
  journal={arXiv preprint arXiv:2006.16094},
  year={2020}
```

