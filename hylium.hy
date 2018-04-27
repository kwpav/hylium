(import [time [sleep]]
        [selenium [webdriver]]
        [selenium.webdriver.common.by [By]]
        [selenium.webdriver.support.ui [WebDriverWait]]
        [selenium.webdriver.support [expected_conditions :as EC]])

;; Locators
;; id and name are reserved words...
;; (setv by-id By.ID)
(setv link-text By.LINK_TEXT)
(setv partial-link-text By.PARTIAL_LINK_TEXT)
;; (setv by-name By.NAME)
(setv tag By.TAG_NAME)
(setv css By.CSS_SELECTOR)
(setv xpath By.XPATH)

;;
;; HELPERS
;;

(defn is-type? [obj expected-type]
  "Determine if an object is an expected type"
  (is (type obj) expected-type))

;;
;; BROWSER ACTIONS
;;

;; String -> Action
(defn navigate [url]
  "Navigate to a URL"
  (.get driver url))

;;
;; FINDS
;;

;; Selenium.By String -> IWebElement
(defn find-element [by locator]
  "Find an element on the page"
  (wait-for-element by locator))

;;
;; WAITS
;;

;; Selenium.By String -> IWebElement
(defn wait-for-element [by locator]
  (-> (WebDriverWait driver 20)
      (.until (EC.presence_of_element_located (tuple [by locator])))))

;;
;; ELEMENT ACTIONS
;;

;; String String -> Action
(defn write [locator keys]
  "Write text or send keys to an element"
  (if (is-type? locator str)
      (-> (find-element css locator) (.send_keys keys))
      (-> locator (.send_keys keys))))

;; String -> Action
(defn click [locator]
  "Click an element"
  (if (is-type? locator str)
      (-> (find-element css locator) (.click))
      (-> locator (.click))))

;; String -> Action
(defn uncheck [locator]
  "Uncheck a checkbox if it is unchecked"
  (if (.is_selected (find-element css locator))
      (click locator)))

;; String -> Action
(defn check [locator]
  "Check a checkbox if it is checked"
  (if (not (.is_selected (find-element css locator)))
      (click locator)))
