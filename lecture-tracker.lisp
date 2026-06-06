(defstruct lecture
  title
  attended
  worked-independently
  notes)

(defparameter *my-lectures* '())
(defparameter *db-filename* "~/projects/lecture-tracker/my-database.txt")



;;===========================================
;;Helper Funcs come first
;;============================================

(defun truncate-text (text max-len)
  "Cuts off text if it is too long and adds '...' so it fits in the table."
  ;; First, make sure the text isn't empty (NIL) to avoid errors
  (if text 
      ;; Check if the text is longer than our maximum allowed length
      (if (> (length text) max-len)
          ;; If it IS too long, cut it and glue "..." to the end
          (concatenate 'string (subseq text 0 (- max-len 3)) "...")
          ;; If it is NOT too long, just return the text exactly as it is
          text)
      ;; If text is empty, return an empty string
      ""))

(defun prompt-read (prompt)
  (format *query-io* "~%> ~A: " prompt)
  (force-output *query-io*)
  (read-line *query-io*))

(defun pause ()
  "Pauses the program until the user presses Enter."
  (format *query-io* "~%Press Enter to return to the menu...")
  (force-output *query-io*)
  (read-line *query-io*)) ; <-- This is what actually makes it wait!

(defun save-lectures (filename)
  "Saves the *my-lectures* list to a file."
  ;; with-open-file safely opens and closes the file automatically
  (with-open-file (outstream filename
                       :direction :output
                       :if-exists :supersede) ; Overwrite if it exists
    ;; with-standard-io-syntax ensures it prints in a way Lisp can read later
    (with-standard-io-syntax
      (print *my-lectures* outstream)))
      (format t "~%=======================~%")
  (format t "Saved database to ~A~%" filename))

(defun load-lectures (filename)
  "Loads the lecture list from a file into *my-lectures*."
  (with-open-file (in filename
                      :direction :input
                      :if-does-not-exist nil) ; Don't crash if file is missing
    (when in
      (with-standard-io-syntax
        (setf *my-lectures* (read in)))))
  (format t "Loaded database from ~A~%" filename))

;;===============================================
;;Logic
;;===============================================

(defun add-lecture ()
  ;; The let* bubble OPENS here
  (let* ((title-ans  (prompt-read "enter the lecture's name"))
         (attend-ans (prompt-read "enter y if attended"))
         (worked-ans (prompt-read "enter y if worked independently"))
         (notes-ans  (prompt-read "enter notes")))
    
    ;; We are STILL INSIDE the bubble, so title-ans exists!
    (push (make-lecture :title title-ans
                        :attended (equal (string-downcase attend-ans) "y")
                        :worked-independently (equal (string-downcase worked-ans) "y")
                        :notes notes-ans)
          *my-lectures*)
    
    (save-lectures *db-filename*)
      (format t "~%=======================~%")
    (format t "Saved ~A to memory!~%" title-ans)) ;; <-- The let* bubble CLOSES here
) ;; end add lecture

(defun delete-prompt ()
(format t "~%=======================~%")
(prompt-read "Type the lecture's name you want to delete"))

(defun delete-lecture (to-delete)
(setf *my-lectures*(remove to-delete *my-lectures* :key #'lecture-title 
                              :test #'string-equal))
(format t "~%=======================~%")                             
(format t "~%lecture '~A' has been deleted" to-delete)
(save-lectures *db-filename*)
)

  (defun show-lectures ()
  "Prints the *my-lectures* list as a formatted table."
  ;; Print the table header
  (format t "~%==================================================================~%")
  (format t "~20A | ~8A | ~11A | ~A~%" "TITLE" "ATTENDED" "INDEPENDENT" "NOTES")
  (format t "---------------------+----------+-------------+-------------------~%")
  
  ;; Check if the list is empty first
  (if (null *my-lectures*)
      (format t "No lectures saved yet!~%")
      ;; If not empty, loop through every lecture and print its row
      (dolist (lec *my-lectures*)
        (format t "~20A | ~8A | ~11A | ~A~%"
                (truncate-text (lecture-title lec) 20)
                (if (lecture-attended lec) "Yes" "No")
                (if (lecture-worked-independently lec) "Yes" "No")
                (truncate-text (lecture-notes lec) 30))))
  
  ;; Print the bottom border
  (format t "==================================================================~%"))

;;========================================
;;main menu
;;============================================

  (defun main-menu ()
(load-lectures *db-filename*)
  (loop
    (format t "~%========================~%")
    (format t "   LECTURE TRACKER      ~%")
    (format t "========================~%")
    (format t "1. Add a new lecture~%")
    (format t "2. Save lectures to file~%")
    (format t "3. Load lectures from file~%")
    (format t "4. Show all lectures~%")
    (format t "5. Delete a lecture~%")
    (format t "6. Quit~%")
    (format t "------------------------~%")

    (let ((choice (prompt-read "Choose an option (1-6)")))
      (cond ((equal choice "1") (add-lecture) (pause))
            ((equal choice "2") (save-lectures *db-filename*))
            ((equal choice "3") (load-lectures *db-filename*))
            ((equal choice "4") (show-lectures) (pause))
            ((equal choice "5") (delete-lecture (delete-prompt)) (pause))
            ((equal choice "6") (return (format t "Goodbye!~%"))) 
            (t (format t "Invalid choice~%")))))) 

;;for repl to exec
;;sb-ext:save-lisp-and-die "lecture-tracker" 
  ;;                        :toplevel #'main-menu 
    ;;                      :executable t)

;;rlwrap sbcl