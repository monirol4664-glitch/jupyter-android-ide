#!/usr/bin/env python3
"""
Runtime Python package installer
This script runs inside the APK to download packages on first use
"""

import subprocess
import sys
import os

def install_package(package_name):
    """Install a Python package from PyPI"""
    try:
        subprocess.check_call([
            sys.executable, '-m', 'pip', 'install',
            package_name, '--target', os.path.join(os.path.dirname(__file__), 'packages')
        ])
        print(f"✅ Installed: {package_name}")
        return True
    except Exception as e:
        print(f"❌ Failed: {package_name} - {e}")
        return False

# Packages that users can install on demand
AVAILABLE_PACKAGES = {
    'numpy': 'NumPy for numerical computing',
    'pandas': 'Pandas for data analysis',
    'requests': 'HTTP library',
    'beautifulsoup4': 'Web scraping',
    'matplotlib': 'Plotting library',
}

if __name__ == '__main__':
    print("📦 Python Package Installer")
    print("Available packages:")
    for pkg, desc in AVAILABLE_PACKAGES.items():
        print(f"  - {pkg}: {desc}")
    
    while True:
        pkg = input("\nPackage to install (or 'done'): ").strip().lower()
        if pkg == 'done':
            break
        if pkg in AVAILABLE_PACKAGES:
            install_package(pkg)
        else:
            print(f"Unknown package: {pkg}")
