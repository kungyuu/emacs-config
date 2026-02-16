;;; plugins.el --- Plugins -*- coding: utf-8; lexical-binding: t; -*-

;;; ==================== 包管理器初始化 ====================
(require 'package)

;; 禁止启动时自动加载包，由 use-package 控制
(setq package-enable-at-startup nil)

;; 配置包仓库 - 按地区选择最快的镜像源
(setq package-archives
      '(;; 官方源 - 速度较慢但最稳定
        ("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("nongnu". "https://elpa.nongnu.org/nongnu/")
        
        ;; 国内镜像源（速度更快）- 需要时取消注释
        ;; 中科大镜像
        ;; ("gnu"   . "https://mirrors.ustc.edu.cn/elpa/gnu/")
        ;; ("melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/")
        ;; ("nongnu". "https://mirrors.ustc.edu.cn/elpa/nongnu/")
        
        ;; 清华镜像
        ;; ("gnu"   . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ;; ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ;; ("nongnu". "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
        )

      ;; 仓库优先级设置 - 确保稳定优先
      package-archive-priorities
      '(("gnu"    . 10)   ;; GNU ELPA 优先级最高，最稳定
        ("nongnu" . 5)    ;; NonGNU 次之
        ("melpa"  . 0)))  ;; MELPA 最后，包更新最快但可能不稳定

;; 启用包快速启动，大幅提升加载速度
(setq package-quickstart t)

;; 初始化包管理器，t 参数避免重新初始化
(package-initialize t)

;;; ==================== use-package 配置 ====================
;; 确保 use-package 已安装
(unless (package-installed-p 'use-package)
  (package-refresh-contents)                  ;; 刷新包列表
  (package-install 'use-package))             ;; 安装 use-package

;; 加载 use-package
(eval-when-compile
  (require 'use-package))

;; use-package 优化配置
(setq use-package-always-ensure t             ;; 自动安装缺失的包
      use-package-expand-minimally t          ;; 最小化展开，减少启动时间
      use-package-compute-statistics t        ;; 统计加载时间供分析
      use-package-verbose nil                 ;; 关闭详细输出，减少启动噪音
      use-package-minimum-reported-time 0.1)  ;; 报告加载超过0.1秒的包

;;; ==================== 内置包优化 ====================
;; 使用内置包替代外部包，减少依赖
(use-package emacs
  :ensure nil                               ;; 不安装，这是Emacs本身
  :config
  ;; 内置包配置可以放在这里
  ;; 例如：设置内置包的行为
  (editorconfig-mode 1)
  )

;; 解决内部依赖问题 - 例如 editorconfig 内置但需要启用
(use-package dash
  :ensure t
  )

;;; ==================== 启动时间统计 ====================
;; 记录启动时间
(defvar my/emacs-load-start-time (current-time)
  "Emacs 启动开始时间，用于计算启动耗时")

;; 启动完成后显示耗时
(add-hook 'after-init-hook
          (lambda ()
            (message "✅ Emacs 启动完成，耗时 %.2f 秒"
                     (float-time (time-subtract (current-time)
                                                my/emacs-load-start-time)))))

;; ==================== 性能监控（可选）====================
;; 如果需要分析启动性能，取消下面的注释
;; (use-package benchmark-init
;;   :ensure t
;;   :demand t                                  ;; 立即加载，确保捕获所有初始化
;;   :config
;;   (add-hook 'after-init-hook 'benchmark-init/deactivate)
;;   (add-hook 'after-init-hook 'benchmark-init/show-durations-log))

;;; ==================== 主题配置 ====================

;; 安装 Dracula Theme - 默认启用
(use-package dracula-theme
  :ensure t
  ;; :demand t                                   ;; 立即加载
  :defer t                                     ;; 延迟加载
  ;; :config
  ;; (load-theme 'dracula t)
  )

;; 其他主题配置优化：
;; 1. 使用 :defer t 延迟加载，只在需要时加载
;; 2. 添加 :custom 设置主题选项
;; 3. 统一使用 autoload 而非立即加载

(use-package poet-theme
  :ensure t
  :config
  (load-theme 'poet t))

(use-package doom-themes
  :ensure t
  :defer t
  ;; :custom
  ;; (doom-themes-enable-bold t)                  ;; 启用粗体
  ;; (doom-themes-enable-italic t)                ;; 启用斜体
  ;; :config
  ;; (load-theme 'doom-zenburn t)              ;; 默认不加载，需要时通过切换主题加载
  )

;;; ==================== 增强功能 ====================

;; which-key - 显示可用的快捷键
(use-package which-key
  :ensure t
  :demand t                                    ;; 立即加载，这是常用的增强功能
  :custom
  (which-key-idle-delay 0.3)                   ;; 延迟0.3秒显示，避免干扰
  (which-key-max-description-length 30)        ;; 描述最大长度
  (which-key-show-early-on-C-h t)              ;; 按C-h后立即显示
  (which-key-sort-order 'which-key-prefix-then-key-order) ;; 排序方式
  :config
  (which-key-mode))                            ;; 启用 which-key 模式

;; smartparens - 智能括号补全
(use-package smartparens
  :ensure t
  :demand t                                     ;; 立即加载，编辑体验相关
  :hook ((prog-mode . smartparens-mode)         ;; 在编程模式中启用
         (markdown-mode . smartparens-mode)     ;; 在markdown中启用
         (org-mode . smartparens-mode))         ;; 在org-mode中启用
  :custom
  (sp-base-key-bindings 'paredit)               ;; 使用 paredit 风格的键绑定
  (sp-autoskip-closing-pair 'always)            ;; 自动跳过关闭括号
  (sp-highlight-pair-overlay t)                 ;; 高亮匹配的括号对
  (sp-highlight-wrap-overlay t)                 ;; 高亮包裹的区域
  (sp-highlight-wrap-tag-overlay t)             ;; 高亮包裹的标签
  :config
  (require 'smartparens-config)                 ;; 加载默认配置
  
  ;; 为特定模式禁用 smartparens
  (dolist (hook '(lisp-interaction-mode-hook    ;; 这些模式禁用
                  emacs-lisp-mode-hook
                  scheme-mode-hook
                  inferior-emacs-lisp-mode-hook))
    (add-hook hook (lambda () (smartparens-mode -1)))))

;;; ==================== 可选功能 ====================

;; company - 代码补全
;; (use-package company
;;   :ensure t
;;   :demand t
;;   :custom
;;   (company-idle-delay 0.3)                    ;; 补全延迟
;;   (company-minimum-prefix-length 2)            ;; 最小触发前缀长度
;;   (company-selection-wrap-around t)            ;; 选择循环
;;   :config
;;   (global-company-mode))

;; 如果需要语法检查，可以取消注释
;; (use-package flycheck
;;   :ensure t
;;   :hook (prog-mode . flycheck-mode)
;;   :custom
;;   (flycheck-check-syntax-automatically '(save idle-change))
;;   (flycheck-idle-change-delay 1.0))

;; ========== Markdown + preview ==========================
;; preview 使用本地浏览器 + 专业浏览器插件 markdown preview
(use-package markdown-mode
  :ensure t
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :config
  (setq markdown-fontify-code-blocks-natively t)
  
  ;; 🔥 新命令：直接用 Edge 打开当前文件
  (defun my-markdown-open-in-edge ()
    "在 Edge 中打开当前 Markdown 文件"
    (interactive)
    (let ((file (buffer-file-name)))
      (if file
          ;; (browse-url-file file)  ;; 用系统默认浏览器打开
          (shell-command (format "start msedge \"%s\"" file)) ;; 使用 ms-edge 打开
        (message "当前缓冲区没有关联的文件"))))
  
  :bind (:map markdown-mode-map
         ("C-c C-c p" . my-markdown-open-in-edge)))  ;; 覆盖原来的预览

;;; ========== 语义补全 (EGLOT + CORFU + ORDERLESS) ==========

;; 确保安装所需插件 (M-x package-install 安装 corfu, orderless)
;; eglot 是 Emacs 29+ 内置的，无需手动安装

;; ---------- 补全前端: Corfu ----------
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)                 ;; 启用自动补全
  (corfu-auto-delay 0.2)         ;; 输入后延迟0.2秒弹出
  (corfu-auto-prefix 1)          ;; 输入1个字符即触发
  (corfu-cycle t)                ;; 允许在列表末尾循环
  (corfu-preselect 'always)      ;; 预选第一项，但不会自动插入
  (corfu-quit-at-boundary nil)   ;; 不要在边界自动退出
  (corfu-quit-no-match nil)      ;; 不要因为没有匹配项就退出
  (corfu-preview-current nil)    ;; 关闭预览，避免干扰
  :init
  (global-corfu-mode))

;; ---------- 补全增强: Orderless (模糊匹配) ----------
(use-package orderless
  :ensure t
  :custom
  ;; 设置补全风格，orderless 在前，basic 作为保底
  (completion-styles '(orderless basic))
  ;; 对于文件路径，使用 partial-completion 以支持通配符
  (completion-category-overrides '((file (styles partial-completion))))
  ;; Emacs 31 及以上的优化设置
  (completion-pcm-leading-wildcard t))

;; ---------- 后端引擎: Eglot (LSP 客户端) ----------
(use-package eglot
  :ensure nil  ;; eglot 是内置的，无需安装
  :hook (;; 对于你想启用 LSP 的编程语言主模式，在这里添加
         (python-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (go-mode . eglot-ensure)
         (js-mode . eglot-ensure)
         (typescript-mode . eglot-ensure)
         (c-mode . eglot-ensure)
         (c++-mode . eglot-ensure)
         (sh-mode . eglot-ensure)
         (bash-ts-mode . eglot-ensure)
         )
  :config
  ;; 告诉 Eglot 使用 Corfu 作为补全前端
  (setq eglot-completion-provider :capf)
  
  ;; 如果你想禁用 Eglot 自动覆盖某些变量，可以这样设置
  ;; (add-to-list 'eglot-stay-out-of 'company-backends) ;; 如果你同时用 company
  )

;; ---------- 额外增强: 补全来源补充 (可选) ----------
;; 提供更丰富的补全来源，比如从当前文件/项目里找单词
(use-package cape
  :ensure t
  :init
  ;; 将 Cape 提供的补全函数添加到全局的补全列表
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)      ;; 从缓冲区补全
  (add-to-list 'completion-at-point-functions #'cape-file)         ;; 文件名补全
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)  ;; 在注释里补全elisp
  ;; (add-to-list 'completion-at-point-functions #'cape-keyword)      ;; 关键字补全
  (add-to-list 'completion-at-point-functions #'cape-elisp-symbol) ;; Elisp 符号补全
  )

;;; ==================== 提供包 ====================
(provide 'plugins)
;;; plugins.el ends here