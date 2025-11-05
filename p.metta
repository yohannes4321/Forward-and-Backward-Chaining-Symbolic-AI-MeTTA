(: fromNumber (-> Number Atom))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))
;; Knowledge base

!(bind! &kb (new-space))     

!(add-atom &kb (: Fact1 (Evaluation croaks Fritz)))
!(add-atom &kb (: Fact2 (Evaluation chirps Tweety)))
!(add-atom &kb (: Fact3 (Inheritance Tweety yellow)))
!(add-atom &kb (: Fact4 (Evaluation eats_flies Tweety)))
!(add-atom &kb (: Fact5 (Evaluation eats_flies Fritz)))
!(add-atom &kb (: Fact6 (True)))


;; Rule base

!(add-atom &kb 
   (: croaks-eats_flies-frog-rule
    (-> (Evaluation croaks $x) 
           (-> (Evaluation eats_flies $x) 
                   (Inheritance $x frog)))))

!(add-atom &kb 
   (: croaks-eats_flies-frog-rule
    (-> (Evaluation croaks $x) 
           (Evaluation eats_flies $x) 
                   (-> (Inheritance $x frog)))))


!(add-atom &kb 

(: frog-green-rule 
    (-> (True)
        (->   (Inheritance $x frog) 
             (Inheritance $x green)))))

!(add-atom &kb 
(: canary-yellow-rule
    (-> (True)
           (->   (Inheritance $x canary)
            (Inheritance $x yellow)))) )
            
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



 

!(bc &kb  (fromNumber 4) (: $prf (Inheritance $who-is-frog frog)) ) 

;; Run forward chaining to depth 4 and bind the expanded KB
!(bind! &kb-fc (fc &kb (fromNumber 4)))

;; Get all newly inferred facts from the forward chaining
(match &kb-fc (: $prf $fact) $fact)


 



;[(: (croaks-eats_flies-frog-rule $prf) (-> (Evaluation eats_flies Fritz) (Inheritance Fritz frog))), (: ((croaks-eats_flies-frog-rule $prf) Fact5) (Inheritance Fritz frog)), (: $prf (Evaluation croaks Fritz))]