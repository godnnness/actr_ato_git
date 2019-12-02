;;;
;;;    Serial-Subtraction Model
;;;     with ACT-R/A/C overlay
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;     Author: Isaac Councill
;;;       Created: 10/14/01
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;


;;;	Table of Contents
;;;
;;; 	i.	initializations
;;; 	ii.	Serial subtraction model chunk types 
;;; 	iii.	ss declarative memory elements
;;; 	iv. 	productions
;;;	v.	production parameters

;;;
;;; 	i.	initializations
;;;

;; (clear-all) is called in the overlay.lisp file.  The overlay should
;; therefore be loaded first.

(pre-appraise)

(sgp
  :ACT NIL
  :MT NIL
  )

;;;
;;; 	ii.	Serial subtraction model chunk types 
;;;

(chunk-type serial-subtraction column)
(chunk-type subtraction-fact top bottom diff)
(chunk-type subtract-column top bottom diff column note)
(chunk-type number tens value units)
(chunk-type index)
(chunk-type next-info before after)
(chunk-type memory-object row column value)
(chunk-type current-number ones tens hundreds thousands)
(chunk-type comparison bigger smaller)
(chunk-type add-ten num sum)
(chunk-type symbol)
(chunk-type sub-by-count start count column note)
(chunk-type distractor last-night fight morning)
(chunk-type problem event)
(chunk-type worry-event)
(chunk-type reset-goal)

;;;
;;; 	iii.	ss declarative memory elements
;;;

