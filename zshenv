# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin/"

# basedir defaults, in case they're not already set up.
# http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
if [[ -z $XDG_DATA_HOME ]]; then
	export XDG_DATA_HOME=$HOME/.local/share
fi

if [[ -z $XDG_CONFIG_HOME ]]; then
	export XDG_CONFIG_HOME=$HOME/.config
fi

if [[ -z $XDG_CACHE_HOME ]]; then
	export XDG_CACHE_HOME=$HOME/.cache
fi

if [[ -z $XDG_DATA_DIRS ]]; then
	export XDG_DATA_DIRS=/usr/local/share:/usr/share
fi

if [[ -z $XDG_CONFIG_DIRS ]]; then
	export XDG_CONFIG_DIRS=/etc/xdg
else
	export XDG_CONFIG_DIRS=/etc/xdg:$XDG_CONFIG_DIRS
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/tools/android-studio/bin" ] ; then
    export PATH="$PATH:$HOME/tools/android-studio/bin"
fi

if [ -d "$HOME/tools/android-sdk/tools" ] ; then
    export PATH="$PATH:$HOME/tools/android-sdk/tools"
fi

if [ -d "$HOME/tools/android-sdk/platform-tools" ] ; then
    export PATH="$PATH:$HOME/tools/android-sdk/platform-tools"
fi

#Add arm-toolchain to PATH
if [ -d "/opt/arm-toolchain/bin" ]; then
    export PATH="$PATH:/opt/arm-toolchain/bin"
fi

export EDITOR=$(which vim)
export PAGER=$(which less)
export LESS="-FRX"
export GTAGSLABEL="default"

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/max/dev/lib/alglib:/home/max/dev/lib/sgpp:/home/max/.local/share/lib"
