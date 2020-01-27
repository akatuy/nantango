(defsystem "nantango"
  :class :package-inferred-system
  :author "Eitaro Fukamachi"
  :version "0.1.0"
  :depends-on ("nantango/main"))

(register-system-packages "lack-component" '(#:lack.component))
