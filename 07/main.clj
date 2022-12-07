(require '[clojure.string :as str])
(require '[clojure.java.io :as io])

(defn unknown-cmd [cmd]
  (println "")
  ; (println "unknown command" cmd)
  )

(defn is-dir-line [line] (clojure.string/starts-with? line "dir"))
(defn is-cmd-line [line] (clojure.string/starts-with? line "$"))
(defn is-file-size-line [line] (and (not (is-dir-line line)) (not= "" line) (not (is-cmd-line line))))

(defn get-cmd [cmd] (clojure.string/split (clojure.string/replace cmd "$ " "") #" "))

(defn get-dir-value [line] (subs line (+ 1 (clojure.string/index-of line " ")))
  )

(defn cd-to [pwd to]
  (-> (io/file pwd to) (.getCanonicalFile) (.toString)))
(defn get-cmd-cd-path [pwd to] (if (= "/" to) "/" (cd-to pwd to)))
(defn is-cmd-cd? [cmd] (= "cd" (first cmd)))

(defn add-line-to-dir [state line]
  (let [lines (get-in state [:dirs (get state :pwd)] [])] ; create an empty lines if not set in state
    (assoc-in state [:dirs (get state :pwd)] (conj lines line))
    ))
(defn set-pwd-dir [state line] (add-line-to-dir state line))

(defn cmd-cd [state cmd]
  (assoc state :pwd
         (get-cmd-cd-path (get state :pwd) (last cmd))))

(defn shellcmd [state line]
  (if (is-cmd-cd? (get-cmd line)) (cmd-cd state (get-cmd line)) (do (unknown-cmd line) state)))


(defn get-file-size [line] (Integer/parseInt (subs line 0 (clojure.string/index-of line " "))))

(defn get-pwd [state] (get state :pwd))

(defn cmdoutput [state line] (set-pwd-dir state line))

(defn print-state [state] (println "pwd:" (get state :pwd) "dirs:" (get state :dirs)))

(defn parsecmd [state line]
  ; (print-state state)
  (if (is-cmd-line line) (shellcmd state line) (cmdoutput state line)))

(defn sum [items] (reduce #(+ %1 %2) 0 items))

(defn get-dir-size [alldirs p]
  (let [
        dir-commands (get alldirs p)
        file-sizes (map get-file-size (filter is-file-size-line dir-commands))
        child-directories (map get-dir-value (filter #(is-dir-line %1) dir-commands))
        ]
    (sum [(sum file-sizes) (sum (map #(get-dir-size alldirs (cd-to p %1)) child-directories))])
    )
  )

(defn collect-dir-sizes [dirs]
  (reduce
    (fn [accu dirdata]
      (assoc accu (first dirdata) (get-dir-size dirs dirdata))) {} dirs))

(defn atmost [size dirs] (filter #(< (last %1) size) dirs))

(defn get-parent-paths [p]
  (if (= p "/") p (conj [p] (get-parent-paths (cd-to p "..")))))

; generates all possible child/parent paths:
; ['/a/b/c' '/b/d/e'] -> ['/a' '/a/b' '/a/b/c' '/b' '/b/d' '/b/d/e' '/']
(defn get-possible-paths [items]
  (set (flatten (map #(get-parent-paths (first %1)) items))))

(defn is-parent-of-any? [item any]
  (every?
    (fn [sitem]
      (not (clojure.string/starts-with? (first item) (first sitem))))
    any))

(defn remove-children [coll]
  (filter
    (fn [item]
      (let [ without-me (filter #(not (= (first item) (first %1))) coll) ]
        (or (empty? without-me)
            (is-parent-of-any? item without-me))
        )) coll))


(defn sum-of-dirs [dirs]
  (reduce (fn [acc i] (+ acc (last i)))
    0 dirs))

(defn main []
   (with-open [rdr (clojure.java.io/reader "input")]
     (let [state (reduce parsecmd { :pwd "/"  :dirs { "/" [] }} (line-seq rdr))
            sizes (reduce
                    (fn [acc path] (assoc acc path (get-dir-size (get state :dirs) path)))
                    {}
                    (get-possible-paths (get state :dirs)))]
        (println (sum (map last (atmost 100000 sizes)))
            )
       ))
   )

(main)
