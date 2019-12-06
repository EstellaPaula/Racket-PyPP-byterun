#lang racket
(require "opcodes.rkt")
(provide make-stack-machine)
(provide run-stack-machine)
(provide get-stack)
(provide get-varnames)
(provide get-consts)
(provide get-names)
(provide get-code)
(provide get-IC)
(provide empty-stack)
(provide make-stack)
(provide push)
(provide pop)
(provide top)


;; TODO 1:
;; Alegeți metoda de reprezentarea a unei stive.
;; Implementați:
(define empty-stack null)
(define (make-stack) null)

(define (push element stack)
  (cons element stack))

(define (top stack) (car stack))
(define (pop stack) (cdr stack))

;; TODO 2:
;; Alegeți metoda de reprezentare a unei mașini stivă.
;; Definiți make-stack-machine, acesta trebuie sa primeasca cele 4 segmente de date
;; Veți avea nevoie de o stivă pentru execuție și un counter ca să stiți
;; la ce instrucțiune sunteți.
(define (make-stack-machine stack co-varnames co-consts co-names co-code IC)
  (list stack co-varnames co-consts co-names co-code IC))


;; Definiți funcțiile `get-varnames`, `get-consts`, `get-names`,
;; `get-code`, `get-stack`, `get-IC` care primesc o mașina stivă și întorc
;; componenta respectivă

