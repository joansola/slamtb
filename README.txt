SLAM Toolbox for Matlab.
========================

This git repository provides EKF-SLAM and graph-SLAM toolboxes.


I. Copyright and license.
=========================
(c) 2007, 2008, 2009, 2010  Joan Sola  @ LAAS-CNRS; 
(c) 2010, 2011, 2012, 2013  Joan Sola
(c) 2014, 2015, 2016        Joan Sola  @ IRI-UPC-CSIC; 
(c) 2009  Joan Sola, David Marquez, Jean Marie Codol,
          Aurelien Gonzalez and Teresa Vidal-Calleja, @ LAAS-CNRS; 

Maintained by Joan Sola
Please write feedback, suggestions and bugs to:

    jsola@iri.upc.edu

or use the GitHub web tools.

Published under GPL license. See COPYING.txt. 


II. Giving credit
=================

In addition to the GPL license, users should consider, in their scientific 
communications :

A. acknowledging the use of this toolbox.

B. citing one of the papers of the authors: 

  - SOLA-ETAL-IJCV-11 "Impact of landmark parametrization on monocular EKF-SLAM with points and lines"
  - SOLA-ETAL-IROS-09 "Undelayed initialization of line segments in monocular SLAM"
  - SOLA-ETAL-TRO-08  "Fusing monocular information in multi-camera SLAM"
  - SOLA-ETAL-IROS-05 "Undelayed initialization in bearing only SLAM" 

appearing in the References section in the documentation.


III. Installation and quick usage.
==================================

To make it work, (1) open a terminal (for example, a linux terminal) and (2) start Matlab. Then follow these steps:

To use EKF-SLAM
-------------------

A. In the [Linux / MacOSX] terminal: 

  A.1. Get the source code,

        git clone git://github.com/joansola/slamtb.git

  A.2. Go to the toolbox 
        
        cd slamtb

  A.3. Select the EKF-SLAM project.

        git checkout ekf

B. In the Matlab command window:  

  B.1. Go to the toolbox 
        
        >> cd slamtb

  B.2. Add all subdirectories in slamtb/ to your Matlab path using the provided script: 
        
        >> slamrc

  B.3. Edit user data file, and enter the data of your experiment.

        >> edit userData.m.

  B.4. Run the main script
        
        >> slamtb.

  B.5. To develop methods, read first slamToolbox.pdf and guidelines.pdf. 


To use graph-SLAM
-------------------

A. In the [Linux / MacOSX] terminal: 

  A.1. Get the source code,

        git clone git://github.com/joansola/slamtb.git

  A.2. Go to the toolbox 
        
        cd slamtb

  A.3. Select the graph-SLAM project.

        git checkout graph

B. In the Matlab prompt:  

  B.1. Go to the toolbox 
        
        >> cd slamtb

  B.2. Add all subdirectories in slamtb/ to your Matlab path using the provided script: 
        
        >> slamrc

  B.3. Edit user data file, and enter the data of your experiment.

        >> edit userDataGraph.m

  B.4. Run the main script

        >> slamtb_graph

  B.5. To develop methods, read first slamToolbox.pdf and guidelines.pdf. 
     For graph-SLAM, read also courseSLAM.pdf.

Enjoy!
