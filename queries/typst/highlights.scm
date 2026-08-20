;; extends

; Top-level function definitions in #let fn(...) = ...
(let
  (call
    (ident) @function))

; Function parameters in signature #let fn(param1, param2) = ...
(let
  (call
    (group
      (ident) @variable.parameter)))

; Variable definitions in #let var = ...
(let
  (ident) @variable)

; Default standalone identifiers to @variable instead of @constant
(ident) @variable

; Parameter references inside function bodies
((ident) @variable.parameter
  (#is-typst-parameter-ref? @variable.parameter))
