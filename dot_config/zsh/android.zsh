export ANDROID_SDK_ROOT=~/Library/Android/sdk

path+=(
  # this is where the emulator binary lives
  $ANDROID_SDK_ROOT/emulator
  # this is where the adb binary lives
  $ANDROID_SDK_ROOT/platform-tools
  # this is where the sdkmanager binary lives
  $ANDROID_SDK_ROOT/cmdline-tools/latest/bin
)
