# Jupyter IDE for Android

A complete offline Python IDE with Jupyter notebook-style interface, syntax highlighting, and auto-completion.

## Features

- 📝 **Jupyter-style Cells** - Add, delete, and run code cells independently
- 🎨 **Syntax Highlighting** - Python keywords, builtins, and strings
- 💡 **Auto-completion** - Real-time code suggestions while typing
- 🚀 **Offline Execution** - Run Python code without internet
- 📱 **Mobile Optimized** - Designed for touch screens

## Building with GitHub Actions

1. Push this repository to GitHub
2. Go to Actions tab → Select "Build Jupyter-Style IDE APK"
3. Click "Run workflow" → Select branch (main)
4. Wait for build to complete (10-15 minutes)
5. Download APK from artifacts

## Manual Build (Local)

```bash
# Install buildozer
pip install buildozer

# Initialize and build
buildozer init
buildozer android debug deploy run