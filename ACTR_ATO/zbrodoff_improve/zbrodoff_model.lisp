
(clear-all)

(define-model zbrodoff
    
(sgp :v nil :esc t :lf 0.4 :bll 0.5 :ans 0.5 :rt 0 :ncnar nil)

(sgp :show-focus t)

(chunk-type problem arg1 arg2 result)
(chunk-type goal state count target)
(chunk-type sequence identity next)

(add-dm
 (zero  ISA sequence identity "0" next "1")
 (one   ISA sequence identity "1" next "2")
 (two   ISA sequence identity "2" next "3")
 (three ISA sequence identity "3" next "4")
 (four  ISA sequence identity "4" next "5")
 (a ISA sequence identity "a" next "b")
 (b ISA sequence identity "b" next "c")
 (c ISA sequence identity "c" next "d")
 (d ISA sequence identity "d" next "e")
 (e ISA sequence identity "e" next "f")
 (f ISA sequence identity "f" next "g")
 (g ISA sequence identity "g" next "h")
 (h ISA sequence identity "h" next "i")
 (i ISA sequence identity "i" next "j")
 (j ISA sequence identity "j" next "k")
 (goal isa goal)
 (attending) (count) (counting))

(set-visloc-default screen-x lowest)

(P attend
   =goal>
      ISA         goal
      state       nil
   =visual-location>
   ?visual>
       state      free
==>
   =goal>
      state       attending
   +visual>
      cmd         move-attention
      screen-pos  =visual-location
)

(P read-first
   =goal>
     ISA         goal
     state       attending
   =visual>
     ISA         visual-object
     value       =char
   ?vocal>
     state      free
   ?imaginal>
     buffer     empty
     state      free   
==>
   +vocal>
     cmd         subvocalize
     string      =char
   +imaginal>
     isa         problem 
     arg1        =char
   =goal>
     state       nil
   +visual-location>
     ISA         visual-location
   > screen-x    current
     screen-x    lowest
   - value       "+"
)


(P read-second
   =goal>
     ISA         goal
     state       attending
   =visual>
     ISA         visual-object
     value       =char
   =imaginal>
     isa         problem
     arg2        nil
   ?vocal>
     state       free
==>
   +vocal>
     cmd         subvocalize
     string      =char
   =imaginal>
     arg2       =char
   =goal>
     state       nil
   +visual-location>
     ISA         visual-location
     screen-x    highest
)


(P read-third
   =goal>
     ISA         goal
     state       attending
   =imaginal>
     isa         problem
     arg1        =arg1
     arg2        =arg2
   =visual>
     ISA         visual-object
     value       =char
   ?vocal>
     state       free
   ?visual>
     state       free
==>
   =imaginal>
   +vocal>
     cmd         subvocalize
     string      =char
   =goal>
     target      =char
     state       count
   +visual>
     cmd         clear
)


(P start-counting
   =goal>
     ISA         goal
     state       count
   
   =imaginal>
     isa         problem
     arg1        =a
     arg2        =val

   ?vocal>
     state      free
==>
   +vocal>
     cmd         subvocalize
     string      =a
   =imaginal>
     result      =a
   =goal>
     count       "0"
     state       counting
   +retrieval>
     ISA         sequence
     identity    =a
)

(P update-result
   =goal>
     ISA         goal
     count       =val
   =imaginal>
     isa         problem
     result      =let
   - arg2        =val
   =retrieval>
     ISA         sequence
     identity    =let
     next        =new
   ?vocal>
     state       free
==>
   +vocal>
     cmd         subvocalize
     string      =new
   =imaginal>
     result      =new
   +retrieval>
     ISA         sequence
     identity    =val
)

(P update-count
   =goal>
     ISA         goal
     count       =val
   =imaginal>
     isa         problem
     result      =ans
   =retrieval>
     ISA         sequence
     identity    =val
     next        =new
   ?vocal>
     state       free
==>
   +vocal>
     cmd         subvocalize
     string      =new
   =imaginal>
   =goal>
     count       =new
   +retrieval>
     ISA         sequence
     identity    =ans
)


(P final-answer-yes
   =goal>
     ISA         goal
     target      =let
     count       =val
   =imaginal>
     isa         problem
     result      =let
     arg2        =val
   ?vocal>
     state       free
   
   ?manual>
     state       free
   ==>
   +goal>
     
   +manual>
     cmd         press-key
     key         "k"
   
)

(P final-answer-no
    =goal>
     ISA         goal
     count       =val
     target      =let
   =imaginal>
     isa         problem
   - result      =let
   - result      nil
     arg2        =val
   ?vocal>
     state       free
   
   ?manual>
     state       free
   ==>
   +goal>
     
   +manual>
     cmd         press-key
     key         "d"
   
)

(set-all-base-levels 100000 -1000)
(goal-focus goal)
)
