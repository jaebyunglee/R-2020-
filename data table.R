rm(list=ls())
# --------------------------------------------------------------------
# 파일명 : data table.R
# 설  명 : data.table 연습
# 작성장 : 이재병 (010-2775-0930, jblee@begas.co.kr)
# 날  짜 : 2020/03/13
# 패키지 : data.table, dplyr, Hmisc
# 참  고 : https://www.listendata.com/2016/10/r-data-table.html
# --------------------------------------------------------------------


#library
library(data.table)
library(dplyr)
library(Hmisc)

#작업공간 설정
setwd("C:/Rproject")

#데이터 불러오기
mydata <- fread("https://github.com/arunsrinivasan/satrdays-workshop/raw/master/flights_2014.csv")

#데이터 살펴보기
nrow(mydata)
ncol(mydata)
summary(mydata)
str(mydata)
Hmisc::describe(mydata)
names(mydata)

# --------------------------------------------------------------------
# Selecting or Keeping Columns
# --------------------------------------------------------------------

#열 추출하기
mydata[,origin] # -> 벡터로 추출
mydata[,.(origin)] # -> 데이터 테이블로 추출
mydata[,c("origin")]; mydata[,2] # -> 데이터 프레임과 동일한 방식으로 추출 가능

#여러 열 동시에 추출 하기
mydata[, .(origin, year, month, hour)] 
mydata[, c(2:4)]

#열 드롭 하기
mydata[, !c("origin")]
mydata[, !c("origin", "year", "month")]

#열 중에서 dep라는 이름을 가진 변수만 추출
mydata[,names(mydata) %like% "dep", with=FALSE]

#TRUE, FALSE로 열 추출
mydata[,c(rep(TRUE,10),rep(FALSE,7)),with=FALSE]


# --------------------------------------------------------------------
# Rename Variables
# --------------------------------------------------------------------

#열 이름 바꾸기
data.table::setnames(mydata,c("dest","origin"),c("Destination","origin.of.flight"))
my.data
#다시 되돌리기
data.table::setnames(mydata,c("Destination","origin.of.flight"),c("dest","origin"))
my.data

# --------------------------------------------------------------------
# Subsetting Rows / Filtering
# --------------------------------------------------------------------

#조건을 만족하는 행 추출하기 1
mydata[origin == "JFK"]

#조건을 만족하는 행 추출하기 2
mydata[origin == "JFK" & carrier == "AA"]

#조건을 만족하는 행 추출하기 3
mydata[origin %in% c("JFK", "LGA")]

#조건을 만족하는 행 추출하기 4
mydata[origin %like% "G"]

#조건을 만족하는 행 제외하고 추출하기
mydata[!origin %in% c("JFK", "LGA")]

# --------------------------------------------------------------------
# Sorting Data
# --------------------------------------------------------------------

#데이터 오름차순 정렬하기
setorder(mydata, origin)
mydata

#데이터 내림차순 정렬하기
setorder(mydata, -origin)
mydata

#여러 변수를 활용해 정렬하기
setorder(mydata, origin, -carrier)
mydata

# --------------------------------------------------------------------
# Adding Columns (Calculation on rows)
# --------------------------------------------------------------------

#열 추가하기
mydata[,dep_sch:=dep_time-dep_delay]
mydata

#여러 열 추가하기
mydata[,c("dep_sch","arr_sch"):=list(dep_time-dep_delay, arr_time-arr_delay)]
mydata

#특정 조건을 만족하는 열 만들기(ifelse)
mydata[,flag:=ifelse(min<20,0,ifelse(min<30,1,2))]
mydata

# --------------------------------------------------------------------
# Summarize or Aggregate Columns
# --------------------------------------------------------------------

#특정 열 Summarize 하기
mydata[,.(arr_delay_mean = mean(arr_delay, na.rm = T),
          dep_delay_mean = mean(dep_delay, na.rm = T),
          arr_delay_median = median(arr_delay, na.rm = T),
          dep_delay_median = median(dep_delay, ra.rm = T))]

# 모든 변수에 대한 mean (.SD는 모든 변수를 한번에 선택함)
mydata[, sapply(.SD, function(x) mean=mean(x))]

# 모든 변수에 대한 mean과 median
mydata[, sapply(.SD, function(x) c(mean=mean(x), median=median(x)))]

# --------------------------------------------------------------------
# Group BY
# --------------------------------------------------------------------

#origin 변수 그룹별 평균
mydata[,.(mean = mean(dep_delay, na.rm=T)), by=origin]

#orgin 변수 그룹별 여러 변수 평균
mydata[,.(dep_delay_mean = mean(dep_delay, na.rm = T), arr_delay_mean = mean(arr_delay, na.rm=T)), by=origin]


# --------------------------------------------------------------------
# Extract values within a group
# --------------------------------------------------------------------

#그룹 별로 상위 2개행 추출
mydata[, .SD[1:2], by=carrier]

#그룹별 마지막 행 추출 
mydata[, .SD[.N], by=carrier]

# --------------------------------------------------------------------
# Summarize or Aggregate Columns by GROUP
# --------------------------------------------------------------------
# 그룹별 합계
mydata[,.(arr_delay_mean = mean(arr_delay, na.rm = T)), by=carrier]

# --------------------------------------------------------------------
# Merging / Joins
# --------------------------------------------------------------------
(dt1 <- data.table(A = letters[rep(1:3, 2)], X = 1:6, key = "A"))
(dt2 <- data.table(A = letters[rep(2:4, 2)], Y = 6:1, key = "A"))

#Inner join
merge(dt1, dt2, by="A")

#Left Join
merge(dt1, dt2, by="A", all.x = TRUE)

#Right Join
merge(dt1, dt2, by="A", all.y = TRUE)

#Full Join
merge(dt1, dt2, all=TRUE)