# Contributing to This Repository / 如何向本仓库上传文件

[English](#english) | [中文](#中文)

---

## English

### How to Upload Files to This Repository

Thank you for your interest in contributing to this research repository! There are several ways to upload files depending on your technical expertise and preferences.

#### Method 1: Using GitHub Web Interface (Easiest)

This is the simplest method for users who are not familiar with Git.

1. **Navigate to the repository**: Go to https://github.com/zhuzhuzhuzhuzhuzhu123/antipsychotics_tte_cprd

2. **Fork the repository** (if you don't have write access):
   - Click the "Fork" button in the top-right corner
   - This creates a copy of the repository in your GitHub account

3. **Upload files**:
   - Navigate to the folder where you want to add files (e.g., "R scripts")
   - Click "Add file" → "Upload files"
   - Drag and drop your files or click "choose your files"
   - Add a commit message describing your changes
   - Click "Commit changes"

4. **Create a Pull Request** (if you forked):
   - Go to the original repository
   - Click "Pull requests" → "New pull request"
   - Click "compare across forks"
   - Select your fork and branch
   - Click "Create pull request"
   - Add a title and description
   - Submit the pull request

#### Method 2: Using Git Command Line

This method is for users comfortable with the command line.

1. **Clone the repository**:
   ```bash
   git clone https://github.com/zhuzhuzhuzhuzhuzhu123/antipsychotics_tte_cprd.git
   cd antipsychotics_tte_cprd
   ```

2. **Create a new branch**:
   ```bash
   git checkout -b add-new-files
   ```

3. **Add your files**:
   ```bash
   # Copy your files to the appropriate directory
   cp /path/to/your/file.R "R scripts/"
   
   # Or create a new file
   nano "R scripts/new_analysis.R"
   ```

4. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Add new analysis script"
   ```

5. **Push to GitHub**:
   ```bash
   git push origin add-new-files
   ```

6. **Create a Pull Request**:
   - Visit the repository on GitHub
   - You'll see a prompt to create a pull request
   - Click "Compare & pull request"
   - Fill in the details and submit

#### Method 3: Using GitHub Desktop (User-Friendly GUI)

1. **Download GitHub Desktop**: https://desktop.github.com/

2. **Clone the repository**:
   - Open GitHub Desktop
   - File → Clone repository
   - Enter the repository URL or select from your GitHub repositories
   - Choose a local path

3. **Add files**:
   - Copy your files to the cloned repository folder on your computer
   - GitHub Desktop will automatically detect the changes

4. **Commit and push**:
   - Review the changes in GitHub Desktop
   - Add a commit message in the bottom-left
   - Click "Commit to main"
   - Click "Push origin"

5. **Create a Pull Request**:
   - In GitHub Desktop, click "Create Pull Request"
   - This opens your browser to create the PR on GitHub

### File Guidelines

When uploading files to this repository:

- **R Scripts**: Place in the "R scripts" folder
- **Code lists**: Link to them in the README or add to a "codelists" folder
- **Documentation**: Update README.md with descriptions of new files
- **Use descriptive names**: Follow the existing naming convention
- **Include comments**: Add clear comments in your R scripts

### Getting Help

If you need assistance:
- Open an issue on GitHub describing what you're trying to upload
- Contact the repository maintainer (see README.md for contact information)
- Review GitHub's documentation: https://docs.github.com/

---

## 中文

### 如何向本仓库上传文件

感谢您对本研究仓库的贡献兴趣！根据您的技术背景和偏好，有多种方式可以上传文件。

#### 方法一：使用 GitHub 网页界面（最简单）

这是最简单的方法，适合不熟悉 Git 的用户。

1. **访问仓库**：访问 https://github.com/zhuzhuzhuzhuzhuzhu123/antipsychotics_tte_cprd

2. **Fork 仓库**（如果您没有写入权限）：
   - 点击右上角的 "Fork" 按钮
   - 这会在您的 GitHub 账户中创建一个仓库副本

3. **上传文件**：
   - 导航到您想要添加文件的文件夹（例如 "R scripts"）
   - 点击 "Add file" → "Upload files"
   - 拖放您的文件或点击 "choose your files"
   - 添加提交消息描述您的更改
   - 点击 "Commit changes"

4. **创建 Pull Request**（如果您进行了 fork）：
   - 访问原始仓库
   - 点击 "Pull requests" → "New pull request"
   - 点击 "compare across forks"
   - 选择您的 fork 和分支
   - 点击 "Create pull request"
   - 添加标题和描述
   - 提交 pull request

#### 方法二：使用 Git 命令行

此方法适合熟悉命令行的用户。

1. **克隆仓库**：
   ```bash
   git clone https://github.com/zhuzhuzhuzhuzhuzhu123/antipsychotics_tte_cprd.git
   cd antipsychotics_tte_cprd
   ```

2. **创建新分支**：
   ```bash
   git checkout -b add-new-files
   ```

3. **添加您的文件**：
   ```bash
   # 将文件复制到适当的目录
   cp /path/to/your/file.R "R scripts/"
   
   # 或创建新文件
   nano "R scripts/new_analysis.R"
   ```

4. **提交更改**：
   ```bash
   git add .
   git commit -m "添加新的分析脚本"
   ```

5. **推送到 GitHub**：
   ```bash
   git push origin add-new-files
   ```

6. **创建 Pull Request**：
   - 在 GitHub 上访问仓库
   - 您会看到创建 pull request 的提示
   - 点击 "Compare & pull request"
   - 填写详细信息并提交

#### 方法三：使用 GitHub Desktop（用户友好的图形界面）

1. **下载 GitHub Desktop**：https://desktop.github.com/

2. **克隆仓库**：
   - 打开 GitHub Desktop
   - File → Clone repository
   - 输入仓库 URL 或从您的 GitHub 仓库中选择
   - 选择本地路径

3. **添加文件**：
   - 将文件复制到计算机上克隆的仓库文件夹中
   - GitHub Desktop 会自动检测更改

4. **提交并推送**：
   - 在 GitHub Desktop 中查看更改
   - 在左下角添加提交消息
   - 点击 "Commit to main"
   - 点击 "Push origin"

5. **创建 Pull Request**：
   - 在 GitHub Desktop 中，点击 "Create Pull Request"
   - 这会打开浏览器，在 GitHub 上创建 PR

### 文件上传指南

向本仓库上传文件时：

- **R 脚本**：放置在 "R scripts" 文件夹中
- **代码列表**：在 README 中链接或添加到 "codelists" 文件夹
- **文档**：在 README.md 中更新新文件的描述
- **使用描述性名称**：遵循现有的命名规范
- **包含注释**：在 R 脚本中添加清晰的注释

### 获取帮助

如果您需要帮助：
- 在 GitHub 上开启一个 issue，描述您想要上传的内容
- 联系仓库维护者（请参阅 README.md 中的联系信息）
- 查看 GitHub 文档：https://docs.github.com/cn/

---

## Additional Resources / 其他资源

### English
- [GitHub Documentation](https://docs.github.com/en/get-started)
- [Git Basics](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics)
- [Creating a Pull Request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)

### 中文
- [GitHub 文档（中文）](https://docs.github.com/cn/get-started)
- [Git 基础](https://git-scm.com/book/zh/v2)
- [创建拉取请求](https://docs.github.com/cn/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)
