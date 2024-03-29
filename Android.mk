LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
        $(call all-logtags-files-under, src)

LOCAL_MODULE := settings-logtags

include $(BUILD_STATIC_JAVA_LIBRARY)

# Build the Settings APK
include $(CLEAR_VARS)

LOCAL_PACKAGE_NAME := Settings
LOCAL_PRIVATE_PLATFORM_APIS := true
LOCAL_CERTIFICATE := platform
LOCAL_PRODUCT_MODULE := true
LOCAL_PRIVILEGED_MODULE := true
LOCAL_REQUIRED_MODULES := privapp_whitelist_com.android.settings
LOCAL_MODULE_TAGS := optional
LOCAL_USE_AAPT2 := true

LOCAL_SRC_FILES := $(call all-java-files-under, src)
LOCAL_SRC_FILES += $(call all-java-files-under, ../RebellionSettings/src)

LOCAL_STATIC_ANDROID_LIBRARIES := \
    androidx-constraintlayout_constraintlayout \
    androidx.slice_slice-builders \
    androidx.slice_slice-core \
    androidx.slice_slice-view \
    androidx.core_core \
    androidx.appcompat_appcompat \
    androidx.cardview_cardview \
    androidx.preference_preference \
    androidx.recyclerview_recyclerview \
    com.google.android.material_material \
    setupcompat \
    setupdesign \
    VendorSupport-preference

LOCAL_JAVA_LIBRARIES := \
    telephony-common \
    ims-common

LOCAL_STATIC_JAVA_LIBRARIES := \
    androidx-constraintlayout_constraintlayout-solver \
    androidx.lifecycle_lifecycle-runtime \
    androidx.lifecycle_lifecycle-extensions \
    guava \
    jsr305 \
    settings-contextual-card-protos-lite \
    settings-log-bridge-protos-lite \
    contextualcards \
    settings-logtags \
    zxing-core-1.7 \
    okhttpcustom \
    okio \
    retrofit \
    converter-gson \
    rxjava \
    adapter-rxjava \
    gson \
    reactive-streams

LOCAL_STATIC_JAVA_AAR_LIBRARIES += \
    rxandroid

LOCAL_PROGUARD_FLAG_FILES := proguard.flags

LOCAL_AAPT_FLAGS := --auto-add-overlay \
    --extra-packages com.rebellion.settings

LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/res \
    packages/apps/RebellionSettings/res

ifneq ($(INCREMENTAL_BUILDS),)
    LOCAL_PROGUARD_ENABLED := disabled
    LOCAL_JACK_ENABLED := incremental
    LOCAL_JACK_FLAGS := --multi-dex native
endif

include frameworks/base/packages/SettingsLib/common.mk
include frameworks/base/packages/SettingsLib/search/common.mk

include $(BUILD_PACKAGE)

# ====  prebuilt library  ========================
include $(CLEAR_VARS)

LOCAL_PREBUILT_STATIC_JAVA_LIBRARIES := \
    contextualcards:libs/contextualcards.aar
include $(BUILD_MULTI_PREBUILT)

include $(CLEAR_VARS)

LOCAL_PREBUILT_STATIC_JAVA_LIBRARIES := \
    okhttpcustom:libs/okhttp-3.8.1.jar \
    okio:libs/okio-1.13.0.jar \
    retrofit:libs/retrofit-2.4.0.jar \
    converter-gson:libs/converter-gson-2.4.0.jar \
    rxjava:libs/rxjava-2.1.11.jar \
    adapter-rxjava:libs/adapter-rxjava2-2.4.0.jar \
    rxandroid:libs/rxandroid-2.0.2.aar \
    gson:libs/gson-2.8.2.jar \
    reactive-streams:libs/reactive-streams-1.0.2.jar

include $(BUILD_MULTI_PREBUILT)

# Use the following include to make our test apk.
ifeq (,$(ONE_SHOT_MAKEFILE))
include $(call all-makefiles-under,$(LOCAL_PATH))
endif
