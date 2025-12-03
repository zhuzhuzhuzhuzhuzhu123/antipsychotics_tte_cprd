# -----------------------
# SHRINKAGE METHODS PRACTICAL
# -----------------------

# 收缩方法实践：岭回归、LASSO、弹性网络和自助法
# Shrinkage Methods: Ridge Regression, LASSO, Elastic Net, and Bootstrapping

# Last updated: 03/12/2025

# 清理内存 / Clear memory
rm(list = ls())

# 加载所需包 / Load required packages
# 如果包未安装，请先运行：install.packages("package_name")
# If packages are not installed, run: install.packages("package_name")

library(glmnet)      # Ridge, LASSO, Elastic Net
library(caret)       # 交叉验证和性能指标 / Cross-validation and performance metrics
library(boot)        # 自助法 / Bootstrapping
library(MASS)        # Boston数据集 / Boston dataset
library(dplyr)       # 数据处理 / Data manipulation
library(ggplot2)     # 可视化 / Visualization
library(reshape2)    # 数据重塑 / Data reshaping
library(gridExtra)   # 图形排列 / Grid arrangement

# ============================================
# 第一部分：数据准备 / Part 1: Data Preparation
# ============================================

cat("\n=== 数据准备 / Data Preparation ===\n")

# 使用Boston房价数据集作为示例
# Using Boston housing dataset as example
# 注意：此数据集用于教学目的。用户可以使用自己的数据集替代。
# Note: This dataset is used for educational purposes. Users can substitute with their own data.
data(Boston)

# 查看数据结构 / View data structure
cat("\n数据集维度 / Dataset dimensions:", dim(Boston), "\n")
cat("变量名 / Variable names:\n")
print(names(Boston))

# 数据集说明 / Dataset description:
# medv: 中位房价（目标变量）/ Median home value (target variable)
# 其他变量为预测变量 / Other variables are predictors

# 设置随机种子以保证结果可重复 / Set seed for reproducibility
set.seed(123)

# 分割训练集和测试集 (70/30) / Split into training and testing sets (70/30)
train_index <- sample(1:nrow(Boston), 0.7 * nrow(Boston))
train_data <- Boston[train_index, ]
test_data <- Boston[-train_index, ]

cat("\n训练集样本数 / Training samples:", nrow(train_data))
cat("\n测试集样本数 / Testing samples:", nrow(test_data), "\n")

# 准备预测变量矩阵和响应变量向量 / Prepare predictor matrix and response vector
x_train <- model.matrix(medv ~ ., train_data)[, -1]  # 移除截距列 / Remove intercept
y_train <- train_data$medv

x_test <- model.matrix(medv ~ ., test_data)[, -1]
y_test <- test_data$medv

# 标准化特征（对于正则化很重要）/ Standardize features (important for regularization)
# glmnet会自动标准化，但我们也可以手动进行
# glmnet standardizes automatically, but we can also do it manually

# ============================================
# 第二部分：岭回归 / Part 2: Ridge Regression
# ============================================

cat("\n\n=== 岭回归 / Ridge Regression ===\n")

# 岭回归使用L2惩罚，不会将系数压缩到零
# Ridge uses L2 penalty, does not shrink coefficients to exactly zero

# 使用交叉验证选择最优lambda / Use cross-validation to select optimal lambda
cv_ridge <- cv.glmnet(x_train, y_train, alpha = 0, nfolds = 10)

# 最优lambda值 / Optimal lambda values
lambda_ridge_min <- cv_ridge$lambda.min      # 最小MSE的lambda / Lambda with minimum MSE
lambda_ridge_1se <- cv_ridge$lambda.1se      # 1标准误内的lambda / Lambda within 1 SE

cat("\n岭回归最优lambda (最小MSE) / Optimal lambda (min MSE):", lambda_ridge_min)
cat("\n岭回归最优lambda (1SE规则) / Optimal lambda (1SE rule):", lambda_ridge_1se, "\n")

