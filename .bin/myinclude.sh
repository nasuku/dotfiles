#!/bin/bash

# this is mainly used as include files to be included from all my utility script

# theoritically tput needs to be used to determine the color sequence and its portable way
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
# however inside containers etc we may not have tput binary. so use the escape sequences

colors() {
	# Reset
	printf -v Color_Off '\033[0m' # Text Reset

	# Regular Colors
	printf -v Black '\033[0;30m'  # Black
	printf -v Red '\033[0;31m'    # Red
	printf -v Green '\033[0;32m'  # Green
	printf -v Yellow '\033[0;33m' # Yellow
	printf -v Blue '\033[0;34m'   # Blue
	printf -v Purple '\033[0;35m' # Purple
	printf -v Cyan '\033[0;36m'   # Cyan
	printf -v White '\033[0;37m'  # White

	# Bold
	printf -v BBlack '\033[1;30m'  # Black
	printf -v BRed '\033[1;31m'    # Red
	printf -v BGreen '\033[1;32m'  # Green
	printf -v BYellow '\033[1;33m' # Yellow
	printf -v BBlue '\033[1;34m'   # Blue
	printf -v BPurple '\033[1;35m' # Purple
	printf -v BCyan '\033[1;36m'   # Cyan
	printf -v BWhite '\033[1;37m'  # White

	# Dull
	printf -v DBlack '\033[2;30m'  # Black
	printf -v DRed '\033[2;31m'    # Red
	printf -v DGreen '\033[2;32m'  # Green
	printf -v DYellow '\033[2;33m' # Yellow
	printf -v DBlue '\033[2;34m'   # Blue
	printf -v DPurple '\033[2;35m' # Purple
	printf -v DCyan '\033[2;36m'   # Cyan
	printf -v DWhite '\033[2;37m'  # White

	# Underline
	printf -v UBlack '\033[4;30m'  # Black
	printf -v URed '\033[4;31m'    # Red
	printf -v UGreen '\033[4;32m'  # Green
	printf -v UYellow '\033[4;33m' # Yellow
	printf -v UBlue '\033[4;34m'   # Blue
	printf -v UPurple '\033[4;35m' # Purple
	printf -v UCyan '\033[4;36m'   # Cyan
	printf -v UWhite '\033[4;37m'  # White

	# Background
	printf -v On_Black '\033[40m'  # Black
	printf -v On_Red '\033[41m'    # Red
	printf -v On_Green '\033[42m'  # Green
	printf -v On_Yellow '\033[43m' # Yellow
	printf -v On_Blue '\033[44m'   # Blue
	printf -v On_Purple '\033[45m' # Purple
	printf -v On_Cyan '\033[46m'   # Cyan
	printf -v On_White '\033[47m'  # White

	# High Intensity
	printf -v IBlack '\033[0;90m'  # Black
	printf -v IRed '\033[0;91m'    # Red
	printf -v IGreen '\033[0;92m'  # Green
	printf -v IYellow '\033[0;93m' # Yellow
	printf -v IBlue '\033[0;94m'   # Blue
	printf -v IPurple '\033[0;95m' # Purple
	printf -v ICyan '\033[0;96m'   # Cyan
	printf -v IWhite '\033[0;97m'  # White

	# Bold High Intensity
	printf -v BIBlack '\033[1;90m'  # Black
	printf -v BIRed '\033[1;91m'    # Red
	printf -v BIGreen '\033[1;92m'  # Green
	printf -v BIYellow '\033[1;93m' # Yellow
	printf -v BIBlue '\033[1;94m'   # Blue
	printf -v BIPurple '\033[1;95m' # Purple
	printf -v BICyan '\033[1;96m'   # Cyan
	printf -v BIWhite '\033[1;97m'  # White

	# High Intensity backgrounds
	printf -v On_IBlack '\033[100m'  # Black
	printf -v On_IRed '\033[101m'    # Red
	printf -v On_IGreen '\033[102m'  # Green
	printf -v On_IYellow '\033[103m' # Yellow
	printf -v On_IBlue '\033[104m'   # Blue
	printf -v On_IPurple '\033[105m' # Purple
	printf -v On_ICyan '\033[106m'   # Cyan
	printf -v On_IWhite '\033[107m'  # White
}
