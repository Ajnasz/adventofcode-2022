#lang racket
(require "data/monkey.rkt")

(define (get-worry-operator monkey)
  (match (hash-ref (hash-ref monkey 'operation) 'op)
         ["+" +]
         ["*" *]))

(define (get-worry-value monkey old)
  (match (hash-ref (hash-ref monkey 'operation) 'value)
         ["old" old]
         [_ (string->number (hash-ref (hash-ref monkey 'operation) 'value))]))

(define monkey-lines (foldl
  (lambda (line ret)
    (match line
      ["" (cons '() ret)]
      [_ (cons (append (car ret) (list line)) (cdr ret))]))
    '(())
    (file->lines "sample")))

(define monkeys
  (sort
    (map create-monkey monkey-lines)
    < #:key (lambda (monkey) (hash-ref monkey 'id))))

(define (find-by fn items)
  (if (pair? items)
    (if (fn (car items))
      (car items)
      (find-by fn (cdr items)))
    null))

; (display "\n")
; (display "------")
; (display "\n")
; (display monkeys)
; (display "\n")
(define (get-target-monkey monkey worry-level)
  (define test (hash-ref monkey 'test))
  (define test-is-true (= 0 (modulo worry-level (hash-ref test 'divisable-by))))
  (car (cdr (find-by
    (lambda (actions) (or (and test-is-true (car actions)) (not (or test-is-true (car actions)))))
    (hash-ref (hash-ref monkey 'test) 'actions)
  ))))

(define throw-item-to (monkeys monkey item) f)
(display
  (map
    (lambda (monkey)
      (begin
        ; (display ((get-worry-operator monkey) (get-worry-value monkey ret) ret))
        ; (display " ")
        (define calculator (lambda (i ret) (floor (/ ((get-worry-operator monkey) (get-worry-value monkey ret) i) 3))))
        (foldl (lambda (i ret)
                 (begin
                   (display i)
                   (display " ")
                   (display ret)
                   (display " ")
                   (display (calculator i ret))
                   (display " throw item to: ")
                   (display (get-target-monkey monkey (calculator i ret)))
                   (display "\n")
                   (calculator i ret))
                 ) 1 (hash-ref monkey 'starting))
        )) monkeys))

(display "\n")
(display "------")
(display "\n")

; (foldl
;   (lambda (a b)
;     (begin
;       (print a)
;       (print "\n")
;       (print b)
;       (print "\n")
;       (+ a b)))
;   0
;   '(1 2 3))
