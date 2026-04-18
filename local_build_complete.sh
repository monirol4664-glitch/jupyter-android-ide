#!/usr/bin/env python3
"""
Local APK builder for Mathematica Console
Run this on Ubuntu/Debian or WSL
"""

import os
import subprocess
import sys

def run_command(cmd, cwd=None):
    print(f"Running: {cmd}")
    result = subprocess.run(cmd, shell=True, cwd=cwd)
    if result.returncode != 0:
        print(f"Command failed with exit code {result.returncode}")
        return False
    return True

def main():
    print("=== Mathematica Console APK Builder ===")
    
    # Install dependencies
    print("\n1. Installing dependencies...")
    run_command("sudo apt-get update")
    run_command("sudo apt-get install -y openjdk-17-jdk python3-pip git zip unzip wget")
    
    # Install Python-for-Android
    print("\n2. Installing python-for-android...")
    run_command("pip3 install python-for-android")
    
    # Create app directory
    print("\n3. Creating app structure...")
    os.makedirs("mathematica_app", exist_ok=True)
    os.chdir("mathematica_app")
    
    # Create main.py
    with open("main.py", "w") as f:
        f.write('''
import sympy as sp
from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.textinput import TextInput
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.scrollview import ScrollView

class MathApp(App):
    def build(self):
        layout = BoxLayout(orientation='vertical', padding=10, spacing=10)
        
        # Title
        title = Label(text='Mathematica Console', size_hint_y=0.1, font_size='24sp')
        layout.add_widget(title)
        
        # Output area
        self.output = ScrollView(size_hint_y=0.6)
        self.output_layout = BoxLayout(orientation='vertical', size_hint_y=None)
        self.output_layout.bind(minimum_height=self.output_layout.setter('height'))
        self.output.add_widget(self.output_layout)
        layout.add_widget(self.output)
        
        # Input area
        self.input = TextInput(hint_text='Enter expression...', multiline=False, size_hint_y=0.1)
        layout.add_widget(self.input)
        
        # Buttons
        btn_layout = BoxLayout(size_hint_y=0.1, spacing=10)
        eval_btn = Button(text='Evaluate')
        eval_btn.bind(on_press=self.evaluate)
        clear_btn = Button(text='Clear')
        clear_btn.bind(on_press=self.clear)
        btn_layout.add_widget(eval_btn)
        btn_layout.add_widget(clear_btn)
        layout.add_widget(btn_layout)
        
        self.add_output("Mathematica Console Ready!")
        self.add_output("Examples: 2+2, x**2, integrate(x**2, x)")
        
        return layout
    
    def add_output(self, text, is_error=False):
        color = (1,0.3,0.3,1) if is_error else (0.8,0.8,0.9,1)
        label = Label(
            text=text,
            size_hint_y=None,
            height=40,
            halign='left',
            valign='top',
            color=color
        )
        label.bind(size=label.setter('text_size'))
        self.output_layout.add_widget(label)
    
    def evaluate(self, instance):
        expr = self.input.text.strip()
        if not expr:
            return
        
        self.add_output(f"In: {expr}")
        try:
            result = sp.sympify(expr)
            self.add_output(f"Out: {result}")
        except Exception as e:
            self.add_output(f"Error: {e}", True)
        
        self.input.text = ''
    
    def clear(self, instance):
        self.output_layout.clear_widgets()
        self.add_output("Console cleared")

if __name__ == '__main__':
    MathApp().run()
''')
    
    # Create buildozer.spec
    with open("buildozer.spec", "w") as f:
        f.write('''
[app]
title = Mathematica Console
package.name = mathconsole
package.domain = org.mathematica
source.dir = .
version = 1.0.0
requirements = python3,kivy,sympy
orientation = portrait
android.permissions = INTERNET
android.api = 30
android.minapi = 21
android.ndk = 23b
log_level = 2

[buildozer]
android.accept_sdk_license = True
''')
    
    # Install buildozer
    print("\n4. Installing buildozer...")
    run_command("pip3 install buildozer")
    
    # Build APK
    print("\n5. Building APK (this will take 10-20 minutes)...")
    run_command("buildozer android debug")
    
    # Check for APK
    print("\n6. Checking for APK...")
    if os.path.exists("bin/mathconsole-1.0.0-debug.apk"):
        print("\n✅ APK created successfully!")
        print(f"Location: {os.path.abspath('bin/mathconsole-1.0.0-debug.apk')}")
        os.system(f"ls -lh bin/*.apk")
    else:
        print("\n❌ APK not found. Build may have failed.")
        print("Check buildozer.log for details.")

if __name__ == "__main__":
    main()
