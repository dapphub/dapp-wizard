(module dapp racket
  (provide rpc
           hex->number
           ethsign-ls)
  (require racket/match)
  (require racket/runtime-path)
  (require net/url)
  (require json)

  (require racket/control)

  ;;; General dapp helpers.

  (define default-node "https://tower.brockman.se/mainnet/ABC123")

  (define (rpc #:base-url [base-url default-node] method . params)
    (define port (post-pure-port
                  (string->url base-url)
                  (jsexpr->bytes
                   (hasheq 'jsonrpc "2.0" 'id 1 'method method 'params params))
                  '("Content-Type: application/json")))
    (with-handlers ([exn:fail? (lambda (exn)
                                 (close-input-port port)
                                 (raise exn))])
      (string->jsexpr (port->string port #:close? #t))))

  (define (hex->number string)
    (match string
      [(regexp #rx"^0x([0-9a-fA-F]+)" (list _ digits))
       (string->number digits 16)]))

  (define (ethsign-ls)
    (string-split
     (with-output-to-string
       (lambda () (system "ethsign ls"))) "\n"))

  ;;; This stuff uses continuations to implement blocking functions
  ;;; in an abstract way, to support "runtimes" like GTK, www, SMS, etc.

  (define wizard-tag (make-continuation-prompt-tag))

  (provide step-wizard)
  (define (step-wizard wizard)
    (call-with-continuation-prompt
     wizard wizard-tag
     (lambda (x) x)))

  (define (wizard-wait . query)
    (call-with-composable-continuation
     (lambda (k)
       (abort-current-continuation
        wizard-tag
        `(,query ,k)))
     wizard-tag))

  (provide wizard-choose-account)
  (define (wizard-choose-account)
    (wizard-wait 'choose-account))

  (provide wizard-say)
  (define (wizard-say . texts)
    (wizard-wait 'say texts))

  ;; (define (wizard-rpc-call #:to #:calldata #:from [from 0])
  ;;   (wizard-wait 'rpc-call to calldata from))

  (provide MKR)
  (define MKR "0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2")

  (define-runtime-path gethtool-exe "gethtool.exe"))
