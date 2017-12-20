(module dapp-cli racket
  (require dapp)
  (require readline/readline)

  ;;; Example of how to define a CLI interpreter for the DSL.
  (define (loop wizard)
    (match wizard
      [`((choose-account) ,k)
       (loop (step-wizard
              (lambda ()
                (k (readline "Account: ")))))]
      [`((say ,texts) ,k)
       (loop (step-wizard
              (lambda ()
                (display (apply string-append texts))
                (newline)
                (newline)
                (display "[Press Enter to continue]")
                (read-line)
                (k #f))))]
      [#f (void)])
    )

  ;;; As a demo, just run the MKR redeemer script.
  (module* main #f
    (require "mkr-redeemer.rkt")
    (display "[Running dapp: MKR Reedemer]\n\n")
    (loop (step-wizard start))
    (void)))
