(: fromNumber (-> Number Atom))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))
;; Knowledge base

!(bind! &kb (new-space))     

!(add-atom &kb (: Fact1 (Student Alice)))
!(add-atom &kb (: Fact2 (Student Bob)))
!(add-atom &kb (: Fact3 (Student Carol)))
!(add-atom &kb (: Fact4 (Teacher Dr_Smith)))
!(add-atom &kb (: Fact5 (Teacher Prof_Jones)))
!(add-atom &kb (: Fact6 (Course AI)))
!(add-atom &kb (: Fact7 (Course Logic)))
!(add-atom &kb (: Fact8 (Course Math)))
!(add-atom &kb (: Fact9 (Graduate Alice)))
!(add-atom &kb (: Fact10 (Enrolled Alice AI)))
!(add-atom &kb (: Fact11 (Enrolled Bob Logic)))
!(add-atom &kb (: Fact12 (Teaches Dr_Smith AI)))
!(add-atom &kb (: Fact13 (Teaches Prof_Jones Logic)))
!(add-atom &kb (: Fact14 (Prerequisite Logic AI)))
!(add-atom &kb (: Fact15 (Enrolled Alice AI)))
!(add-atom &kb (: Fact16 (Friend Alice Bob)))
!(add-atom &kb (: Fact17 (Friend Bob Carol)))




;; Rule base

!(add-atom &kb 
   (: knows-prerequisite
    (-> (Enrolled $s $c) 
           (-> (Prerequisite $p $c)
                   (Knows $s $p)))))

!(add-atom &kb 
   (: student-enrolled-course
    (-> (Student $s)
          (-> (Enrolled $s $c)
              (-> (Teaches $t $c)
                   (-> (TaughtBy $s $t)))))))


!(add-atom &kb 
(: graduate-know-logic  
    (-> (Graduate $s) 
        (->   (Knows $s Logic) 
             (TeachingAssistant $s)))))






!(add-atom &kb 
(: scholarship
    (-> (Excellent $s)
           (->   (TeachingAssistant $s)
                 (EligibleForScholarship $s)))) )

!(add-atom &kb 
(: scholarship
    (-> (ActiveLearner $s)
           (->   (Hobby $s $h)
            (WellRounded $s)))) )



!(add-atom &kb 
   (: teacher-level
    (-> (Teaches $t $c1) 
           (Teaches $t $c2) 
                   (-> (SeniorTeacher $t)))))


!(add-atom &kb 
   (: Taughtby-student-teacher
    (-> (Enrolled $s $c) 
           (Teaches $t $c) 
                   (-> (TaughtByy $s $t)))))
!(add-atom &kb 
   (: enrolled-prerequisite-knows-rule
    (-> (Enrolled $s $c) 
           (Prerequisite $p $c) 
                   (-> (knows $s $p)))))
            
; !(bind! &rb (new-space))     
; !(add-reduct &rb (croaks-eats_flies-frog-rule))
; !(add-reduct &rb (chirps-sings-canary-rule))
; !(add-reduct &rb (frog-green-rule))
; !(add-reduct &rb (canary-yellow-rule))

;; Forward chainer

;; Base case
; (= (fc $premise $depth) $premise)
; ;; Recursive steps
; (= (fc $premise1 (S $k))
;    (match &rb (-> $premise1 $premise2 $conclusion)
;           (match &kb $premise2 (fc $conclusion $k))))

; (= (fc $premise2 (S $k))
;    (match &rb (-> $premise1 $premise2 $conclusion)
;           (match &kb $premise1 (fc $conclusion $k))))


(: bc (-> $a                           ; Knowledge base space
          Nat                          ; Maximum depth
          $b                           ; Query
          $b))                         ; Result

;; Base case
(= (bc $kb $_ (: $prf $ccln)) (match $kb (: $prf $ccln) (: $prf $ccln)))

;; Recursive step.  $k = (S ( S Z)). Z
;(S (S Z))
;(S Z)
Z

(= (bc $kb (S $k) (: ($prfabs $prfarg) $ccln))
   (let* (((: $prfabs (-> $prms $ccln)) (bc $kb $k (: $prfabs (-> $prms $ccln))))
          ((: $prfarg $prms) (bc $kb $k (: $prfarg $prms))))
     (: ($prfabs $prfarg) $ccln)))

;; Base case
(= (fcc $kb $_ (: $prf $prms)) (: $prf $prms))

;; Recursive step
(= (fcc $kb (S $k) (: $prfarg $prms))
   (let (: $prfabs (-> $prms $ccln)) (bc $kb $k (: $prfabs (-> $prms $ccln)))
     (fcc $kb $k (: ($prfabs $prfarg) $ccln))))
(= (fcc $kb (S $k) (: $prfabs (-> $prms $ccln)))
    (let (: $prfarg $prms) (bc $kb $k (: $prfarg $prms))
     (fcc $kb $k (: ($prfabs $prfarg) $ccln))))



!(fcc &kb (fromNumber 5) (: Fact12 (Teaches Dr_Smith AI)))# the perfect
!(fcc &kb (fromNumber 5) (: Fact13 (Teaches Prof_Jones Logic)))# this also


!(bc  &kb (fromNumber 5) (: $prf (Knows Alice Logic))) # good
!(bc  &kb (fromNumber 5) (: $prf (TeachingAssistant Alice)))#

