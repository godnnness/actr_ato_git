;;;
;;;     ACT-R/A/C Graphical Interface
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;        Author: Isaac Councill
;;;            igc2@psu.edu
;;;          Created: 09/10/01
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; This is the graphical user interface for
;;; the ACT-R/AC serial subtraction model.
;;;

;;; Credit due to Jason Cornwell for prototyping the chunk matrix,
;;; and Roman Belavkin for the trace control window and functions.

;;;;;; Table of Contents
;;;
;;;   	i. 	Model Behavior Window
;;;  	ii. 	Appraisal Window
;;;	iii. 	Control Window
;;;	iv.	Roman's trace control
;;;  	v. 	Script Data Window
;;; 	vi.	Conjure the windows

;; At the end of the file, all windows are created and displayed.


;;;
;;; i. 	The Model Behavior Window
;;;

;; This window displays the current number that the
;; the model is subtracting from, the number of subtraction
;; attempts, number of errors, the current time
;; elapsed since the start of the run, and an indicator
;; that displays when the model is worrying about something,
;; if the worry feature is enabled.  Also displayed
;; is the current numeric chunk that the model has in
;; working memory. 

(create-instance 'behavior inter:interactor-window
                          (:height 243)
                          (:width 262)
                          (:top 129)
                          (:left 520)
                          (:background-color opal:motif-light-gray)
                          (:title "Model Behavior"))

