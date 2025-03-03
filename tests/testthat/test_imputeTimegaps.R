library(GGIR)
context("g.imputeTimegaps")
test_that("timegaps are correctly imputed", {
  N = 10000
  sf = 20
  x = data.frame(time = as.POSIXct(x = (1:N)/sf, tz = "", origin = "1970/1/1"),
                 X = 1:N, Y = 1:N, Z = 1:N)
  xyzCol = c("X", "Y", "Z")
  
  
  x_without_time = data.frame(X = 1:N, Y = 1:N, Z = 1:N)
  xyzCol = c("X", "Y", "Z")
  
  zeros = c(5:200, 6000:6500, 7000:7500, 8000:9500)
  
  # TEST THAT SAME FILE WITH DIFFERENT FORMATS IS IMPUTED IN THE SAME WAY ----
  # Format 1: with timestamp & with timegaps (no zeroes, incomplete dataset)
  x1 = x[-zeros,]
  x1_imputed = g.imputeTimegaps(x1, xyzCol, timeCol = "time", sf = sf, k = 2/sf, impute = TRUE, PreviousLastValue = c(0,0,1))
  x1_removed = g.imputeTimegaps(x1, xyzCol, timeCol = "time", sf = sf, k = 2/sf, impute = FALSE, PreviousLastValue = c(0,0,1))
  
  # Format 2: with timestamp & with zeros (complete dataset)
  x2 = x
  x2[zeros, xyzCol] = 0
  x2_imputed = g.imputeTimegaps(x2, xyzCol, timeCol = "time", sf = sf, k = 2/sf, impute = TRUE, PreviousLastValue = c(0,0,1))
  x2_removed = g.imputeTimegaps(x2, xyzCol, timeCol = "time", sf = sf, k = 2/sf, impute = FALSE, PreviousLastValue = c(0,0,1))
  
  # Format 3: without timestamp & with zeros (complete dataset)
  x3 = x_without_time
  x3[zeros, xyzCol] = 0
  x3_imputed = g.imputeTimegaps(x3, xyzCol, timeCol = "time", sf = sf, k = 2/sf, impute = TRUE, PreviousLastValue = c(0,0,1))
  x3_removed = g.imputeTimegaps(x3, xyzCol, timeCol = "time", sf = sf, k = 2/sf, impute = FALSE, PreviousLastValue = c(0,0,1))
  
  # tests number of rows
  expect_equal(nrow(x1_imputed), N)
  expect_equal(nrow(x2_imputed), N)
  expect_equal(nrow(x3_imputed), N)
  
  expect_equal(nrow(x1_removed), N - length(zeros))
  expect_equal(nrow(x2_removed), N - length(zeros))
  expect_equal(nrow(x3_removed), N - length(zeros))
  
  # test imputations on different formats worked identically
  expect_equal(x1_imputed$X, x2_imputed$X)
  expect_equal(x1_imputed$X, x3_imputed$X)
  
  expect_equal(x1_removed$X, x2_removed$X)
  expect_equal(x1_removed$X, x3_removed$X)
  
  # TEST IMPUTATION WHEN FIRST ROW IS NOT CONSECUTIVE TO PREVIOUS CHUNK ----
  # Format 4: with timestamp & with timegaps (no zeroes, incomplete dataset)
  x4 = x[-zeros,]
  PreviousLastTime = x[1,"time"] - 30 # dummy gap of 30 seconds between chunks
  suppressWarnings({ # warning arising from made up PreviousLastTime
    x4_imputed = g.imputeTimegaps(x4, xyzCol, timeCol = "time", sf = sf, k = 2/sf, impute = TRUE, 
                                  PreviousLastValue = c(0,0,1), PreviousLastTime = PreviousLastTime)
    x4_removed = g.imputeTimegaps(x4, xyzCol, timeCol = "time", sf = sf, k = 2/sf, impute = FALSE, 
                                  PreviousLastValue = c(0,0,1), PreviousLastTime = PreviousLastTime)
  })
  
  expect_equal(nrow(x4_imputed), N + sf*30)
  expect_equal(nrow(x4_removed), N - length(zeros))
  
  # TEST IMPUTATION WHEN FIRST AND LAST ROW CONTAIN ZEROS ----
  zeros = c(1:200, 6000:6500, 7000:7500, 8000:10000)
  # Format 5: with timestamp & with zeros (complete dataset)
  x5 = x
  x5[zeros, xyzCol] = 0
  x5_imputed = g.imputeTimegaps(x5, xyzCol, timeCol = "time", sf = sf, k = 2/sf, impute = TRUE, PreviousLastValue = c(0,0,1))
  x5_removed = g.imputeTimegaps(x5, xyzCol, timeCol = "time", sf = sf, k = 2/sf, impute = FALSE, PreviousLastValue = c(0,0,1))
  
  expect_equal(nrow(x5_imputed), N)
  expect_equal(nrow(x5_removed), N - length(zeros))
  
})
 