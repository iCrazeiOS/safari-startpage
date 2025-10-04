export PREFIX = /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/
export SDKVERSION = 12.2
export ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = MobileSafari

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = startpage

startpage_FILES = Tweak.x
startpage_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
