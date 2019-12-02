;;
;;   script-functions.lisp
;;
;;   author:  Isaac Councill
;;   created: 1-23-02 
;;   revised: 18-11-02
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  The code found in this file allows
;;  the ACT-RAC serial subtraction model
;;  to be run in various scripting conditions
;;  as many times as your computer will
;;  allow.  Processed data is outputted
;;  to a file called data in the model
;;  directory.
;;

;;;  Table of Contents
;;;
;;;   i. Global variables
;;;   I. Script 1 Condition 
;;;   II. Script 4-Trial Blocks
;;;   III. Single 4-Trial Script
;;;   IV. Utility Functions


;;;
;;;   i. Global variables
;;;

;; First, declare some global variables

(defvar no-traces t
  "This sets all traces to nil for scripted runs.  
Set to nil if you do not want to turn off traces.")

(defvar att-vector '())
(defvar err-vector '())
(defvar att-avg)
(defvar err-avg)


;; 
(defun create-file (file-name)
  (with-open-file (ifile file-name :direction :output)
     (format ifile " ")))

;;;
;;; I. Script 1 Condition
;;;

(defun script-1-cond (str int)
  "Writes the output of each run to a temporary file,
then reads that file and outputs average data to another file."
  (let ((temp-data-file 
            (merge-pathnames *model-dir* 
                   (format nil "raw-data-~a-~a" 
                           (print-date "-") (print-time "-"))))
        (final-avg-file 
            (merge-pathnames *model-dir* 
                 (format nil "data-~a-~a" (print-date "-") (print-time "-")))))

    ;; probe file, and act according to result.
    ;;  (this should no longer happen, 25nov02 -FER
    (if (probe-file temp-data-file)
      (progn
        (if (probe-file (merge-pathnames *model-dir* "raw-data.old"))
          (delete-file (merge-pathnames *model-dir* "raw-data.old")))
        (rename-file temp-data-file "raw-data.old")
        (create-file temp-data-file))
      (create-file temp-data-file))

    ;; output model data for each run to temp file.

    (do ((x 1 (+ x 1)))
        ((> x int))
      (setf *appraisal-marker* str)
      (model-reset)
      (script-reset)
      (if no-traces (turn-off-traces))
      (run)
      (if (not (equal x int))
        (with-open-file (s temp-data-file
                           :direction :output 
                           :if-exists :append)
          (format s "~A~%" (gv noatts :string))
          (format s "~A~%" (gv noerrs :string)))
        (with-open-file (s temp-data-file
                           :direction :output 
                           :if-exists :append)
          (format s "~A~%" (gv noatts :string))
          (format s "~A~%" (gv noerrs :string))
          (format s "d"))))

    ;; read in the temp file, and compute averages.

    (setf att-vector '())
    (setf err-vector'())

    (with-open-file (s temp-data-file :direction :input)
      (let ((eof "d")
            (l1 nil)
            (l2 nil)
            (stop-flag nil))
        (if (not stop-flag)
          (read-data s eof))))
    (setf att-vector (mapcar #'read-from-string att-vector))
    (setf err-vector (mapcar #'read-from-string err-vector))
    (setf att-avg (/ (sum-list att-vector) (length att-vector)))
    (setf err-avg (/ (sum-list err-vector) (length err-vector)))

    ;; Probe for final data file.

    (if (probe-file final-avg-file)
      (progn
        (if (probe-file (merge-pathnames *model-dir* "data.old"))
          (delete-file (merge-pathnames *model-dir* "data.old")))
        (rename-file final-avg-file "data.old")
        (create-file final-avg-file))
      (create-file final-avg-file))

    ;; Write final output to data file.

    (with-open-file (s final-avg-file :direction :output
                       :if-exists :append)
      (format s "~%Model Data File for Script")
      (format s "~%~%Created on ~A" (read-from-string (print-date)))
      (format s "~%~%All runs in condition ~A" 
              (read-from-string str))
      (format s "~%Number of runs: ~A" int)
      (format s "~%~%Caffeine level: ~A" (gv caf :value))
      (format s "~%~%Worry ~A" (check-for-worry))
      (write-parameters s str)
      (format s "~%Average number of attempts:  ~,2F" att-avg)
      (format s "     SD: ~,2F" (get-standard-dev att-vector))
      (format s "~%Average number of errors:    ~,2F" err-avg)
      (format s "     SD: ~,2F" (get-standard-dev err-vector)))
    (format t "~%~%Output available in ~A~%" final-avg-file)))
                                              
;;;
;;; II.  Script 4-trial Blocks
;;;

(defvar threat-count)
(defvar chall-count)
(defvar cycle-caffeine nil)

(defun script-4-trials (str int)
  "This scripts the model in 4-trial blocks, in order
to simulate the Tomaka et al. experiment."
   (setf threat-count 0)
   (setf chall-count 0)
   (let ((temp-data-file (merge-pathnames *model-dir* "raw-data"))
        (final-avg-file (merge-pathnames *model-dir* "data")))

    ;; probe files, and act according to result.
     
     (if (probe-file temp-data-file)
      (progn
        (if (probe-file (merge-pathnames *model-dir* "raw-data.old"))
          (delete-file (merge-pathnames *model-dir* "raw-data.old")))
        (rename-file temp-data-file "raw-data.old")
        (create-file temp-data-file))
      (create-file temp-data-file))

    ;; output model data for each run to temp file.

    (do ((x 1 (+ x 1)))
        ((> x int))
      (setf *appraisal-marker* str)
      (model-reset)
      (script-reset)
      (if no-traces (turn-off-traces))

      ;; single 4-trial script

            (do ((i 1 (+ i 1)))
                   ((> i 4) 'Script_Done)
                (run)

        ;; enter data
      
        (if (or (not (equal i 4)) (not (equal x int)))
          (with-open-file (s temp-data-file
                             :direction :output 
                             :if-exists :append)
            (format s "~A~%" (gv noatts :string))
            (format s "~A~%" (gv noerrs :string)))
          (with-open-file (s temp-data-file
                             :direction :output 
                             :if-exists :append)
            (format s "~A~%" (gv noatts :string))
            (format s "~A~%" (gv noerrs :string))
            (format s "d")))

        ;; Remember how many pre-task appraisals of each type.

        (let ((pre-app (gv pre-app-text :string)))
          (cond
           ((equal pre-app "Threat") (incf threat-count))
           ((equal pre-app "Challenge") (incf chall-count))))

        ;; set up for next run in 4-trial block

                (setf *appraisal-marker* (gv post-app-text :string))
                (s-value pre-app-text :string *appraisal-marker*)
                (model-reset)
                (setf script-history 0)
                (if no-traces (turn-off-traces))))

    ;; read in the temp file, and compute averages.

    (setf att-vector '())
    (setf err-vector'())

    (with-open-file (s temp-data-file :direction :input)
      (let ((eof "d")
            (l1 nil)
            (l2 nil)
            (stop-flag nil))
        (if (not stop-flag)
          (read-data s eof))))

    ;; break-to-fours compiles the raw data into
    ;; groups of four to keep the 4-trial blocks intact

    (setf att-vector (break-to-fours 
                      (mapcar #'read-from-string att-vector)))
    (setf err-vector (break-to-fours 
                      (mapcar #'read-from-string err-vector)))
    (setf att-avg (/ (sum-list att-vector) 
                     (length att-vector)))
    (setf err-avg (/ (sum-list err-vector) 
                     (length err-vector)))

    ;; Probe for final data file.

    (if (probe-file final-avg-file)
      (progn
        (if (probe-file (merge-pathnames *model-dir* "data.old"))
          (delete-file (merge-pathnames *model-dir* "data.old")))
        (rename-file final-avg-file "data.old")
        (create-file final-avg-file))
      (create-file final-avg-file))

    ;; Write final output to data file.

    (with-open-file (s final-avg-file :direction :output
                       :if-exists :append)
      (format s "~%Model Data File for Script")
      (format s "~%~%Created on ~A" (read-from-string (print-date)))
      (format s "~%~%Four-Trial Blocks - Initial Appraisal: ~A" 
              (read-from-string str))
      (format s "~%Number of runs: ~A" int)
      (format s "~%~%Caffeine level: ~A" (gv caf :value))
      (format s "~%~%Worry ~A" (check-for-worry))
      (write-parameters s str)
      (format s "~%Average number of attempts:  ~,2F" att-avg)
      (format s "     SD: ~,2F" (get-standard-dev att-vector))
      (format s "~%Average number of errors:    ~,2F" err-avg)
      (format s "     SD: ~,2F" (get-standard-dev err-vector))
      (format s "~%~%Number of runs in Threat: ~A  (~,1F%)"
              threat-count (* 100 (/ threat-count 
                                  (+ threat-count chall-count))))
      (format s "~%Number of runs in Challenge: ~A  (~,1F%)"
              chall-count (* 100 (/ chall-count 
                                 (+ threat-count chall-count)))))     
    (format t "~%~%Output available in ~A~%" final-avg-file)))

;;;
;;; III. The Single 4-trial Script Extension
;;;

(defvar script-history 0)

(defun single-4-trial-script ()
    (do ((i 1 (+ i 1)))
           ((> i 4) 'Script_Done)
        (run)
        (incf script-history)
        (enter-script-data script-history)
        (setf *appraisal-marker* (gv post-app-text :string))
        (s-value pre-app-text :string *appraisal-marker*)
        (model-reset))
    (setf script-history 0)
    (format t "~%~%DONE SCRIPTING~%"))

(defun enter-script-data (hist)
    "This macro enters data into the script window after each run."
    (cond
      ((equal hist 1)
        (if (equal (gv pre-app-text :string)
	                "Threat")
	   (s-value pre1-text :string "T")
           (if (equal (gv pre-app-text :string)
		           "Neutral")
	      (s-value pre1-text :string "N")
	      (if  (equal (gv pre-app-text :string)
		               "Challenge")
	         (s-value pre1-text :string "C"))))
        
        (if (equal (gv post-app-text :string)
	                "Threat")
	   (s-value post1-text :string "T")
           (if (equal (gv post-app-text :string)
		           "Neutral")
	      (s-value post1-text :string "N")
	      (if  (equal (gv post-app-text :string)
		               "Challenge")
	         (s-value post1-text :string "C"))))
        
        (s-value att1-text :string
	              (gv noatts :string))
        
        (s-value err1-text :string
	              (gv noerrs :string)))
      
      ((equal hist 2)
        (if (equal (gv pre-app-text :string)
	                "Threat")
	   (s-value pre2-text :string "T")
           (if (equal (gv pre-app-text :string)
		           "Neutral")
	      (s-value pre2-text :string "N")
	      (if  (equal (gv pre-app-text :string)
		               "Challenge")
	         (s-value pre2-text :string "C"))))
        
        (if (equal (gv post-app-text :string)
	                "Threat")
	   (s-value post2-text :string "T")
           (if (equal (gv post-app-text :string)
		           "Neutral")
	      (s-value post2-text :string "N")
	      (if  (equal (gv post-app-text :string)
		               "Challenge")
	         (s-value post2-text :string "C"))))
        
        (s-value att2-text :string
	              (gv noatts :string))
        
        (s-value err2-text :string
	              (gv noerrs :string)))
      
      ((equal hist 3)
        (if (equal (gv pre-app-text :string)
		        "Threat")
	   (s-value pre3-text :string "T")
           (if (equal (gv pre-app-text :string)
		           "Neutral")
	      (s-value pre3-text :string "N")
	      (if  (equal (gv pre-app-text :string)
		               "Challenge")
	         (s-value pre3-text :string "C"))))
        
        (if (equal (gv post-app-text :string)
	                "Threat")
	   (s-value post3-text :string "T")
           (if (equal (gv post-app-text :string)
		           "Neutral")
	      (s-value post3-text :string "N")
	      (if  (equal (gv post-app-text :string)
		               "Challenge")
                 (s-value post3-text :string "C"))))
        
        (s-value att3-text :string
                      (gv noatts :string))
        
        (s-value err3-text :string
                      (gv noerrs :string)))
      
      ((equal hist 4)
        (if (equal (gv pre-app-text :string)
	                "Threat")
	   (s-value pre4-text :string "T")
           (if (equal (gv pre-app-text :string)
		           "Neutral")
	      (s-value pre4-text :string "N")
	      (if  (equal (gv pre-app-text :string)
		               "Challenge")
	         (s-value pre4-text :string "C"))))
        
        (if (equal (gv post-app-text :string)
	                "Threat")
	   (s-value post4-text :string "T")
           (if (equal (gv post-app-text :string)
		           "Neutral")
	      (s-value post4-text :string "N")
	      (if  (equal (gv post-app-text :string)
		               "Challenge")
	         (s-value post4-text :string "C"))))
        
        (s-value att4-text :string
	              (gv noatts :string))
        
        (s-value err4-text :string
	              (gv noerrs :string)))))


;;;
;;; IV.  Utility Functions
;;;

(defun read-data (str end)
  "Reads input from a file stream line by line and 
pushes even and odd results into separate vectors."
  (setf l1 (read-line str nil end))
  (setf l2 (read-line str nil end))
  (if (not (or (equal l1 end) 
               (equal l2 end)))
    (progn
      (push l1 att-vector)
      (push l2 err-vector)
      (read-data str end))
    (setf stop-flag t)))

(defun sum-list (list)
  "Adds the elements of a list of numbers together and returns the result."
  (let ((sum 0))
    (mapcar (lambda (x) (incf sum x)) list)
    sum))

(defun get-standard-dev (list)
  "Returns the standard deviation of a list of numbers."
  (let ((mean (/ (sum-list list) (length list))))
    (let ((diff-list (mapcar (lambda (x) (- x mean)) list)))
      (let ((ss (sum-list (mapcar (lambda (x) (* x x)) diff-list))))
        (sqrt (/ ss (- (length list) 1)))))))

(defun write-parameters (s str)
  "Writes out the parameter settings of the model to stream s."
  (setf *appraisal-marker* str)
  (let ((param-list (pre-appraise)))
    (let ((G (nth 0 param-list))
          (GA (nth 1 param-list))
          (ANS (nth 2 param-list))
          (PM (nth 3 param-list))
          (MP (nth 4 param-list))
          (PAN (nth 5 param-list))
          (EGS (nth 6 param-list))
          (BLC (nth 7 param-list))
          (ERA (nth 8 param-list))
          (ER (nth 9 param-list))
          (RT (nth 10 param-list))
          (DAT (nth 11 param-list))
          (LF (nth 12 param-list)))
      (format s "~%~%PARAMETER SETTINGS")
      (format s "~%~%G ~A" G)
      (format s "~%GA ~A" GA)
      (format s "~%ANS ~A" ANS)
      (format s "~%PM ~A" PM)
      (format s "~%MP ~A" MP)
      (format s "~%PAN ~A" PAN)
      (format s "~%EGS ~A" EGS)
      (format s "~%BLC ~A" BLC)
      (format s "~%ERA ~A" ERA)
      (format s "~%ER ~A" ER)
      (format s "~%RT ~A" RT)
      (format s "~%DAT ~A" DAT)
      (format s "~%LF ~A" LF)
      (format s "~%~%"))))

(defun turn-off-traces ()
  "This turns off all of the default ACT-R traces. 
By doing this the scripts are sped up considerably." 
  (sgp :pct nil
       :ct nil
       :lt nil
       :ot nil
       :v nil))

(defun print-date (&optional (sep "/"))
  "Prints out the current date as month/day/year."
  (multiple-value-bind (sec min hr day mon yr) (get-decoded-time)
    (declare (ignore sec min hr))
    (format nil "~A~a~A~a~A" mon sep day sep yr)))

(defun print-time (&optional (sep "/"))
  "Prints out the current time as hr/min/sec."
  (multiple-value-bind (sec min hr day mon yr) (get-decoded-time)
    (declare (ignore day mon yr))
    (format nil "~A~a~A~a~A" hr sep min sep sec)))


(defmacro while (test &body body)
  "A good old-fashioned while loop.  I couldn't do without one."
  `(do ()
       ((not ,test))
     ,@body))

(defun break-to-fours (list)
  "This function takes in a list of individual data 
points, groups them into fours, and averages the groups."
  (let ((new-list '()))
    (while list
      (let ((temp-list '()))
        (do ((i 1 (+ i 1)))
            ((> i 4))
          (push (car list) temp-list)
          (pop list))
        (push-last (sum-list temp-list) new-list)))
    (mapcar (lambda (x) (/ x 4)) new-list)))

(defun check-for-worry ()
  "Returns ON if on, OFF if off."
  (if (gv wor-chk :value)
    'ON 'OFF))
