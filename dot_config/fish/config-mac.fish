alias ls "ls -p -G"

# Homebrew
set -l homebrew_prefix /opt/homebrew
fish_add_path -g $homebrew_prefix/bin $homebrew_prefix/sbin

# 1Password SSH agent
set -gx SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# Android SDK
set -gx ANDROID_HOME $HOME/Library/Android/sdk
if test -d $ANDROID_HOME
    fish_add_path -a $ANDROID_HOME/emulator $ANDROID_HOME/tools $ANDROID_HOME/platform-tools
end

# Java
set -l android_java_home /Applications/Android\ Studio.app/Contents/jbr/Contents/Home
if test -x $android_java_home/bin/java
    set -gx JAVA_HOME $android_java_home
else if test -x /usr/libexec/java_home
    set -l detected_java_home (/usr/libexec/java_home -v 17 2>/dev/null)
    if test $status -eq 0; and test -n "$detected_java_home"
        set -gx JAVA_HOME $detected_java_home
    end
end

# Google Cloud SDK
set -l google_cloud_sdk_bin_path $homebrew_prefix/share/google-cloud-sdk/bin
if test -d $google_cloud_sdk_bin_path
    set -gx CLOUDSDK_PYTHON (command -v python)
    fish_add_path -g $google_cloud_sdk_bin_path
end
