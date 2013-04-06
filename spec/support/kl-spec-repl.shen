(define double-quotes -> (n->string 34))
(define new-line -> (n->string 10))

(define escape-string
  "" -> ""
  (@s Dq Tail) -> (@s "\" (double-quotes) (escape-string Tail)) 
                  where (= Dq (double-quotes))
  (@s Nl Tail) -> (@s "\n" (escape-string Tail))
                  where (= Nl (new-line))
  (@s "\" Tail) -> (@s "\\" (escape-string Tail))
  (@s S Tail) -> (@s S (escape-string Tail)))

(define tagged-value
  Val -> (cases (= Val ())     "(empty-list)"
                (cons? Val)      (tagged-cons Val)
                (symbol? Val)    (tagged-atom symbol (str Val))
                (string? Val)    (tagged-atom string Val)
                (integer? Val)   (tagged-atom integer (str Val))
                (number? Val)    (tagged-atom real (str Val))
                (boolean? Val)   (tagged-atom boolean (str Val))
                (absvector? Val) (tagged-absvector Val)
                true             (tagged-atom unknown (str Val))))

(define tagged-absvector
  Vec -> (make-string "(absvector ~S)" (hash Vec 4294967295)))

(define tagged-atom
  Tag Val -> (make-string "(~A ~S)" Tag (escape-string Val)))

(define tagged-error
  Err -> (tagged-atom error (error-to-string Err)))

(define tagged-cons
  [Head | Tail] -> (make-string "(cons ~A ~A)"
                                (tagged-value Head)
                                (tagged-value Tail)))

(define result-to-string
    (@p success Val) -> (tagged-value Val)
    (@p error Err) -> (tagged-error Err))

(define kl-print
    Result -> (do (output "=> ")
                  (output (result-to-string Result))
                  (nl 1)))

(define kl-exec
    Form -> (trap-error (@p success (eval-kl Form))
                        (/. E (@p error E))))
(define kl-spec-repl
   -> (do (nl)
          (output "READY")
          (nl)
          (kl-spec-repl-loop)))

(define kl-spec-repl-loop
    -> (let Form (read)
            (if (= Form quit!)
                done
                (do (kl-print (kl-exec Form))
                    (kl-spec-repl-loop)))))
