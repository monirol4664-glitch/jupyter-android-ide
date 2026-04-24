[app]
title = Jupyter IDE
package.name = jupyteride
package.domain = org.ide
source.dir = .
source.include_exts = py,png,jpg,kv,atlas,ttf
requirements = python3,kivy==2.1.0,pygments
orientation = portrait
fullscreen = 0
version = 0.1

[android]
android.api = 30
android.minapi = 21
android.ndk = 25b
android.accept_sdk_license = True
android.arch = arm64-v8a
android.permissions = WRITE_EXTERNAL_STORAGE

[buildozer]
log_level = 2
warn_on_root = 1