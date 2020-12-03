;;; init.el --- Standard ML environment in Emacs     -*- lexical-binding: t; -*-

;; Copyright (C) 2020 Keita SAITOU

;; Author: Keita SAITOU <keita44.f4@gmail.com>
;; Keywords: tools, languages

;; This program is distribute under MIT license.
;; See also LICENSE file.

;;; Commentary:

;; This is Emacs configuration file to develop to Standard ML code.
;; It requires latest SML# compiler or MLton compiler >= v20130715.
;; If you use SML# compiler to flycheck, you need not only .sml file
;; but also .smi file.

;;; Code:

;; package.el
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(eval-and-compile (package-initialize))

;; leaf.el
;; https://github.com/conao3/leaf.el
(unless (package-installed-p 'leaf)
  (package-refresh-contents)
  (package-install 'leaf))
(eval-and-compile
  (leaf leaf-keywords :ensure t
    :init
    (leaf el-get :ensure t)
    :config
    (leaf-keywords-init)))

;; company-mode
;; https://company-mode.github.io/
(leaf company :ensure t
  :defvar company-backends
  :global-minor-mode global-company-mode
  :custom
  (company-selection-wrap-around . t)      ; 補完候補で上下をループする
  (company-tooltip-align-annotations . t)) ; 補完リストの型を右揃えで整列する

;; company-quickhelp
;; https://github.com/company-mode/company-quickhelp
(leaf company-quickhelp :ensure t
  :config
  (company-quickhelp-mode))

;; flycheck
;; https://www.flycheck.org/en/latest/
(leaf flycheck :ensure t
  :defvar flycheck-checkers flycheck-checker
  :global-minor-mode global-flycheck-mode)

;; flycheck-pos-tip
;; https://github.com/flycheck/flycheck-pos-tip
(leaf flycheck-pos-tip :ensure t
  :after flycheck
  :custom
  (flycheck-pos-tip-timeout . 0) ; pos-tipを自動で消さない
  :config
  (flycheck-pos-tip-mode))

;; sml-mode
;; https://www.smlnj.org/doc/Emacs/sml-mode.html
(leaf sml-mode :ensure t
  ;; :hook (sml-mode-hook . (lambda () (setq-local flycheck-checker 'smlsharp)))
  )

;; company-mlton
;; https://github.com/MatthewFluet/company-mlton
(leaf company-mlton
  :el-get (company-mlton
           :url "https://github.com/MatthewFluet/company-mlton.git")
  :config
  (push
   '(company-mlton-keyword company-mlton-basis :with company-dabbrev-code)
   company-backends)
  :hook
  (sml-mode-hook . company-mlton-basis-autodetect))

;; flycheck-smlsharp
;; https://github.com/yonta/flycheck-smlsharp
(leaf flycheck-smlsharp
  :if (executable-find "smlsharp")
  :el-get (flycheck-smlsharp
           :url "https://github.com/yonta/flycheck-smlsharp.git")
  :after sml-mode
  :require t)

;; flycheck-mlton
;; https://gist.github.com/yonta/80c938a54f4d14a1b75146e9c0b76fc2
(leaf flycheck-mlton
  :if (executable-find "mlton")
  :el-get gist:80c938a54f4d14a1b75146e9c0b76fc2:flycheck-mlton
  :after sml-mode
  :require t
  :config
  (add-to-list 'flycheck-checkers 'mlton))

;; smartparens
;; https://github.com/Fuco1/smartparens
(leaf smartparens :ensure t
  :defun sp-local-pair
  :global-minor-mode smartparens-global-mode
  :config
  (sp-local-pair 'sml-mode "(*" "*)")
  (sp-local-pair 'sml-mode "'" nil :actions nil)
  (sp-local-pair 'sml-mode "`" nil :actions nil)
  (sp-local-pair 'inferior-sml-mode "(*" "*)")
  (sp-local-pair 'inferior-sml-mode "'" nil :actions nil)
  (sp-local-pair 'inferior-sml-mode "`" nil :actions nil))

;; dumb-jump
;; https://github.com/jacktasia/dumb-jump
(leaf dumb-jump :ensure t
  :hook (xref-backend-functions . dumb-jump-xref-activate))

(provide 'init)
;;; init.el ends here
