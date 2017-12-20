;; Define a Racket-based language with some functionality.
(module wizard racket
  (require dapp)
  (require racket/control)

  (provide
   lambda #%app #%datum
   (rename-out [wizard-choose-account choose-account]
               [wizard-say say]
               [wizard-module-begin #%module-begin])
   MKR)

  (define-syntax-rule (wizard-module-begin expr ...)
    (#%module-begin
     (define start (lambda () expr ...))
     (provide start))))
