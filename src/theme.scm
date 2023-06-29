(define-module (theme)
  #:use-module (haunt artifact)
  #:use-module (haunt builder blog)
  #:use-module (haunt html)
  #:use-module (haunt post)
  #:use-module (haunt site)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-19)
  #:use-module (utils)
  #:export (lispy-theme
            static-page
            project-page))

(define %cc-by-sa-link
  '(a (@ (href "https://creativecommons.org/licenses/by-sa/4.0/"))
      "Creative Commons Attribution Share-Alike 4.0 International"))

(define %cc-by-sa-button
  '(a (@ (class "cc-button")
         (href "https://creativecommons.org/licenses/by-sa/4.0/"))
      (img (@ (src "https://mirrors.creativecommons.org/presskit/buttons/88x31/svg/by-sa.svg")
              (height 31)))))

(define %emacs-button
  '(a (@ (class "cc-button")
         (href "https://www.gnu.org/software/emacs/"))
      (img (@ (src "images/made-with-emacs.png")))))

(define %glider-button
  '(a (@ (class "cc-button")
         (href "http://www.catb.org/jargon/html/"))
      (img (@ (src "images/glider.svg")
							(height 31)))))

(define %gnu-button
	'(a (@ (class "cc-button")
         (href "https://gnu.org"))
      (img (@ (src "images/gnubanner.gif")))))

(define %git-button
	'(a (@ (class "cc-button")
         (href "https://github.com/cel7t/blog"))
      (img (@ (src "images/get-the-source.png")
              (height 31)))))

(define (first-paragraph post)
  (let loop ((sxml (post-sxml post))
             (result '()))
    (match sxml
      (() (reverse result))
      ((or (('p ...) _ ...) (paragraph _ ...))
       (reverse (cons paragraph result)))
      ((head . tail)
       (loop tail (cons head result))))))

(define (kebabify str)
  (string-map
    (lambda (x)
      (if (eq? x #\Space) 
        #\-
        (char-downcase x)))
    str))

(define lispy-theme
  (theme #:name "lispy"
         #:layout
         (lambda (site title body)
           `((doctype "html")
             (head
              (meta (@ (charset "utf-8")))
              (title ,(string-append "(" (kebabify title) " . " (site-title site) ")"))
              (script (@ (type "module")
                         (src "https://esm.run/seia")))
              ,(stylesheet "reset")
              ,(stylesheet "fonts")
              ,(stylesheet "blog"))
             (body
              (div (@ (class "container"))
                   (div (@ (class "nav"))
                        (ul (li ,(link "(blog . (lispy . tech))" "/"))
                            (li (@ (class "fade-text")) " ")
                            (li ,(link "#:about" "/about.html"))
                            (li ,(link "#:posts" "/index.html"))))
                   ,body
                   (s-e-i-a) 
                   (footer (@ (class "text-center"))
                           (p (@ (class "copyright"))
                              "© 2023 Sarthak Shah • Built with "
                              ,(link "Haunt" "https://dthompson.us/projects/haunt.html"))
                           (link (@ (rel "webmention")
                                    (href "https://webmention.io/blog.lispy.tech/webmention")))
                           (link (@ (rel "pingback")
                                    (href "https://webmention.io/blog.lispy.tech/xmlrpc")))
                           (link (@ (rel "me")
                                    (href "mailto:shahsarthakw@gmail.com")))
                           (p (@ (class "copyright"))
                              ,%cc-by-sa-button
                              ,%emacs-button
															,%glider-button
															,%git-button
															,%gnu-button))))))
         #:post-template
         (lambda (post)
           `((h1 (@ (class "title")) ,(post-ref post 'title))
             (div (@ (class "date"))
                  ,(date->string (post-date post)
                                 "~B ~d, ~Y")
                  " • "
                  (a (@ (href "/about.html"))
                     ,(post-ref post 'author)))
            (div (@ (class "tags"))
                 (ul ,@(map (lambda (tag)
                              `(li "#:"
                                   (a (@ (href ,(string-append "/feeds/tags/"
                                                               tag ".xml")))
                                      ,tag)))
                            (assq-ref (post-metadata post) 'tags))))
             (div (@ (class "post"))
                  ,(post-sxml post))))
         #:collection-template
         (lambda (site title posts prefix)
           (define (post-uri post)
             (string-append "/" (or prefix "")
                            (site-post-slug site post) ".html"))

           `((h1 ,title
                 (a (@ (href "/feed.xml"))
                    (img (@ (class "feed-icon") (src "images/feed.png")))))
             ,(map (lambda (post)
                     (let ((uri (string-append "/"
                                               (site-post-slug site post)
                                               ".html")))
                       `(div (@ (class "summary"))
                             (h2 (a (@ (href ,uri))
                                    ,(post-ref post 'title)))
                             (div (@ (class "date"))
                                  ,(date->string (post-date post)
                                                 "~B ~d, ~Y"))
                             (div (@ (class "post"))
                                  ,(first-paragraph post))
                             (a (@ (href ,uri)) "(read more)"))))
                   posts)))))
         ;; #:pagination-template
         ;; (lambda (site body previous-page next-page)
         ;;   `(,@body
         ;;     (div (@ (class "paginator"))
         ;;      ,(if previous-page
         ;;           `(a (@ (class "paginator-prev") (href ,previous-page))
         ;;                "🡐 Newer")
         ;;           '())
         ;;      ,(if next-page
         ;;           `(a (@ (class "paginator-next") (href ,next-page))
         ;;               "Older 🡒")
         ;;           '()))))

(define (static-page title file-name body)
  (lambda (site posts)
    (serialized-artifact file-name
                         (with-layout lispy-theme site title body)
                         sxml->html)))
