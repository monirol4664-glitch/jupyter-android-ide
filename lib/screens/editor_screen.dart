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

class _EditorScreenState extends State<EditorScreen> with SingleTickerProviderStateMixin {
  final ExecutionService _executionService = ExecutionService();
  late TabController _tabController;
  bool _isFullscreen = false;
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final notebook = Provider.of<NotebookModel>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(notebook),
      body: _buildBody(notebook),
      floatingActionButton: _buildFAB(notebook),
    );
  }
  
  PreferredSizeWidget _buildAppBar(NotebookModel notebook) {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Jupyter',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Python IDE',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.black87,
      actions: [
        // Kernel status indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'Python 3.11',
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Run all button
        _buildToolbarButton(
          icon: Icons.play_arrow,
          label: 'Run All',
          onTap: () => _runAllCells(notebook),
          color: Colors.green,
        ),
        // Clear all button
        _buildToolbarButton(
          icon: Icons.cleaning_services,
          label: 'Clear',
          onTap: () => notebook.clearAllOutputs(),
          color: Colors.orange,
        ),
        // Fullscreen toggle
        _buildToolbarButton(
          icon: _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
          label: 'Fullscreen',
          onTap: () {
            setState(() => _isFullscreen = !_isFullscreen);
          },
          color: Colors.blue,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
  
  Widget _buildToolbarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: color),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBody(NotebookModel notebook) {
    if (_isFullscreen) {
      return _buildFullscreenMode(notebook);
    }
    
    return Column(
      children: [
        // Tab bar
        Container(
          color: Colors.grey[100],
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.green,
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: '📓 Notebook', icon: Icon(Icons.edit_note)),
              Tab(text: '📊 Variables', icon: Icon(Icons.code)),
            ],
          ),
        ),
        // Search bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search in cells...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () {
                          setState(() => _searchQuery = '');
                          notebook.clearSearch();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
                notebook.searchCells(value);
              },
            ),
          ),
        ),
        // Main content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildNotebookView(notebook),
              _buildVariablesView(notebook),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildNotebookView(NotebookModel notebook) {
    if (notebook.cells.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_note, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No cells yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => notebook.addCell(),
              icon: const Icon(Icons.add),
              label: const Text('Add your first cell'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: notebook.cells.length,
      itemBuilder: (context, index) {
        final cell = notebook.cells[index];
        final isHighlighted = _searchQuery.isNotEmpty && 
            cell.code.toLowerCase().contains(_searchQuery.toLowerCase());
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isHighlighted ? Colors.yellow[100] : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCellToolbar(notebook, cell, index),
              _buildCellInput(cell, notebook),
              if (cell.output.isNotEmpty || cell.isRunning)
                _buildCellOutput(cell),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildCellToolbar(NotebookModel notebook, dynamic cell, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          // Cell number badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cell.isRunning ? Colors.green[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (cell.isRunning)
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                if (cell.isRunning) const SizedBox(width: 6),
                Text(
                  cell.isRunning ? 'RUNNING' : 'In [${index + 1}]',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: cell.isRunning ? Colors.green[800] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Run button
          _buildCellButton(
            icon: Icons.play_arrow,
            color: Colors.green,
            onTap: cell.isRunning ? null : () => _runCell(notebook, cell),
            tooltip: 'Run Cell',
          ),
          // Add above button
          _buildCellButton(
            icon: Icons.arrow_upward,
            color: Colors.blue,
            onTap: () => notebook.addCellAbove(cell.id),
            tooltip: 'Add Cell Above',
          ),
          // Add below button
          _buildCellButton(
            icon: Icons.arrow_downward,
            color: Colors.blue,
            onTap: () => notebook.addCell(afterId: cell.id),
            tooltip: 'Add Cell Below',
          ),
          // Copy button
          _buildCellButton(
            icon: Icons.copy,
            color: Colors.orange,
            onTap: () => notebook.copyCell(cell.id),
            tooltip: 'Copy Cell',
          ),
          // Delete button
          _buildCellButton(
            icon: Icons.delete,
            color: Colors.red,
            onTap: () => notebook.deleteCell(cell.id),
            tooltip: 'Delete Cell',
          ),
          // Drag handle
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: const Icon(Icons.drag_handle, size: 20, color: Colors.grey),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCellButton({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: onTap == null ? Colors.grey : color),
        ),
      ),
    );
  }
  
  Widget _buildCellInput(dynamic cell, NotebookModel notebook) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: CodeEditor(
        code: cell.code,
        onChanged: (code) => notebook.updateCode(cell.id, code),
      ),
    );
  }
  
  Widget _buildCellOutput(dynamic cell) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: cell.isRunning
          ? const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Executing...', style: TextStyle(color: Colors.grey)),
              ],
            )
          : SelectableText(
              cell.output,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
    );
  }
  
  Widget _buildVariablesView(NotebookModel notebook) {
    final variables = notebook.getVariables();
    
    if (variables.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.code_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No variables defined',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Run some code to see variables here',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: variables.length,
      itemBuilder: (context, index) {
        final variable = variables[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green[100],
              child: Text(
                variable['type']?.substring(0, 1).toUpperCase() ?? 'V',
                style: TextStyle(color: Colors.green[800]),
              ),
            ),
            title: Text(
              variable['name'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(variable['type'] ?? ''),
            trailing: Text(
              variable['value'] ?? '',
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildFullscreenMode(NotebookModel notebook) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: CodeEditor(
              code: notebook.cells.isNotEmpty ? notebook.cells.last.code : '',
              onChanged: (code) {
                if (notebook.cells.isNotEmpty) {
                  notebook.updateCode(notebook.cells.last.id, code);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildFAB(NotebookModel notebook) {
    return FloatingActionButton.extended(
      onPressed: () => notebook.addCell(),
      icon: const Icon(Icons.add),
      label: const Text('New Cell'),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
    );
  }
  
  Future<void> _runCell(NotebookModel notebook, dynamic cell) async {
    notebook.setRunning(cell.id, true);
    final output = await _executionService.executeCode(cell.code);
    notebook.updateOutput(cell.id, output);
    notebook.recordVariable(cell.code, output);
  }
  
  Future<void> _runAllCells(NotebookModel notebook) async {
    for (var cell in notebook.cells) {
      if (cell.code.trim().isNotEmpty) {
        await _runCell(notebook, cell);
      }
    }
  }
}
