## 一、日常提交

```powershell
# 查看当前状态
git status

# 添加文件（明确指定要提交的文件）
git add 文件名1 文件名2

# 提交并写清楚改了啥
git commit -m "更新内容说明"

# 推送到 GitHub
git push
```

## 二、首次推送新仓库

```powershell
# 初始化
git init

# 添加文件
git add 你的配置文件

# 第一次提交
git commit -m "初始化项目"

# 关联远程仓库
git remote add origin https://github.com/用户名/仓库名.git

# 推送
git push -u origin main
```

## 三、常见问题解决

1. 误添加了不该加的文件（如 elpa/ 目录）

```powershell
# 取消暂存（还没提交）
git reset HEAD .

# 或者从 Git 中移除（已提交过）
git rm -r --cached 目录名
echo "目录名/" >> .gitignore
git add .gitignore
git commit -m "忽略目录"
```

2. 提交信息写错了

```powershell
# 修改最近一次提交的信息
git commit --amend -m "新的提交信息"
```

3. 想撤销最近的一次提交（但保留修改）

```powershell
git reset --soft HEAD~1
```

4. 连接不上 GitHub（代理问题）

```powershell
# 设置代理（端口根据你的代理软件调整）
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890

# 取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```

5. "Repository not found"

```powershell
# 检查远程地址是否正确
git remote -v

# 重新设置远程地址
git remote set-url origin https://github.com/用户名/仓库名.git
```

## 四、仓库改名后

```powershell
# 更新本地远程地址
git remote set-url origin https://github.com/用户名/新仓库名.git
```

## 五、查看历史

```powershell
# 查看提交历史
git log --oneline

# 查看某次改了啥
git show 提交ID
```

## 六、批量操作（小心使用）

```powershell
# 添加所有修改过的文件
git add .

# 添加所有并提交（跳过 git add）
git commit -a -m "更新说明"

# 推送所有分支
git push --all
```

## 一句话原则

. 每次提交前先 git status 看一眼  
. 只添加你想提交的文件，不用 git add .  
. 提交信息写清楚改了啥，方便以后回顾  
. 每次 push 前先 pull，保持同步  