(add-dm
  (ones ISA index)
  (tens ISA index)
  (hundreds ISA index)
  (thousands ISA index)
  (top ISA index)
  (bottom ISA index)
  (n1 ISA next-info before ones after tens)
  (n2 ISA next-info before tens after hundreds)
  (n3 ISA next-info before hundreds after thousands)
  (m1 ISA memory-object column ones row top value number_3)
  (m2 ISA memory-object column tens row top value number_5)
  (m3 ISA memory-object column hundreds row top value number_1)
  (m4 ISA memory-object column thousands row top value number_6)
  (number ISA current-number ones number_3 tens number_5 hundreds number_1 thousands number_6)
  (m5 ISA memory-object column ones row bottom value number_7)
  (m6 ISA memory-object column tens row bottom value number_0)
  (m7 ISA memory-object column hundreds row bottom value number_0)
  (m8 ISA memory-object column thousands row bottom value -)
  (- ISA symbol)
  (no-borrow ISA symbol)
  (borrow ISA symbol)
  (SF19-7 ISA subtraction-fact top number_19 bottom number_7 diff number_12)
  (SF18-7 ISA subtraction-fact top number_18 bottom number_7 diff number_11)
  (SF17-7 ISA subtraction-fact top number_17 bottom number_7 diff number_10)
  (SF16-7 ISA subtraction-fact top number_16 bottom number_7 diff number_9)
  (SF15-7 ISA subtraction-fact top number_15 bottom number_7 diff number_8)
  (SF14-7 ISA subtraction-fact top number_14 bottom number_7 diff number_7)
  (SF13-7 ISA subtraction-fact top number_13 bottom number_7 diff number_6)
  (SF12-7 ISA subtraction-fact top number_12 bottom number_7 diff number_5)
  (SF11-7 ISA subtraction-fact top number_11 bottom number_7 diff number_4)
  (SF10-7 ISA subtraction-fact top number_10 bottom number_7 diff number_3)
  (SF9-7  ISA subtraction-fact top number_9 bottom number_7 diff number_2)
  (SF8-7  ISA subtraction-fact top number_8 bottom number_7 diff number_1)
  (SF7-7  ISA subtraction-fact top number_7 bottom number_7 diff number_0)
  (SF19-1 ISA subtraction-fact top number_19 bottom number_1 diff number_18)
  (SF18-1 ISA subtraction-fact top number_18 bottom number_1 diff number_17)
  (SF17-1 ISA subtraction-fact top number_17 bottom number_1 diff number_16)
  (SF16-1 ISA subtraction-fact top number_16 bottom number_1 diff number_15)
  (SF15-1 ISA subtraction-fact top number_15 bottom number_1 diff number_14)
  (SF14-1 ISA subtraction-fact top number_14 bottom number_1 diff number_13)
  (SF13-1 ISA subtraction-fact top number_13 bottom number_1 diff number_12)
  (SF12-1 ISA subtraction-fact top number_12 bottom number_1 diff number_11)
  (SF11-1 ISA subtraction-fact top number_11 bottom number_1 diff number_10)
  (SF10-1 ISA subtraction-fact top number_10 bottom number_1 diff number_9)
  (SF9-1  ISA subtraction-fact top number_9 bottom number_1 diff number_8)
  (SF8-1  ISA subtraction-fact top number_8 bottom number_1 diff number_7)
  (SF7-1  ISA subtraction-fact top number_7 bottom number_1 diff number_6)
  (SF6-1  ISA subtraction-fact top number_6 bottom number_1 diff number_5)
  (SF5-1  ISA subtraction-fact top number_5 bottom number_1 diff number_4)
  (SF4-1  ISA subtraction-fact top number_4 bottom number_1 diff number_3)
  (SF3-1  ISA subtraction-fact top number_3 bottom number_1 diff number_2)
  (SF2-1  ISA subtraction-fact top number_2 bottom number_1 diff number_1)
  (SF1-1  ISA subtraction-fact top number_1 bottom number_1 diff number_0)
  (SF9-0  ISA subtraction-fact top number_9 bottom number_0 diff number_9)
  (SF8-0  ISA subtraction-fact top number_8 bottom number_0 diff number_8)
  (SF7-0  ISA subtraction-fact top number_7 bottom number_0 diff number_7)
  (SF6-0  ISA subtraction-fact top number_6 bottom number_0 diff number_6)
  (SF5-0  ISA subtraction-fact top number_5 bottom number_0 diff number_5)
  (SF4-0  ISA subtraction-fact top number_4 bottom number_0 diff number_4)
  (SF3-0  ISA subtraction-fact top number_3 bottom number_0 diff number_3)
  (SF2-0  ISA subtraction-fact top number_2 bottom number_0 diff number_2)
  (SF1-0  ISA subtraction-fact top number_1 bottom number_0 diff number_1)
  (SF0-0  ISA subtraction-fact top number_0 bottom number_0 diff number_0)
  (number_0 ISA number value 0 tens number_0 units number_0)
  (number_1 ISA number value 1 tens number_0 units number_1)
  (number_2 ISA number value 2 tens number_0 units number_2)
  (number_3 ISA number value 3 tens number_0 units number_3)
  (number_4 ISA number value 4 tens number_0 units number_4)
  (number_5 ISA number value 5 tens number_0 units number_5)
  (number_6 ISA number value 6 tens number_0 units number_6)
  (number_7 ISA number value 7 tens number_0 units number_7)
  (number_8 ISA number value 8 tens number_0 units number_8)
  (number_9 ISA number value 9 tens number_0 units number_9)
  (number_10 ISA number value 10 tens number_1 units number_0)
  (number_11 ISA number value 11 tens number_1 units number_1)
  (number_12 ISA number value 12 tens number_1 units number_2)
  (number_13 ISA number value 13 tens number_1 units number_3)
  (number_14 ISA number value 14 tens number_1 units number_4)
  (number_15 ISA number value 15 tens number_1 units number_5)
  (number_16 ISA number value 16 tens number_1 units number_6)
  (number_17 ISA number value 17 tens number_1 units number_7)
  (number_18 ISA number value 18 tens number_1 units number_8)
  (number_19 ISA number value 19 tens number_1 units number_9)
  (c1 ISA comparison bigger number_19 smaller number_0)
  (c2 ISA comparison bigger number_18 smaller number_0)
  (c3 ISA comparison bigger number_17 smaller number_0)
  (c4 ISA comparison bigger number_16 smaller number_0)
  (c5 ISA comparison bigger number_15 smaller number_0)
  (c6 ISA comparison bigger number_14 smaller number_0)
  (c7 ISA comparison bigger number_13 smaller number_0)
  (c8 ISA comparison bigger number_12 smaller number_0)
  (c9 ISA comparison bigger number_11 smaller number_0)
  (c10 ISA comparison bigger number_10 smaller number_0)
  (c11 ISA comparison bigger number_9 smaller number_0)
  (c12 ISA comparison bigger number_8 smaller number_0)
  (c13 ISA comparison bigger number_7 smaller number_0)
  (c14 ISA comparison bigger number_6 smaller number_0)
  (c15 ISA comparison bigger number_5 smaller number_0)
  (c16 ISA comparison bigger number_4 smaller number_0)
  (c17 ISA comparison bigger number_3 smaller number_0)
  (c18 ISA comparison bigger number_2 smaller number_0)
  (c19 ISA comparison bigger number_1 smaller number_0)
  (cf1 ISA comparison bigger number_0 smaller number_0)
  (c20 ISA comparison bigger number_19 smaller number_1)
  (c21 ISA comparison bigger number_18 smaller number_1)
  (c22 ISA comparison bigger number_17 smaller number_1)
  (c23 ISA comparison bigger number_16 smaller number_1)
  (c24 ISA comparison bigger number_15 smaller number_1)
  (c25 ISA comparison bigger number_14 smaller number_1)
  (c26 ISA comparison bigger number_13 smaller number_1)
  (c27 ISA comparison bigger number_12 smaller number_1)
  (c28 ISA comparison bigger number_11 smaller number_1)
  (c29 ISA comparison bigger number_10 smaller number_1)
  (c30 ISA comparison bigger number_9 smaller number_1)
  (c31 ISA comparison bigger number_8 smaller number_1)
  (c32 ISA comparison bigger number_7 smaller number_1)
  (c33 ISA comparison bigger number_6 smaller number_1)
  (c34 ISA comparison bigger number_5 smaller number_1)
  (c35 ISA comparison bigger number_4 smaller number_1)
  (c36 ISA comparison bigger number_3 smaller number_1)
  (c37 ISA comparison bigger number_2 smaller number_1)
  (cf2 ISA comparison bigger number_1 smaller number_1)
  (c38 ISA comparison bigger number_19 smaller number_2)
  (c39 ISA comparison bigger number_18 smaller number_2)
  (c40 ISA comparison bigger number_17 smaller number_2)
  (c41 ISA comparison bigger number_16 smaller number_2)
  (c42 ISA comparison bigger number_15 smaller number_2)
  (c43 ISA comparison bigger number_14 smaller number_2)
  (c44 ISA comparison bigger number_13 smaller number_2)
  (c45 ISA comparison bigger number_12 smaller number_2)
  (c46 ISA comparison bigger number_11 smaller number_2)
  (c47 ISA comparison bigger number_10 smaller number_2)
  (c48 ISA comparison bigger number_9 smaller number_2)
  (c49 ISA comparison bigger number_8 smaller number_2)
  (c50 ISA comparison bigger number_7 smaller number_2)
  (c51 ISA comparison bigger number_6 smaller number_2)
  (c52 ISA comparison bigger number_5 smaller number_2)
  (c53 ISA comparison bigger number_4 smaller number_2)
  (c54 ISA comparison bigger number_3 smaller number_2)
  (cf3 ISA comparison bigger number_2 smaller number_2)
  (c55 ISA comparison bigger number_19 smaller number_3)
  (c56 ISA comparison bigger number_18 smaller number_3)
  (c57 ISA comparison bigger number_17 smaller number_3)
  (c58 ISA comparison bigger number_16 smaller number_3)
  (c59 ISA comparison bigger number_15 smaller number_3)
  (c60 ISA comparison bigger number_14 smaller number_3)
  (c61 ISA comparison bigger number_13 smaller number_3)
  (c62 ISA comparison bigger number_12 smaller number_3)
  (c63 ISA comparison bigger number_11 smaller number_3)
  (c64 ISA comparison bigger number_10 smaller number_3)
  (c65 ISA comparison bigger number_9 smaller number_3)
  (c66 ISA comparison bigger number_8 smaller number_3)
  (c67 ISA comparison bigger number_7 smaller number_3)
  (c68 ISA comparison bigger number_6 smaller number_3)
  (c69 ISA comparison bigger number_5 smaller number_3)
  (c70 ISA comparison bigger number_4 smaller number_3)
  (cf4 ISA comparison bigger number_3 smaller number_3)
  (c71 ISA comparison bigger number_19 smaller number_4)
  (c72 ISA comparison bigger number_18 smaller number_4)
  (c73 ISA comparison bigger number_17 smaller number_4)
  (c74 ISA comparison bigger number_16 smaller number_4)
  (c75 ISA comparison bigger number_15 smaller number_4)
  (c76 ISA comparison bigger number_14 smaller number_4)
  (c77 ISA comparison bigger number_13 smaller number_4)
  (c78 ISA comparison bigger number_12 smaller number_4)
  (c79 ISA comparison bigger number_11 smaller number_4)
  (c80 ISA comparison bigger number_10 smaller number_4)
  (c81 ISA comparison bigger number_9 smaller number_4)
  (c82 ISA comparison bigger number_8 smaller number_4)
  (c83 ISA comparison bigger number_7 smaller number_4)
  (c84 ISA comparison bigger number_6 smaller number_4)
  (c85 ISA comparison bigger number_5 smaller number_4)
  (cf5 ISA comparison bigger number_4 smaller number_4)
  (c86 ISA comparison bigger number_19 smaller number_5)
  (c87 ISA comparison bigger number_18 smaller number_5)
  (c88 ISA comparison bigger number_17 smaller number_5)
  (c89 ISA comparison bigger number_16 smaller number_5)
  (c90 ISA comparison bigger number_15 smaller number_5)
  (c91 ISA comparison bigger number_14 smaller number_5)
  (c92 ISA comparison bigger number_13 smaller number_5)
  (c93 ISA comparison bigger number_12 smaller number_5)
  (c94 ISA comparison bigger number_11 smaller number_5)
  (c95 ISA comparison bigger number_10 smaller number_5)
  (c96 ISA comparison bigger number_9 smaller number_5)
  (c97 ISA comparison bigger number_8 smaller number_5)
  (c98 ISA comparison bigger number_7 smaller number_5)
  (c99 ISA comparison bigger number_6 smaller number_5)
  (cf6 ISA comparison bigger number_5 smaller number_5)
  (c100 ISA comparison bigger number_19 smaller number_6)
  (c101 ISA comparison bigger number_18 smaller number_6)
  (c102 ISA comparison bigger number_17 smaller number_6)
  (c103 ISA comparison bigger number_16 smaller number_6)
  (c104 ISA comparison bigger number_15 smaller number_6)
  (c105 ISA comparison bigger number_14 smaller number_6)
  (c106 ISA comparison bigger number_13 smaller number_6)
  (c107 ISA comparison bigger number_12 smaller number_6)
  (c108 ISA comparison bigger number_11 smaller number_6)
  (c109 ISA comparison bigger number_10 smaller number_6)
  (c110 ISA comparison bigger number_9 smaller number_6)
  (c111 ISA comparison bigger number_8 smaller number_6)
  (c112 ISA comparison bigger number_7 smaller number_6)
  (cf7 ISA comparison bigger number_6 smaller number_6)
  (c113 ISA comparison bigger number_19 smaller number_7)
  (c114 ISA comparison bigger number_18 smaller number_7)
  (c115 ISA comparison bigger number_17 smaller number_7)
  (c116 ISA comparison bigger number_16 smaller number_7)
  (c117 ISA comparison bigger number_15 smaller number_7)
  (c118 ISA comparison bigger number_14 smaller number_7)
  (c119 ISA comparison bigger number_13 smaller number_7)
  (c120 ISA comparison bigger number_12 smaller number_7)
  (c121 ISA comparison bigger number_11 smaller number_7)
  (c122 ISA comparison bigger number_10 smaller number_7)
  (c123 ISA comparison bigger number_9 smaller number_7)
  (c124 ISA comparison bigger number_8 smaller number_7)
  (cf8 ISA comparison bigger number_7 smaller number_7)
  (c125 ISA comparison bigger number_19 smaller number_8)
  (c127 ISA comparison bigger number_18 smaller number_8)
  (c128 ISA comparison bigger number_17 smaller number_8)
  (c129 ISA comparison bigger number_16 smaller number_8)
  (c130 ISA comparison bigger number_15 smaller number_8)
  (c131 ISA comparison bigger number_14 smaller number_8)
  (c132 ISA comparison bigger number_13 smaller number_8)
  (c133 ISA comparison bigger number_12 smaller number_8)
  (c134 ISA comparison bigger number_11 smaller number_8)
  (c135 ISA comparison bigger number_10 smaller number_8)
  (c136 ISA comparison bigger number_9 smaller number_8)
  (cf9 ISA comparison bigger number_8 smaller number_8)
  (c137 ISA comparison bigger number_19 smaller number_9)
  (c138 ISA comparison bigger number_18 smaller number_9)
  (c139 ISA comparison bigger number_17 smaller number_9)
  (c140 ISA comparison bigger number_16 smaller number_9)
  (c141 ISA comparison bigger number_15 smaller number_9)
  (c142 ISA comparison bigger number_14 smaller number_9)
  (c143 ISA comparison bigger number_13 smaller number_9)
  (c144 ISA comparison bigger number_12 smaller number_9)
  (c145 ISA comparison bigger number_11 smaller number_9)
  (c146 ISA comparison bigger number_10 smaller number_9)
  (cf10 ISA comparison bigger number_9 smaller number_9)
  (t1 ISA add-ten num number_0 sum number_10)
  (t2 ISA add-ten num number_1 sum number_11)
  (t3 ISA add-ten num number_2 sum number_12)
  (t4 ISA add-ten num number_3 sum number_13)
  (t5 ISA add-ten num number_4 sum number_14)
  (t6 ISA add-ten num number_5 sum number_15)
  (t7 ISA add-ten num number_6 sum number_16)
  (t8 ISA add-ten num number_7 sum number_17)
  (t9 ISA add-ten num number_8 sum number_18)
  (t10 ISA add-ten num number_9 sum number_19)
  
  ;; some chunks relating to why the model might be worried
  
  (exam ISA distractor last-night study-not-enough
	     fight with-sleep morning unprepared)
  (study-not-enough ISA problem event play-play-station-instead)
  (with-sleep ISA problem event give-up-and-goto-bed)
  (unprepared ISA problem event going-to-fail)
  (play-play-station-instead ISA worry-event)
  (give-up-and-goto-bed ISA worry-event)
  (going-to-fail ISA worry-event)
  (goal ISA serial-subtraction)
  (reset-goal isa reset-goal))

