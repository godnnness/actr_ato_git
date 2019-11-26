(clear-all)

(define-model SP

(sgp :v nil :esc t :lf 0.4 :bll 0.5 :ans 0.5 :rt 0 :ncnar nil :trace-detail high)

(sgp :show-focus t)

(chunk-type goal state acspeed)
(chunk-type judge pn  property)
(chunk-type speed-diff speed distance level)
(chunk-type goal state count target)

(add-dm
   (a ISA judge pn "-"  property "down")
   (b ISA judge pn "0"  property "keep")
   (c ISA judge pn "+" property "up")
   (d ISA judge pn "EB" property "EB")

 (goal isa goal)
 (attending)(count) (counting))
(set-visloc-default screen-x lowest)

(P attend-speed-diff
   =goal>
      ISA       goal
      state     nil
   =visual-location>
   ?visual>
      state       free
==>
   =goal>
      state       attending
   +visual>
      cmd         move-attention
      screen-pos  =visual-location

)

(P encode-delta-speed-attend-distance
   =goal>
      ISA         goal
      state       attending
   =visual>
      ISA         visual-object
      value       =delta-speed
   ?imaginal>
      buffer     empty
      state       free
==>
   =goal>
      state        nil
   +imaginal>
      isa          speed-diff
      speed      =delta-speed
   +visual-location>
     ISA         visual-location
     > screen-x    current
     screen-y    current

   !output!       (the value is =delta-speed)
)

(P encode-distance-attend-EB
   =goal>
     ISA         goal
     state       attending
   =visual>
     ISA         visual-object
     value       =distance
   =imaginal>
     isa          speed-diff
     distance      nil
   ?visual>
     state       free

==>
   =imaginal>
     distance       =distance
   =goal>
     state       nil
   +visual-location>
      ISA         visual-location
      screen-y     current
     > screen-x    current
)

(P encode-EB
   =goal>
     ISA         goal
     state       attending
   =imaginal>
     isa          speed-diff
     speed          =speed
     distance       =distance
   =visual>
     ISA         visual-object
     value       =level
   ?visual>
     state       free
   ;;!eval! (< =distance  =level)
==>
   =imaginal>
     level          =level
   =goal>
     acspeed      =speed
     state       count
   +visual>
     cmd         clear
)

(P start-counting
   =goal>
     ISA         goal
     state       count

   =imaginal>
     isa          speed-diff
     speed          =speed
     distance       =distance


   ?manual>
     state       free
==>
   +goal>
   +manual>
     cmd         press-key
     key         "k"
)





(goal-focus goal)
)