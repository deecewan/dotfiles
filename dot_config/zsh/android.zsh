export ANDROID_HOME=$HOME/Library/Android/sdk

path+=(
  # this is where the emulator binary lives
  $ANDROID_HOME/emulator
  # this is where the adb binary lives
  $ANDROID_HOME/platform-tools
  # this is where the sdkmanager binary lives
  $ANDROID_HOME/cmdline-tools/latest/bin
  # this is here to make sure it comes _after_ cmdline-tools, which has the
  # modern version of things
  $ANDROID_HOME/tools/bin
)
