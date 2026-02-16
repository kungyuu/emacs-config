;;; init.el --- Init Settings -*- coding: utf-8; lexical-binding: t; -*-

;; ========================================
;; 1. 恢复 early-init.el 中禁用的功能
;; ========================================
(setq file-name-handler-alist nil)

;; ========================================
;; 2. Customize 配置
;; ========================================
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; ========================================
;; 3. 配置文件加载管理
;; ========================================
(defconst my/init-files '("plugins.el"
                          "options.el"
                          ))
(defun my/safe-load-config-file (filename)
  (condition-case err
      (let ((file-path (expand-file-name filename user-emacs-directory)))
        (when (file-exists-p file-path)
          (load-file file-path)
          (message "✅ 已加载: %s" filename)))
    (error
     (message "❌ 加载失败 %s: %s" filename (error-message-string err)))))

(dolist (file my/init-files)
  (my/safe-load-config-file file))

;; ========================================
;; 4. 启动完成提示
;; ========================================
(add-hook 'after-init-hook
          (lambda ()
            (message "🎉 Emacs 初始化完成")))
