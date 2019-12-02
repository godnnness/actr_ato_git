;;; 
;;;           ACT-R/A/C Functions
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 
;;;          Author: Isaac Councill
;;;              igc2@psu.edu
;;;            Created: 10/14/01 
;;;            Revised: 18/11/02
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; This file is a general function library
;;; for the ACT-R/AC serial subtraction model.
;;;

;;;;;; Table of Contents
;;;
;;;   i. Declare Some Global Variables - User settable
;;;  ii. Declare Some Global Variables - User usable
;;; iii. Interface Functions
;;;  iv. Macro for Chunk Similarity Setting
;;;


(in-package :user)

;;;
;;;   i. Declare Some Global Variables - User settable
;;;

;; these variables are designed to be user settable

(defvar check-delay nil
    "This sets the delay for displaying right/wrong check marks 
over the model's answer - set to nil for scripting speed, 0.1 is 
adequate for viewing the model's performance as it runs.")

(defparameter *run-time* "0"
    "This keeps track of the elapsed time, as a string.")

(defvar *stop-time* 240 
    "This variable determines how long each run will last, in seconds.")

;;;
;;;  ii. Declare Some Global Variables - User usable
;;;

;; these variables should generally not be modified by users, but are
;; helpful to have around for reports, GAs, scripts, and so on

(defvar run-history nil 
    "This can be used to determine whether the model is being scripted.")

(defparameter *answer* "6153"
    "This holds the current subtraction answer.")

(defvar *raw-count* 0 
    "This integer notes how many subtractions the model has made.")

(defparameter *count* "0"
    "This keeps track of how many subtraction the model has made, as a string.")

(defvar *appraisal-marker* "Neutral" 
    "This contains the model's current task appraisal.")

(defvar *worry-marker* nil 
    "This variable marks whether or not the model is worried.")


;;;
;;; iii. Interface Functions
;;;

;; Process single-column answers and return quoted answer -
;; this is to obtain compatibility with interface display

(defun proc-ans (str digit var)
    (let ((newvar (proc-var var))
            (newstr (copy-seq str)))
       (setf (char newstr digit) newvar)
       (setf *answer* newstr)
       *answer*))

(defun proc-var (var)
    (cond
      ((equal var 'number_0) #\0)
      ((equal var 'number_1) #\1)
      ((equal var 'number_2) #\2)
      ((equal var 'number_3) #\3)
      ((equal var 'number_4) #\4)
      ((equal var 'number_5) #\5)
      ((equal var 'number_6) #\6)
      ((equal var 'number_7) #\7)
      ((equal var 'number_8) #\8)
      ((equal var 'number_9) #\9)
      (t (format t 
                       "Argument to proc-var must be symbol number_0 through number_9~%")
          (format t "~%Given ~A, returning #\0.~%" var)
          (sleep 2)
          (check-answer)
          (return-from proc-var #\0))))


;; General parameter trackers

(defun att-counter ()
    (setf *raw-count* (+ *raw-count* 1))
    (setf *count* (write-to-string *raw-count*)))

(defun timer ()
    (setf *run-time* (format nil "~,2F" *time*)))

;; Set the stop-time from user input

(defun set-stop-time ()
    (setf *stop-time* (with-input-from-string
		                      (s (gv stop-time :txt :string))
		                      (read s))))


;; Updating the Garnet interface

(defun update-interface (num)
    (proc-ans *answer* 0 num)
    (update-ans)
    (att-counter)
    (update-count)
    (timer)
    (update-time)
    (opal:update behavior))

; NOTE: The following functions may seem unnecessarily inefficient.
;       Their structure is required to get around a bug in the 
;       Garnet update function under Unix.

; All updates are calls to objects defined in gui.lisp.

(defun update-ans ()
    (opal:remove-components behav-agg answer)
    (s-value answer :string *answer*)
    (opal:add-components behav-agg answer))

(defun update-count ()
    (opal:remove-components behav-agg noatts)
    (s-value noatts :string *count*)
    (opal:add-components behav-agg noatts))

(defun update-time ()
    (opal:remove-components behav-agg time-info)
    (s-value time-info :string *run-time*)
    (opal:add-components behav-agg time-info))

(defun update-no-wrong ()
    (opal:remove-components behav-agg noerrs)
    (s-value noerrs :string (princ-to-string *no-wrong*))
    (opal:add-components behav-agg noerrs))


;; Error-Checker Functions


(defvar units-parse nil)
(defvar tens-parse nil)
(defvar hunds-parse nil)
(defvar thous-parse nil)
(defvar *right-answer* nil)
(defvar *no-wrong* 0)

(defun get-right-answer ()
    (setf *right-answer* (- (with-input-from-string (s *answer*)
				              (read s))
			                 7)))

;; The following function checks whether the model has
;; given a correct response.  If the answer is incorrect,
;; the model is set on the right track again (the model 
;; is given the correct answer), and 4 seconds are added
;; to the time elapsed to represent time lost from the
;; process of correction.

(defun check-answer ()
    (if (equal *right-answer*
	            (with-input-from-string (s *answer*)
                         (read s)))
       (check-right)
       (progn
           (unless no-traces (format t "~~oops..."))
           (setf *no-wrong* (1+ *no-wrong*))
           (update-no-wrong)
           (check-wrong)
           (setf *answer* (princ-to-string *right-answer*))
           (actr-time 4)
           (parse-answer)
           (goal-focus reset-goal))))

(defun parse-answer ()
    (setf units-parse (r-proc-ans 
		                 (princ-to-string (char *answer* 3))))
    (setf tens-parse (r-proc-ans 
		                (princ-to-string (char *answer* 2))))
    (setf hunds-parse (r-proc-ans 
		                   (princ-to-string (char *answer* 1))))
    (setf thous-parse (r-proc-ans 
		                  (princ-to-string (char *answer* 0)))))

(defun r-proc-ans (sym)
    (cond
      ((equal sym "0") 'number_0)
      ((equal sym "1") 'number_1)
      ((equal sym "2") 'number_2)
      ((equal sym "3") 'number_3)
      ((equal sym "4") 'number_4)
      ((equal sym "5") 'number_5)
      ((equal sym "6") 'number_6)
      ((equal sym "7") 'number_7)
      ((equal sym "8") 'number_8)
      ((equal sym "9") 'number_9)
      (t (format t "Number outside range or not in quote"))))

;;; Interface Answer-Check

(defun check-wrong ()
    (s-value ex-line1 :visible t)
    (s-value ex-line2 :visible t)
    (opal:update behavior)
    (if check-delay 
       (sleep check-delay))
    (s-value ex-line1 :visible nil)
    (s-value ex-line2 :visible nil)
    (opal:update behavior))

(defun check-right ()
    (s-value chk-line1 :visible t)
    (s-value chk-line2 :visible t)
    (opal:update behavior)
    (if check-delay
       (sleep check-delay))
    (s-value chk-line1 :visible nil)
    (s-value chk-line2 :visible nil)
    (opal:update behavior))

;; Worry Indicator

(defun worry-light ()
    (s-value wor-indic :filling-style opal:red-fill)
    (opal:update behavior)
    (if check-delay (sleep check-delay))
    (s-value wor-indic :filling-style opal:motif-blue-fill)
    (opal:update behavior))

(defun model-reset ()
    (load (merge-pathnames *model-dir* "overlay"))
    (load (merge-pathnames *model-dir* "sub-model"))
    (setf *answer* "6153")
    (setf *raw-count* 0)
    (setf *count* "0")
    (setf *no-wrong* 0)
    (s-value noerrs :string "0")
    (setf *run-time* "0")
    (set-stop-time)
    (hide-highlight)
    (update-ans)
    (update-count)
    (update-time)
    (s-value pre-app-text :string *appraisal-marker*)
    (s-value post-app-text :string "")
    (update-all)
    (opal:update script-win))

(defun update-all ()
    (opal:update behavior)
    (opal:update appraisal)
    (opal:update script-win)
    (opal:update control))

(defun script-reset ()
    (s-value pre1-text :string "")
    (s-value post1-text :string "")
    (s-value att1-text :string "")
    (s-value err1-text :string "")
    
    (s-value pre2-text :string "")
    (s-value post2-text :string "")
    (s-value att2-text :string "")
    (s-value err2-text :string "")
    
    (s-value pre3-text :string "")
    (s-value post3-text :string "")
    (s-value att3-text :string "")
    (s-value err3-text :string "")
    
    (s-value pre4-text :string "")
    (s-value post4-text :string "")
    (s-value att4-text :string "")
    (s-value err4-text :string "")
    
    (opal:update script-win))

;; Hook Functions

(defun setup-hook-functions ()
    "Config hook functions"
    (setf *cycle-hook-fn* 'cycle-hook-fn))

(defun cycle-hook-fn (&optional instantiation)
    "Call this function after each cycle with the instantiation fired."
    (if (null instantiation)
       (progn
           (unless no-traces
               (format t "~%Model:   I forgot the number that I was working on!~%")
               (format t "~%Experimenter:   The number that you were on was ~A.~%~%" 
                            (read-from-string *answer*)))
           (check-answer))           
       (progn
           (timer)
           (update-time)
           (opal:update behavior))))

(setf *init-hook-fn* 'setup-hook-functions)


;;;
;;; iv. Macro for Chunk Similarity Setting
;;;

;; Called after the add-dm command in model file.


(defmacro set-chunk-similarity-values (spread)

    "Sets a ripple of similarity values among chunks encoding numbers and 
subtraction facts- the similarity values range from 0 to the number given as 
an argument, with the closest numbers getting the highest similarity value."

    (format t "~%~%Setting chunk similarities...")
    (let ((spread-unit (/ spread 10)))

       ; First, set the similarities among chunks number_0 through number_9

       (do ((x 0 (+ x 1)))
              ((> x 9))
           (do ((y 0 (+ y 1)))
                  ((> y 9))
               (if (> y x)
                  (let ((chunk-i (read-from-string 
                                          (concatenate 'string "number_" (princ-to-string x))))
                          (chunk-j (read-from-string 
                                          (concatenate 'string "number_" (princ-to-string y))))
		          (sim-value (* (- 11 (abs (- x y))) spread-unit)))
                     (eval `(set-similarities (,chunk-i ,chunk-j ,sim-value)))))))

       ; Now, set the similarities among chunks number_10 through number_19

       (do ((x 10 (+ x 1)))
              ((> x 19))
           (do ((y 10 (+ y 1)))
                  ((> y 19))
               (if (> y x)
                  (let ((chunk-i (read-from-string 
                                          (concatenate 'string "number_" (princ-to-string x))))
                          (chunk-j (read-from-string 
                                          (concatenate 'string "number_" (princ-to-string y))))
		          (sim-value (* (- 11 (abs (- x y))) spread-unit)))
                     (eval `(set-similarities (,chunk-i ,chunk-j ,sim-value))))))))

     ; Reset spread-unit for the next two tiers
    
    (let ((spread-unit (/ spread 20)))
       
        ; Set similarities among chunks SF7-7 through SF19-7

       (do ((x 7 (+ x 1)))
	      ((> x 19))
           (do ((y 8 (+ y 1)))
	          ((> y 19))
	       (if (> y x)
	          (let ((chunk-i (read-from-string 
			                  (concatenate 'string "SF" (princ-to-string x) "-7")))
		          (chunk-j (read-from-string 
			                  (concatenate 'string "SF" (princ-to-string y) "-7")))
		          (sim-value (* (- 21 (abs (- x y))) spread-unit)))
	             (eval `(set-similarities (,chunk-i ,chunk-j ,sim-value)))))))
       
        ; Set similarities for chunks SF1-1 through SF19-1

       (do ((x 1 (+ x 1)))
	      ((> x 19))
           (do ((y 2 (+ y 1)))
	          ((> y 19))
	       (if (> y 2)
	          (let ((chunk-i (read-from-string 
			                  (concatenate 'string "SF" (princ-to-string y) "-1")))
		          (chunk-j (read-from-string 
			                  (concatenate 'string "SF" (princ-to-string y) "-1")))
		          (sim-value (* (- 21 (abs (- x y))) spread-unit)))
	             (eval `(set-similarities (,chunk-i ,chunk-j ,sim-value))))))))
    
    (format t "Done~%~%"))


