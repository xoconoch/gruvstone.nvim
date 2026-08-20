;; extends

(variable_expression
  name: (identifier) @variable.parameter
  (#is-parameter-ref? @variable.parameter))

(inherited_attrs
  (identifier) @variable.parameter
  (#is-parameter-ref? @variable.parameter))
