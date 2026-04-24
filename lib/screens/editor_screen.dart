import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/notebook_model.dart';
import '../services/execution_service.dart';
import '../widgets/code_editor.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});
  
  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final ExecutionService _executionService = ExecutionService();
  
  @override
  Widget build(BuildContext context) {
    final notebook = Provider.of<NotebookModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐍 Jupyter IDE'),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Run all cells button
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () => _runAllCells(notebook),
            tooltip: 'Run All Cells',
          ),
          // Clear all outputs button
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: () => notebook.clearAllOutputs(),
            tooltip: 'Clear All Outputs',
          ),
          // Info button
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
            tooltip: 'About',
          ),
        ],
      ),
      body: Column(
        children: [
          // Cell count indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[850],
            child: Row(
              children: [
                Icon(Icons.code, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Text(
                  '${notebook.cells.length} cells',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const Spacer(),
                Text(
                  'Drag ⋮⋮ to reorder',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          // Cells list
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) => 
                  notebook.reorderCells(oldIndex, newIndex),
              padding: const EdgeInsets.all(8),
              children: [
                for (var cell in notebook.cells)
                  Container(
                    key: Key(cell.id),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: cell.isRunning ? Colors.green : Colors.grey[700]!,
                        width: cell.isRunning ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildToolbar(notebook, cell),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: CodeEditor(
                            code: cell.code,
                            onChanged: (code) => notebook.updateCode(cell.id, code),
                          ),
                        ),
                        if (cell.output.isNotEmpty || cell.isRunning)
                          Container(
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[800]!),
                            ),
                            child: cell.isRunning
                                ? const Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation(Colors.green),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Running...',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  )
                                : SelectableText(
                                    cell.output,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 13,
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => notebook.addCell(),
        icon: const Icon(Icons.add),
        label: const Text('New Cell'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
  
  Widget _buildToolbar(NotebookModel notebook, CodeCell cell) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          // Drag handle
          const Icon(Icons.drag_handle, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          // Cell number
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cell.isRunning 
                  ? Colors.green[900] 
                  : Colors.deepPurple[700],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (cell.isRunning)
                  const SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                if (cell.isRunning) const SizedBox(width: 6),
                Text(
                  cell.isRunning ? 'RUNNING' : 'In [${cell.id.split('_').last}]',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Run button
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Colors.green, size: 20),
            onPressed: cell.isRunning ? null : () => _runCell(notebook, cell),
            tooltip: 'Run Cell',
          ),
          // Add button
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue, size: 20),
            onPressed: () => notebook.addCell(afterId: cell.id),
            tooltip: 'Add Cell Below',
          ),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () => notebook.deleteCell(cell.id),
            tooltip: 'Delete Cell',
          ),
        ],
      ),
    );
  }
  
  Future<void> _runCell(NotebookModel notebook, CodeCell cell) async {
    notebook.setRunning(cell.id, true);
    final output = await _executionService.executeCode(cell.code);
    notebook.updateOutput(cell.id, output);
  }
  
  Future<void> _runAllCells(NotebookModel notebook) async {
    for (var cell in notebook.cells) {
      if (cell.code.trim().isNotEmpty) {
        await _runCell(notebook, cell);
      }
    }
  }
  
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🐍 Jupyter IDE'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Features:'),
            Text('• Python syntax highlighting'),
            Text('• Auto-completion'),
            Text('• Jupyter-style cells'),
            Text('• Offline execution'),
            SizedBox(height: 8),
            Text('Built with Flutter'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
