# 收缩方法实践教程 / Shrinkage Methods Practical Tutorial

## 概述 / Overview

本脚本演示了四种重要的收缩方法（也称为正则化方法）：
This script demonstrates four important shrinkage methods (also known as regularization methods):

1. **岭回归 (Ridge Regression)** - 使用L2惩罚
2. **LASSO回归** - 使用L1惩罚，可以进行特征选择
3. **弹性网络 (Elastic Net)** - 结合L1和L2惩罚
4. **自助法均匀收缩 (Bootstrapping)** - 基于重采样的稳健估计

**注意 / Note**: 脚本使用Boston房价数据集作为演示示例，这是一个常用的教学数据集。用户可以轻松替换为自己的数据集。
The script uses the Boston housing dataset as a demonstration example, which is a commonly used educational dataset. Users can easily substitute their own data.

## 安装要求 / Installation Requirements

### 必需的R包 / Required R Packages

在运行脚本之前，请确保安装以下R包：
Before running the script, ensure the following R packages are installed:

```r
# 安装必需的包 / Install required packages
install.packages(c(
  "glmnet",      # Ridge, LASSO, Elastic Net
  "caret",       # 交叉验证和性能指标 / Cross-validation and performance metrics
  "boot",        # 自助法 / Bootstrapping
  "MASS",        # Boston数据集 / Boston dataset
  "dplyr",       # 数据处理 / Data manipulation
  "ggplot2",     # 可视化 / Visualization
  "reshape2",    # 数据重塑 / Data reshaping
  "gridExtra"    # 图形排列 / Grid arrangement
))
```

## 如何运行脚本 / How to Run the Script

### 方法1：在RStudio中运行 / Method 1: Run in RStudio

1. 打开RStudio
2. 打开脚本文件：`R scripts/8. Shrinkage Methods - Ridge LASSO Elastic Net.R`
3. 点击"Source"按钮或按Ctrl+Shift+S（Windows/Linux）或Cmd+Shift+S（Mac）

### 方法2：在R控制台中运行 / Method 2: Run in R Console

```r
# 设置工作目录 / Set working directory
setwd("path/to/antipsychotics_tte_cprd")

# 运行脚本 / Run script
source("R scripts/8. Shrinkage Methods - Ridge LASSO Elastic Net.R")
```

### 方法3：使用命令行 / Method 3: Using Command Line

```bash
# 在终端中 / In terminal
cd /path/to/antipsychotics_tte_cprd
Rscript "R scripts/8. Shrinkage Methods - Ridge LASSO Elastic Net.R"
```

## 脚本输出 / Script Output

脚本运行后会生成以下输出：
The script will generate the following outputs:

### 1. 控制台输出 / Console Output

- 数据集信息 / Dataset information
- 训练集和测试集大小 / Training and test set sizes
- 每种方法的最优参数 / Optimal parameters for each method
- 性能指标比较表 / Performance metrics comparison table
- 最佳模型推荐 / Best model recommendation

### 2. 图形输出 / Graphical Output

脚本会生成多个可视化图形：
The script generates multiple visualization plots:

- **交叉验证曲线** / Cross-validation curves - 显示不同lambda值的模型性能
- **系数路径** / Coefficient paths - 显示系数如何随惩罚强度变化
- **预测值 vs 实际值** / Predicted vs Actual - 评估预测准确性
- **残差图** / Residual plots - 诊断模型假设
- **Alpha调优图** / Alpha tuning plot - 显示弹性网络参数优化

## 性能指标说明 / Performance Metrics Explanation

脚本计算以下性能指标：
The script calculates the following performance metrics:

| 指标 / Metric | 说明 / Description | 解释 / Interpretation |
|--------------|-------------------|---------------------|
| **MSE** (均方误差) | 预测误差的平方平均值 | 越小越好 / Lower is better |
| **RMSE** (均方根误差) | MSE的平方根 | 与目标变量单位相同 / Same units as target |
| **MAE** (平均绝对误差) | 预测误差绝对值的平均值 | 对异常值不太敏感 / Less sensitive to outliers |
| **R²** (决定系数) | 模型解释的方差比例 | 越接近1越好 / Closer to 1 is better |

## 方法比较 / Method Comparison

### 岭回归 (Ridge Regression)
- **优点 / Advantages**: 处理多重共线性，稳定性好
- **缺点 / Disadvantages**: 不进行特征选择，保留所有变量
- **适用场景 / Use when**: 所有特征都很重要

### LASSO回归
- **优点 / Advantages**: 自动特征选择，产生稀疏模型
- **缺点 / Disadvantages**: 当变量高度相关时可能不稳定
- **适用场景 / Use when**: 需要特征选择或简单模型

### 弹性网络 (Elastic Net)
- **优点 / Advantages**: 结合Ridge和LASSO的优点
- **缺点 / Disadvantages**: 需要调整两个参数（alpha和lambda）
- **适用场景 / Use when**: 需要平衡特征选择和稳定性

### 自助法 (Bootstrapping)
- **优点 / Advantages**: 提供不确定性估计，稳健
- **缺点 / Disadvantages**: 计算密集
- **适用场景 / Use when**: 需要系数的置信区间

## 自定义数据 / Using Custom Data

要在自己的数据上使用收缩方法：
To use shrinkage methods on your own data:

```r
# 加载数据 / Load your data
my_data <- read.csv("your_data.csv")

# 准备预测变量和响应变量 / Prepare predictors and response
x <- model.matrix(response ~ ., my_data)[, -1]
y <- my_data$response

# 应用岭回归 / Apply ridge regression
cv_fit <- cv.glmnet(x, y, alpha = 0)
predictions <- predict(cv_fit, s = "lambda.min", newx = x)
```

## 常见问题 / Troubleshooting

### 问题1：包加载失败 / Issue 1: Package Loading Fails

**解决方案 / Solution**: 确保安装所有必需的包

```r
install.packages("package_name")
```

### 问题2：内存不足 / Issue 2: Out of Memory

**解决方案 / Solution**: 对于大数据集，减少自助法重采样次数

```r
# 将R参数从1000减少到100 / Reduce R parameter from 1000 to 100
boot_results <- boot(data = train_data, statistic = bootstrap_lm, R = 100)
```

### 问题3：图形未显示 / Issue 3: Plots Not Showing

**解决方案 / Solution**: 确保图形设备已打开

```r
# 打开新的图形窗口 / Open new graphics window
dev.new()
```

## 进一步学习 / Further Learning

### 推荐资源 / Recommended Resources

1. **书籍 / Books**:
   - "The Elements of Statistical Learning" by Hastie, Tibshirani, and Friedman
   - "An Introduction to Statistical Learning" by James et al.

2. **在线课程 / Online Courses**:
   - Stanford CS229 (Machine Learning)
   - Coursera: Machine Learning by Andrew Ng

3. **文档 / Documentation**:
   - [glmnet包文档](https://cran.r-project.org/web/packages/glmnet/index.html)
   - [caret包文档](https://topepo.github.io/caret/)

## 许可证 / License

本脚本遵循与仓库相同的许可证。
This script follows the same license as the repository.

## 联系方式 / Contact

如有问题或建议，请联系仓库维护者。
For questions or suggestions, please contact the repository maintainer.
