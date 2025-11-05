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
            
(: bc (-> $a                           ; Knowledge base space
          Nat                          ; Maximum depth
          $goal                           ; Query
          $result))                         ; Result

;; Base case
(= (bc $kb $_ (: $proofName $ccln))
 
(match $kb (: $prfName $ccln) (: $prfName $ccln)))


(= (bc $kb (S $k) (: ($RuleName $RuleArg) $ccln))
   (let* (((: $RuleName (-> $premise $ccln)) (bc $kb $k (: $RuleName (-> $premise $ccln))))
          ((: $RuleArg $premise) (bc $kb $k (: $RuleArg $premise))))
     (: ($RuleName $RuleArg) $ccln)))

;; forward

;; Base case
(= (fcc $kb $_ (: $proofName $premise)) 
(: $proofName $premise))

;; Recursive step
(= (fcc $kb (S $k) (: $RuleArg $premise))
   (let (: $RuleName (-> $premise $ccln)) (bc $kb $k (: $RuleName (-> $premise $ccln)))
     (fcc $kb $k (: ($RuleName $RuleArg) $ccln))))
(= (fcc $kb (S $k) (: $RuleName (-> $premise $ccln)))
    (let (: $RuleArg $premise) (bc $kb $k (: $RuleArg $premise))
     (fcc $kb $k (: ($RuleName $RuleArg) $ccln))))



!(fcc &kb (fromNumber 5) (: Fact12 (Teaches Dr_Smith AI)))
!(fcc &kb (fromNumber 5) (: Fact13 (Teaches Prof_Jones Logic)))


!(bc  &kb (fromNumber 5) (: $prf (Knows Alice Logic))) 
!(bc  &kb (fromNumber 5) (: $prf (TeachingAssistant Alice)))

