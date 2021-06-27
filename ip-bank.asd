;;;; ip-bank.asd

(asdf:defsystem #:ip-bank
  :description "Describe ip-bank here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on ("clack"
               "alexandria"
               "trivia"
               "cl-json"
               "dexador"
               "flexi-streams"
               "slynk")
  :components ((:file "package")
               (:file "utils")
               (:file "ip-bank"))
)
