(define-module (html-prime)
  #:use-module (haunt post)
  #:use-module (haunt reader)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-26)
  #:use-module (sxml simple)
  #:export (html-reader-prime))

(define (read-html-post-prime port)
  (values (read-metadata-headers port)
          (let loop ((ret '()))
            (catch 'parser-error
              (lambda ()
                (match (xml->sxml port)
                  (('*TOP* sxml) (loop (cons sxml ret)))))
              (lambda (key . parameters)
                (reverse ret))))))

(define html-reader-prime
  (make-reader (make-file-extension-matcher "html")
               (cut call-with-input-file <> read-html-post-prime)))
