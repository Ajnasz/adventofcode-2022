(local tablex (require "pl.tablex"))

(fn sum [data]
  (accumulate
    [sum 0
     i n (ipairs data)]
    (+ sum n)))

(fn push [tbl val] (tset tbl (+ (length tbl) 1) val) tbl)
(fn readline [file out]
  (let [line ((file:lines))]
    (push out line)
    (if line (readline file out) out)))

(fn read-file [file]
  (readline file []))

(fn get-elves [lines]
  (var elves [])
  (var elf [])
  (each [i val (ipairs lines)]
    (if (not (= val ""))
      (push elf val)
      (do
        (set elves (push elves elf))
        (set elf []))
      )
    ) elves)

(fn get-max [items]
  (accumulate
    [max 0
     i n (ipairs items)]
    (do (if (< max n) n max))))

(fn get-max-n [n items]
  (local out [])
  (for [i 1 n 1] (table.insert out 0))
  (accumulate
    [output out
     i v (ipairs items)]
    (do
      (let [idx (tablex.find_if output #(> v $1))]
      (when idx
          (tablex.insertvalues output idx [v])
          (tablex.sub output 1 n)))
    (tablex.sub output 1 n))))

(with-open [fin (io.open :input)]
  (local lines (read-file fin))
  (local ret (sum (get-max-n 1 (tablex.map sum (get-elves lines)))))
  (local ret2 (sum (get-max-n 3 (tablex.map sum (get-elves lines)))))
  (assert (= ret 69206))
  (assert (= ret2 197400)))
