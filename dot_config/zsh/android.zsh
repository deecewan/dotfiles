export ANDROID_HOME=$HOME/Library/Android/sdk

path+=(
  # this is where the emulator binary lives
  $ANDROID_HOME/emulator
  # this is where the adb binary lives
  $ANDROID_HOME/platform-tools
  # this is where the sdkmanager binary lives
  $ANDROID_HOME/cmdline-tools/latest/bin
)
