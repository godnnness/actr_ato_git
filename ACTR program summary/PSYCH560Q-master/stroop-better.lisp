;;; ======================================================================== ;;;
;;; Stroop, well done
;;; ======================================================================== ;;;
;;; Does nothing, except randomly responding to the stimuli.
;;; ======================================================================== ;;;

(clear-all)

(define-model stroop-model

(sgp :esc t
	 :er t
	 :visual-activation 3.0
	 :mas 3.0
	 :blc 1000.0
	 :auto-attend t
     )


(chunk-type color-name
			kind
		    concept
			name)

;;; ===  CHUNKS ============================================================ ;;;

(add-dm (blue-color-name isa color-name
						 kind color-name
						 concept blue
						 name "blue")
		(red-color-name isa color-name
						kind color-name
						concept red
						name "red")
		(green-color-name isa color-name
						  kind color-name
						  concept green
						  name "green"))

(add-sji (green green-color-name 1.0)
		 (red red-color-name 1.0)
		 (blue blue-color-name 1.0))



;;; === Productions ======================================================== ;;;

(p check-the-screen
   "Checks whatever is on the screen"
   ?visual>
     state          free
     buffer         empty

   ?visual-location>
     state          free

   ?manual>
     preparation free
     processor free
     execution free	 
==>
   +visual-location>
     kind           text
     screen-y       lowest
)


;;; --- Focus on color and retrieve color name -------------------------------



(p retrieve-color-name
   "Retrieves the name of a color"
   =visual>
     text t
   - color black
     color =COLOR	 

   ?manual>
     preparation free
     processor free
     execution free

   ?retrieval>
     state free
     buffer empty

   ?visual>
     state free	  
==>
   =visual>   

   +retrieval>
     kind color-name
     ;concept =COLOR
)

;;; --- Respond based on color name ------------------------------ ;;;

(p respond-red
   "Responds to red"
   =visual>
     text t
   - color black

   =retrieval>
     isa color-name
     name "red"

   ?manual>
     preparation free
     processor free
     execution free
==>
   +manual>
     cmd punch
	 hand right
     finger index
   -retrieval>
   -visual>	 
)

(p respond-blue
   "Responds 'BLUE'"
   =visual>
     text t
   - color black

   =retrieval>
     isa color-name
     name "blue"
   
   ?manual>
     preparation free
     processor free
     execution free
==>
   +manual>
     cmd punch
	 hand right
     finger middle
   -retrieval>
   -visual>	 
)



(p respond-green
   "Responds randomly"
   =visual>
     text t
   - color black

   =retrieval>
     isa color-name
     name "green"
   
   ?manual>
     preparation free
     processor free
     execution free
==>
   +manual>
     cmd punch
	 hand right
     finger ring
   -retrieval>
   -visual>	 
)

;;; --- DONE! -------------------------------------------------------------- ;;;

(p done
   "Detects when the experiment is done"
   =visual>
     text t
     value "done"
     color black

   ?visual>
     state free
	 
   ?manual>
     preparation free
     processor free
     execution free	 
==>
   !stop!
)


) ;; End of model
