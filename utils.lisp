;;;UTILS

(in-package #:utils)



(defmacro with-generic-error-handler (exp)
  `(handler-case 
       ,exp
     (t (c) 
       (format T "~a ~%" c)
       (cl-json:encode-json-to-string `(("RESULT" . "ERR")
                                        ("STATUS" . "FUCKUP"))))))

(defmacro match-with-request (data &body body)
  `(let ((data (decode-json-from-string-wrapped (body-to-string (getf ,data :raw-body)))))
     (trivia:match data
                   ,@(mapcar #'(lambda (pat-fun-pair)
                                 `((alist
                                    ,@(car pat-fun-pair))
                                   `(200 (:content-type "application/json")
                                         (,,(cadr pat-fun-pair)))))
                             `,body)
                   (_ `(500 (:content-type "application/json") (,(invalid-req-handler)))))))

(defun body-to-string (stream)
  (if (listen stream)
      (alexandria:read-stream-content-into-string stream)
      ""))

(defun decode-json-from-string-wrapped (string)
  (ignore-errors
    (json:decode-json-from-string string)))

(defun invalid-req-handler ()
  (format nil "Invalid request my kid"))


(defun secure-entry-point (request func)
  (match-with-request request
                      (((:key . "SHAMOWNE")) 
                       (funcall #'func request)))))
