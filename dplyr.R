rm(list=ls())
# --------------------------------------------------------------------
# 파일명 : dplyr.R
# 설  명 : data.table 연습
# 작성장 : 이재병 (010-2775-0930, jblee@begas.co.kr)
# 날  짜 : 2020/03/13
# 패키지 : dplyr, Hmisc
# 참  고 : https://www.listendata.com/2016/08/dplyr-tutorial.html
# --------------------------------------------------------------------

#library
library(dplyr)
library(Hmisc)

#작업공간 설정
setwd("C:/Rproject")

#데이터 불러오기
mydata <- read.csv("https://raw.githubusercontent.com/deepanshu88/data/master/sampledata.csv")



# --------------------------------------------------------------------
# distinct 함수
# --------------------------------------------------------------------
distinct(mydata)
distinct(mydata, Index)
distinct(mydata, Index, .keep_all= TRUE) #특정 변수 기준
distinct(mydata, Index, Y2010, .keep_all= TRUE) #듀 가지 변수 기준



# --------------------------------------------------------------------
# select 함수
# --------------------------------------------------------------------
mydata %>% select(Index, Y2008) #특정 변수 추출
mydata %>% select(-Index, -Y2008) #특정 변수 드롭
mydata %>% select(contains("I")) #변수명에 "I"가 들어간 변수만 추출
mydata %>% select(everything()) #모든 변수 추출
mydata %>% select(State, everything()) #변수 순서 재정렬



# --------------------------------------------------------------------
# rename 함수
# --------------------------------------------------------------------
mydata %>% rename(Index1 = Index) #특정 변수 이름 바꾸기



# --------------------------------------------------------------------
# Filter 함수
# --------------------------------------------------------------------
mydata %>% filter(Index=="A") #Index가 A인 행만 추출
mydata %>% filter(Index %in% c("A","C")) #Index가 A 또는 C인 행 추출
mydata %>% filter(!Index %in% c("A","C")) #Index가 A, C 둘다 아닌 행 추출
mydata %>% filter(Index %in% c("A","C") & Y2002 >= 1300000) #Index가 A 또는 C이면서 Y2002가 1300000 이상인 행 추출
mydata %>% filter(Index %in% c("A", "C") | Y2002 >= 1300000) #Index가 A 또는 C 이거나 또는 Y2002가 1300000 이상인 행 추출 
mydata %>% filter(grepl("Ar", State)) #State 열에서 "Ar"이 포함되어 있는 행 추출



# --------------------------------------------------------------------
# summarise 함수
# --------------------------------------------------------------------
mydata %>%  dplyr::summarise(Y2015_mean = mean(Y2015), Y2015_med = median(Y2015))
mydata %>%  dplyr::summarise_at(vars(Y2014,Y2015), function(x) mean=mean(x))



# --------------------------------------------------------------------
# arrange 함수
# --------------------------------------------------------------------
mydata %>% arrange(Index, Y2011)



# --------------------------------------------------------------------
# group 함수
# --------------------------------------------------------------------
mydata %>% group_by(Index) %>% summarise_at(vars(Y2011:Y2015),funs(n(),mean(.,na.rm=T))) #여러변수 그룹별 n, mean

#do 함수 (아래 명령문의 차이를 파악)
#do 함수는 group_by와 함께 사용
#group_by + do 사용시 각 그룹별로 함수가 적용되게 함
mydata %>% filter(Index %in% c("A", "C","I")) %>% group_by(Index) %>% head(2)
mydata %>% filter(Index %in% c("A", "C","I")) %>% group_by(Index) %>% do(head( . , 2)) #인덱스 그룹별로 2개 출력
mydata %>% filter(Index %in% c("A", "C","I")) %>% group_by(Index) %>% do(arrange(. , desc(Y2015))) %>% slice(3) 
#인덱스 그룹 별로 3번째로 큰 값 추출

# --------------------------------------------------------------------
# mutate함수
# --------------------------------------------------------------------
mydata %>% mutate_all(funs("new"=.*1000))
mydata %>% mutate_at(vars(Y2008:Y2010),funs(Rank=min_rank(.)))
mydata %>% mutate_at(vars(Y2008:Y2010),funs(Rank=min_rank(desc(.))))
mydata %>% mutate(Y2002 = ifelse(Y2002<1300000,0,ifelse(Y2002<1500000,1,2)))
