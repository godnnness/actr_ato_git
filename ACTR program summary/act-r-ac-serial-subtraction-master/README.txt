---------------------------------------------------------------
This is the README for the ACT-R/A/C Serial Subtraction model
---------------------------------------------------------------

Send comments and bug reports to Isaac Councill <igc2@psu.edu>
revised 16 nov 02

--------------------------------------------------------------

What you need to run this model

   a. Unix or Macintosh computer
   
      This model does not run in Windows, yet.  This may change
      soon if Garnet is successfully ported to the Windows environment.

   b. Lisp interpreter

      I use CMUCL 18c on Solaris and Mac Common Lisp 4.3 on Macintosh.
      The only limiting factor on what Lisp you can use (that I am aware of)
      is that it must be able to interface with Garnet.
          With MCL, you might need to increase the amount of memory that 
      MCL claims at startup.  You can do this by right-clicking on the MCL
      icon (the real one, not an alias), and selecting "Get Info" --> "Memory" 
      from the list of options (make sure that MCL is not running).  I found
      setting the minimum size to 18000 K and the preferred size to 20000 K
      worked just fine (you may not need that much).  

   c. Garnet GUI library

      Go to http://www-2.cs.cmu.edu/Groups/garnet/ for instructions
      related to obtaining and setting up Garnet.

   d. ACT-R 4.0

      Available from http://act.psy.cmu.edu/ACT-R_4.0/

   e. The model files

      Here is an inventory list of the ACT-R/A/C files:

      sub-model.lisp
      sub-functions.lisp
      script-functions.lisp
      overlay.lisp
      sub-gui.lisp
      sub-loader.lisp

      The files ACT-R_AC.tar.gz (for Unix) and ACT-R_AC.sit (for Mac)
      contain all the necessary files.

--------------------------------------------------------------

Configuring the model for your environment

   Before running the model, you must first edit the paths in
      the sub-loader.lisp file. Set the ACT-R 4.0, Garnet, and model
      directory paths to the appropriate values.

--------------------------------------------------------------

To Load

   Load the file sub-loader.lisp from the Lisp listener

     example:  * (load "sub-loader")

--------------------------------------------------------------

Documentation

   For an explanation of the interface, and a more detailed
      discussion of the model in general, see the html documentation
      in the docs directory.

--------------------------------------------------------------

Note

   The performance of this program varies greatly depending
      on the Lisp used.  As the program is configured primarily
      for use within Solaris/CMUCL, when the model is run within 
      Mac Common Lisp the speed of execution drastically reduces
      the usefulness of the chunk matrix.  Model performace can be 
      slowed by editing the check-delay global variable at the top
      of the sub-functions.lisp file.

--------------------------------------------------------------