(create-instance 'behav-agg opal:aggregate)
(s-value behavior :aggregate behav-agg)

;; Answer box

(create-instance 'model-box opal:rectangle
                          (:width 100)
                          (:height 60)
                          (:top 30)
                          (:left 20)
                          (:filling-style opal:white-fill))

(create-instance 'model-text opal:text
                 (:top 15)
                 (:left (o-formula (+ (gv model-box :left)
                                      (- (round (gv model-box :width) 2)
                                         (round (gvl :width) 2)))))
                          (:string "Current Number"))

(opal:add-components behav-agg model-text)
(opal:add-components behav-agg model-box)

(create-instance 'answer-font opal:font
                          (:size :very-large))

(create-instance 'large opal:font
		          (:size :large))

(create-instance 'answer opal:text
                          (:top 47)
                          (:font answer-font)
                          (:string *answer*)
                          (:left 41))
(opal:add-components behav-agg answer)

;; Answer-Check

; Wrong Answer

(create-instance 'ex opal:aggregate
		          (:top 10)
		          (:left 100))

(create-instance 'ex-line1 opal:line
		          (:x1 57)
		          (:y1 47)
		          (:x2 82)
		          (:y2 72)
		          (:line-style opal:red-line)
		          (:visible nil))

(create-instance 'ex-line2 opal:line
		          (:x1 57)
		          (:y1 72)
		          (:x2 82)
		          (:y2 47)
		          (:line-style opal:red-line)
		          (:visible nil))

(opal:add-component ex ex-line1)
(opal:add-component ex ex-line2)

(opal:add-component behav-agg ex)

; Right Answer

(create-instance 'check opal:aggregate)

(create-instance 'chk-line1 opal:line
		          (:x1 93)
		          (:y1 43)
		          (:x2 100)
		          (:y2 55)
		          (:line-style opal:blue-line)
		          (:visible nil))

(create-instance 'chk-line2 opal:line
		          (:x1 100)
		          (:y1 55)
		          (:x2 110)
		          (:y2 35)
		          (:line-style opal:blue-line)
		          (:visible nil))

(opal:add-component check chk-line1)
(opal:add-component check chk-line2)

(opal:add-component behav-agg check)

;; Boxes to display # of attempts, # of wrong answers, and time elapsed.

(create-instance 'noatt opal:rectangle
                          (:top 35)
                          (:left 180)
                          (:height 40)
                          (:width 40)
                          (:filling-style opal:white-fill))

(create-instance 'noatt-label opal:text
                 (:top (o-formula (- (gv noatt :top) 15)))
                 (:left (o-formula (+ (gv noatt :left)
                                      (- (round (gv noatt :width)
                                         2)
                                      (round (gvl :width) 2)))))
                          (:string "# of Attempts"))

(create-instance 'noatts opal:text
                          (:top (o-formula (+ (gv noatt :top) 14)))
                          (:left (o-formula (+ (gv noatt :left)
                                               (- (round (gv noatt :width)
                                                  2)
                                               (round (gvl :width) 2)))))
                          (:string *count*))

(opal:add-components behav-agg noatt)
(opal:add-components behav-agg noatt-label)
(opal:add-components behav-agg noatts)

(create-instance 'noerr opal:rectangle
                          (:top 95)
                          (:left 180)
                          (:width 40)
                          (:height 40)
                          (:filling-style opal:white-fill))

(create-instance 'noerr-label opal:text
                 (:top (o-formula (- (gv noerr :top) 15)))
                 (:left (o-formula (+ (gv noerr :left)
                                      (- (round (gv noerr :width) 2)
                                         (round (gvl :width) 2)))))
                          (:string "# of Errors"))

(create-instance 'noerrs opal:text
                 (:top (o-formula (+ (gv noerr :top) 14)))
                 (:left (o-formula (+ (gv noerr :left)
                                      (- (round (gv noerr :width) 2) 
                                      (round (gvl :width) 2)))))
                 (:string "0"))

(opal:add-components behav-agg noerr)
(opal:add-components behav-agg noerr-label)
(opal:add-components behav-agg noerrs)

(create-instance 'time opal:rectangle
                          (:top 159)
                          (:left 170)
                          (:width 60)
                          (:height 30)
                          (:filling-style opal:white-fill))

(create-instance 'time-label opal:text
                 (:top (o-formula (- (gv time :top) 14)))
                 (:left (o-formula (+ (gv time :left)
                                      (- (round (gv time :width) 2)
                                      (round (gvl :width) 2)))))
                 (:string "Task-Time in s"))

(create-instance 'time-info opal:text
                 (:top (o-formula (+ (gv time :top) 10)))
                 (:left (o-formula (+ (gv time :left)
                                      (- (round (gv time :width) 2)
                                      (round (gvl :width) 2)))))
                 (:string *run-time*))

(opal:add-components behav-agg time)
(opal:add-components behav-agg time-label)
(opal:add-components behav-agg time-info)

;;; The chunk-matrix - this creates a grid of numbers that
;;; are highlighted when the model is thinking about them.
;;; Thanks Jason!

;; create label
(create-instance 'grid-label opal:text
                 (:top 115)
                 (:left (o-formula (+ (gv t19 :left)
                                      (- (round (+ (- (gv t15 :left)
                                                      (gv t19 :left))
                                                   (gv t15 :width)) 2)
                                         (round (gvl :width) 2)))))
                 (:string "Number in Memory"))

(create-instance 'underscore opal:line
                 (:x1 (o-formula (gv grid-label :left)))
                 (:y1 (o-formula (+ (gv grid-label :top) 12)))
                 (:x2 (o-formula (+ (gv grid-label :left)
                                    (gv grid-label :width))))
                 (:y2 (o-formula (+ (gv grid-label :top) 12))))

;; Create text
(create-instance 't19 opal:text (:left 23) (:top 135) (:string "19"))
(create-instance 't18 opal:text (:left 43) (:top 135) (:string "18"))
(create-instance 't17 opal:text (:left 63) (:top 135) (:string "17"))
(create-instance 't16 opal:text (:left 83) (:top 135) (:string "16"))
(create-instance 't15 opal:text (:left 103) (:top 135) (:string "15"))
(create-instance 't14 opal:text (:left 23) (:top 150) (:string "14"))
(create-instance 't13 opal:text (:left 43) (:top 150) (:string "13"))
(create-instance 't12 opal:text (:left 63) (:top 150) (:string "12"))
(create-instance 't11 opal:text (:left 83) (:top 150) (:string "11"))
(create-instance 't10 opal:text (:left 103) (:top 150) (:string "10"))
(create-instance 't09 opal:text (:left 23) (:top 165) (:string "09"))
(create-instance 't08 opal:text (:left 43) (:top 165) (:string "08"))
(create-instance 't07 opal:text (:left 63) (:top 165) (:string "07"))
(create-instance 't06 opal:text (:left 83) (:top 165) (:string "06"))
(create-instance 't05 opal:text (:left 103) (:top 165) (:string "05"))
(create-instance 't04 opal:text (:left 23) (:top 180) (:string "04"))
(create-instance 't03 opal:text (:left 43) (:top 180) (:string "03"))
(create-instance 't02 opal:text (:left 63) (:top 180) (:string "02"))
(create-instance 't01 opal:text (:left 83) (:top 180) (:string "01"))
(create-instance 't00 opal:text (:left 103) (:top 180) (:string "00"))



;; Create highlighter
(create-instance 'srect opal:rectangle
                 (:left 10)(:top 132)(:width 24)
                 (:height 18)(:line-style opal:red-line)
                 (:fast-redraw-p :redraw)
                 (:fast-redraw-line-style opal:white-line)
                 (:visible nil))

;; Add objects to window
(opal:add-component behav-agg t00)
(opal:add-component behav-agg t01)
(opal:add-component behav-agg t02)
(opal:add-component behav-agg t03)
(opal:add-component behav-agg t04)
(opal:add-component behav-agg t05)
(opal:add-component behav-agg t06)
(opal:add-component behav-agg t07)
(opal:add-component behav-agg t08)
(opal:add-component behav-agg t09)
(opal:add-component behav-agg t10)
(opal:add-component behav-agg t11)
(opal:add-component behav-agg t12)
(opal:add-component behav-agg t13)
(opal:add-component behav-agg t14)
(opal:add-component behav-agg t15)
(opal:add-component behav-agg t16)
(opal:add-component behav-agg t17)
(opal:add-component behav-agg t18)
(opal:add-component behav-agg t19)
(opal:add-component behav-agg srect)
(opal:add-component behav-agg grid-label)
(opal:add-component behav-agg underscore)

;; The worry indicator

(create-instance 'wor-text opal:text
		  (:top 212)
		  (:left 62)
		  (:string "Worry Indicator"))

(create-instance 'wor-indic opal:circle
		  (:top 212)
		  (:left (o-formula (+ (gv wor-text :left) 115)))
		  (:width 12)
		  (:height 12)
		  (:filling-style opal:motif-blue-fill))

(opal:add-components behav-agg wor-indic)
(opal:add-components behav-agg wor-text)

;; Functions having to do with the matrix

(defun grid-highlight (value)
    "Highlights a number on the grid"
    (if (and (> value -1) (< value 20)) 
       (progn
           (s-value srect :visible t)
           (s-value srect :left (+ 18 (- 80 (* 20 (mod value 5)))))
           (s-value srect :top (+ 132 (* 15 (- 3 (floor (/ value 5))))))
           (opal:update behavior))
       (progn
           (s-value srect :visible nil)
           (opal:update behavior))))

(defun hide-highlight ()
    "Hides the highlight rectangle"
    (s-value srect :visible nil)
    (opal:update behavior))

;;;
;;; ii.	The Appraisal Window
;;;

;; This window shows the model's pre-task appraisal for
;; the current run, and displays the model's post-task
;; appraisal at the end of a run.

(create-instance 'appraisal inter:interactor-window
		  (:top 405)
		  (:left 579)
		  (:height 207)
		  (:width 138)		 
		  (:title "Appraisals")
		  (:background-color opal:motif-light-gray))

(create-instance 'app-agg opal:aggregate)
(s-value appraisal :aggregate app-agg)

(create-instance 'appraisal-font opal:font
                  :size :large))

(create-instance 'post-app-box opal:rectangle
		  (:top 43)
		  (:left 15)
		  (:width 108)
		  (:height 50)
		  (:filling-style opal:white-fill))

(create-instance 'post-app-label opal:text
		  (:top 23)
		  (:left (o-formula (- (+ (round (gv post-app-box :width) 2)
                                          (gv post-app-box :left))
			               (round (gvl :width) 2))))
                  (:string "Post-Task Appraisal"))

(create-instance 'post-app-text opal:text
		 (:top (o-formula (- (+ (round (gv post-app-box :height) 2)
                                        (gv post-app-box :top))
				     (round (gvl :height) 2))))
                 (:left (o-formula (- (+ (round (gv post-app-box :width) 2)
                                      (gv post-app-box :left))
				      (round (gvl :width) 2))))
                 (:font appraisal-font)
	         (:string ""))

(create-instance 'pre-app-box opal:rectangle
		          (:top 135)
		          (:left 15)
		          (:width 108)
		          (:height 50)
		          (:filling-style opal:white-fill))

(create-instance 'pre-app-label opal:text
		 (:top 115)
		 (:left (o-formula (- (+ (round (gv pre-app-box :width) 
		       		                         2)
		       	                     (gv pre-app-box :left))
		                                (round (gvl :width) 2))))
		 (:string "Pre-Task Appraisal"))

(create-instance 'pre-app-text opal:text
		 (:top (o-formula (- (+ (round (gv pre-app-box :height) 
		       	                                 2)
		       	                      (gv pre-app-box :top))
		                                (round (gvl :height) 2))))
		 (:left (o-formula (- (+ (round (gv pre-app-box :width) 
		       		                         2)
		       	                     (gv pre-app-box :left))
		                                (round (gvl :width) 2))))
		 (:font appraisal-font)
		 (:string "Neutral"))

(opal:add-components app-agg pre-app-box
		                     post-app-box
		                     pre-app-label
		                     post-app-label
		                     pre-app-text
		                     post-app-text)


;;;
;;; iii.	The Control Window
;;;

;; This is where all of the user-defined settings that
;; affect the model's behavior can be run.  There are
;; controls for setting the model's initial pre-task
;; appraisal, whether the model is worried, and the model's
;; caffeine level.  There are buttons for running,
;; reloading, and scripting the model.  Also present is
;; a menubar and a place to set the run length in seconds,
;; though these are still works in progress, and do not
;; work correctly yet.

(create-instance 'control inter:interactor-window
                          (:top 129)
                          (:left 131)
                          (:height 205)
                          (:width 376)
                          (:title "Control Panel")
                          (:background-color opal:motif-light-gray))

(create-instance 'con-agg opal:aggregate)
(s-value control :aggregate con-agg)


;; Threat/Challenge/Neutral radio buttons

(create-instance 't-vs-c gg:motif-radio-button-panel
		          (:left 30)
		          (:top 40)
		          (:text-on-left-p nil)
		          (:items '("Threat" "Neutral" "Challenge"))
		          (:value "Neutral")
		          (:selection-function 't-vs-c-fn))
(opal:add-component con-agg t-vs-c)

;; Worry check-box

(create-instance 'wor-chk gg:motif-check-button
		          (:left 30)
		          (:top 114)
		          (:string "Worried")
		          (:selection-function 'worry-fn))
(opal:add-component con-agg wor-chk)

;; Run/Reload buttons

(create-instance 'run gg:motif-text-button-panel
                          (:items '("RUN" "RELOAD" "SCRIPT 1"))
                          (:top (o-formula (+ (gv t-vs-c :top) 5)))
                          (:left (o-formula (+ (gv t-vs-c :width) 100)))
                          (:selection-function 'Run-Reload-Buttons-Fn))
(opal:add-components con-agg run)

(create-instance 'stop-time-box opal:rectangle
                          (:top (+ (gv t-vs-c :top) 9))
                          (:left (+ (+ (gv run :left) (gv run :width)) 15))
                          (:width (gv run :width))
                          (:height 18)
                          (:filling-style opal:white-fill))

(create-instance 'stop-time opal:aggregadget
                  (:top (+ (gv stop-time-box :top) 4))
                  (:left (o-formula
                            (+ (gv stop-time-box :left)
                                 (- (round (gv stop-time-box :width) 2) 
                                     (round (gvl :width) 2)))))
                  (:parts
                    `((:txt ,opal:text
                               (:left ,(o-formula (+ (gv stop-time-box :left)
                                                     (- (round (gv stop-time-box :width) 
		        	                                                2) 
                                                                    (round (gvl :width) 2)))))
                               (:top ,(o-formula (+ (gv stop-time-box :top) 3)))
                               (:string "240"))))
                  (:interactors
                    `((:editor ,inter:text-interactor
                                    (:start-where ,(o-formula 
		                                            (list :in (gvl :operates-on :txt))))
                                    (:window ,(o-formula (gvl :operates-on :window)))
                                    (:stop-event (:any-mousedown #\RETURN))
                                    (:start-event :leftdown)))))


(create-instance 'stop-time-label opal:text
                  (:top (gv stop-time :top))
                  (:left (o-formula (+ (gv stop-time-box :left)
		                                  (gv stop-time-box :width) 4)))
                  (:string "sec"))

;; Step Button

(create-instance 'stepper gg:motif-text-button
  (:string "STEP")
  (:top 85)
  (:left 285)
  (:selection-function 'Step-Fn))

(defun Step-Fn (gadget v)
  "Runs the model for 1 production cycle"
  (declare (ingnore gadget v))
  (run 1))

(opal:add-component con-agg stepper)

;; Menubar

(create-instance 'menu gg:motif-menubar 
                  (:items '(("Model" nil 
                                  (("Script" open-script-dialog)
                                    ("Run" run-from-menu)
                                    ("Reload" reset-from-menu) 
                                    ("Quit" quit-from-menu)))
	                        ("Edit" nil (("Traces" open-trace-control) ))
	                        ("                                   " nil)
	                        ("Help" nil (("Info" help-window-fn)))))
                  (:title "Model"))

(opal:add-components con-agg stop-time-label)
(opal:add-components con-agg stop-time-box)
(opal:add-components con-agg stop-time)
(opal:add-components con-agg menu)

(defun run-from-menu (gadget menu-item submenu-item)
    "Runs the model for one 4-minute task."
    (declare (ignore gadget menu-item submenu-item))
    (run))

(defun reset-from-menu (gadget menu-item submenu-item)
    "Resets the model."
    (declare (ignore gadget menu-item submenu-item))
    (model-reset))

(defun quit-from-menu (gadget menu-item submenu-item)
    "Quits lisp."
    (declare (ignore gadget menu-item submenu-item))
    (quit))


;; A Dialog for script options.

(defun script-1-cond-dialog (gadget value)
  "Runs the script-1-cond function from the GUI."
  (declare (ignore gadget value))
  (let ((num (read-from-string (gv scr-1-it :txt :string))))
    (cond
     ((equal (gv tnc-opt-single :value) "Threat")
      (opal:update control)
      (script-1-cond "Threat" num)
      (opal:destroy script-dialog))
     ((equal (gv tnc-opt-single :value) "Neutral")
      (opal:update control)
      (script-1-cond "Neutral" num)
      (opal:destroy script-dialog))
     ((equal (gv tnc-opt-single :value) "Challenge")
      (update-all)
      (script-1-cond "Challenge" num)
      (opal:destroy script-dialog))
     ((not (gv tnc-opt-single :value))
      (format t "~%Please select a condition~%"))
     (t (format t "~%Unknown error~%")))))


(defun open-script-dialog (gadget menu-item submenu-item)
  "Creates a dialog for scripting options."
  (declare (ignore gadget menu-item submenu-item))

; main window

  (create-instance 'script-dialog inter:interactor-window
    (:top 50)
    (:left 80)
    (:height 271)
    (:width 309)
    (:background-color opal:motif-light-blue)
    (:title "Script Options"))
  
  (create-instance 'script-dialog-agg opal:aggregate)
  (s-value script-dialog :aggregate script-dialog-agg)

;  labels indicating script type.

  (create-instance 'script-1-opt opal:text
    (:top 20)
    (:left 15)
    (:string "Script Single Condition"))
  
  (create-instance 'script-4-opt opal:text
    (:top 140)
    (:left 15)
    (:string "Script Four-Trial Blocks"))
  
  (opal:add-components script-dialog-agg script-1-opt
                       script-4-opt)
  
; radio buttons to select condition

  (create-instance 'tnc-opt-1label opal:text
    (:top 45)
    (:left 35)
    (:string "Select condition:"))
  (opal:add-component script-dialog-agg tnc-opt-1label)
  
  (create-instance 'tnc-opt-single gg:motif-radio-button-panel
    (:left 60)
    (:top 65)
    (:v-spacing 2)
    (:items '("Threat" "Neutral" "Challenge")))
  (opal:add-component script-dialog-agg tnc-opt-single)
  
; Text box to select number of iterations

  (create-instance 'scr-1-itlabel opal:text
    (:left 170)
    (:top 68)
    (:string "Iterations"))
  
  (create-instance 'scr-1-itbox opal:rectangle
    (:left 248)
    (:top 65)
    (:width 30)
    (:height 20)
    (:filling-style opal:white-fill))
  
    (create-instance 'scr-1-it opal:aggregadget
       (:top (+ (gv scr-1-itbox :top) 5))
       (:left (o-formula
                 (+ (gv scr-1-itbox :left)
                      (- (round (gv scr-1-itbox :width) 2) 
                          (round (gvl :width) 2)))))
       (:parts
         `((:txt ,opal:text
                    (:left ,(o-formula (+ (gv scr-1-itbox :left)
                                                     (- (round (gv scr-1-itbox :width) 
                                                                     2) 
                                                         (round (gvl :width) 2)))))
                    (:top ,(o-formula (+ (gv scr-1-itbox :top) 3)))
                    (:string "10"))))
       (:interactors
         `((:editor ,inter:text-interactor
                         (:start-where ,(o-formula 
                                                 (list :in (gvl :operates-on :txt))))
                         (:window ,(o-formula (gvl :operates-on :window)))
                         (:stop-event (:any-mousedown #\RETURN))
                         (:start-event :leftdown)))))
  
  (opal:add-components script-dialog-agg scr-1-itlabel
                       scr-1-itbox scr-1-it)

; GO button

  (create-instance 'script-1-go-button gg:motif-text-button
    (:left 220)
    (:top 95)
    (:width 60)
    (:string "GO")
    (:selection-function 'script-1-cond-dialog))
  (opal:add-component script-dialog-agg script-1-go-button)

; radio buttons to select initial 4-trial condition

  (create-instance 'tnc-opt-4label opal:text
    (:top 165)
    (:left 35)
    (:string "Select initial appraisal:"))
  (opal:add-component script-dialog-agg tnc-opt-4label)
  
  (create-instance 'tnc-opt-4trial gg:motif-radio-button-panel
    (:left 60)
    (:top 185)
    (:v-spacing 2)
    (:items '("Threat" "Neutral" "Challenge")))
  (opal:add-component script-dialog-agg tnc-opt-4trial)

;; I didn't quite get around to finishing this.  
; check button to select caffeine cycling
;
;  (create-instance 'caf-cycling gg:motif-check-button-panel
;    (:left 35)
;    (:top 250)
;    (:items '("Caffeine Cycling")))
;  (opal:add-component script-dialog-agg caf-cycling)
  
; Text box to select number of iterations

  (create-instance 'scr-4-itlabel opal:text
    (:left 170)
    (:top 188)
    (:string "Iterations"))
  
  (create-instance 'scr-4-itbox opal:rectangle
    (:left 248)
    (:top 185)
    (:width 30)
    (:height 20)
    (:filling-style opal:white-fill))
  
    (create-instance 'scr-4-it opal:aggregadget
       (:top (+ (gv scr-4-itbox :top) 5))
       (:left (o-formula
                 (+ (gv scr-4-itbox :left)
                      (- (round (gv scr-4-itbox :width) 2) 
                          (round (gvl :width) 2)))))
       (:parts
         `((:txt ,opal:text
                    (:left ,(o-formula (+ (gv scr-4-itbox :left)
                                                     (- (round (gv scr-4-itbox :width) 
                                                                     2) 
                                                         (round (gvl :width) 2)))))
                    (:top ,(o-formula (+ (gv scr-4-itbox :top) 3)))
                    (:string "10"))))
       (:interactors
         `((:editor ,inter:text-interactor
                         (:start-where ,(o-formula 
                                                 (list :in (gvl :operates-on :txt))))
                         (:window ,(o-formula (gvl :operates-on :window)))
                         (:stop-event (:any-mousedown #\RETURN))
                         (:start-event :leftdown)))))
  
  (opal:add-components script-dialog-agg scr-4-itlabel
                       scr-4-itbox scr-4-it)
  
; GO button

  (create-instance 'script-4-go-button gg:motif-text-button
    (:left 220)
    (:top 215)
    (:width 60)
    (:string "GO")
    (:selection-function 'script-4-trials-dialog))
  (opal:add-component script-dialog-agg script-4-go-button)

  (opal:update script-dialog))


(defun script-4-trials-dialog (gadget value)
  "Runs the script-1-cond function from the GUI."
  (declare (ignore gadget value))
  (let ((num (read-from-string (gv scr-4-it :txt :string))))
    (cond
     ((equal (gv tnc-opt-4trial :value) "Threat")
      (opal:update control)
      (script-4-trials "Threat" num)
      (opal:destroy script-dialog))
     ((equal (gv tnc-opt-4trial :value) "Neutral")
      (opal:update control)
      (script-4-trials "Neutral" num)
      (opal:destroy script-dialog))
     ((equal (gv tnc-opt-4trial :value) "Challenge")
      (update-all)
      (script-4-trials "Challenge" num)
      (opal:destroy script-dialog))
     ((not (gv tnc-opt-4trial :value))
      (format t "~%Please select a condition~%"))
     (t (format t "~%Unknown error~%")))))




(defun help-window-fn (gadget menu-item submenu-item)
  "Calls up a help window."
  (declare (ignore gadget menu-item submenu-item))

  (create-instance 'help-win inter:interactor-window
    (:left 420)
    (:top 220)
    (:height 70)
    (:width 200)
    (:title "Help")
    (:background-color opal:motif-light-blue))
  
  (create-instance 'help-agg opal:aggregate)
  (s-value help-win :aggregate help-agg)
  
  (create-instance 'help-text1 opal:text
    (:left 20)
    (:top 20)
    (:string "See the docs directory"))
  
  (create-instance 'help-text2 opal:text
    (:left 50)
    (:top 35)
    (:string "for html help."))
  
  (opal:add-components help-agg help-text1 help-text2)
  (opal:update help-win))


;; Functions to support run-control buttons buttons

(defun worry-fn (gadget v)
    "Loads in the worry production (or unloads it)."
    (declare (ignore gadget v))
    (if (not *worry-marker*)
       (progn
	   (PEnable worry)
	   (setf *worry-marker* t)
	   (format t "Worry Enabled~%"))
       (progn
           (PDisable worry)
           (format t "Worry Disabled~%")
           (setf *worry-marker* nil)
           (s-value wor-chk :value nil))))

(defun t-vs-c-fn (gadget value)
    "Loads model with new global parameters file according to setting."
    (declare (ignore gadget))
    (cond
      ((equal value "Threat")
        (setf *appraisal-marker* "Threat")
        (s-value pre-app-text :string "Threat")
        (model-reset))
      ((equal value "Neutral")
        (setf *appraisal-marker* "Neutral")
        (s-value pre-app-text :string "Neutral")
        (model-reset))
      ((equal value "Challenge") 
        (setf *appraisal-marker* "Challenge")
        (s-value pre-app-text :string "Challenge")
        (model-reset))
      (t (format t "~s~%" value)))
    (opal:update appraisal))

(defun Run-Reload-Buttons-Fn (gadget value)
    "Run or Reload Model."
    (declare (ignore gadget))
    (cond
      ((equal value "RUN")
        (run))
      ((equal value "RELOAD")
        (model-reset)
        (script-reset))
      ((equal value "SCRIPT 1") (single-4-trial-script))
      (t (format t "~s~%" value))))


;; Caffeine slider

(create-instance 'caf gg:h-slider
                          (:left 30)
                          (:top 145)
                          (:val-2 600)
                          (:num-marks 7))
(create-instance 'caf-text opal:text
                          (:left 135)
                          (:top 183)
                          (:string "Caffeine Level (mg)"))

(opal:add-components con-agg caf)
(opal:add-components con-agg caf-text)



;;;
;;;	iv.	Roman's trace control
;;;

;;/-----------------------------------------------------
;;
;; The following code is taken
;; from Roman Belavkin's ACT-R-Vision
;; tool (U of Nottingham)
;;

;;; Useful functions

(defun unwrap (list)
  (and list (if (listp list) (unwrap (car list)) list)))

(defmacro watch-command (command text-object)
  "Redirects the output of ACT-R command to a text-object"
  `(let ((*command-trace* (make-string-output-stream)))
     ,command
     (s-value ,text-object :string
              (get-output-stream-string *command-trace*))
     (opal:update (gv ,text-object :window))))

(defun sgp-p (parameter)
  "Returns ACT-R global parameter value.  Used as a predicate."
  (let ((*command-trace* nil))
    (unwrap (eval (list 'sgp parameter)))))

(defmacro spp-values (parameter)
  "Returns a list of vlues of a parameter for all the rules"
  `(let ((*command-trace* nil)
         (val nil)
         (values nil))
     (dolist (rule (pp) values)
             (setf val (unwrap (eval (list 'spp rule ,parameter))))
             (push-last val values))))

;; Trace control

(defun init-trace ()
  "Gets and returns the current trace settings"
  (let ((trace-list nil))
    (when (sgp-p :emt) (push "Exact Matching" trace-list))
    (when (sgp-p :pmt) (push "Partial Matching" trace-list))
    (when (sgp-p :pct) (push "Production Compilation" trace-list))
    (when (sgp-p :act) (push "Activation" trace-list))
    (when (sgp-p :crt) (push "Conflict Resolution" trace-list))
    (when (sgp-p :cst) (push "Conflict Set" trace-list))
    (when (sgp-p :mt)  (push "Matches" trace-list))
    (when (sgp-p :pt)  (push "Production" trace-list))
    (when (sgp-p :ct)  (push "Cycle" trace-list))
    (when (sgp-p :lt)  (push "Latency" trace-list))
    (when (sgp-p :ot)  (push "Output" trace-list))
    (when (sgp-p :dmt) (push "Declarative Memory" trace-list))
    (when (sgp-p :gt)  (push "Goal" trace-list))
    (when (sgp-p :v)   (push "Verbose" trace-list))
    trace-list))

;; Set trace

(defun set-trace (gadget value)
  "Sets Act-R traces"
  (declare (ignore gadget))
  (if (member "Exact Matching" value :test #'equal)
      (sgp :emt t) (sgp :emt nil))
  (if (member "Partial Matching" value :test #'equal)
      (sgp :pmt t) (sgp :pmt nil))
  (if (member "Production Compilation" value :test #'equal)
      (sgp :pct t) (sgp :pct nil))
  (if (member "Activation" value :test #'equal)
      (sgp :act t) (sgp :act nil))
  (if (member "Conflict Resolution" value :test #'equal)
      (sgp :crt t) (sgp :crt nil))
  (if (member "Conflict Set" value :test #'equal)
      (sgp :cst t) (sgp :cst nil))
  (if (member "Matches" value :test #'equal)
      (sgp :mt t) (sgp :mt nil))
  (if (member "Production" value :test #'equal)
      (sgp :pt t) (sgp :pt nil))
  (if (member "Cycle" value :test #'equal)
      (sgp :ct t) (sgp :ct nil))
  (if (member "Latency" value :test #'equal)
      (sgp :lt t) (sgp :lt nil))
  (if (member "Output" value :test #'equal)
      (sgp :ot t) (sgp :ot nil))
  (if (member "Declarative Memory" value :test #'equal)
      (sgp :dmt t) (sgp :dmt nil))
  (if (member "Goal" value :test #'equal)
      (sgp :gt t) (sgp :gt nil))
  (if (member "Verbose" value :test #'equal)
      (sgp :v t) (sgp :v nil)))

(defun trace-control ()
  "Trace Control tool"

  (create-instance 'TRACE-CONTROL-WIN inter:interactor-window
      (:top 100) (:width 180) (:height 255) (:left 20)
      (:title "Trace Control")
      (:background-color opal:motif-light-blue))

  (s-value TRACE-CONTROL-WIN :aggregate
           (create-instance 'TC-AGG opal:aggregate))

  (create-instance 'TRACES gg:Motif-Check-Button-Panel
     (:v-spacing 0)
     (:foreground-color opal:motif-light-gray)
     (:items '("Exact Matching"
               "Partial Matching"
               "Production Compilation"
               "Activation"
               "Conflict Resolution"
               "Conflict Set"
               "Matches"
               "Production"
               "Cycle"
               "Latency"
               "Output"
               "Declarative Memory"
               "Goal"
               "Verbose"))
     (:selection-function 'set-trace) )

  (opal:add-components TC-AGG TRACES)

  (opal:update TRACE-CONTROL-WIN))

(defun open-trace-control (gadget menu-item submenu-item)
  "Opens the Trace Control tool"
  (declare (ignore gadget menu-item submenu-item))
  (trace-control)
  (s-value TRACES :value (init-trace))
  (opal:update TRACE-CONTROL-WIN))

;;/--------- End Roman's code----------
;;------------------------------------------/


;;;
;;; v. The Script Data Window
;;;

;; If the model is scripted, the model's output over
;; the four runs is recorded here.  Data captured
;; includes the pre- and post-task appraisals, the
;; number of subtraction attempts, and the number
;; of errors made for each 4 minute run.

(create-instance 'script-win inter:interactor-window
		          (:left 149)
		          (:top 389)
		          (:height 220) 
		          (:width 346)
		          (:background-color opal:motif-light-gray)
		          (:title "Script Data"))

(create-instance 'script-agg opal:aggregate)
(s-value script-win :aggregate script-agg)

;; Divide the window into four quadrants

(create-instance 'divide-v opal:line
		          (:x1 173)
		          (:x2 173)
		          (:y1 0)
		          (:y2 220))
(opal:add-component script-agg divide-v)

(create-instance 'divide-h opal:line
		          (:x1 0)
		          (:x2 346)
		          (:y1 110)
		          (:y2 110))
(opal:add-component script-agg divide-h)

;; Trial 1 Pane

(create-instance 'large opal:font
		          (:size :large))

(create-instance 'trial1 opal:text
		          (:string "Trial 1")
		          (:left 48)
		          (:top 5)
		          (:font large))

(opal:add-component script-agg trial1)


(create-instance 'pre1-lab opal:text
		          (:string "pre-task apprais")
		          (:top 30)
		          (:left 12))

(create-instance 'pre1-text opal:text
		          (:string "")
		          (:top 30)
		          (:left 143))

(create-instance 'post1-lab opal:text
		          (:string "post-task apprais")
		          (:top 47)
		          (:left 5))

(create-instance 'post1-text opal:text
		          (:string "")
		          (:top 47)
		          (:left 143))

(create-instance 'att1-lab opal:text
		          (:string "# of attempts")
		          (:top 64)
		          (:left 33))

(create-instance 'att1-text opal:text
		          (:string "")
		          (:top 64)
		          (:left 143))

(create-instance 'err1-lab opal:text
		          (:string "# of errors")
		          (:top 81)
		          (:left 47))

(create-instance 'err1-text opal:text
		          (:string "")
		          (:top 81)
		          (:left 143))

(opal:add-components script-agg pre1-lab pre1-text post1-lab
	             post1-text att1-lab att1-text err1-lab err1-text)

;; Trial 2 Pane

(create-instance 'trial2 opal:text
		          (:string "Trial 2")
		          (:left 221)
		          (:top 5)
		          (:font large))

(opal:add-component script-agg trial2)

(create-instance 'pre2-lab opal:text
		          (:string "pre-task apprais")
		          (:top 30)
		          (:left 185))

(create-instance 'pre2-text opal:text
		          (:string "")
		          (:top 30)
		          (:left 316))

(create-instance 'post2-lab opal:text
		          (:string "post-task apprais")
		          (:top 47)
		          (:left 178))

(create-instance 'post2-text opal:text
		          (:string "")
		          (:top 47)
		          (:left 316))

(create-instance 'att2-lab opal:text
		          (:string "# of attempts")
		          (:top 64)
		          (:left 206))

(create-instance 'att2-text opal:text
		          (:string "")
		          (:top 64)
		          (:left 316))

(create-instance 'err2-lab opal:text
		          (:string "# of errors")
		          (:top 81)
		          (:left 220))

(create-instance 'err2-text opal:text
		          (:string "")
		          (:top 81)
		          (:left 316))

(opal:add-components script-agg pre2-lab pre2-text post2-lab 
		                     post2-text att2-lab att2-text err2-lab err2-text)

;; Trial 3 Pane

(create-instance 'trial3 opal:text
		          (:string "Trial 3")
		          (:left 48)
		          (:top 115)
		          (:font large))

(create-instance 'pre3-lab opal:text
		          (:string "pre-task apprais")
		          (:top 140)
		          (:left 12))

(create-instance 'pre3-text opal:text
		          (:string "")
		          (:top 140)
		          (:left 143))

(create-instance 'post3-lab opal:text
		          (:string "post-task apprais")
		          (:top 157)
		          (:left 5))

(create-instance 'post3-text opal:text
		          (:string "")
		          (:top 157)
		          (:left 143))

(create-instance 'att3-lab opal:text
		          (:string "# of attempts")
		          (:top 174)
		          (:left 33))

(create-instance 'att3-text opal:text
		          (:string "")
		          (:top 174)
		          (:left 143))

(create-instance 'err3-lab opal:text
		          (:string "# of errors")
		          (:top 191)
		          (:left 47))

(create-instance 'err3-text opal:text
		          (:string "")
		          (:top 191)
		          (:left 143))

(opal:add-components script-agg trial3 pre3-lab pre3-text post3-lab
		                     post3-text att3-lab att3-text err3-lab err3-text)

;; Trial 4 Pane

(create-instance 'trial4 opal:text
		          (:string "Trial 4")
		          (:left 221)
		          (:top 115)
		          (:font large))

(create-instance 'pre4-lab opal:text
		          (:string "pre-task apprais")
		          (:top 140)
		          (:left 185))

(create-instance 'pre4-text opal:text
		          (:string "")
		          (:top 140)
		          (:left 316))

(create-instance 'post4-lab opal:text
		          (:string "post-task apprais")
		          (:top 157)
		          (:left 178))

(create-instance 'post4-text opal:text
		          (:string "")
		          (:top 157)
		          (:left 316))

(create-instance 'att4-lab opal:text
		          (:string "# of attempts")
		          (:top 174)
		          (:left 206))

(create-instance 'att4-text opal:text
		          (:string "")
		          (:top 174)
		          (:left 316))

(create-instance 'err4-lab opal:text
		          (:string "# of errors")
		          (:top 191)
		          (:left 220))

(create-instance 'err4-text opal:text
		          (:string "")
		          (:top 191)
		          (:left 316))

(opal:add-components script-agg trial4 pre4-lab pre4-text post4-lab 
		                     post4-text att4-lab att4-text err4-lab err4-text)



;;;
;;; 	vi.	Conjure the windows
;;;

(update-all)

