#!/bin/bash

source myinclude.sh

####### colors ############
#more info at https://misc.flogisoft.com/bash/tip_colors_and_formatting

# this function produces the raw escape sequences for colors
# this draws like a table with a predefined text
rawColorList() {
	T='gYw' # The test text

	echo -e "\n                 40m     41m     42m     43m\
     44m     45m     46m     47m"

	for FGs in '    m' '   1m' '   2m' '   4m' '   5m' '   7m' \
		'  30m' '1;30m' '2;30m' '4;30m' '5;30m' '7;30m' \
		'  31m' '1;31m' '2;31m' '4;31m' '5;31m' '7;31m' \
		'  32m' '1;32m' '2;32m' '4;32m' '5;32m' '7;32m' \
		'  33m' '1;33m' '2;33m' '4;33m' '5;33m' '7;33m' \
		'  34m' '1;34m' '2;34m' '4;34m' '5;34m' '7;34m' \
		'  35m' '1;35m' '2;35m' '4;35m' '5;35m' '7;35m' \
		'  36m' '1;36m' '2;36m' '4;36m' '5;36m' '7;36m' \
		'  37m' '1;37m' '2;37m' '4;37m' '5;37m' '7;37m'; do
		FG=${FGs// /}
		echo -en " $FGs \033[$FG  $T  \033[0m"
		for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do
			#echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m"
			echo -en " \033[$FG\033[$BG  $T  \033[0m"
		done
		echo
	done
	echo
}

rawColorList2() {
	for clbg in {40..47} {100..107} 49; do
		#Foreground
		for clfg in {30..37} {90..97} 39; do
			#Formatting
			for attr in 0 1 2 4 5 7; do
				#Print the result
				echo -e "\033[${attr};${clbg};${clfg}m \\\033[${attr};${clbg};${clfg}m \033[0m"
			done
			echo #Newline
		done
	done
}

# this function uses the variables that were defined earlier to specify the color scheme map
colorList() {
    colors
	T='gYw' # The test text
	printf "%10s" " "
	printf "%8s" "default"
	for BG in 'On_' 'On_I'; do
		for BGCOL in 'Black' 'Red' 'Green' 'Yellow' 'Blue' 'Purple' 'Cyan' 'White'; do
			printf "%8s" "${BG/On_/}${BGCOL}"
			echo -n " "
		done
	done
	echo
	for FG in '' 'B' 'D' 'U' 'I' 'BI'; do
		for COL in 'Black' 'Red' 'Green' 'Yellow' 'Blue' 'Purple' 'Cyan' 'White'; do
			fgcol="$FG$COL"
			printf " %8s " ${fgcol}
			printf ${!fgcol}
			printf "%8s" "${T} "
			printf ${Color_Off}
			echo -n " "
			for BG in 'On_' 'On_I'; do
				for BGCOL in 'Black' 'Red' 'Green' 'Yellow' 'Blue' 'Purple' 'Cyan' 'White'; do
					bgcol="$BG${BGCOL}"
					printf ${!fgcol}${!bgcol}
					printf "%8s" "${T} "
					printf ${Color_Off}
					echo -n " "
				done
			done
			echo
		done
	done
}

#colors
#echo This is ${Blue}${On_Yellow}test${Color_Off}
