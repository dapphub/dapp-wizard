(module dapp-ui racket/gui
  (require dapp)
  
  (define (main-frame)
    (new frame% [label "DappHub"]
         [border 8]
         [spacing 8]
         [alignment '(center center)]))

  (let* ((frame (main-frame)))

    (send frame show #t)
    (send frame create-status-line)
    (send frame set-status-text "Loading token balances...")

    (define rpc-panel (new group-box-panel%
                           (label "RPC node")
                           (parent frame)))

    (new combo-field% (parent rpc-panel)
         (label #f)
         (font (make-font #:size 22 #:family 'modern))
         (choices '("https://mainnet.infura.io"))
         (init-value "https://mainnet.infura.io"))

    (let ((accounts (ethsign-ls))
          (account-panel (new group-box-panel%
                              (label "Account")
                              (parent frame))))

      (new button% (label "Change key directory...")
           (parent account-panel))

      (new radio-box% (parent account-panel)
           (label #f)
           (font (make-font #:size 22 #:family 'modern))
           (choices accounts))

      (let* ((token-panel (new group-box-panel%
                               (label "MKR token")
                               (parent frame)))
             (token-list (new list-box% (parent token-panel)
                              (label #f)
                              (font (make-font #:size 22 #:family 'modern))
                              (style '(multiple column-headers))
                              (choices '())
                              (min-height 200)
                              (columns (list "Token" "Amount")))))
        (send token-list set
              '("Old MKR" "New MKR")
              '("Loading..." "Loading..."))
        (send token-list set-column-width 0 200 200 200)

        (new button% (label "Redeem all my MKR")
             (parent token-panel)))))
  )
