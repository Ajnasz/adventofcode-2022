#lang racket

(provide create-monkey)

(define (get-monkey-id monkey-lines) (string->number (substring (car monkey-lines) 7 8)))


(define (parse-operation op)
  (define operation (make-hash))
  (hash-set! operation 'op (substring op 10 11))
  (hash-set! operation 'value (substring op 12))
  operation)

(define (get-monkey-operation-line monkey-lines) (substring (car (cdr (cdr monkey-lines))) 13))

(define (get-monkey-test-line monkey-lines)
  (substring (car (cdr (cdr (cdr monkey-lines)))) 8))

(define (get-test-action-condition line) (substring line 7 8))
(define (get-action-target line) (substring line (- (string-length line) 1)))

(define (get-test-action action-line)
  (match (get-test-action-condition action-line)
         ["t" (list #t (get-action-target action-line))]
         ["f" (list #f (get-action-target action-line))])
  )

(define (get-test-actions monkey-lines)
  (map get-test-action (cdr (cdr (cdr (cdr monkey-lines))))))

(define (get-monkey-test-op monkey-lines)
  (define test-props (make-hash))
  (hash-set! test-props 'divisable-by (string->number (substring (get-monkey-test-line monkey-lines) 13)))
  (hash-set! test-props 'actions (get-test-actions monkey-lines))
  test-props)

(define
  (get-monkey-operation monkey-lines)
  (parse-operation (get-monkey-operation-line monkey-lines)))

(define
  (get-monkey-starting-items
    monkey-lines)
    (map string->number(string-split (substring (car (cdr monkey-lines)) 18) ", ")))

; id: 0
; starting: (54 65 75 74)
; operation:
;   op: "+"
;   value: 6
; test:
;   divisible-by 19
;   actions:
;     (#t 2)
;     (#f 0)
(define (create-monkey monkey-lines)
  (define monkey (make-hash))
  (hash-set! monkey 'id (get-monkey-id monkey-lines))
  (hash-set! monkey 'starting (get-monkey-starting-items monkey-lines))
  (hash-set! monkey 'operation (get-monkey-operation monkey-lines))
  (hash-set! monkey 'test (get-monkey-test-op monkey-lines))
  monkey
  )


