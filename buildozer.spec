[app]

# Application title (string)
title = Mathematica Console

# Package name (string)
package.name = mathemaconsole

# Package domain (string, unique identifier)
package.domain = org.mathematica

# Version code (integer, increases with each release)
version.regex = ^\s*__version__\s*=\s*['"](.*)['"]
version.filename = %(source.dir)s/__init__.py

# Alternatively, you can use simple version:
# version = 1.0.0

# Source code directory (string)
source.dir = src/mathematica_console

# Requirements (comma-separated)
requirements = python3,kivy==2.2.1,kivymd==1.1.1,sympy==1.12,mpmath==1.3.0,matplotlib==3.7.2,numpy==1.24.3,pillow==10.0.1

# Android permissions (list)
android.permissions = INTERNET,WRITE_EXTERNAL_STORAGE,READ_EXTERNAL_STORAGE

# Android API level (integer)
android.api = 30
android.minapi = 21
android.ndk = 23b
android.sdk = 30

# Android architecture (list)
android.archs = armeabi-v7a, arm64-v8a

# Android manifest settings
android.manifest_application_attributes = android:allowBackup="true" android:requestLegacyExternalStorage="true"
android.manifest_activity_attributes = android:launchMode="singleTop"

# Presplash and icon files (optional)
# presplash.filename = %(source.dir)s/presplash.png
# icon.filename = %(source.dir)s/icon.png

# Include file extensions (list)
source.include_exts = py,png,jpg,kv,atlas,ttf,gif,txt

# Exclude directories (list)
source.exclude_dirs = tests, __pycache__, docs

# Exclude files (list)
source.exclude_exts = spec, db

# Include patterns (list)
source.include_patterns = resources/*.txt, resources/*.kv

# Orientation (string)
android.orientation = portrait

# Fullscreen (boolean)
fullscreen = 0

# Window size (width, height)
window.size = (400, 700)

# Log level (integer)
log_level = 2

# Debug mode (boolean)
debug = 0

# Enable/disable Android services
services = 

# Java classes to include (list)
android.add_src = 

# Android Wear (boolean)
android.wear = False

# Android Gradle dependencies (list)
android.gradle_dependencies = 

# Android Gradle plugins (list)
android.gradle_plugins = 

# Android extra arguments (list)
android.extra_java_args = 

# Android ndk version (string)
# android.ndk = 23b

# Android sdk version (string)
# android.sdk = 30

# Android ndk API (integer)
# android.ndk_api = 21

# Permission check (boolean)
android.permission_check = False

# Java version (string)
android.java_version = 17

# Bootstrap (string)
bootstrap = sdl2

# Warning on root (boolean)
warn_on_root = 1

# Blacklist directories (list)
blacklist_dir = 

# Whitelist directories (list)
whitelist_dir = 

# Extra python dependencies (list)
p4a.local_recipes = 

# Private recipes (boolean)
p4a.private_recipes = False

# Permissions (list)
# android.permissions = INTERNET, WRITE_EXTERNAL_STORAGE, READ_EXTERNAL_STORAGE

# Meta-data (list)
# android.meta_data = 

# Window transparent (boolean)
# window.transparent = False

# Window icon (string)
# window.icon = 

# Window title (string)
# window.title = Mathematica Console

# iOS requirements (list)
# ios.requirements = 

# iOS plist (dictionary)
# ios.plist = 

# iOS xcode version (string)
# ios.xcode_version = 

# iOS framework (string)
# ios.framework = 

# iOS deploy target (string)
# ios.deploy_target = 

# iOS app icon (string)
# ios.app_icon = 

# iOS app background (string)
# ios.app_background = 

# iOS app launch image (string)
# ios.app_launch_image = 

[buildozer]

# Log level (integer)
log_level = 2

# Warning on root (boolean)
warn_on_root = 1

# Path to Android SDK (string)
# android.sdk_path = 

# Path to Android NDK (string)
# android.ndk_path = 

# Path to Ant (string)
# android.ant_path = 

# Accept Android SDK license (boolean)
android.accept_sdk_license = True

# SDK version to use (string)
android.sdk_version = 30

# NDK version to use (string)
android.ndk_version = 23b

# NDK API level (integer)
android.ndk_api = 21

# Include device debugging (boolean)
android.include_debug = False

# Use Gradle (boolean)
android.gradle = True

# Gradle directory (string)
android.gradle_dir = 

# Gradle distribution URL (string)
android.gradle_dist_url = 

# Copy libs (boolean)
android.copy_libs = True

# Exclude Android libraries (list)
android.exclude_libs = 

# Android release name (string)
android.release_name = 

# Android release keystore (string)
android.release_keystore = 

# Android release keystore alias (string)
android.release_keystore_alias = 

# Android release keystore password (string)
android.release_keystore_password = 

# Android release keystore alias password (string)
android.release_keystore_alias_password = 

# Android debug keystore (string)
android.debug_keystore = 

# Android debug keystore alias (string)
android.debug_keystore_alias = 

# Android debug keystore password (string)
android.debug_keystore_password = 

# Android debug keystore alias password (string)
android.debug_keystore_alias_password = 

# Enable/disable backup (boolean)
android.enable_backup = True

# Android manifest (string)
# android.manifest = 

# Android manifest XML (string)
# android.manifest_xml = 

# Android resource directory (string)
# android.resources_dir = 

# Android source directory (string)
# android.src_dir = 

# Android includes (list)
# android.includes = 

# Android excludes (list)
# android.excludes = 

# Android Java directory (string)
# android.java_dir = 

# Android Java classes (list)
# android.java_classes = 

# Android add libs (list)
# android.add_libs = 

# Android add jars (list)
# android.add_jars = 

# Android add source files (list)
# android.add_src = 

# Android add assets (list)
# android.add_assets = 

# Android service (list)
# android.services = 

# Android broadcast receivers (list)
# android.broadcast_receivers = 

# Android activities (list)
# android.activities = 

# Android intent filters (list)
# android.intent_filters = 

# Android meta data (list)
# android.meta_data = 

# Android library (boolean)
# android.library = False

# Android manifest action (string)
# android.manifest.action = 

# Android manifest category (string)
# android.manifest.category = 

# Android manifest theme (string)
# android.manifest.theme = 

# Android manifest hardware (string)
# android.manifest.hardware = 

# Android manifest config (string)
# android.manifest.config = 

# Android manifest version (string)
# android.manifest.version = 

# Android manifest version code (string)
# android.manifest.version_code = 

# Android manifest min sdk version (string)
# android.manifest.min_sdk_version = 

# Android manifest target sdk version (string)
# android.manifest.target_sdk_version = 

# Android manifest max sdk version (string)
# android.manifest.max_sdk_version = 

# Android manifest uses permission (list)
# android.manifest.uses_permission = 

# Android manifest uses feature (list)
# android.manifest.uses_feature = 

# Android manifest uses library (list)
# android.manifest.uses_library = 

# Android manifest uses configuration (list)
# android.manifest.uses_configuration = 

# Android manifest supports screens (list)
# android.manifest.supports_screens = 

# Android manifest compatible screens (list)
# android.manifest.compatible_screens = 

# Android manifest supports gl texture (list)
# android.manifest.supports_gl_texture = 

# Android manifest supports input (list)
# android.manifest.supports_input = 

# Android manifest supports touch (list)
# android.manifest.supports_touch = 

# Android manifest supports keyboard (list)
# android.manifest.supports_keyboard = 

# Android manifest supports navigation (list)
# android.manifest.supports_navigation = 

# Android manifest supports stylus (list)
# android.manifest.supports_stylus = 

# Android manifest supports trackball (list)
# android.manifest.supports_trackball = 

# Android manifest supports mouse (list)
# android.manifest.supports_mouse = 

# Android manifest supports joystick (list)
# android.manifest.supports_joystick = 

# Android manifest supports gamepad (list)
# android.manifest.supports_gamepad = 

# Android manifest supports touchscreen (list)
# android.manifest.supports_touchscreen = 

# Android manifest supports wifi (list)
# android.manifest.supports_wifi = 

# Android manifest supports bluetooth (list)
# android.manifest.supports_bluetooth = 

# Android manifest supports camera (list)
# android.manifest.supports_camera = 

# Android manifest supports gps (list)
# android.manifest.supports_gps = 

# Android manifest supports microphone (list)
# android.manifest.supports_microphone = 

# Android manifest supports nfc (list)
# android.manifest.supports_nfc = 

# Android manifest supports telephony (list)
# android.manifest.supports_telephony = 

# Android manifest supports usb (list)
# android.manifest.supports_usb = 

# Android manifest supports accessibility (list)
# android.manifest.supports_accessibility = 

# iOS distribution method (string)
# ios.distribution_method = app-store

# iOS team ID (string)
# ios.team_id = 

# iOS bundle identifier (string)
# ios.bundle_identifier = 

# iOS export method (string)
# ios.export_method = app-store

# iOS provisioning profile (string)
# ios.provisioning_profile = 

# iOS code signing identity (string)
# ios.codesign_identity = 

# iOS development team (string)
# ios.development_team = 
