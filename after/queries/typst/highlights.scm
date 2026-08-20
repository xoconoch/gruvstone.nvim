;; extends

; Top-level function definitions in #let fn(...) = ...
((let
  (call
    (ident) @function))
  (#set! "priority" 130))

; Function parameters in signature #let fn(param1, param2) = ...
((let
  (call
    (group
      (ident) @variable.parameter)))
  (#set! "priority" 130))

; Variable definitions in #let var = ...
((let
  (ident) @variable)
  (#set! "priority" 130))

; Default standalone identifiers to @variable instead of @constant
((ident) @variable
  (#set! "priority" 105))

; Parameter references inside function bodies
((ident) @variable.parameter
  (#is-typst-parameter-ref? @variable.parameter)
  (#set! "priority" 130))
