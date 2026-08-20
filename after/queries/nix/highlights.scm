;; extends

((variable_expression
  name: (identifier) @variable.parameter)
  (#is-parameter-ref? @variable.parameter)
  (#set! "priority" 130))

((inherited_attrs
  (identifier) @variable.parameter)
  (#is-parameter-ref? @variable.parameter)
  (#set! "priority" 130))
