;;;
;;;     ACT-R/A/C Overlay
;;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Author: Isaac Councill
;;;      igc2@psu.edu
;;;    Created: 11-14-01
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;

(in-package :user)

;;;	i.	Preamble
;;;	I.	Pre-task appraisal effects
;;; 	II.	Post-task appraisal
;;;	III.	Caffeine
;;; 	IV.	Document overlay on *features*

;;;
;;;	i.	Preamble
;;;

;;; This file works with ACT-R 4.0 running under MCL 4.3
;;; and cmucl (tested).

;;; This file contains the code for the overlay
;;; of pre- and post-task appraisals, as well as
;;; for the simple caffeine interaction.

;;; Should be loaded before model file.

;; clear everything out of ACT-R
(clear-all)

;;;
;;;	I.	Pre-task appraisal effects
;;;

;; Note on parameters:
;; The only parameter that changes between the Threat
;; and Challenge conditions is Expected Gain Noise (EGS).
;; In the Threat condition, EGS increases, causing the model
;; to choose worse strategies.


(defparameter similarity-spread 0.6
    "This sets the similarity spread value for inter-chunk similarities
regarding the number chunks (number_*).  See the sub-funtions.lisp
file for details regarding how to use it.")


;; The following function is called at the beginning of
;; the sub-model.lisp file.

(defun Pre-Appraise ()
  (cond
   ((equal *appraisal-marker* "Threat") (sgp 
			                                         :G 20.0     ; Goal Value 
			                                         :GA 1.0    ; Goal Activation
			                                         :ANS 0.011   ; Chunk Activation Noise
                                                                 :PM T     ; Partial Matching
                                                                 :MP 3.7           ; Mismatch Penalty
			                                         :PAN NIL   ; Permanent Activation Noise
					                         :EGS 1.0   ; Expected Gain Noise
					                         :BLC 0.0   ; Base Level Constant
					                         :ERA T     ; Enable Rational Analysis
					                         :ER T      ; Enable Randomness
					                         :RT -0.12    ; Retrieval Threshold
                                                                 :DAT 0.04  ; Default Action Time
					                         :LF 0.04)) ; Latency Factor
   ((equal *appraisal-marker* "Challenge") (sgp 
					                              :G 20.0
					                              :GA 1.0
					                              :ANS 0.011
                                                                      :PM T
                                                                      :MP 3.7
					                              :PAN NIL
					                              :EGS 0.05
					                              :BLC 0.0
					                              :ERA T
					                              :ER T
					                              :RT -0.12
                                                                      :DAT 0.035
					                              :LF 0.04))

   ;; The neutral condition has all default ACT-R parameters
   ;; except the latency factor, which is constant across all
   ;; conditions, and EGS, ERA, and ER, which allow both 
   ;; the subtraction fact and counting subtraction strategies
   ;; to fire during model runs.

   ((equal *appraisal-marker* "Neutral") (sgp 
					                          :G 20.0
					                          :GA 1.0
					                          :ANS NIL
                                                                  :PM NIL
                                                                  :MP 1.5
					                          :PAN NIL
					                          :EGS 0.1
					                          :BLC 0.0
					                          :ERA T
					                          :ER T
					                          :RT NIL
                                                                  :DAT 0.05
					                          :LF 0.04))))


;;;
;;; 	II.	Post-task appraisal
;;;

;; This is where caffeine has its effect for now.
;; The cumulative effects of the post task appraisal
;; over 4 scripted runs leads to statistically
;; significant changes in average performance - 
;; the average performance over the 4 four-minute 
;; runs is what currently gives the model predictive power.

;; It should be noted that appraisal is not continuous.
;; That is, appraisals are not made dynamically during
;; model runs, but only at the beginning and end of a run.
;; This mechanism is not intended to be psychologically
;; plausible, but represents a first step towards the
;; inclusion of a plausible appraisal mechanism within
;; the ACT-R architecture.


;; The following function is called at the end of each
;; model run.

(Defvar *Postapp* nil)

(Defun post-appraise ()
     (get-caff-effect)
     (get-no-wrong-req)
     (Review-Performance)
     (S-Value Post-App-Text :String *postapp*)
     (opal:update appraisal))

;; The post-appraisal mechanism works through an interaction
;; between the model's caffeine level and the number of errors
;; made during the task.  We must first set a "number wrong"
;; limit, based on a percentage of total subtraction attempts,
;; that will determine the requirements for a "threatened"
;; or "challenged" post-task appraisal.

;; The "number wrong percentage" is here set to 10 percent.

(defvar *no-wrong-percent*)
(setf *no-wrong-percent* 0.1)

;; The following is a function to translate the percentage
;; into a concrete limit.

(defvar *no-wrong-limit*)
(defun get-no-wrong-req ()
    (setf *no-wrong-limit* (* *no-wrong-percent* *raw-count*)))

;; The following function modulates the actual number wrong
;; by multiplying it by the caffeine effect, discussed later.
;; The number resulting from this interaction represents the
;; "perceived" error rate of the model.  This perceived rate is
;; then compared with the "number wrong limit", resulting in an
;; appraisal.

(defun review-performance ()
    (cond
      ((>= (* *caf-effect* *no-wrong*) *no-wrong-limit*) 
        (setf *postapp* "Threat"))
      ((< (* *caf-effect* *no-wrong*) *no-wrong-limit*) 
        (setf *postapp* "Challenge"))
      (t (format t "Error in Post-Appraisal mechanism"))))


;;;
;;;	III.	Caffeine
;;;

;; Interaction at present is based only on level of caffeine, not the
;; physiology, per se.  We would like this to change as more clarity emerges
;; from collaboration between cognitive scientists and the physiological
;; psychology community regarding correlations between patterns of
;; physiology and cognitive performance.
;;
;; To avoid any confusion, the physiology windows displaying the model's
;; heart rate, pre-ejection period, and cardiac output have been eliminated
;; from the current public release of this model.

(defvar *caf-effect* 2)


;; This function creates an inverted u shaped curve
;; in the average script performance, so that average
;; performace increases as the model approaches a optimum
;; caffeine level (~500 mg), and decreases thereafter.

;; "caf :value" is defined on the user interface as the
;; value of the caffeine slider.

(defun get-caff-effect ()
    (setf *caf-effect* (gv caf :value))
    (if (<= *caf-effect* 300)
       (setf *caf-effect* (- 2 (/ *caf-effect* 300)))
       (setf *caf-effect* (/ *caf-effect* 300))))

;;;
;;; 	IV.	Document overlay on *features*
;;;

(push :AC-overlay *features*)
(push :AC-overlay1.0 *features*)

