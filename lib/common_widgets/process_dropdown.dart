import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import '../models/process_name_model.dart';

class ProcessDropdown extends StatefulWidget {
  final List<ProcessNameModel> processes;
  final ProcessNameModel? selectedProcess;
  final void Function(ProcessNameModel?) onChanged;

  const ProcessDropdown({
    Key? key,
    required this.processes,
    this.selectedProcess,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ProcessDropdown> createState() => _ProcessDropdownState();
}

class _ProcessDropdownState extends State<ProcessDropdown> {
  late TextEditingController _controller;
  late ProcessNameModel? _selectedProcess;

  @override
  void initState() {
    super.initState();
    _selectedProcess = widget.selectedProcess;
    _controller = TextEditingController(
      text: _selectedProcess?.taskName ?? '',
    );
  }

  @override
  void didUpdateWidget(ProcessDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedProcess != oldWidget.selectedProcess) {
      _selectedProcess = widget.selectedProcess;
      _controller.text = _selectedProcess?.taskName ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchField<ProcessNameModel>(
      controller: _controller, // Add controller
      suggestions: widget.processes
          .map(
            (p) => SearchFieldListItem<ProcessNameModel>(
          p.taskName ?? '',
          item: p,
        ),
      )
          .toList(),
      suggestionState: Suggestion.expand,
      searchInputDecoration: SearchInputDecoration(
        labelText: 'Process Name *',
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        suffixIcon: _selectedProcess != null
            ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _controller.clear();
            setState(() {
              _selectedProcess = null;
            });
            widget.onChanged(null);
          },
        )
            : null,
      ),
      maxSuggestionsInViewPort: 5,
      itemHeight: 48,
      onSuggestionTap: (item) {
        setState(() {
          _selectedProcess = item.item;
          _controller.text = item.item!.taskName ?? '';
        });
        widget.onChanged(item.item);
      },
      validator: (value) {
        if (value == null || value.isEmpty || _selectedProcess == null) {
          return 'Required field';
        }
        return null;
      },
    );
  }
}