# from http://stackoverflow.com/questions/26168138/makefile-ignore-segfault
define EXPECTED_FAIL
if ! { $1 ; } 2>$@.temp; then \
    echo EXPECTED FAILURE: ; cat $@.temp; \
    fi
endef

default: build

build:
	pandoc -o index.html README.md

check: gnu clang

gnu: code.cpp
	g++ -std=c++14 -Wall -Wextra -g code.cpp -o code
	 $(call EXPECTED_FAIL, ./code)

clang: code.cpp
	clang++ -std=c++14 -Wall -Wextra -g code.cpp -o code
	 $(call EXPECTED_FAIL, ./code)

