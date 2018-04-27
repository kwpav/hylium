(import [time [sleep]]
        [selenium [webdriver]]
        [selenium.webdriver.common.by [By]]
        [selenium.webdriver.support.ui [WebDriverWait]]
        [selenium.webdriver.support [expected_conditions :as EC]])

;; 
;; CONFIG
;;

(setv default-selector-type css)
(setv default-wait-time 60)

;; 
;; LOCATORS
;;

(setv by-id By.ID)
(setv by-link-text By.LINK_TEXT)
(setv by-partial-link-text By.PARTIAL_LINK_TEXT)
(setv by-name By.NAME)
(setv by-tag By.TAG_NAME)
(setv by-css By.CSS_SELECTOR)
(setv by-xpath By.XPATH)

;;
;; HELPERS
;;

(defn is-type? [obj expected-type]
  "Determine if an object is an expected type."
  (is (type obj) expected-type))

;;
;; BROWSER ACTIONS
;;

;; String -> Action
(defn navigate [url]
  "Navigate to a URL."
  (.get driver url))

;;
;; WAITS
;;

;; Selenium.By String -> WebElement
(defn wait-for-element [by locator]
  (-> (WebDriverWait driver default-wait-time)
      (.until (EC.presence_of_element_located (make-element by locator)))))

;;
;; ELEMENTS
;;

;; Selenium.By String -> Tuple
(defn make-element [by locator]
  "Define an element using a locator and its type (e.g. css, id, etc.)"
  (tuple [by locator]))

;; Element -> Selenium.By
(defn get-locator-type [element]
  "Get an elements locator type (e.g. css, id, etc.)"
  (first element))

;; Element -> String
(defn get-locator [element]
  "Get an elements locator"
  (last element))

;; (String or Element or WebElement) -> WebElement
(defn handle-element [element]
  "Find and return an element using the default selector, our element implementation,
  or return itself if it is already an element."
  (cond [(is-type? element str)
         (find-element default-selector-type element)]
        [(is-type? element tuple)
         (find-element (get-locator-type element)
                       (get-locator element))]
        [True element]))

;; Selenium.By String -> WebElement
(defn find-element [by locator]
  "Find an element on the page"
  (wait-for-element by locator))

;;
;; ELEMENT ACTIONS
;;

;; (String or Element or WebElement) String -> Action
(defn write [element keys]
  "Write text or send keys to an element."
  (-> (handle-element element) (.send_keys keys)))

;; (String or Element or WebElement) -> Action
(defn click [element]
  "Click an element"
  (.click (handle-element element)))

;; (String or Element or WebElement) -> Action
(defn uncheck [element]
  "Uncheck a checkbox if it is checked."
  (if (.is_selected (handle-element element))
      (click element)))

;; (String or Element or WebElement) -> Action
(defn check [element]
  "Check a checkbox if it is unchecked."
  (if (not (.is_selected (handle-element element)))
      (click element)))

;; (String or Element or WebElement) -> String
(defn text [element]
  "Read the text of an element."
  (setv el (handle-element element))
  el.text)
