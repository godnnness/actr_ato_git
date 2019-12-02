;;;
;;;  ACT-R/A/C Serial Subtraction Loader
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;       Author: Isaac Councill
;;;           igc2@psu.edu
;;;         Created: 11/14/01 
;;;       revised 21 oct 02 -FER
;;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; This file loads all of the necessary
;;; files to run the ACT-R/AC serial
;;; subtraction model.
;;;
;;; Simply set the required paths below, and then
;;; load this file from the lisp listener.
;;;
;;;
;;;;; SET THESE PATHS TO REFLECT YOUR LOCAL ENVIRONMENT ;;;;;

;; Note that you must enter a directory separator character
;; at the end of these paths.  For example, a pathname should
;; look like "HD:Applications:Model Dir:" (on Mac) or
;; "/usr/local/model_dir/" (on Unix).  Notice the extra : or /
;; at the end of the path strings.

;; load CLX, if necessary (not required with MCL)
#+:UNIX (load "library:subsystems/clx-library")  

;; model directory
(defvar *model-dir*  "/path/to/ACT-R_AC/")       ;; SET THIS 

;; path to "garnet-loader.lisp"
(load "/path/to/garnet-loader.lisp")             ;; SET THIS

;; path to ACT-R 4.0
#-:act-r (load  "/path/to/act-r.lisp")           ;; SET THIS
(push :act-r *features*)

;;;;;;;;;;;;;;;; END REQUIRED MODIFICATIONS ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; These settings might speed up your cmucl.
(setf *gc-verbose* nil)
(setf *byte-consed-between-gcs* 16777216) ;; 16Mb

;; Load some needed Garnet components.
(dolist (file '("motif-radio-buttons-loader"
		     "motif-check-buttons-loader"
		     "motif-text-buttons-loader"
		     "motif-menubar-loader"
		     "h-slider-loader"))
    (user::garnet-load (concatenate 'string "gadgets:" file))))


;;; Load ACT-R/A/C model

(load (merge-pathnames *model-dir* "sub-functions.lisp"))
(load (merge-pathnames *model-dir* "sub-gui.lisp"))
(load (merge-pathnames *model-dir* "overlay.lisp"))
(load (merge-pathnames *model-dir* "sub-model.lisp"))
(load (merge-pathnames *model-dir* "script-functions.lisp"))

