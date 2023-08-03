(use-modules (haunt asset)
             (haunt builder blog)
             (haunt builder atom)
             (haunt builder assets)
             (haunt post)
             (haunt site)
             (html-prime)
             (theme)
             (utils))

(define %collections
  `(("Recent Posts" "index.html" ,posts/reverse-chronological)))

(define about-page
  (static-page
   "About Me"
   "about.html"
   `(div (@ (style "display:flex")) 
         (img (@ (src "images/suigintou-sicp.jpg") 
                 (style "object-fit:contain; align-self:flex-start; 
                         width: 350px; padding-top: 20px; padding-bottom: 20px")))
         (div (@ (style "flex: 1 1 auto; padding-left: 30px"))
              (h2 "Hello 👋")
              (p "My name is Sarthak (IPA: /s̪äːɾ.t̪ʰək/).")
              (p "I like computers, mathematics and music.")
              (p "I am currently working as a " 
                 ,(anchor "GSoC" "https://summerofcode.withgoogle.com") 
                 " intern at "
                 ,(anchor "GNU Guix" "https://guix.gnu.org")
                 ".")
              (p "You can contact me via e-mail at shahsarthakw at gmail dot com.")))))

(site #:title "(blog . (lispy . tech))"
      #:domain "blog.lispy.tech"
      #:default-metadata
      '((author . "Sarthak Shah")
        (email  . "shahsarthakw@gmail.com"))
      #:readers (list html-reader-prime)
      #:builders (list (blog #:theme lispy-theme #:collections %collections)
                       (atom-feed)
                       (atom-feeds-by-tag)
                       about-page
                       (static-directory "css")
                       (static-directory "js")
                       (static-directory "fonts")
                       (static-directory "images")))