# 使用最优lambda拟合最终模型 / Fit final model with optimal lambda
ridge_model <- glmnet(x_train, y_train, alpha = 0, lambda = lambda_ridge_min)

# 在测试集上预测 / Predict on test set
ridge_pred <- predict(ridge_model, s = lambda_ridge_min, newx = x_test)

# 计算性能指标 / Calculate performance metrics
ridge_mse <- mean((ridge_pred - y_test)^2)
ridge_rmse <- sqrt(ridge_mse)
ridge_mae <- mean(abs(ridge_pred - y_test))
ridge_r2 <- 1 - sum((y_test - ridge_pred)^2) / sum((y_test - mean(y_test))^2)

cat("\n岭回归性能指标 / Ridge Performance Metrics:")
cat("\n  MSE:  ", ridge_mse)
cat("\n  RMSE: ", ridge_rmse)
cat("\n  MAE:  ", ridge_mae)
cat("\n  R²:   ", ridge_r2, "\n")

# ============================================
# 第三部分：LASSO回归 / Part 3: LASSO Regression
# ============================================

cat("\n\n=== LASSO回归 / LASSO Regression ===\n")

# LASSO使用L1惩罚，可以将系数压缩到零（特征选择）
# LASSO uses L1 penalty, can shrink coefficients to exactly zero (feature selection)

# 使用交叉验证选择最优lambda / Use cross-validation to select optimal lambda
cv_lasso <- cv.glmnet(x_train, y_train, alpha = 1, nfolds = 10)

# 最优lambda值 / Optimal lambda values
lambda_lasso_min <- cv_lasso$lambda.min
lambda_lasso_1se <- cv_lasso$lambda.1se

cat("\nLASSO最优lambda (最小MSE) / Optimal lambda (min MSE):", lambda_lasso_min)
cat("\nLASSO最优lambda (1SE规则) / Optimal lambda (1SE rule):", lambda_lasso_1se, "\n")

# 使用最优lambda拟合最终模型 / Fit final model with optimal lambda
lasso_model <- glmnet(x_train, y_train, alpha = 1, lambda = lambda_lasso_min)

# 查看哪些变量被选择（系数非零）/ See which variables are selected (non-zero coefficients)
lasso_coef <- coef(lasso_model, s = lambda_lasso_min)
cat("\nLASSO选择的变量数 / Number of variables selected:", sum(lasso_coef != 0) - 1, "\n")

# 在测试集上预测 / Predict on test set
lasso_pred <- predict(lasso_model, s = lambda_lasso_min, newx = x_test)

# 计算性能指标 / Calculate performance metrics
lasso_mse <- mean((lasso_pred - y_test)^2)
lasso_rmse <- sqrt(lasso_mse)
lasso_mae <- mean(abs(lasso_pred - y_test))
lasso_r2 <- 1 - sum((y_test - lasso_pred)^2) / sum((y_test - mean(y_test))^2)

cat("\nLASSO性能指标 / LASSO Performance Metrics:")
cat("\n  MSE:  ", lasso_mse)
cat("\n  RMSE: ", lasso_rmse)
cat("\n  MAE:  ", lasso_mae)
cat("\n  R²:   ", lasso_r2, "\n")

# ============================================
# 第四部分：弹性网络 / Part 4: Elastic Net
# ============================================

cat("\n\n=== 弹性网络回归 / Elastic Net Regression ===\n")

# 弹性网络结合L1和L2惩罚（alpha在0和1之间）
# Elastic Net combines L1 and L2 penalties (alpha between 0 and 1)

# 使用alpha = 0.5（L1和L2权重相等）/ Use alpha = 0.5 (equal weight for L1 and L2)
cv_elastic <- cv.glmnet(x_train, y_train, alpha = 0.5, nfolds = 10)

# 最优lambda值 / Optimal lambda values
lambda_elastic_min <- cv_elastic$lambda.min
lambda_elastic_1se <- cv_elastic$lambda.1se