;; Set similarity values among the chunks encoding numbers (number_*).
;; See the file sub-functions.lisp for details regarding the macro that does the setting.
;; The variable "similarity-spread" is set in the overlay.lisp file.

(eval `(set-chunk-similarity-values ,similarity-spread))


;;;
;;; 	iv. 	productions
;;;

;; the worry production

(P worry
     =goal>
       ISA       subtract-column
     =distraction>
       ISA         distractor
       last-night  =d1
       fight       =d2
       morning     =d3
==>
     !eval!         (worry-light) )


(P stop-subtraction
     =goal>
       ISA         subtract-column
     !eval!         (>= (floor *time*) *stop-time*)
==>
     !eval!         (post-appraise)
     !eval!         (setf run-history t)
     !stop!)


;; In the task we are modeling, the subject is corrected after
;; making a mistake


(p reset-after-error
     =goal>
       ISA    reset-goal
     =object1>
       ISA         memory-object
       row    top
       column ones
       value  =val1
     =object2>
       ISA    memory-object
       row    top
       column tens
       value  =val2
     =object3>
       ISA    memory-object
       row    top
       column hundreds
       value  =val3
     =object4>
       ISA    memory-object
       row    top
       column thousands
       value  =val4 
     !bind!   =o  (gv units-parse)
     !bind!   =t  (gv tens-parse)
     !bind!   =h  (gv hunds-parse)
     !bind!   =th (gv thous-parse)
==>
     =newgoal>
       ISA    subtract-column
       column ones
       note   no-borrow
     =object1>
       ISA    memory-object
       row    top
       column ones
       value  =o
     =object2>
       ISA    memory-object
       row    top
       column tens
       value  =t
     =object3>
       ISA    memory-object
       row    top
       column hundreds
       value  =h
     =object4>
       ISA    memory-object
       row    top
       column thousands
       value  =th
     !eval!      (get-right-answer)
     !eval!      (Actr-Time 4)
     !pop!
     !push!      =newgoal)

(P start-subtraction
     =goal>
       ISA         serial-subtraction
       column      nil
     =object1>
       ISA         memory-object
       row    top
       column ones
       value  =val1
     =object2>
       ISA    memory-object
       row    top
       column tens
       value  =val2
     =object3>
       ISA    memory-object
       row    top
       column hundreds
       value  =val3
     =object4>
       ISA    memory-object
       row    top
       column thousands
       value  =val4      
     !eval!   (parse-answer)
     !bind!   =o  (gv units-parse)
     !bind!   =t  (gv tens-parse)
     !bind!   =h  (gv hunds-parse)
     !bind!   =th (gv thous-parse)
==>
     =newgoal>
       ISA         subtract-column
       column      ones
       note        no-borrow
     =goal>
       column      tens
     =object1>
       ISA    memory-object
       row    top
       column ones
       value  =o
     =object2>
       ISA    memory-object
       row    top
       column tens
       value  =t
     =object3>
       ISA    memory-object
       row    top
       column hundreds
       value  =h
     =object4>
       ISA    memory-object
       row    top
       column thousands
       value  =th
     !push!         =newgoal
     !eval!         (get-right-answer))

(P recall-number1
     =goal>
       ISA         subtract-column
       top         nil
       column      =col
     =object>
       ISA         memory-object
       value       =num1
       row         top
       column      =col
     =num1>
       ISA         number
       value       =val
==>
     =goal>
       top         =num1
     !eval!         (grid-highlight =val))

(P recall-number2
     =goal>
        ISA         subtract-column
        bottom      nil
        column      =col
     =object>
        ISA         memory-object
        value       =num2
        column      =col
        row         bottom
==>
      =goal>
        bottom      =num2)

(P simple-subtract-note-borrow-ones-dm
     =goal>
       ISA         subtract-column
       column      ones
       top         =num1
       bottom      =num2
       diff        nil
       note        no-borrow
     =compare>
       ISA         comparison
       bigger      =num1
       smaller     =num2
     =fact>
       ISA         subtraction-fact
       top         =num1
       bottom      =num2
       diff        =diff
     =num1>
       ISA         number
       tens        number_1
     =diff>
       ISA         number
       value       =ans
     =col1>
       ISA         memory-object
       column      ones
       row         top
       value       =val
     =current>
       ISA         current-number
       ones        =o
       tens        =t
       hundreds    =h
       thousands   =th
==>
     =goal>
       diff        =diff
       note        borrow
     =current>
       ones        =diff
     =col1>
       value       =diff
     !eval!         (proc-ans *answer* 3 =diff)
     !eval!         (grid-highlight =ans))

(P simple-subtract-note-borrow-tens-dm
     =goal>
       ISA         subtract-column
       column      tens
       top         =num1
       bottom      =num2
       diff        nil
       note        no-borrow
     =compare>
       ISA         comparison
       bigger      =num1
       smaller     =num2
     =fact>
       ISA         subtraction-fact
       top         =num1
       bottom      =num2
       diff        =diff
     =num1>
       ISA         number
       tens        number_1
     =diff>
       ISA         number
       value       =ans
     =col2>
       ISA         memory-object
       column      tens
       row         top
       value       =val
     =current>
       ISA         current-number
       ones        =o
       tens        =t
       hundreds    =h
       thousands   =th
==>
     =goal>
       diff        =diff
       note        borrow
     =current>
       tens        =diff
     =col2>
       value       =diff
     !eval!         (proc-ans *answer* 2 =diff)
     !eval!         (grid-highlight =ans))

(P simple-subtract-note-borrow-hundreds-dm
     =goal>
       ISA         subtract-column
       column      hundreds
       top         =num1
       bottom      =num2
       diff        nil
       note        no-borrow
     =compare>
       ISA         comparison
       bigger      =num1
       smaller     =num2
     =fact>
       ISA         subtraction-fact
       top         =num1
       bottom      =num2
       diff        =diff
     =num1>
       ISA         number
       tens        number_1
     =diff>
       ISA         number
       value       =ans
     =col3>
       ISA         memory-object
       column      hundreds
       row         top
       value       =val
     =current>
       ISA         current-number
       ones        =o
       tens        =t
       hundreds    =h
       thousands   =th
==>
     =goal>
       diff        =diff
       note        borrow
     =current>
       hundreds    =diff
     =col3>
       value       =diff
     !eval!         (proc-ans *answer* 1 =diff)
     !eval!         (grid-highlight =ans))

(P simple-subtract-note-borrow-thousands-dm
     =goal>
       ISA         subtract-column
       column      thousands
       top         =num1
       bottom      =num2
       diff        nil
       note        no-borrow
     =compare>
       ISA         comparison
       bigger      =num1
       smaller     =num2
     =fact>
       ISA         subtraction-fact
       top         =num1
       bottom      =num2
       diff        =diff
     =num1>
       ISA         number
       tens        number_1
     =diff>
       ISA         number
       value       =ans
     =col4>
       ISA         memory-object
       column      thousands
       row         top
       value       =val
     =current>
       ISA         current-number
       ones        =o
       tens        =t
       hundreds    =h
       thousands   =th
==>
     =goal>
       diff        =diff
       note        borrow
     =current>
       thousands   =diff
     =col4>
       value       =diff
     !eval!         (grid-highlight =ans)
     !eval!         (proc-ans *answer* 0 =diff))

(P simple-subtract-no-borrow-ones-dm
     =goal>
       ISA         subtract-column
       column      ones
       top         =num1
       bottom      =num2
       diff        nil
       note        no-borrow
     =compare>
       ISA         comparison
       bigger      =num1
       smaller     =num2
     =fact>
       ISA         subtraction-fact
       top         =num1
       bottom      =num2
       diff        =diff
     =num1>
       ISA         number
       tens        number_0
     =diff>
       ISA         number
       value       =ans
     =col1>
       ISA         memory-object
       column      ones
       row         top
       value       =val
     =current>
       ISA         current-number
       ones        =o
       tens        =t
       hundreds    =h
       thousands   =th
==>
     =goal>
       diff        =diff
       note        no-borrow
     =current>
       ones        =diff
     =col1>
       value       =diff
     !eval!         (proc-ans *answer* 3 =diff)
     !eval!         (grid-highlight =ans))

(P simple-subtract-no-borrow-tens-dm
     =goal>
       ISA         subtract-column
       column      tens
       top         =num1
       bottom      =num2
       diff        nil
       note        no-borrow
     =compare>
       ISA         comparison
       bigger      =num1
       smaller     =num2
     =fact>
       ISA         subtraction-fact
       top         =num1
       bottom      =num2
       diff        =diff
     =num1>
       ISA         number
       tens        number_0
     =diff>
       ISA         number
       value       =ans
     =col2>
       ISA         memory-object
       column      tens
       row         top
       value       =val
     =current>
       ISA         current-number
       ones        =o
       tens        =t
       hundreds    =h
       thousands   =th
==>
     =goal>
       diff        =diff
       note        no-borrow
     =current>
       tens        =diff
     =col2>
       value       =diff
     !eval!         (proc-ans *answer* 2 =diff)
     !eval!         (grid-highlight =ans))

(P simple-subtract-no-borrow-hundreds-dm
     =goal>
       ISA         subtract-column
       column      hundreds
       top         =num1
       bottom      =num2
       diff        nil
       note        no-borrow
     =compare>
       ISA         comparison
       bigger      =num1
       smaller     =num2
     =fact>
       ISA         subtraction-fact
       top         =num1
       bottom      =num2
       diff        =diff
     =num1>
       ISA         number
       tens        number_0
     =diff>
       ISA         number
       value       =ans
     =col3>
       ISA         memory-object
       column      hundreds
       row         top
       value       =val
     =current>
       ISA         current-number
       ones        =o
       tens        =t
       hundreds    =h
       thousands   =th
==>
     =goal>
       diff        =diff
       note        no-borrow
     =current>
       hundreds    =diff
     =col3>
       value       =diff
     !eval!         (proc-ans *answer* 1 =diff)
     !eval!         (grid-highlight =ans))

(P simple-subtract-no-borrow-thousands-dm
     =goal>
       ISA         subtract-column
       column      thousands
       top         =num1
       bottom      =num2
       diff        nil
       note        no-borrow
     =compare>
       ISA         comparison
       bigger      =num1
       smaller     =num2
     =fact>
       ISA         subtraction-fact
       top         =num1
       bottom      =num2
       diff        =diff
     =num1>
       ISA         number
       tens        number_0
     =diff>
       ISA         number
       value       =ans
     =col4>
       ISA         memory-object
       column      thousands
       row         top
       value       =val
     =current>
       ISA         current-number
       ones        =o
       tens        =t
       hundreds    =h
       thousands   =th
==>
     =goal>
       diff        =diff
       note        no-borrow
     =current>
       thousands   =diff
     =col4>
       value       =diff
     !eval!         (proc-ans *answer* 0 =diff)
     !eval!         (grid-highlight =ans))

;; the count strategy  -----------{

(P simple-subtract-note-borrow-c
     =goal>
       ISA         subtract-column
       column      =col
       top         =num1
       bottom      number_7
       diff        nil
       note        no-borrow
     =compare>
       ISA         comparison
       bigger      =num1
       smaller     number_7
     =num1>
       ISA         number
       tens        number_1
==>
     =newgoal>
       ISA         sub-by-count
       start       =num1
       count       number_7
       column      =col
       note        borrow
     !push!         =newgoal)

(P simple-subtract-no-borrow-c
     =goal>
       ISA         subtract-column
       column      =col
       top         =num1
       bottom      number_7
       diff        nil
       note        no-borrow
     =compare>
       ISA         comparison
       bigger      =num1
       smaller     number_7
     =num1>
       ISA         number
       tens        number_0
       value       =val
==>
     =newgoal>
       ISA         sub-by-count
       start       =num1
       count       number_7
       column      =col
       note        no-borrow
     !push!         =newgoal)

(P count
     =goal>
       ISA         sub-by-count
       start       =num
       count       =count
     =count>
       ISA         number
    -  value       0
     =decrement-num>
       ISA         subtraction-fact
       top         =num
       bottom      number_1
       diff        =newnum
     =newnum>
       ISA         number
       value       =val
     =decrement-count>
       ISA         subtraction-fact
       top         =count
       bottom      number_1
       diff        =newcount
==>
     =goal>
       start       =newnum
       count       =newcount
     !output!       ("*** counting:   ~A" =newnum)
     !eval!         (grid-highlight =val))

(P stop-count-ones
     =goal>
       ISA         sub-by-count
       start       =num
       count       number_0
       column      ones
       note        =note
     =num>
       ISA         number
       value       =ans
     =col1>
       ISA         memory-object
       column      ones
       row         top
       value       =val
     =current>
       ISA         current-number
       ones        =o
       tens        =t
       hundreds    =h
       thousands   =th
==>
     =col1>
       value       =num
     =current>
       ones        =num
     !output!       ("column ones answer: ~A~%" =num)
     !eval!         (proc-ans *answer* 3 =num)
     !eval!         (grid-highlight =ans)
     !pop!
     =old-goal>
       ISA         subtract-column
       column      tens
       note        =note
     !push!         =old-goal)

(P stop-count-tens
     =goal>
       ISA         sub-by-count
       start       =num
       count       number_0
       column      tens
       note        =note
     =num>
       ISA         number
       value       =ans
     =col2>
       ISA         memory-object
       column      tens
       row         top
       value       =val
     =current>
       ISA         current-number
       ones        =o
       tens        =t
       hundreds    =h
       thousands   =th
==>
     =col2>
       value       =num
     =current>
       tens        =num
     !output!       ("column tens answer: ~A~%" =num)
     !eval!         (proc-ans *answer* 2 =num)
     !eval!         (grid-highlight =ans)
     !pop!
     =old-goal>
       ISA         subtract-column
       column      hundreds
       note        =note
     !push!         =old-goal)

(P stop-count-hundreds
     =goal>
       ISA         sub-by-count
       start       =num
       count       number_0
       column      hundreds
       note        =note
     =num>
       ISA         number
       value       =ans
     =col3>
       ISA         memory-object
       column      hundreds
       row         top
       value       =val
     =current>
       ISA         current-number
       ones        =o
       tens        =t
       hundreds    =h
       thousands   =th
==>
     =col3>
       value       =num
     =current>
       hundreds    =num
     !output!       ("column hundreds answer: ~A~%" =num)
     !eval!         (proc-ans *answer* 1 =num)
     !eval!         (grid-highlight =ans)
     !pop!
     =old-goal>
       ISA         subtract-column
       column      thousands
       note        =note
     !push!         =old-goal)

;; end count strategy  -----------}


(P subtract-with-borrow
     =goal>
       ISA         subtract-column
       top         =num1
       bottom      =num2
       diff        nil
       note        no-borrow
     =compare>
       ISA         comparison
       bigger      =num2
       smaller     =num1
     =fact>
       ISA         add-ten
       num         =num1
       sum         =newtop
     =newtop>
       ISA         number
       value       =val
     !eval!         (not (equal =num1 =num2))
==>
     =goal>
       top         =newtop
     !eval!         (grid-highlight =val))

(P process-borrow
     =goal>
       ISA         subtract-column
       column      =col
       top         =num1
       bottom      =num2
       diff        nil
       note        borrow
     =num1>
       ISA         number
    - units       number_0
     =fact>
       ISA         subtraction-fact
       top         =num1
       bottom      number_1
       diff        =newtop
     =newtop>
       ISA         number
       value       =val
==>
     =goal>
       top         =newtop
       note        no-borrow
     !eval!         (grid-highlight =val))

(P process-borrow-with-number_0
     =goal>
       ISA         subtract-column
       column      =col
       top         =num1
       bottom      =num2
       diff        nil
       note        borrow
     =num1>
       ISA         number
       tens        number_0
       units       number_0
     =fact1>
       ISA         add-ten
       num         =num1
       sum         =sum
     =fact2>
       ISA         subtraction-fact
       top         =sum
       bottom      number_1
       diff        =newtop
     =next>
       ISA         next-info
       before      =col
       after       =nextcol
     =number_1-over>
       ISA         memory-object
       column      =nextcol
       row         top
       value       =val
     =val>
       ISA         number
    - units       number_0
     =fact3>
       ISA         subtraction-fact
       top         =val
       bottom      number_1
       diff        =newval
==>
     =goal>
       top         =newtop
       note        no-borrow
     =number_1-over>
       value       =newval)

(P process-borrow-with-number_0-number_0
     =goal>
       ISA         subtract-column
       column      =col
       top         =num1
       bottom      =num2
       diff        nil
       note        borrow
     =num1>
       ISA         number
       tens        number_0
       units       number_0
     =fact1>
       ISA         add-ten
       num         =num1
       sum         =sum
     =fazt2>
       ISA         subtraction-fact
       top         =sum
       bottom      number_1
       diff        =newtop
     =next1>
       ISA         next-info
       before      =col
       after       =number_1-over-col
     =number_1-over>
       ISA         memory-object
       column      =number_1-over-col
       row         top
       value       =val-number_1-over
     =val-number_1-over>
       ISA         number
       units       number_0
     =fact3>
       ISA         add-ten
       num         =val-number_1-over
       sum         =sum-number_1-over
     =fact4>
       ISA         subtraction-fact
       top         =sum-number_1-over
       bottom      number_1
       diff        =new-val-number_1-over
     =next2>
       ISA         next-info
       before      =number_1-over-col
       after       =number_2-over-col
     =number_2-over>
       ISA         memory-object
       column      =number_2-over-col
       row         top
       value       =val-number_2-over
     =fact5>
       ISA         subtraction-fact
       top         =val-number_2-over
       bottom      number_1
       diff        =new-val-number_2-over
==>
     =goal>
       top         =newtop
       note        no-borrow
     =number_1-over>
       value       =new-val-number_1-over
     =number_2-over>
       value       =new-val-number_2-over)

(P last-column-no-borrow
     =goal>
       ISA         subtract-column
       top         =num
       bottom      -
       column      =col
       note        no-borrow
     =current>
       ISA         current-number
       ones        =o
       tens        =t
       hundreds    =h
       thousands   =th
==>
     =newgoal>
       ISA         serial-subtraction
       column      nil
     =goal>
       diff        =num
     =current>
       thousands   =num
     !output!       ( "~%~%Model Speaks: *** ~s ~s ~s ~s ***~%" =num =h =t =o)
     !eval!         (update-interface =num)
     !pop!
     !focus-on!     =newgoal
     !eval!         (check-answer)
     !eval!         (Actr-time 2))

(P last-column-with-borrow
     =goal>
       ISA         subtract-column
       top         =num
       bottom      -
       column      =col
       note        borrow
     =fact>
       ISA         subtraction-fact
       top         =num
       bottom      number_1
       diff        =diff
     =current>
       ISA         current-number
       ones        =o
       tens        =t
       hundreds    =h
       thousands   =th
==>
     =newgoal>
       ISA         serial-subtraction
       column      nil
     =goal>
       diff        =diff
     =current>
       thousands   =diff
     !output!       ( "~%~%Model Speaks: *** ~s ~s ~s ~s ***~%" =diff =h =t =o)
     !eval!         (update-interface =diff)
     !pop!
     !focus-on!     =newgoal
     !eval!         (check-answer)
     !eval!         (Actr-time 2))

(P next-column-no-borrow
     =goal>
       ISA         subtract-column
       column      =pos1
       diff        =diff
       note        no-borrow
     =next>
       ISA         next-info
       before      =pos1
       after       =pos2
==>
     =newgoal>
       ISA         subtract-column
       column      =pos2
       note        no-borrow
     !focus-on!     =newgoal)

(P next-column-with-borrow
     =goal>
       ISA         subtract-column
       column      =pos1
       diff        =diff
       note        borrow
     =next>
       ISA         next-info
       before      =pos1
       after       =pos2
==>
     =newgoal>
       ISA         subtract-column
       column      =pos2
       note        borrow
       !focus-on!     =newgoal)


;;;
;;;	V.	production parameters
;;;

;; Set the parameters of the count productions to reflect the estimation of
;; increased time spent achieving an answer via the count strategey, rather
;; then the rule-retrieval method.

(parameters simple-subtract-note-borrow-c :b 2.5)
(parameters simple-subtract-no-borrow-c :b 2.5)
(spp count :effort 0.15)


;; Disable worry, for starters, then set the goal.
;; Worry is disabled only if the worry check box
;; is in the off position on the interface.

(unless (gv wor-chk :value)
    (PDisable worry))

(goal-focus goal)

