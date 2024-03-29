(clear-all)
(require-extra "emma")
;;(require-extra "threads")

(define-model actr-parking

(sgp :v t :esc t :egs 3 :show-focus t :ul t :ult t :needs-mouse t :visual-num-finsts 10 :trace-detail high :emma t :auto-attend t
:saccade-feat-time 0.01  :saccade-init-time 0.01 :eye-spot-color "yellow" )


(chunk-type try-strategy strategy state)
(chunk-type encoding a-loc b-loc c-loc  d-loc e-loc f-loc g-loc h-loc goal-loc length over under)

(define-chunks
    (goal isa try-strategy state start)
    (start) (find-line) (looking) (attending)
    (encode-under) (encode-over) (choose-strategy)
    (calculate-difference) (consider-next) (check-for-done)
    (read-done) (evaluate-c) (evaluate-d)(evaluate-e)(evaluate-f)(evaluate-g)(evaluate-h)(prepare-mouse) (evaluate-a)
    (over) (under) (move-mouse) (wait-for-click))

(set-visloc-default :attended nil)


(p start-trial
   =goal>
      isa      try-strategy
      state    start
   ?visual-location>
      buffer   unrequested
  ==>
   =goal>
      state    find-line
)

(p find-next-line
   =goal>
      isa       try-strategy
      state     find-line
  ==>
   +visual-location>
      isa       visual-location
      :attended nil
      kind      line
      screen-y  lowest
   =goal>
      state     looking
)


(p attend-line
   =goal>
      isa        try-strategy
      state      looking
   =visual-location>
   ?visual>
      state      free
  ==>
   =goal>
      state      attending
   +visual>
      isa        move-attention
      screen-pos =visual-location)

(p encode-line-a
   =goal>
      isa        try-strategy
      state      attending
   =visual>
      isa        line
      screen-pos =pos
   ?imaginal>
      buffer     empty
      state      free
  ==>
   +imaginal>
      isa        encoding
      a-loc      =pos
   =goal>
      state      find-line)

(p encode-line-b
   =goal>
      isa        try-strategy
      state      attending
   =imaginal>
      isa        encoding
      a-loc      =a
      b-loc      nil
   =visual>
      isa        line
      screen-pos =pos
  ==>
   =imaginal>
      b-loc      =pos
   =goal>
      state      find-line)


(p encode-line-c
   =goal>
      isa        try-strategy
      state      attending
   =imaginal>
      isa        encoding
      b-loc      =b
      c-loc      nil
   =visual>
      isa        line
      screen-pos =pos
  ==>
   =imaginal>
      c-loc      =pos
   =goal>
      state      find-line)

(p encode-line-d
   =goal>
      isa        try-strategy
      state      attending
   =imaginal>
      isa        encoding
      c-loc      =c
      d-loc      nil
   =visual>
      isa        line
      screen-pos =pos
  ==>
   =imaginal>
      d-loc      =pos
   =goal>
      state      find-line)

(p encode-line-e
   =goal>
      isa        try-strategy
      state      attending
   =imaginal>
      isa        encoding
      d-loc      =d
      e-loc   nil
   =visual>
      isa        line
      screen-pos =pos
  ==>
   =imaginal>
      e-loc      =pos
   =goal>
      state      find-line)

(p encode-line-f
   =goal>
      isa        try-strategy
      state      attending
   =imaginal>
      isa        encoding
      e-loc      =e
      f-loc   nil
   =visual>
      isa        line
      screen-pos =pos
  ==>
   =imaginal>
      f-loc      =pos
   =goal>
      state      find-line)

(p encode-line-g
   =goal>
      isa        try-strategy
      state      attending
   =imaginal>
      isa        encoding
      f-loc      =f
      g-loc   nil
   =visual>
      isa        line
      screen-pos =pos
  ==>
   =imaginal>
      g-loc      =pos
   =goal>
      state      find-line)

(p encode-line-h
   =goal>
      isa        try-strategy
      state      attending
   =imaginal>
      isa        encoding
      g-loc      =g
      h-loc   nil
   =visual>
      isa        line
      screen-pos =pos
  ==>
   =imaginal>
      h-loc      =pos
   =goal>
      state      find-line)


(p encode-line-goal
   =goal>
      isa        try-strategy
      state      attending
   =imaginal>
      isa        encoding
      h-loc      =h
      goal-loc   nil
   =visual>
      isa        line
      screen-pos =pos
      width      =length
   ?visual>
      state      free
  ==>
   =imaginal>
      goal-loc   =pos
      length     =length
   =goal>
      state      encode-over
   +visual>
      isa        move-attention
      screen-pos =h)

(p encode-over
   =goal>
      isa      try-strategy
      state    encode-over
   =imaginal>
      isa      encoding
      length   =goal-len
   =visual>
      isa      line
      width    =b-len
  ==>
   !bind! =val (- =b-len =goal-len)
   =imaginal>
      over     =val
   =goal>
      state    choose-strategy)

(p decide-over
   =goal>
      isa       try-strategy
      state     choose-strategy
      strategy  nil
   =imaginal>
      isa       encoding
      over      =over
   !eval! (> =over 0)
  ==>
   =imaginal>
   =goal>
      state     prepare-mouse
      strategy  over
   +visual-location>
      isa       visual-location
      kind      oval
      value     "b")

(p force-over
   =goal>
      isa       try-strategy
      state     choose-strategy
    - strategy  over
  ==>
   =goal>
      state     prepare-mouse
      strategy  over
   +visual-location>
      isa       visual-location
      kind      oval
      value     "b")

(p encode-line-current
   =goal>
      isa        try-strategy
      state      attending
   =imaginal>
      isa        encoding
      goal-loc   =goal-loc
   =visual>
      isa        line
      width      =current-len
   ?visual>
      state      free
  ==>
   =imaginal>
      length     =current-len
   =goal>
      state      calculate-difference
   +visual>
      isa        move-attention
      screen-pos =goal-loc)


(p calculate-difference
   =goal>
      isa      try-strategy
      state    calculate-difference
   =imaginal>
      isa      encoding
      length   =current-len
   =visual>
      isa      line
      width    =goal-len
  ==>
   !bind! =val (- =current-len =goal-len)
   !output! (currentlen - goallen is =val and current-len is =current-len and goal-len is =goal-len)
   =imaginal>
      length   =val
   =goal>
      state    consider-next)

(p check-for-done
   =goal>
      isa       try-strategy
      state     consider-next
   =imaginal>
      isa       encoding
      <= length    0
  ==>
   =goal>
      state     check-for-done
   +visual-location>
      isa       visual-location
      value     "done")

(p find-done
   =goal>
      isa        try-strategy
      state      check-for-done
   =visual-location>
   ?visual>
      state      free
  ==>
   +visual>
      isa        move-attention
      screen-pos =visual-location
   =goal>
      state      read-done)

(p read-done
   =goal>
      isa    try-strategy
      state  read-done
   =visual>
      isa    text
      value  "done"
  ==>
  !stop!
   +goal>
      isa    try-strategy
      state  start
   )

(p consider-c
   =goal>
      isa        try-strategy
      state      consider-next
   =imaginal>
      isa        encoding
      c-loc      =c-loc
    > length     0
   ?visual>
       state     free
  ==>
   =imaginal>
   =goal>
      state      evaluate-c
   +visual>
      isa        move-attention
      screen-pos =c-loc)

(p choose-c
   =goal>
      isa       try-strategy
      state     evaluate-c
   =imaginal>
      isa       encoding
      length    =difference
   =visual>
      isa       line
   <= width     =difference
  ==>
   =imaginal>
   =goal>
      state     prepare-mouse
   +visual-location>
      isa       visual-location
      kind      oval
      value     "c")

(p consider-a
   =goal>
      isa        try-strategy
      state      evaluate-c
   =imaginal>
      isa        encoding
      a-loc      =a-loc
      length     =difference
   =visual>
      isa        line
    > width      =difference
   ?visual>
      state      free
  ==>
   =imaginal>
   =goal>
      state      evaluate-a
   +visual>
      isa        move-attention
      screen-pos =a-loc)

(p choose-a
   =goal>
      isa       try-strategy
      state     evaluate-a
   =imaginal>
      isa       encoding
      length    =difference
   =visual>
      isa       line
   <= width     =difference
  ==>
   =imaginal>
   =goal>
      state     prepare-mouse
   +visual-location>
      isa       visual-location
      kind      oval
      value     "a")


(p consider-d
   =goal>
      isa        try-strategy
      state      evaluate-a
   =imaginal>
      isa        encoding
      d-loc      =d-loc
      length     =difference
   =visual>
      isa        line
    > width      =difference
   ?visual>
      state      free
  ==>
   =imaginal>
   =goal>
      state      evaluate-d
   +visual>
      isa        move-attention
      screen-pos =d-loc)

(p choose-d
   =goal>
      isa       try-strategy
      state     evaluate-d
   =imaginal>
      isa       encoding
      length    =difference
   =visual>
      isa       line
   <= width     =difference
  ==>
   =imaginal>
   =goal>
      state     prepare-mouse
   +visual-location>
      isa       visual-location
      kind      oval
      value     "d")

(p consider-e
   =goal>
      isa        try-strategy
      state      evaluate-d
   =imaginal>
      isa        encoding
      e-loc      =e-loc
      length     =difference
   =visual>
      isa        line
    > width      =difference
   ?visual>
      state      free
  ==>
   =imaginal>
   =goal>
      state      evaluate-e
   +visual>
      isa        move-attention
      screen-pos =e-loc)

(p choose-e
   =goal>
      isa       try-strategy
      state     evaluate-e
   =imaginal>
      isa       encoding
      length    =difference
   =visual>
      isa       line
   <= width     =difference
  ==>
   =imaginal>
   =goal>
      state     prepare-mouse
   +visual-location>
      isa       visual-location
      kind      oval
      value     "e")

(p consider-f
   =goal>
      isa        try-strategy
      state      evaluate-e
   =imaginal>
      isa        encoding
      f-loc      =f-loc
      length     =difference
   =visual>
      isa        line
    > width      =difference
   ?visual>
      state      free
  ==>
   =imaginal>
   =goal>
      state      evaluate-f
   +visual>
      isa        move-attention
      screen-pos =f-loc)

(p choose-f
   =goal>
      isa       try-strategy
      state     evaluate-f
   =imaginal>
      isa       encoding
      length    =difference
   =visual>
      isa       line
   <= width     =difference
  ==>
   =imaginal>
   =goal>
      state     prepare-mouse
   +visual-location>
      isa       visual-location
      kind      oval
      value     "f")

(p consider-g
   =goal>
      isa        try-strategy
      state      evaluate-f
   =imaginal>
      isa        encoding
      g-loc      =g-loc
      length     =difference
   =visual>
      isa        line
    > width      =difference
   ?visual>
      state      free
  ==>
   =imaginal>
   =goal>
      state      evaluate-g
   +visual>
      isa        move-attention
      screen-pos =g-loc)

(p choose-g
   =goal>
      isa       try-strategy
      state     evaluate-g
   =imaginal>
      isa       encoding
      length    =difference
   =visual>
      isa       line
   <= width     =difference
  ==>
   =imaginal>
   =goal>
      state     prepare-mouse
   +visual-location>
      isa       visual-location
      kind      oval
      value     "g")

(p consider-h
   =goal>
      isa        try-strategy
      state      evaluate-g
   =imaginal>
      isa        encoding
      h-loc      =h-loc
      length     =difference
   =visual>
      isa        line
    > width      =difference
   ?visual>
      state      free
  ==>
   =imaginal>
   =goal>
      state      evaluate-h
   +visual>
      isa        move-attention
      screen-pos =h-loc)

(p choose-h
   =goal>
      isa       try-strategy
      state     evaluate-h
   =imaginal>
      isa       encoding
      length    =difference
   =visual>
      isa       line
   <= width     =difference
  ==>
   =imaginal>
   =goal>
      state     prepare-mouse
   +visual-location>
      isa       visual-location
      kind      oval
      value     "h")

(p reset
   =goal>
      isa       try-strategy
      state     evaluate-h
   =imaginal>
      isa       encoding
      length    =difference
   =visual>
      isa       line
    > width     =difference
  ==>
   =imaginal>
   =goal>
      state     prepare-mouse
   +visual-location>
      isa       visual-location
      kind      oval
      value     "reset")



(p move-mouse
   =goal>
      isa        try-strategy
      state      prepare-mouse
   =visual-location>
   ?visual>
      state      free
   ?manual>
      state      free
  ==>
   +visual>
      isa        move-attention
      screen-pos =visual-location
   =goal>
      state      move-mouse
   +manual>
      isa        move-cursor
      loc        =visual-location)

(p click-mouse
   =goal>
      isa    try-strategy
      state  move-mouse
   ?manual>
      state  free
  ==>
   =goal>
      state  wait-for-click
   +manual>
      isa    click-mouse)

(p look-for-current
   =goal>
      isa       try-strategy
      state     wait-for-click
   ?manual>
      state     free
   =visual>
      - value "reset"
  ==>
   +visual-location>
      isa       visual-location
      kind      line
      screen-y  highest
   =goal>
      state     looking)

(p pick-another-strategy
   =goal>
      isa      try-strategy
      state    wait-for-click
   ?manual>
      state    free
   =visual>
      value    "reset"
  ==>
   =goal>
      state    choose-strategy)


(goal-focus goal)

(spp decide-over :u 13)
(spp force-over :u 10)


(spp pick-another-strategy :reward 0)
(spp read-done :reward 100))
