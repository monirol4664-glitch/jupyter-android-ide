[app]

# (str) Title of your application
title = Jupyter IDE

# (str) Package name
package.name = jupyteride

# (str) Package domain (needed for android/ios packaging)
package.domain = org.ide

# (str) Source code where the main.py live
source.dir = .

# (list) Source files to include (let empty to include all the files)
source.include_exts = py,png,jpg,kv,atlas,ttf

# (list) Application requirements
requirements = python3,kivy==2.1.0,pygments

# (str) Supported orientation (one of landscape, sensorLandscape, portrait or all)
orientation = portrait

# (bool) Indicate if the application should be fullscreen or not
fullscreen = 0

# (str) Application versioning
version = 0.1

# (list) Permissions
android.permissions = WRITE_EXTERNAL_STORAGE,READ_EXTERNAL_STORAGE

[android]

# (int) Android API level (the minimum API version)
android.api = 30

# (int) Minimum API required (21 = Android 5.0)
android.minapi = 21

# (int) Android NDK version to use
android.ndk = 25b

# (bool) Accept SDK license
android.accept_sdk_license = True

# (str) Android arch to build for
android.archs = arm64-v8a

# (str) Android entry point
android.entrypoint = org.kivy.android.PythonActivity

# (str) Android app theme
android.apptheme = @android:style/Theme.NoTitleBar

# (bool) Copy prebuilt python dependency
android.copy_libs = 1

# (bool) Enable AndroidX support
android.enable_androidx = True

[buildozer]

# (int) Log level (0 = error only, 1 = info, 2 = debug)
log_level = 2

# (bool) Stop build if a Python file is missing required module
warn_on_root = 1