;; ex:
;; > (get-varnames (make-stack-machine empty-stack 'dummy-co-varnames (hash) (hash) (list) 0))
;; 'dummy-co-varnames

;;stack co-varnames co-consts co-names co-code IC

(define (get-varnames stack-machine) (list-ref stack-machine 1))

;; ex:
;; > (get-consts (make-stack-machine empty-stack (hash) 'dummy-co-consts (hash) (list) 0))
;; 'dummy-co-consts
(define (get-consts stack-machine) (list-ref stack-machine 2))

;; ex:
;; > (get-names (make-stack-machine empty-stack (hash) (hash) 'dummy-co-names (list) 0))
;; 'dummy-co-names
(define (get-names stack-machine) (list-ref stack-machine 3))

;(get-names (make-stack-machine 'None 'None 'None (hash 0 "prod") 'None 'None))

;result -> (hash 0 "prod")

;; ex:
;; > (get-code (make-stack-machine empty-stack (hash) (hash) (hash) 'dummy-co-code 0))
;; dummy-co-code
(define (get-code stack-machine) (list-ref stack-machine 4))

;; Întoarce stiva de execuție.
;; ex:
;; > (get-code (make-stack-machine 'dummy-exec-stack (hash) (hash) (hash) (list) 0))
;; dummy-exec-stack
(define (get-stack stack-machine) (list-ref stack-machine 0))

;; Întoarce instruction counterul.
;; ex:
;; > (get-code (make-stack-machine empty-stack (hash) (hash) (hash) (list) 0))
;; 0
(define (get-IC stack-machine) (car (reverse stack-machine)))



(define symbols (list 'STACK 'CO-VARNAMES 'CO-CONSTS 'CO-NAMES 'CO-CODE 'INSTRUCTION-COUNTER))

;; TODO 3:
;; Definiți funcția get-symbol-index care gasește index-ul simbolului in listă.
(define (get-symbol-index symbol)
  (cond
    ((equal? symbol 'STACK) 0)
    ((equal? symbol 'CO-VARNAMES) 1)
    ((equal? symbol 'CO-CONSTS) 2)
    ((equal? symbol 'CO-NAMES) 3)
    ((equal? symbol 'CO-CODE) 4)
    ((equal? symbol 'INSTRUCTION-COUNTER) 5)))
    

;; Definiți funcția update-stack-machine care intoarce o noua mașina stivă
;; înlocuind componenta corespondentă simbolului cu item-ul dat în paremetri.
;; > (get-varnames (update-stack-machine "new-varnames" 'CO-VARNAMES stack-machine))
;; "new-varnames"
;; > (get-varnames (update-stack-machine "new-names" 'CO-NAMES stack-machine))
;; "new-names"

;;--- stack co-varnames co-consts co-names co-code IC

(define (update-stack-machine item symbol stack-machine)
  (cond
    ((equal? symbol 'STACK) (make-stack-machine item (get-varnames stack-machine) (get-consts stack-machine) (get-names stack-machine) (get-code stack-machine) (get-IC stack-machine))) 
    ((equal? symbol 'CO-VARNAMES) (make-stack-machine (get-stack stack-machine) item (get-consts stack-machine) (get-names stack-machine) (get-code stack-machine) (get-IC stack-machine)))
    ((equal? symbol 'CO-CONSTS) (make-stack-machine (get-stack stack-machine) (get-varnames stack-machine) item (get-names stack-machine) (get-code stack-machine) (get-IC stack-machine)))
    ((equal? symbol 'CO-NAMES) (make-stack-machine (get-stack stack-machine) (get-varnames stack-machine) (get-consts stack-machine) item (get-code stack-machine) (get-IC stack-machine)))
    ((equal? symbol 'CO-CODE) (make-stack-machine (get-stack stack-machine) (get-varnames stack-machine) (get-consts stack-machine) (get-names stack-machine) item (get-IC stack-machine)))
    ((equal? symbol 'INSTRUCTION-COUNTER) (make-stack-machine (get-stack stack-machine) (get-varnames stack-machine) (get-consts stack-machine) (get-names stack-machine) (get-code stack-machine) item))))

;; Definiți funcția push-exec-stack care primește o masină stivă și o valoare
;; și intoarce o noua mașina unde valoarea este pusă pe stiva de execuție
(define (push-exec-stack value stack-machine)
  (make-stack-machine (cons value (get-stack stack-machine)) (get-varnames stack-machine) (get-consts stack-machine) (get-names stack-machine) (get-code stack-machine) (get-IC stack-machine)))


  
;;  Definiți funcția pop-exec-stack care primește o masină stivă
;;  și intoarce o noua mașina aplicând pop pe stiva de execuție.
(define (pop-exec-stack stack-machine)
  (make-stack-machine (cdr (get-stack stack-machine)) (get-varnames stack-machine) (get-consts stack-machine) (get-names stack-machine) (get-code stack-machine) (get-IC stack-machine)))

;; TODO 4:
;; Definiți funcția run-stack-machine care execută operații pană epuizează co-code.
(define (run-stack-machine stack-machine)
  (letrec ((ic (get-IC stack-machine)) (operation (list-ref (get-code stack-machine) ic)) (co-code (get-code stack-machine))
        (machine-left (make-stack-machine (get-stack stack-machine) (get-varnames stack-machine) (get-consts stack-machine) (get-names stack-machine) (get-code stack-machine) (add1 (get-IC stack-machine)))))
     (cond
       ((equal? (car operation) 'RETURN_VALUE) machine-left)
       ((equal? (car operation) 'BINARY_ADD) (run-stack-machine (binary_add machine-left)))
       ((equal? (car operation) 'POP_TOP) (run-stack-machine (pop_top machine-left)))
       ((equal? (car operation) 'INPLACE_ADD) (run-stack-machine (binary_add machine-left)))
       ((equal? (car operation) 'BINARY_MODULO) (run-stack-machine (binary_modulo machine-left)))
       ((equal? (car operation) 'INPLACE_MODULO) (run-stack-machine (binary_modulo machine-left)))
       ((equal? (car operation) 'BINARY_SUBTRACT) (run-stack-machine (binary_subtract machine-left)))
       ((equal? (car operation) 'INPLACE_SUBTRACT) (run-stack-machine (binary_subtract machine-left)))
       ((equal? (car operation) 'LOAD_CONST) (run-stack-machine (load_const (cdr operation) machine-left)))
       ((equal? (car operation) 'LOAD_GLOBAL) (run-stack-machine (load_global (cdr operation) machine-left)))
       ((equal? (car operation) 'COMPARE_OP) (run-stack-machine (compare_op (cdr operation) machine-left)))
       ((equal? (car operation) 'POP_JUMP_IF_FALSE) (run-stack-machine (jump_pop_false (cdr operation) machine-left)))
       ((equal? (car operation) 'JUMP_ABSOLUTE) (run-stack-machine (jump_absolute (cdr operation) machine-left)))
       ((equal? (car operation) 'FOR_ITER) (run-stack-machine (for_iter (cdr operation) machine-left)))
       ((equal? (car operation) 'CALL_FUNCTION) (run-stack-machine (call_function (cdr operation) machine-left)))
       ((equal? (car operation) 'LOAD_FAST) (run-stack-machine (load_fast (cdr operation) machine-left)))
       ((equal? (car operation) 'STORE_FAST) (run-stack-machine (store_fast (cdr operation) machine-left)))
       (else  (run-stack-machine machine-left)))))
       


(define (tos stack-machine)
  (if (null? (get-stack stack-machine))
      '()
  (car (get-stack stack-machine))))

(define (tos1 stack-machine)
  (if (null? (get-stack stack-machine))
      '()
  (car (get-stack (pop-exec-stack stack-machine)))))

(define (pop_top stack-machine)
  (pop-exec-stack stack-machine))

(define (load_const i stack-machine)
  (push-exec-stack (hash-ref (get-consts stack-machine) i) stack-machine))

(define (get-list nr L)
  (let loop ((i 0) (result '()) (list L))
    (if (equal? i nr)
        (cons (car list) (reverse result))
        (loop (add1 i) (cons (car list) result) (cdr list)))))

(define (call_function nr_arg stack-machine)
  (let ((function (car (get-list nr_arg (get-stack stack-machine))))
        (argv (cdr (get-list nr_arg (get-stack stack-machine))))
        (stack (get-stack stack-machine)))
  (update-stack-machine (cons (apply (get-function function) argv) (list-tail stack (add1 nr_arg))) 'STACK stack-machine)))

(define (load_global i stack-machine)
  (push-exec-stack (hash-ref (get-names stack-machine) i) stack-machine))

(define (load_fast i stack-machine)
  (push-exec-stack (hash-ref (get-varnames stack-machine) i) stack-machine))

(define (store_fast i stack-machine)
  (pop-exec-stack (update-stack-machine (hash-set (get-varnames stack-machine) i (tos stack-machine)) 'CO-VARNAMES stack-machine)))

(define (binary_add stack-machine)
  (push-exec-stack (+ (tos1 stack-machine) (tos stack-machine)) (pop-exec-stack (pop-exec-stack stack-machine))))

(define (binary_subtract stack-machine)
  (push-exec-stack (- (tos1 stack-machine) (tos stack-machine)) (pop-exec-stack (pop-exec-stack stack-machine))))

(define (binary_modulo stack-machine)
  (push-exec-stack (modulo (tos1 stack-machine) (tos stack-machine)) (pop-exec-stack (pop-exec-stack stack-machine))))

(define (compare_op i stack-machine)
  (push-exec-stack ((get-cmpop i) (tos1 stack-machine) (tos stack-machine)) (pop-exec-stack (pop-exec-stack stack-machine))))

(define (jump_pop_false i stack-machine)
  (if (false? (car (get-stack stack-machine)))
      (pop-exec-stack (update-stack-machine (quotient i 2) 'INSTRUCTION-COUNTER stack-machine))
      (pop-exec-stack stack-machine)))

(define (jump_absolute i stack-machine)
  (update-stack-machine (quotient i 2) 'INSTRUCTION-COUNTER stack-machine))

(define (for_iter delta stack-machine)
  (if (null? (tos stack-machine))
      (pop-exec-stack (update-stack-machine (+ (get-IC stack-machine) (+ (quotient delta 2) 1)) 'INSTRUCTION-COUNTER stack-machine))
      (update-stack-machine (apply list (car (tos stack-machine)) (cdr (tos stack-machine)) (cdr (get-stack stack-machine))) 'STACK stack-machine)))

