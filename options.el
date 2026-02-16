;;; options.el --- Basic options  -*- lexical-binding: t; -*-

;; ========================================
;; 编码设置（必须放在最前面）
;; ========================================
(set-default-coding-systems 'utf-8)
(set-language-environment 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; ========================================
;; 字体设置
;; ========================================
(when (eq system-type 'windows-nt)
  ;; 默认字体
  (set-face-attribute 'default nil
                      :family "Sarasa Term SC Nerd"
                      :height 110)
  
  ;; 固定宽度字体
  (set-face-attribute 'fixed-pitch nil
                      :family "Sarasa Term SC Nerd"
                      :height 1.0)
  
  ;; 可变宽度字体
  (set-face-attribute 'variable-pitch nil
                      :family "Microsoft Yahei"
                      :height 1.2
                      :weight 'normal)
  
  ;; 🔥 修复 tab-bar 字体过大
  (set-face-attribute 'tab-bar nil
                      :family (face-attribute 'default :family)
                      :height (face-attribute 'default :height))
  (set-face-attribute 'tab-bar-tab nil
                      :family (face-attribute 'default :family)
                      :height (face-attribute 'default :height))
  (set-face-attribute 'tab-bar-tab-inactive nil
                      :family (face-attribute 'default :family)
                      :height (face-attribute 'default :height))
  
  ;; Emoji 字体
  (set-fontset-font t 'unicode
                    (font-spec :family "Segoe UI Emoji")
                    nil 'after))

;; ========================================
;; Markdown 代码块强制修复
;; ========================================
(defun my-force-markdown-faces ()
  "Markdown 样式：针对 Adwaita 浅色主题优化"
  (when (derived-mode-p 'markdown-mode)
    (setq-local line-spacing 0)
    
    ;; Adwaita 浅色主题配色
    (let ((bg-color "#ffffff")      ;; 纯白背景
          (fg-color "#2e3436")      ;; 深灰文字
          (code-bg "#f6f8fa")       ;; 浅灰代码块背景
          (inline-code-bg "#f0f0f0")) ;; 行内代码背景
      
      ;; 重置所有相关 face
      (dolist (face '(markdown-pre-face
                      markdown-code-face
                      markdown-inline-code-face
                      markdown-link-face
                      markdown-url-face))
        (face-remap-reset-base face))
      
      ;; 代码块
      (face-remap-add-relative 'markdown-pre-face
                               `(:background ,code-bg :foreground ,fg-color :extend t))
      (face-remap-add-relative 'markdown-code-face
                               `(:background ,code-bg :foreground ,fg-color :extend t))
      
      ;; 行内代码
      (face-remap-add-relative 'markdown-inline-code-face
                               `(:background ,inline-code-bg 
                                            :foreground ,fg-color 
                                            :extend nil))
      
      ;; 链接 - 让它和普通文字一样
      (face-remap-add-relative 'markdown-link-face 'default)
      (face-remap-add-relative 'markdown-url-face 'default)
      
      (message "Markdown faces updated for Adwaita theme"))))

;; 进入 Markdown 时应用
(add-hook 'markdown-mode-hook #'my-force-markdown-faces)

;; 切换主题时重新应用
(add-hook 'after-load-theme-hook
          (lambda ()
            (dolist (buf (buffer-list))
              (with-current-buffer buf
                (when (derived-mode-p 'markdown-mode)
                  (my-force-markdown-faces))))))

;;; 基础界面设置
;; (menu-bar-mode -1)                    ;; 关闭菜单栏，节省屏幕空间
(tool-bar-mode -1)                    ;; 关闭工具栏，保持界面简洁
;; (scroll-bar-mode -1)                  ;; 关闭滚动条，使用键盘滚动更高效
(global-display-line-numbers-mode t)  ;; 全局显示行号，便于定位
(column-number-mode t)                ;; 显示列号，精确光标位置
(global-hl-line-mode t)               ;; 高亮当前行，便于视觉定位
(show-paren-mode t)                   ;; 显示匹配的括号
(setq show-paren-style 'parenthesis)  ;; 仅高亮括号本身，不高亮区域
;; (blink-cursor-mode -1)                ;; 关闭光标闪烁，减少视觉干扰
(setq visible-bell t)                 ;; 使用视觉反馈代替蜂鸣声

;;; 编辑设置
(setq-default indent-tabs-mode nil)   ;; 使用空格代替Tab，保证跨编辑器一致性
(setq-default tab-width 4)            ;; 设置Tab宽度为4个空格
(setq-default fill-column 80)         ;; 设置自动换行列宽为80
(electric-pair-mode t)                ;; 自动补全括号引号，提升编码效率
(delete-selection-mode t)             ;; 选中区域后直接输入会替换选中内容
(electric-indent-mode t)              ;; 自动缩进，遵循语言规范
(global-visual-line-mode t)           ;; 视觉换行，不修改实际文本
(transient-mark-mode 1)               ;; 启用区域高亮显示

;;; 文件相关
(global-auto-revert-mode t)           ;; 文件变更时自动刷新缓冲区
(setq auto-save-default nil           ;; 禁用自动保存文件
      make-backup-files nil           ;; 禁用备份文件
      create-lockfiles nil            ;; 禁用锁定文件，避免冲突
      vc-follow-symlinks t            ;; 跟踪符号链接到实际文件
      require-final-newline t)        ;; 文件末尾自动添加换行符
(save-place-mode 1)                   ;; 记住文件上次光标位置
(recentf-mode t)                      ;; 启用最近打开文件列表
(setq recentf-max-menu-items 25       ;; 菜单中最多显示25个最近文件
      recentf-max-saved-items 25)     ;; 保存25个最近文件记录

;;; 搜索设置
(setq case-fold-search t)             ;; 搜索时忽略大小写
(setq isearch-lazy-highlight t)       ;; 搜索时实时高亮所有匹配项
(setq search-highlight t)            ;; 搜索时高亮当前匹配项
(setq query-replace-highlight t)     ;; 替换时高亮当前匹配项

;;; 滚动优化
(setq scroll-step 1                            ;; 每次滚动一行
      scroll-margin 0                            ;; 光标距窗口边缘0行时开始滚动
      scroll-conservatively 10000                  ;; 尽量保持光标在窗口内
      scroll-preserve-screen-position t             ;; 滚动时尽量保持光标位置
      mouse-wheel-scroll-amount '(1 ((shift) . 1))   ;; 鼠标滚轮每次滚动一行，Shift加速
      mouse-wheel-progressive-speed nil)               ;; 禁用鼠标滚轮加速
(pixel-scroll-precision-mode t)                          ;; 启用精确像素滚动

;;; 性能优化
(setq gc-cons-threshold 8000000                ;; GC阈值设为8MB，平衡性能和内存
      gc-cons-percentage 0.2                      ;; GC百分比设为20%
      auto-revert-verbose nil                       ;; 自动刷新时不显示详细信息
      idle-update-delay 1.0                           ;; 空闲更新延迟1秒
      echo-keystrokes 0.1)                             ;; 按键回显延迟0.1秒
(run-with-idle-timer 5 t #'garbage-collect)             ;; 空闲5秒后执行GC

;;; 界面增强
(which-function-mode t)        ;; 在模式栏显示当前函数名
(fset 'yes-or-no-p 'y-or-n-p)  ;; 用y/n代替yes/no，减少输入

;;; 行号样式
(custom-set-faces
 '(line-number ((t (:foreground "dim gray"))))            ;; 普通行号使用灰色
 '(line-number-current-line ((t (:background "yellow" :foreground "black"))))) ;; 当前行号黑底黄字

;;; Tab Bar设置 - 类似浏览器的标签页功能
(tab-bar-mode 1)                                ;; 启用标签栏模式
(setq tab-bar-show 1)                          ;; 始终显示标签栏
;; (setq tab-bar-new-tab-choice "*scratch*")     ;; 新标签页默认打开 *scratch* 缓冲区
;; (setq tab-bar-close-button-show nil)          ;; 隐藏标签页关闭按钮，使用快捷键关闭

(defun my-new-tab ()
  "Create a new tab with an empty buffer.
创建一个新的标签页并打开一个未命名的空缓冲区。
使用 generate-new-buffer-name 自动处理重名情况。"
  (interactive)                                 ;; 定义为交互式命令
  (tab-bar-new-tab)                              ;; 创建新标签页
  (switch-to-buffer (generate-new-buffer-name "*untitled*"))) ;; 切换到新创建的空白缓冲区
(defalias 'tab-new 'my-new-tab)                  ;; 为自定义函数创建别名

;; 标签页操作快捷键绑定
(global-set-key (kbd "C-x t N") 'my-new-tab)      ;; C-x t N 新建标签页
(global-set-key (kbd "C-x t n") 'tab-next)        ;; C-x t n 切换到下一个标签页
(global-set-key (kbd "C-x t p") 'tab-previous)    ;; C-x t p 切换到上一个标签页
(global-set-key (kbd "C-x t c") 'tab-bar-close-tab) ;; C-x t c 关闭当前标签页
(global-set-key (kbd "C-x t t") 'tab-bar-switch-to-tab) ;; C-x t t 选择指定标签页

;;; 插入新行函数 - 类似IDE的向下/向上插入新行功能
(defun insert-newline-below-and-indent ()
  "Insert a newline below the current line and indent it.
在当前行下方插入新行并进行缩进。
光标移动到当前行末尾，插入新行并自动缩进。"
  (interactive)                                   ;; 定义为交互式命令
  (end-of-line)                                    ;; 移动到当前行末尾
  (newline-and-indent))                            ;; 插入新行并缩进

(defun insert-newline-above-and-indent ()
  "Insert a newline above the current line and indent it.
在当前行上方插入新行并进行缩进。
光标移动到当前行开头，插入新行后上移光标并缩进。"
  (interactive)                                   ;; 定义为交互式命令
  (beginning-of-line)                              ;; 移动到当前行开头
  (newline)                                         ;; 插入新行（光标在新行的下一行）
  (forward-line -1)                                  ;; 上移光标到新插入的行
  (indent-according-to-mode))                         ;; 根据模式自动缩进

;; 插入新行快捷键绑定
(global-set-key (kbd "C-c o") 'insert-newline-below-and-indent) ;; C-c o 下方插入新行
(global-set-key (kbd "C-c O") 'insert-newline-above-and-indent) ;; C-c O 上方插入新行

;;; 注释增强 - 改进的注释/取消注释功能
(defun my-comment-dwim (&optional arg)
  "Enhanced comment/demment function.
改进的注释/取消注释功能：
- 如果选中区域，注释/取消注释该区域
- 如果光标在某行且不是空白行，注释/取消注释整行
- 其他情况调用默认的 comment-dwim"
  (interactive "*P")                             ;; 接受前缀参数，*表示只读缓冲区报错
  (comment-normalize-vars)                        ;; 确保注释变量已初始化
  (if (and (not (region-active-p))                 ;; 如果没有选中区域
           (not (looking-at "[ \t]*$")))            ;; 且当前行不是空白行
      (comment-or-uncomment-region                  ;; 注释/取消注释整行
        (line-beginning-position) (line-end-position))
    (comment-dwim arg)))                            ;; 否则调用默认函数

(global-set-key "\M-;" 'my-comment-dwim)           ;; M-; 调用增强版注释功能


;;; 简化主题切换 - 循环切换已安装的主题
(defvar my-themes nil 
  "Available themes cache. 已安装主题的缓存列表")
(defvar my-last-theme-update nil 
  "Last theme update time. 上次更新主题列表的时间")
(defun my-update-theme-cache ()
  "Update available themes cache.
更新已安装主题的缓存列表。"
  (setq my-themes (custom-available-themes)))      ;; 获取所有可用主题

(defun my-cycle-theme (direction)
  "Cycle through themes in DIRECTION (1 for forward, -1 for backward).
按指定方向循环切换主题：
DIRECTION 为 1 时切换到下一个主题，为 -1 时切换到上一个主题。"
  (when (or (null my-themes)                         ;; 如果主题列表为空
            (and my-last-theme-update                  ;; 或上次更新超过1小时
                 (> (float-time (time-since my-last-theme-update)) 3600)))
    (my-update-theme-cache)                            ;; 更新主题缓存
    (setq my-last-theme-update (current-time)))        ;; 记录更新时间
  
  (unless my-themes                                    ;; 如果没有可用主题
    (user-error "No available themes"))                ;; 报错
  
  (let* ((current (car custom-enabled-themes))          ;; 获取当前启用的主题
         (index (if current                              ;; 获取当前主题在列表中的索引
                    (or (cl-position current my-themes) -1)
                  -1))
         (new-index (mod (+ index direction) (length my-themes)))) ;; 计算新索引
    (when current                                        ;; 如果当前有启用的主题
      (disable-theme current))                            ;; 禁用当前主题
    (load-theme (nth new-index my-themes) t)              ;; 加载新主题
    (message "Theme: %s (Index: %d/%d)"                   ;; 显示切换信息
             (nth new-index my-themes) 
             (1+ new-index) 
             (length my-themes))))

(defun my-theme-next ()
  "Switch to the next theme.
切换到下一个主题。"
  (interactive)                                        ;; 定义为交互式命令
  (my-cycle-theme 1))                                   ;; 向前循环

(defun my-theme-prev ()
  "Switch to the previous theme.
切换到上一个主题。"
  (interactive)                                        ;; 定义为交互式命令
  (my-cycle-theme -1))                                  ;; 向后循环

;; 主题切换快捷键绑定
(global-set-key (kbd "C-c t") 'my-theme-next)          ;; C-c t 下一个主题
(global-set-key (kbd "C-c p") 'my-theme-prev)          ;; C-c p 上一个主题

;; 初始化主题
(my-update-theme-cache)                                 ;; 初始化主题列表
(setq my-last-theme-update (current-time))              ;; 记录初始化时间

;; 在主题加载后执行
;; (add-hook 'after-load-theme-hook #'my/fix-face-background)
;; (my/fix-face-background)

;;; 行连接增强 - 类似 Vim 的 J 命令
(defun my-join-next-line ()
  "Join the next line onto the current line with a space.
将下一行连接到当前行末尾，用空格分隔。
类似于 Vim 的 J 命令。"
  (interactive)                                         ;; 定义为交互式命令
  (if (= (line-number-at-pos) (line-number-at-pos (point-max))) ;; 如果已在最后一行
      (message "Already at the last line.")              ;; 提示已在最后一行
    (forward-line 1)                                      ;; 移动到下一行
    (call-interactively 'delete-indentation)))            ;; 删除缩进并连接

(global-set-key (kbd "M-^") 'my-join-next-line)         ;; M-^ 连接下一行

;;; ========== 区域选择和剪贴板相关 ==========

;; 剪贴板设置 - 确保与系统剪贴板同步
(setq select-enable-clipboard t            ;; 启用剪贴板集成
      select-enable-primary t               ;; 启用主选区集成（X11）
      mouse-drag-copy-region t               ;; 鼠标拖选时复制到区域
      mouse-yank-at-point t                    ;; 鼠标中键粘贴到光标位置
      x-select-enable-primary t                 ;; X11主选区支持
      x-select-enable-clipboard t)               ;; 系统剪贴板支持

;; 区域信息显示相关变量
(defvar my-region-timer nil 
  "Timer for showing region info. 用于显示区域信息的定时器")

(defvar my-timer-active nil 
  "Whether region timer is active. 区域信息定时器是否激活")

(defun my-show-region-info ()
  "Display the number of lines and characters in selected region.
显示选中区域的行数和字符数。
仅在区域激活且有实际内容时显示，避免在复制/剪切命令执行时干扰。"
  (when (and (region-active-p) (use-region-p)            ;; 当区域激活且有内容时
             ;; 避免在复制/剪切命令执行时显示
             (not (memq this-command '(kill-ring-save kill-region))))
    (let* ((start (region-beginning))                     ;; 区域开始位置
           (end (region-end))                              ;; 区域结束位置
           (lines (count-lines start end))                 ;; 计算行数
           (chars (- end start)))                           ;; 计算字符数
      (message "选中 %d 行，%d 字符" lines chars))))        ;; 显示信息

(defun my-start-region-timer ()
  "Start the region info timer if not already running.
启动区域信息显示定时器（如果尚未运行）。
使用0.5秒空闲时间触发，避免频繁显示干扰操作。"
  (unless my-timer-active                                  ;; 如果定时器未激活
    (setq my-region-timer (run-with-idle-timer 0.5 t 'my-show-region-info) ;; 创建定时器
          my-timer-active t)))                              ;; 标记为已激活

(defun my-stop-region-timer ()
  "Stop the region info timer.
停止区域信息显示定时器。"
  (when my-timer-active                                    ;; 如果定时器已激活
    (cancel-timer my-region-timer)                          ;; 取消定时器
    (setq my-timer-active nil)))                             ;; 标记为未激活

;; 启动区域信息定时器
(my-start-region-timer)                                     ;; 初始化时启动定时器

(defun my-count-and-message (orig-fun &rest args)
  "Advice function to count characters affected by kill-region.
为 kill-region 函数添加计数功能的 advice。
临时停止区域信息定时器避免干扰，执行剪切后显示剪切字符数。"
  (let* ((beg (nth 0 args))                                 ;; 剪切开始位置
         (end (nth 1 args))                                 ;; 剪切结束位置
         (char-count (- end beg))                            ;; 计算剪切字符数
         result)
    ;; 停止定时器避免干扰
    (my-stop-region-timer)                                   ;; 暂停区域信息显示
    ;; 调用原始剪切函数
    (setq result (apply orig-fun args))                      ;; 执行剪切
    ;; 重新启动定时器
    (my-start-region-timer)                                   ;; 恢复区域信息显示
    ;; 显示剪切信息
    (when (> char-count 0)                                    ;; 如果剪切了内容
      (message "剪切 %d 个字符" char-count))                  ;; 显示剪切字符数
    result))                                                  ;; 返回原始函数结果

;; 为剪切命令添加计数功能
(advice-add 'kill-region :around #'my-count-and-message)    ;; 增强剪切命令

(defun my-copy-region-with-count (orig-fun &rest args)
  "Advice function for kill-ring-save to show copied content info.
为复制命令添加计数功能的 advice。
临时停止区域信息定时器避免干扰，执行复制后显示复制的行数和字符数。"
  (let* ((beg (nth 0 args))                                 ;; 复制开始位置
         (end (nth 1 args))                                 ;; 复制结束位置
         (char-count (- end beg))                            ;; 计算复制字符数
         (line-count (count-lines beg end))                  ;; 计算复制行数
         result)
    ;; 停止定时器避免干扰
    (my-stop-region-timer)                                   ;; 暂停区域信息显示
    ;; 调用原始复制函数
    (setq result (apply orig-fun args))                      ;; 执行复制
    ;; 重新启动定时器
    (my-start-region-timer)                                   ;; 恢复区域信息显示
    ;; 显示复制信息
    (if (> line-count 1)                                      ;; 如果复制了多行
        (message "Copied %d lines, %d characters" line-count char-count) ;; 显示行数和字符数
      (message "Copied %d characters" char-count))            ;; 只显示字符数
    result))                                                  ;; 返回原始函数结果

;; 为复制命令添加计数功能
(advice-add 'kill-ring-save :around #'my-copy-region-with-count) ;; 增强复制命令

;;; 智能删除到行首 - 保留缩进的删除功能
(defun my-delete-to-line-beginning-smart ()
  "Smart delete from point to beginning of line.
智能删除从光标到行首的内容：
- 如果光标在缩进位置或之前：删除到真正的行首
- 如果光标在文本上：只删除到缩进开始（保留缩进）
类似于 Vim 的 d0 和 d^ 命令的结合。"
  (interactive)                                             ;; 定义为交互式命令
  (let* ((bol (line-beginning-position))                     ;; 行首位置
         (indent-pos (save-excursion (back-to-indentation) (point))) ;; 缩进开始位置
         (current-pos (point)))                              ;; 当前光标位置
    (cond
     ;; 光标在缩进位置或之前：删除到真正的行首
     ((<= current-pos indent-pos)
      (delete-region bol current-pos))
     ;; 光标在文本上：只删除到缩进开始（保留缩进）
     (t
      (delete-region indent-pos current-pos)))))

(global-set-key (kbd "C-c u") 'my-delete-to-line-beginning-smart) ;; C-c u 智能删除到行首

;;; 编码设置 - 统一使用UTF-8
(set-default-coding-systems 'utf-8)                        ;; 设置默认编码为UTF-8
(setq initial-scratch-message nil)                          ;; 清空*scratch*缓冲区的默认消息

;;; 确保退出时清理定时器 - 避免Emacs退出后残留定时器
(add-hook 'kill-emacs-hook #'my-stop-region-timer)         ;; Emacs退出时停止定时器

(setq whitespace-display-mappings
      '((space-mark ?\  [?·] [?.])      ;; 空格显示为 ·
        (newline-mark ?\n [?$ ?\n])      ;; 换行显示为 $
        (tab-mark ?\t [?» ?\t])))        ;; Tab 显示为 »

;; ========================================
;; 强制修复标题栏字体大小
;; ========================================
(defun my-fix-tab-bar-font ()
  "强制 tab-bar 字体与默认字体一致"
  (let ((default-height (face-attribute 'default :height))
        (default-family (face-attribute 'default :family)))
    (set-face-attribute 'tab-bar nil
                        :family default-family
                        :height default-height)
    (set-face-attribute 'tab-bar-tab nil
                        :family default-family
                        :height default-height)
    (set-face-attribute 'tab-bar-tab-inactive nil
                        :family default-family
                        :height default-height)))

;; 在主题加载后和 Emacs 启动后都执行
(add-hook 'after-load-theme-hook #'my-fix-tab-bar-font)
(add-hook 'window-setup-hook #'my-fix-tab-bar-font)  ;; 启动后执行

;; 立即执行一次
(my-fix-tab-bar-font)

(provide 'options)                                       ;; 提供 options 模块
;;; options.el ends here
