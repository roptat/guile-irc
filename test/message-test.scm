;; Copyright (C) 2012 bas smit (fbs)

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

(use-modules (srfi srfi-64))
(use-modules ((irc message) #:prefix msg:))

(test-begin "message")

(let ((m (msg:parse-message-string ":server.org NOTICE Auth :*** Looking !")))
  (test-assert "test 1: prefix"
    (string=? (msg:prefix m) "server.org"))
  (test-assert "test 1: command"
    (eq? (msg:command m) (string->symbol "NOTICE")))
  (test-assert "test 1: timestamp"
    (number? (msg:time m)))
  (test-assert "test 1: middle"
    (string=? (msg:middle m) "Auth"))
  (test-assert "test 1: tail"
    (string=? (msg:trailing m) "*** Looking !")))

(let ((m (msg:parse-message-string ":moorcock.freenode.net 001 foeps :Welcome !@#$%^&*()-=_+[]{};';\",./<>?")))
  (test-assert "test 2: valid characters: prefix"
    (string=? (msg:prefix m) "moorcock.freenode.net"))
  (test-assert "test 2: valid characters: command"
    (= (msg:command m) 1))
  (test-assert "test 2: valid characters: timestamp"
    (number? (msg:time m)))
  (test-assert "test 2: valid characters: timestamp 2"
    (<= (msg:time m) (current-time)))
  (test-assert "test 2: valid characters: middle"
    (string=? (msg:middle m) "foeps"))
  (test-assert "test 2: valid characters: tail"
    (string=? (msg:trailing m) "Welcome !@#$%^&*()-=_+[]{};';\",./<>?")))

(let ([m (msg:parse-message-string "PING :irc.baslab.org")])
  (test-assert "test 3: message without prefix: message source"
    (string=? "irc.baslab.org" (msg:parse-source m)))
  (test-assert "test 3: message without prefix: message target"
    (string=? "irc.baslab.org" (msg:parse-target m)))
  (test-assert "test 3: message without prefix: command"
    (eq? 'PING (msg:command m)))
  (test-assert "test 3: message without prefix: middle"
    (eq? #f (msg:middle m))))

(let ([m (msg:parse-message-string ":fubs!fubs@127.0.0.1 MODE #test +o bas")])
  (let ([prefix (msg:prefix m)])
    (test-assert "test 4: mode: nick"
      (string=? (car prefix) "fubs"))
    (test-assert "test 4: mode: user"
      (string=? (cadr prefix) "fubs"))
    (test-assert "test 4: mode: hostname"
      (string=? (caddr prefix) "127.0.0.1")))
  (test-assert "test 4: mode: message command"
    (eq? 'MODE (msg:command m)))
  (let ([middle (msg:middle m)])
    (test-assert "test 4: mode: middle command 1"
      (string=? (car middle) "#test"))
    (test-assert "test 4: mode: middle command 2"
      (string=? (cadr middle) "+o"))
    (test-assert "test 4: mode: middle command 3"
      (string=? (caddr middle) "bas"))))

(test-end "message")
