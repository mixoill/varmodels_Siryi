install.packages(c("tidyverse", "fastDummies", "lubridate"))
install.packages(c("BVAR"))
install.packages("ggplot2")
library(lubridate)
library(fastDummies)
library(BVAR)
library(zoo)
library(ggplot2)

mfvar_data <- read.csv("C:\\Users\\User\\Desktop\\дані для диплому\\var_diff_dataset.xlsx")

mfvar_data$date <- as.Date(as.yearqtr(mfvar_data$Показник, format = "%YQ%q"))
rownames(mfvar_data) <- mfvar_data$date

mfvar_data$quarter_factor <- factor(quarter(mfvar_data$date, with_year = FALSE))

mfvar_data <- dummy_cols(mfvar_data, 
                         select_columns = 'quarter_factor', 
                         remove_first_dummy = TRUE,
                         remove_selected_columns = TRUE)
mfvar_data <- mfvar_data[, !colnames(mfvar_data) %in% c('Показник', 'date')]

train = mfvar_data[1:21, ]
test = mfvar_data[21:nrow(mfvar_data), ]

Y_train <- train[, c("gdp_ua_log", "enterprises_log", "kyiv_gdp_log", "salaries_ind_kyiv_log", "infl_ukr_log")]
X_train <- train[, grep("quarter_factor", colnames(train))]

bvar_mod <- bvar(
  data = Y_train, 
  exog = X_train, 
  lags = 1, 
  n_draw = 5000, 
  n_burn = 2000
)

summary(bvar_mod)

bvar_forecast <- predict(bvar_mod, horizon = 4)
plot(bvar_forecast, area = TRUE, col = "red", fill = "lightblue", back_data = 12)

plot(irf(bvar_mod), col = "red")

plot(bvar_mod)

plot(density(bvar_mod))

plot(bvar_mod, type = "density")
plot(bvar_mod, type = "density", vars = "gdp_ua_log")
plot(bvar_mod, type = "density", vars = "kyiv_gdp_log")
plot(bvar_mod, type = "density", vars = "infl_ukr_log")

bvar_forecast

predicted_values <- apply(bvar_forecast$fcast[,, 1], 2, median)
predicted_values

actual_values <- test$gdp_ua_log[1:4]
actual_values

rmse <- sqrt(mean((actual_values - predicted_values)^2, na.rm = TRUE))

mae <- mean(abs(actual_values - predicted_values), na.rm = TRUE)

print(paste("RMSE gdp_ua:", round(rmse, 5)))
print(paste("MAE:", round(mae, 5)))

predicted_values <- apply(bvar_forecast$fcast[,, 5], 2, median)
actual_values <- test$infl_ukr_log[1:4]

rmse <- sqrt(mean((actual_values - predicted_values)^2, na.rm = TRUE))
mae <- mean(abs(actual_values - predicted_values), na.rm = TRUE)
print(paste("RMSE infl:", round(rmse, 5)))
print(paste("MAE infl:", round(mae, 5)))

predicted_values <- apply(bvar_forecast$fcast[,, 3], 2, median)
actual_values <- test$kyiv_gdp_log[1:4]

rmse <- sqrt(mean((actual_values - predicted_values)^2, na.rm = TRUE))
print(paste("RMSE kyiv_gdp:", round(rmse, 5)))

predicted_values <- apply(bvar_forecast$fcast[,, 4], 2, median)
actual_values <- test$salaries_ind_kyiv_log[1:4]

rmse <- sqrt(mean((actual_values - predicted_values)^2, na.rm = TRUE))
print(paste("RMSE salaries:", round(rmse, 5)))

predicted_values <- apply(bvar_forecast$fcast[,, 2], 2, median)
actual_values <- test$enterprises_log[1:4]

rmse <- sqrt(mean((actual_values - predicted_values)^2, na.rm = TRUE))
print(paste("RMSE salaries:", round(rmse, 5)))