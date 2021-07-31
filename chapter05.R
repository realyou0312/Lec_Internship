#### 데이터의 대략적인 특징 파악


head(Orange) # 첫번째 행부터 6번째 행까지 추출                          
head(Orange,3) # 첫번째 행부터 3번째 행까지 추출 

tail(Orange)   # 마지막 행부터 6개의 행까지 추출
tail(Orange, 3) # 마지막 행부터 3개의 행까지 추출 

str(Orange)  #데이터의 구조를 파악 
summary  (Orange)

dim(Orange)

#### 외부 파일 읽기 

##CSV 파일 불러오기   
nhis <- read.csv("c:/Users/user/Desktop/G-BIG/Homework/0709R/data/NHIS_OPEN_GJ_EUC-KR.csv")
head(nhis) 

nhis <- read.csv("c:/Users/user/Desktop/G-BIG/Homework/0709R/data/NHIS_OPEN_GJ_EUC-KR.csv", fileEncoding="EUC-KR")
nhis <- read.csv("c:/Users/user/Desktop/G-BIG/Homework/0709R/data/NHIS_OPEN_GJ_UTF-8.csv", fileEncoding = "UTF-8" ) 

sample<- read.csv("c:/Users/user/Desktop/G-BIG/Homework/0709R/data/sample.csv", header = F,  
                              fileEncoding="EUC-KR", stringsAsFactor = TRUE) 
str(sample)

nhis <- read.table("c:/Users/user/Desktop/G-BIG/Homework/0709R/data/NHIS_OPEN_GJ_EUC-KR.csv", header=T, sep=",")

##엑셀 파일 불러오기   

install.packages('openxlsx')    # openxlsx 패키지 설치    
library(openxlsx)                 

nhis_sheet1= read.xlsx('c:/Users/user/Desktop/G-BIG/Homework/0709R/data/NHIS_OPEN_GJ_EUC-KR.xlsx' ) 
# 디폴트로 엑셀 파일의 첫번째 sheet를 읽음.  
  
nhis_sheet2= read.xlsx('c:/Users/user/Desktop/G-BIG/Homework/0709R/data/NHIS_OPEN_GJ_EUC-KR.xlsx', sheet=2) 
# 엑셀 파일의 두번째 sheet를 읽음.
  

##빅데이터 파일 불러오기 
install.packages('data.table')       # data.table 패키지 설치    
library(data.table)                  # data.table 패키지 불러오기 

nhis_bigdata = fread("c:/Users/user/Desktop/G-BIG/Homework/0709R/data/NHIS_OPEN_GJ_BIGDATA_UTF-8.csv", encoding = "UTF-8" )
str(nhis_bigdata) 



######데이터 추출 

Orange[1, ]
Orange[1:5, ]        
Orange[6:10, ]        
Orange[c(1,5), ]  
Orange[-c(1:29), ]               		# 1~29행  제외하고 모든 행 추출  

 
## 데이터를 비교하여 행 제한
Orange[Orange$age ==118,  ]     # age컬럼의 데이터가 118인 행만 추출
Orange[Orange$age %in% c(118,484), ] 
# age 컬럼의 데이터가 118또는 484인 행만 추출
  
Orange[Orange$age >= 1372 , ] 
# age 컬럼의 데이터가 1372와 같거나 큰 행만 추출 

# subset()
#Orange 데이터 프레임에서 Tree열의 값이 1인 행만 추출
subset(Orange, Tree==1)

subset(Orange, age >= 1500 | Tree==1)

subset(Orange, Tree%in%c(3,2) & age >= 1000)


##열이름을 이용하여 열 제한  
# Orange의 circumference 열만 추출. 행은 모든 행 추출
Orange[ , "circumference"]
 

# Orange의 Tree와 circumference열만 추출. 행은 1행만 추출 
Orange[ 1 , c("Tree","circumference")]

Orange[ , 1]  # Orange 데이터프레임의 첫번째 열만 추출
Orange[ , c(1,3)] # Orange 데이터프레임의 1열과 3열만 추출
Orange[ , c(1:3)] # Orange 데이터프레임의 첫번째 열부터 3번째 열까지 추출 
Orange[ , -c(1,3)] # Orange 데이터프레임의 1열과 3열만 제외하고 추출

subset(Orange, , c("age", "Tree"))

##행과 열제한 

Orange[1:5 , "circumference"] 

# Tree열이 3또는 2인 행의 Tree 열과 circumference 열 추출 
Orange[Orange$Tree %in% c(3,2),  c("Tree","circumference")]


##정렬
OrangeT1 <- Orange[Orange$circumference < 50,  ] 
OrangeT1[ order(OrangeT1$circumference),    ]

# 내림차순 정렬은 order()안에 마이너스(-) 기호를 사용하면 됨 
OrangeT1[ order( -OrangeT1$circumference ),  ]  

##그룹별 집계   
# Tree 별 circumference 평균
aggregate(circumference ~ Tree, Orange, mean)
  
#plyr 패키지 - 접두어 배열, 데이터프레임, 리스트, 출력
install.packages("plyr")
library(plyr)

ddply(Orange, .(Tree), summarise, m = mean(circumference))

ddply(Orange[Orange$age >1300, ], . (Tree),, transform, m = mean(circumference))

#dplyr 패키지 - 데이터 추출용
install.packages("dplyr")
library(dplyr)

Orange %>% filter(age >= 200)

Orange %>% select(circumference)

#sqldf 패키지 - SQL이용
install.packages("sqldf")
library(sqldf)

sqldf("select * from Orange where age > 1500 order by age, circumference desc")

sqldf("select Tree, age from Orange where age > 1200 and Tree = 1 order by age desc")

######## 데이터 구조 변경

## 데이터 준비 
stu1 <- data.frame( no = c(1,2,3),  midterm = c(100,90,80)) 
stu2 <- data.frame( no = c(1,2,3),  finalterm = c(100,90,80)) 
stu3 <- data.frame( no = c(1,4,5),  quiz = c(99,88,77)) 
stu4 <- data.frame( no = c(4,5,6),  midterm = c(99,88,77))  


## 데이터 병합
stu1
stu2
merge(stu1, stu2)
stu3
merge(stu1, stu3)
merge(stu1, stu3, all=TRUE) 
stu4
stu1
rbind(stu1, stu4)
stu2
cbind(stu1, stu2)
cbind(stu1, stu3)

#데이터 구조 변환

product_info = data.frame(product_no = c("1", "2", "3"),
seoul_qty = c(3, 5, 6),
busan_qty = c(10, 20, 30))

product_info

install.packages("reshape2")
library(reshape2)

m_prod <- melt(product_info, id.vars ="product_no")
m_prod

dcast(m_prod, product_no ~ variable)
