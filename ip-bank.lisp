;;;; ip-bank.lisp

(in-package #:ip-bank)

(defvar *bank* (make-hash-table :test 'equal))

(defun write-ip (id ip)
  (setf (gethash id *bank*) ip)
  (cl-json:encode-json-to-string
   `(("RESULT" . "OK")
     ("DATA" . NIL))))

(defun read-ip (id)
  (cl-json:encode-json-to-string
   `(("RESULT" . "OK")
     ("DATA" . ,(gethash id *bank*)))))

(defun run-http-server (request)
  (match-with-request request
              (((:cmd . "WRITE")
                (:id  . id)
                (:ip  . ip))
               (with-generic-error-handler (write-ip id ip)))
              (((:cmd . "READ")
                (:id  . id)
                (:ip  . ip))
               (with-generic-error-handler (read-ip id)))))

(defun run-http-server-protected (request)
  (secure-entry-point request run-http-server))

(defun main ()
  (defvar *http-handler* (clack:clackup #'run-http-server-protected :port 8787))
  (format T "launching this motherfuker ~%")
  (force-output)
  (uiop:format! t "slynking ma boi")
  (bt:make-thread (lambda ()
                    (slynk:create-server :port 4006)
                    :name "slynk")))
