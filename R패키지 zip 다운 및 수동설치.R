###########################################################
# 파일명 : R패키지 zip 다운 및 수동설치.R
# 설  명 : 인터넷이 안되는 공간에서 R 패키지 수동설치 방법
# 작성자 : 이재병 (010-2775-0930)
# 작성일 : 2020.04.04
###########################################################


# #모든 패키지 windows binary zip 파일 받기
# pkglist <- available.packages()
# download.packages(pkgs = pkglist, destrid = "C:/PKG/", type = "win.binary")


#패키지 수동 설치하기
pkg.path.down <- "C:/PKG" #zip 파일로 된 R패키지들이 압축해제 되어있는 장소
pkg.path.lib <- .libPaths()
src.type <- "zip"
pkg.all.list <- available.packages()


install.pkgs_fn <- function(tgr.pkg){
  #1. 의존 패키지 찾아내기
  getDependencies <- function(packs, pkg.all.list){
    dependencyNames <- unlist(tools::package_dependencies(package = packs,
                                                          db = pkg.all.list,
                                                          which = c("Depends", "Imports"),
                                                          recursive = T))
    packageNames <- union(packs, dependencyNames)
    return(packageNames)
  }
  
  
  #2. 의존 패키지 체크하기
  pkg.list <- getDependencies(tgr.pkg, pkg.all.list)
  
  #pkg.path.down 에서 해당하는 패키지 리스트 뽑아내기
  list.x <- grep(paste0(paste0('^', pkg.list,'_'), collapse = '|'), list.files(pkg.path.down), value = T)
  list.x <- grep(paste0('.', src.type), list.x, value = T)
  #3. 패키지 설치하기 (Unzip & Move Source File)
  setwd(pkg.path.down)
  
  for(i in 1:length(list.x)){
    #패키지 library 폴더에 unzip
    suppressWarnings(unzip(list.x[i], exdir = pkg.path.lib, overwrite = F))
    print(paste(i, length(list.x), sep = "/"))
  }
}

# 설치할 패키지
tgr.pkg <- "randomForest"

install.packages(tgr.pkg)