cat("\n弹性网络最优lambda (最小MSE) / Optimal lambda (min MSE):", lambda_elastic_min)
cat("\n弹性网络最优lambda (1SE规则) / Optimal lambda (1SE rule):", lambda_elastic_1se, "\n")

# 使用最优lambda拟合最终模型 / Fit final model with optimal lambda
elastic_model <- glmnet(x_train, y_train, alpha = 0.5, lambda = lambda_elastic_min)

# 在测试集上预测 / Predict on test set
elastic_pred <- predict(elastic_model, s = lambda_elastic_min, newx = x_test)

# 计算性能指标 / Calculate performance metrics
elastic_mse <- mean((elastic_pred - y_test)^2)
elastic_rmse <- sqrt(elastic_mse)
elastic_mae <- mean(abs(elastic_pred - y_test))
elastic_r2 <- 1 - sum((y_test - elastic_pred)^2) / sum((y_test - mean(y_test))^2)

cat("\n弹性网络性能指标 / Elastic Net Performance Metrics:")
cat("\n  MSE:  ", elastic_mse)
cat("\n  RMSE: ", elastic_rmse)
cat("\n  MAE:  ", elastic_mae)
cat("\n  R²:   ", elastic_r2, "\n")

# ============================================
# 第五部分：使用自助法的均匀收缩 / Part 5: Uniform Shrinkage using Bootstrapping
# ============================================

cat("\n\n=== 使用自助法的均匀收缩 / Uniform Shrinkage using Bootstrapping ===\n")

# 定义自助法函数 / Define bootstrap function
bootstrap_lm <- function(data, indices) {
  d <- data[indices, ]
  fit <- lm(medv ~ ., data = d)
  return(coef(fit))
}

# 执行自助法（1000次重采样）/ Perform bootstrapping (1000 resamples)
cat("\n执行自助法，这可能需要几秒钟... / Running bootstrap, this may take a few seconds...\n")
boot_results <- boot(data = train_data, statistic = bootstrap_lm, R = 1000)

# 计算系数的自助法均值和标准误 / Calculate bootstrap means and standard errors
boot_means <- colMeans(boot_results$t)
boot_se <- apply(boot_results$t, 2, sd)

# 应用收缩（使用均值作为估计值）/ Apply shrinkage (using mean as estimate)
# 在实际应用中，可以根据偏差-方差权衡调整收缩因子
# In practice, shrinkage factor can be adjusted based on bias-variance tradeoff

shrinkage_factor <- 0.9  # 90%的系数
shrunk_coef <- boot_means * shrinkage_factor

# 使用收缩后的系数进行预测 / Make predictions with shrunk coefficients
x_test_with_intercept <- cbind(1, x_test)  # 添加截距 / Add intercept
boot_pred <- x_test_with_intercept %*% shrunk_coef

# 计算性能指标 / Calculate performance metrics
boot_mse <- mean((boot_pred - y_test)^2)
boot_rmse <- sqrt(boot_mse)
boot_mae <- mean(abs(boot_pred - y_test))
boot_r2 <- 1 - sum((y_test - boot_pred)^2) / sum((y_test - mean(y_test))^2)

cat("\n自助法收缩性能指标 / Bootstrap Shrinkage Performance Metrics:")
cat("\n  MSE:  ", boot_mse)
cat("\n  RMSE: ", boot_rmse)
cat("\n  MAE:  ", boot_mae)
cat("\n  R²:   ", boot_r2, "\n")

# ============================================
# 第六部分：性能比较和可视化 / Part 6: Performance Comparison and Visualization
# ============================================

cat("\n\n=== 性能比较 / Performance Comparison ===\n")

# 创建性能指标比较表 / Create performance metrics comparison table
performance_df <- data.frame(
  Method = c("Ridge", "LASSO", "Elastic Net", "Bootstrap Shrinkage"),
  MSE = c(ridge_mse, lasso_mse, elastic_mse, boot_mse),
  RMSE = c(ridge_rmse, lasso_rmse, elastic_rmse, boot_rmse),
  MAE = c(ridge_mae, lasso_mae, elastic_mae, boot_mae),
  R2 = c(ridge_r2, lasso_r2, elastic_r2, boot_r2)
)

