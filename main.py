"""
Jupyter Notebook Style Python IDE for Android
Features: Syntax highlighting, auto-completion, cell execution, offline
"""

from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.button import Button
from kivy.uix.label import Label
from kivy.uix.scrollview import ScrollView
from kivy.uix.textinput import TextInput
from kivy.uix.gridlayout import GridLayout
from kivy.clock import Clock
from kivy.core.window import Window
from kivy.graphics import Color, Rectangle
import re

from editor import CodeEditor
from interpreter import PythonInterpreter
from autocomplete import AutoCompleter

# Set window size for better mobile experience
Window.size = (360, 640)


class CodeCell(BoxLayout):
    """Represents a Jupyter-style code cell"""
    
    def __init__(self, cell_id, interpreter, autocompleter, **kwargs):
        super().__init__(orientation='vertical', spacing=5, size_hint_y=None, **kwargs)
        self.cell_id = cell_id
        self.interpreter = interpreter
        self.autocompleter = autocompleter
        self.height = 200
        self.padding = [10, 10]
        
        # Cell toolbar
        toolbar = BoxLayout(size_hint_y=None, height=40, spacing=5)
        
        self.cell_label = Label(text=f'In [{cell_id}]:', size_hint_x=0.3)
        run_btn = Button(text='▶ Run', size_hint_x=0.2)
        run_btn.bind(on_press=self.run_cell)
        add_btn = Button(text='+', size_hint_x=0.1)
        add_btn.bind(on_press=self.add_cell_below)
        del_btn = Button(text='🗑', size_hint_x=0.1)
        del_btn.bind(on_press=self.delete_cell)
        
        toolbar.add_widget(self.cell_label)
        toolbar.add_widget(run_btn)
        toolbar.add_widget(add_btn)
        toolbar.add_widget(del_btn)
        
        # Code editor
        self.editor = CodeEditor(autocompleter=self.autocompleter)
        self.editor.bind(height=self._on_editor_height_change)
        
        # Output area
        self.output_area = TextInput(
            readonly=True,
            size_hint_y=None,
            height=100,
            background_color=(0.1, 0.1, 0.1, 1),
            foreground_color=(0.8, 0.8, 0.8, 1),
            font_size=12
        )
        
        self.add_widget(toolbar)
        self.add_widget(self.editor)
        self.add_widget(self.output_area)
        
        # Bind to update parent scroll
        self.editor.bind(height=self._update_parent_scroll)
        self.output_area.bind(height=self._update_parent_scroll)
    
    def _on_editor_height_change(self, instance, value):
        """Adjust cell height when editor grows"""
        self.height = self.editor.height + self.output_area.height + 100
    
    def _update_parent_scroll(self, instance, value):
        """Notify parent to update scroll area"""
        if self.parent:
            Clock.schedule_once(lambda dt: setattr(self.parent, 'height', self.parent.minimum_height), 0.1)
    
    def run_cell(self, instance):
        """Execute code in this cell"""
        code = self.editor.text
        if not code.strip():
            self.output_area.text = "No code to execute"
            return
        
        output, error = self.interpreter.execute_code(code)
        
        if error:
            self.output_area.text = f"Error:\n{error}"
        else:
            self.output_area.text = output if output.strip() else "Executed successfully (no output)"
        
        # Update cell number
        self.cell_label.text = f'Out[{self.cell_id}]:'
    
    def add_cell_below(self, instance):
        """Add new cell below current one"""
        if self.parent and hasattr(self.parent, 'add_cell'):
            self.parent.add_cell(after_cell=self)
    
    def delete_cell(self, instance):
        """Delete this cell"""
        if self.parent and hasattr(self.parent, 'remove_cell'):
            self.parent.remove_cell(self)
    
    def set_cell_id(self, new_id):
        """Update cell display number"""
        self.cell_id = new_id
        self.cell_label.text = f'In [{new_id}]:'


class NotebookLayout(ScrollView):
    """Main notebook container with scrolling cells"""
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.cells = []
        self.next_cell_id = 1
        
        # Container for all cells
        self.cell_container = GridLayout(
            cols=1,
            spacing=10,
            size_hint_y=None
        )
        self.cell_container.bind(minimum_height=self.cell_container.setter('height'))
        self.add_widget(self.cell_container)
        
        # Create interpreter and autocompleter
        self.interpreter = PythonInterpreter()
        self.autocompleter = AutoCompleter()
        
        # Add first cell
        self.add_cell()
        
        # Add new cell button at bottom
        self.add_new_cell_button()
    
    def add_new_cell_button(self):
        """Add button to create new cells"""
        btn_layout = BoxLayout(size_hint_y=None, height=60)
        new_btn = Button(text='+ Add New Cell', font_size=16)
        new_btn.bind(on_press=lambda x: self.add_cell())
        btn_layout.add_widget(new_btn)
        self.cell_container.add_widget(btn_layout)
    
    def add_cell(self, after_cell=None, code=""):
        """Add a new code cell"""
        cell = CodeCell(
            cell_id=self.next_cell_id,
            interpreter=self.interpreter,
            autocompleter=self.autocompleter
        )
        
        if code:
            cell.editor.text = code
        
        self.next_cell_id += 1
        
        if after_cell:
            # Insert after specific cell
            index = self.cell_container.children.index(after_cell)
            self.cell_container.add_widget(cell, index + 1)
        else:
            # Add at the end, before the new button
            if len(self.cell_container.children) > 0:
                self.cell_container.add_widget(cell, len(self.cell_container.children) - 1)
            else:
                self.cell_container.add_widget(cell)
        
        self.cells.append(cell)
        self._renumber_cells()
    
    def remove_cell(self, cell):
        """Remove a code cell"""
        if len(self.cells) > 1:
            self.cell_container.remove_widget(cell)
            self.cells.remove(cell)
            self._renumber_cells()
    
    def _renumber_cells(self):
        """Renumber all cells sequentially"""
        for idx, cell in enumerate(self.cells, 1):
            cell.set_cell_id(idx)


class JupyterIDEApp(App):
    """Main Application"""
    
    def build(self):
        # Main layout
        root = BoxLayout(orientation='vertical')
        
        # Title bar
        title_bar = BoxLayout(size_hint_y=None, height=50)
        title_bar.canvas.before.add(Color(0.2, 0.2, 0.3, 1))
        title_bar.canvas.before.add(Rectangle(size=title_bar.size, pos=title_bar.pos))
        title_bar.bind(size=self._update_rect, pos=self._update_rect)
        
        title = Label(text='Jupyter IDE - Python', font_size=18, color=(1, 1, 1, 1))
        clear_all_btn = Button(text='Clear All Output', size_hint_x=0.3)
        clear_all_btn.bind(on_press=self.clear_all_output)
        
        title_bar.add_widget(title)
        title_bar.add_widget(clear_all_btn)
        
        # Notebook area
        self.notebook = NotebookLayout()
        
        root.add_widget(title_bar)
        root.add_widget(self.notebook)
        
        return root
    
    def _update_rect(self, instance, value):
        instance.canvas.before.clear()
        with instance.canvas.before:
            Color(0.2, 0.2, 0.3, 1)
            Rectangle(size=instance.size, pos=instance.pos)
    
    def clear_all_output(self, instance):
        """Clear output from all cells"""
        for cell in self.notebook.cells:
            cell.output_area.text = ""


if __name__ == '__main__':
    JupyterIDEApp().run()