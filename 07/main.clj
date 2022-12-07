(require '[clojure.string :as str])
(require '[clojure.java.io :as io])

(defn is-dir-line? [line] (str/starts-with? line "dir"))
(defn is-cmd-line? [line] (str/starts-with? line "$"))
(defn is-file-size-line? [line] (and (not (is-dir-line? line)) (not= "" line) (not (is-cmd-line? line))))

(defn get-str-til [index line] (subs line 0 index))
(defn get-str-from [index line] (subs line index))
(defn get-first-word [line] (->
                              (str/index-of line " ")
                              (get-str-til line)))
(defn get-second-word [line] (->
                               (str/index-of line " ")
                               (inc)
                               (get-str-from line)))

(defn get-cmd [cmd] (str/split (str/replace cmd "$ " "") #" "))

(defn get-dir-name [line] (get-second-word line))

(defn cd-to [to pwd] (->
                       (io/file pwd to)
                       (.getCanonicalFile)
                       (.toString)))
(defn get-cmd-cd-path [pwd to]
  (if (= "/" to)
    "/"
    (cd-to to pwd)))


(defn is-cmd-cd? [cmd] (= "cd" (first cmd)))

(defn add-line-to-dir [state line]
  ; get-in last param return default value so we will create empty :dirs key if
  ; not set in state
  (let [lines (get-in state [:dirs (get state :pwd)] [])]
    (->> line
         (conj lines)
         (assoc-in state [:dirs (get state :pwd)]))))

(defn cmd-cd [state cmd]
  (->> cmd
       last
       (get-cmd-cd-path (get state :pwd))
       (assoc state :pwd)))

(defn shellcmd [state line]
  (if (is-cmd-cd? (get-cmd line))
    (cmd-cd state (get-cmd line))
    state))

(defn get-file-size [line] (Integer/parseInt (get-first-word line)))

(defn cmdoutput [state line] (add-line-to-dir state line))

(defn parsecmd [state line]
  (if (is-cmd-line? line)
    (shellcmd state line)
    (cmdoutput state line)))

(defn get-dir-size [alldirs p]
  (let [
        dir-commands (get alldirs p)
        file-sizes (->> dir-commands
                       (filter is-file-size-line?)
                       (map get-file-size))
        child-directories (->> dir-commands
                              (filter is-dir-line?)
                              (map get-dir-name))
        ]
    (->> child-directories
         (map #(get-dir-size alldirs (cd-to %1 p)))
         (apply +)
         (+ (apply + file-sizes))
        )
    )
  )

(defn at-most [size dirs] (filter #(< (last %1) size) dirs))

(defn get-parent-paths [p]
  (if (= p "/")
    p
    (conj [p] (get-parent-paths (cd-to ".." p)))))

; generates all possible child/parent paths:
; [['/a/b/c' 1] ['/b/d/e' 2] -> ['/a' '/a/b' '/a/b/c' '/b' '/b/d' '/b/d/e' '/']
(defn get-possible-paths [items]
  (set
    (->> items
         (map first)
         (map get-parent-paths)
         (flatten)
         )))

(def max-size 100000)
(def fs-size 70000000)
(def min-unused-space 30000000)
(defn main []
  (with-open [rdr (io/reader "input")]
    (let [
          state (reduce parsecmd { :pwd "/"  :dirs { "/" [] }} (line-seq rdr))
          state-dirs (get state :dirs)
          sizes (reduce
                  (fn [acc path] (->>
                                   (get-dir-size state-dirs path)
                                   (assoc acc path)))
                  {}
                  (get-possible-paths state-dirs))
          root-size (get sizes "/")
          space-needed (->> root-size
                           (- fs-size)
                           (- min-unused-space))
          ]
      (println "directories sum smaller than" max-size (apply + (->> sizes
                                                                  (at-most max-size)
                                                                  (map last))))
      (println "used space" root-size)
      (println "unused space" (- fs-size root-size))
      (println "additional space needed" space-needed)
      (println (apply min (filter #(<= space-needed %1) (map last sizes))))
      )))

(main)