print(performance_df)

# 找出最佳模型 / Find best model
best_model <- performance_df$Method[which.min(performance_df$RMSE)]
cat("\n最佳模型（基于RMSE）/ Best model (based on RMSE):", best_model, "\n")

# 可视化1：交叉验证曲线 / Visualization 1: Cross-validation curves
par(mfrow = c(2, 2))

# 岭回归CV曲线 / Ridge CV curve
plot(cv_ridge, main = "Ridge Regression CV")
abline(v = log(lambda_ridge_min), col = "red", lty = 2)

# LASSO CV曲线 / LASSO CV curve
plot(cv_lasso, main = "LASSO Regression CV")
abline(v = log(lambda_lasso_min), col = "red", lty = 2)

# 弹性网络CV曲线 / Elastic Net CV curve
plot(cv_elastic, main = "Elastic Net CV")
abline(v = log(lambda_elastic_min), col = "red", lty = 2)

# 可视化2：系数路径 / Visualization 2: Coefficient paths
par(mfrow = c(1, 3))

# 岭回归系数路径 / Ridge coefficient paths
ridge_path <- glmnet(x_train, y_train, alpha = 0)
plot(ridge_path, xvar = "lambda", main = "Ridge Coefficient Paths")
abline(v = log(lambda_ridge_min), col = "red", lty = 2)

# LASSO系数路径 / LASSO coefficient paths
lasso_path <- glmnet(x_train, y_train, alpha = 1)
plot(lasso_path, xvar = "lambda", main = "LASSO Coefficient Paths")
abline(v = log(lambda_lasso_min), col = "red", lty = 2)

# 弹性网络系数路径 / Elastic Net coefficient paths
elastic_path <- glmnet(x_train, y_train, alpha = 0.5)
plot(elastic_path, xvar = "lambda", main = "Elastic Net Coefficient Paths")
abline(v = log(lambda_elastic_min), col = "red", lty = 2)

# 可视化3：预测值 vs 实际值 / Visualization 3: Predicted vs Actual
par(mfrow = c(2, 2))

# 岭回归 / Ridge
plot(y_test, ridge_pred, main = "Ridge: Predicted vs Actual",
     xlab = "Actual", ylab = "Predicted", pch = 16, col = "blue")
abline(0, 1, col = "red", lwd = 2)

# LASSO
plot(y_test, lasso_pred, main = "LASSO: Predicted vs Actual",
     xlab = "Actual", ylab = "Predicted", pch = 16, col = "green")
abline(0, 1, col = "red", lwd = 2)

# 弹性网络 / Elastic Net
plot(y_test, elastic_pred, main = "Elastic Net: Predicted vs Actual",
     xlab = "Actual", ylab = "Predicted", pch = 16, col = "purple")
abline(0, 1, col = "red", lwd = 2)

# 自助法收缩 / Bootstrap Shrinkage
plot(y_test, boot_pred, main = "Bootstrap: Predicted vs Actual",
     xlab = "Actual", ylab = "Predicted", pch = 16, col = "orange")
abline(0, 1, col = "red", lwd = 2)

# 可视化4：残差分析 / Visualization 4: Residual Analysis
par(mfrow = c(2, 2))

# 岭回归残差 / Ridge residuals
ridge_resid <- y_test - ridge_pred
plot(ridge_pred, ridge_resid, main = "Ridge Residuals",
     xlab = "Predicted", ylab = "Residuals", pch = 16, col = "blue")
abline(h = 0, col = "red", lwd = 2)

# LASSO残差 / LASSO residuals
lasso_resid <- y_test - lasso_pred
plot(lasso_pred, lasso_resid, main = "LASSO Residuals",
     xlab = "Predicted", ylab = "Residuals", pch = 16, col = "green")
abline(h = 0, col = "red", lwd = 2)

