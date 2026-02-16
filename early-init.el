;;; early-init.el --- Early initialization  -*- lexical-binding: t; -*-

;; ========================================
;; 1. 语言环境和编码设置
;; ========================================
(set-language-environment "UTF-8")  ;; 设置语言环境为 UTF-8，确保正确处理 Unicode 字符
(set-terminal-coding-system 'utf-8) ;; 终端输入输出使用 UTF-8 编码, 确保在终端中正确显示 Unicode 字符
(set-keyboard-coding-system 'utf-8) ;; 键盘输入使用 UTF-8 编码，确保输入的 Unicode 字符正确处理

;; ========================================
;; 窗口大小设置（必须在图形界面初始化前）
;; ========================================
(setq frame-inhibit-implied-resize t)  ;; 禁止 Emacs 隐含的窗口大小调整
(setq window-resize-pixelwise t)        ;; 调整时按像素来，更精细

;; 可选：设置默认窗口大小（字符为单位）
(setq default-frame-alist
      '((width . 120)      ;; 字符宽度
        (height . 35)      ;; 字符高度
        (left . 248)         ;; 左边距（像素）
        (top . 55)))       ;; 上边距（像素）

;; ========================================
;; 2. 警告控制（最早）
;; ========================================
(setq warning-suppress-types '((cl)       ;; 屏蔽 cl 相关警告
                               (x)        ;; 屏蔽 face 库相关警告
                               (face)     ;; 屏蔽 face 相关警告
                               (files)    ;; 屏蔽文件相关警告
                               (lexical)  ;; 屏蔽 lexical-binding 警告
                               ))
(setq warning-minimum-level :warning) ;; 保持默认警告级别，或设为 :warning

;; ========================================
;; 3. 启动画面控制
;; ========================================
(defun my-startup-screen-advice (orig-fun &rest args)
  "不带参数时显示欢迎界面，否则隐藏欢迎界面"
  (let ((file-buffers (seq-filter #'buffer-file-name (buffer-list))))
    (when (= (length file-buffers) 0)
      (apply orig-fun args))))
(advice-add 'display-startup-screen :around #'my-startup-screen-advice)

;; ========================================
;; 4. 性能优化（可选）
;; ========================================
(setq file-name-handler-alist nil)  ; 临时禁用，init.el 最后恢复
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist nil)))  ; 启动后恢复

(message "✅ early-init.el loaded.")