# 弹性网络残差 / Elastic Net residuals
elastic_resid <- y_test - elastic_pred
plot(elastic_pred, elastic_resid, main = "Elastic Net Residuals",
     xlab = "Predicted", ylab = "Residuals", pch = 16, col = "purple")
abline(h = 0, col = "red", lwd = 2)

# 自助法残差 / Bootstrap residuals
boot_resid <- y_test - boot_pred
plot(boot_pred, boot_resid, main = "Bootstrap Residuals",
     xlab = "Predicted", ylab = "Residuals", pch = 16, col = "orange")
abline(h = 0, col = "red", lwd = 2)

# ============================================
# 第七部分：高级主题 - 调优alpha参数 / Part 7: Advanced - Tuning alpha parameter
# ============================================

cat("\n\n=== 调优弹性网络的alpha参数 / Tuning Elastic Net alpha parameter ===\n")

# 尝试不同的alpha值 / Try different alpha values
alpha_values <- seq(0, 1, by = 0.1)
results_list <- list()

for (i in seq_along(alpha_values)) {
  alpha <- alpha_values[i]
  cv_fit <- cv.glmnet(x_train, y_train, alpha = alpha, nfolds = 10)
  pred <- predict(cv_fit, s = "lambda.min", newx = x_test)
  mse <- mean((pred - y_test)^2)
  results_list[[i]] <- data.frame(alpha = alpha, mse = mse)
}

results_alpha <- do.call(rbind, results_list)
best_alpha <- results_alpha$alpha[which.min(results_alpha$mse)]

cat("\n最优alpha值 / Optimal alpha value:", best_alpha)
cat("\n对应的MSE / Corresponding MSE:", min(results_alpha$mse), "\n")

# 可视化alpha调优 / Visualize alpha tuning
par(mfrow = c(1, 1))
plot(results_alpha$alpha, results_alpha$mse, type = "b",
     xlab = "Alpha", ylab = "MSE",
     main = "MSE vs Alpha (0=Ridge, 1=LASSO)",
     pch = 16, col = "darkblue", lwd = 2)
points(best_alpha, min(results_alpha$mse), col = "red", pch = 16, cex = 2)

# ============================================
# 总结 / Summary
# ============================================

cat("\n\n=== 总结 / Summary ===\n")
cat("\n本脚本演示了以下收缩方法：")
cat("\nThis script demonstrated the following shrinkage methods:\n")
cat("\n1. 岭回归（Ridge Regression）- L2正则化，保留所有变量")
cat("\n   Ridge Regression - L2 regularization, keeps all variables\n")
cat("\n2. LASSO回归 - L1正则化，可以进行特征选择")
cat("\n   LASSO Regression - L1 regularization, performs feature selection\n")
cat("\n3. 弹性网络（Elastic Net）- 结合L1和L2正则化")
cat("\n   Elastic Net - Combines L1 and L2 regularization\n")
cat("\n4. 使用自助法的均匀收缩 - 基于重采样的稳健估计")
cat("\n   Uniform Shrinkage with Bootstrapping - Robust estimation via resampling\n")

cat("\n\n关键性能指标说明：")
cat("\nKey Performance Metrics Explanation:\n")
cat("\n- MSE (均方误差): 预测误差的平方平均值，越小越好")
cat("\n  Mean Squared Error: Average squared prediction error, lower is better\n")
cat("\n- RMSE (均方根误差): MSE的平方根，与目标变量单位相同")
cat("\n  Root Mean Squared Error: Square root of MSE, same units as target\n")
cat("\n- MAE (平均绝对误差): 预测误差绝对值的平均值")
cat("\n  Mean Absolute Error: Average absolute prediction error\n")
cat("\n- R² (决定系数): 模型解释的方差比例，越接近1越好")
cat("\n  R-squared: Proportion of variance explained, closer to 1 is better\n")

cat("\n\n脚本执行完成！/ Script execution completed!\n")
cat("所有图形已生成。请查看绘图窗口。\n")
cat("All plots have been generated. Please check the plot windows.\n\n")

# 恢复默认绘图参数 / Reset plotting parameters
par(mfrow = c(1, 1))
