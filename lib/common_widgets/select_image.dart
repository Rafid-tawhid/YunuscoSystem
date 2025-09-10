import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerRow extends StatefulWidget {
  final String buttonText;
  final EdgeInsetsGeometry? buttonPadding;
  final ButtonStyle? buttonStyle;
  final TextStyle? pathTextStyle;
  final TextStyle? placeholderTextStyle;
  final double spacing;
  final ValueChanged<PlatformFile>? onFileSelected;
  final String? initialPath;
  final List<String> allowedExtensions;
  final bool allowMultiple;

  const FilePickerRow({
    Key? key,
    this.buttonText = 'Select File',
    this.buttonPadding,
    this.buttonStyle,
    this.pathTextStyle,
    this.placeholderTextStyle,
    this.spacing = 16.0,
    this.onFileSelected,
    this.initialPath,
    this.allowedExtensions = const ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    this.allowMultiple = false,
  }) : super(key: key);

  @override
  _FilePickerRowState createState() => _FilePickerRowState();
}

class _FilePickerRowState extends State<FilePickerRow> {
  String? _filePath;
  List<PlatformFile> _selectedFiles = [];

  @override
  void initState() {
    super.initState();
    _filePath = widget.initialPath;
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: widget.allowedExtensions,
        allowMultiple: widget.allowMultiple,
      );

      if (result != null) {
        setState(() {
          _selectedFiles = result.files;
          _filePath = _selectedFiles.isNotEmpty ? _selectedFiles.first.path : null;
        });

        // Callback for each selected file
        for (var file in _selectedFiles) {
          widget.onFileSelected?.call(file);
        }

        print('Selected ${_selectedFiles.length} file(s)');
        if (_selectedFiles.isNotEmpty) {
          print('First file path: $_filePath');
        }
      }
    } catch (e) {
      print('Error picking files: $e');
    }
  }

  // Public method to get the current file paths
  List<String> getFilePaths() {
    return _selectedFiles.map((file) => file.path!).where((path) => path != null).toList();
  }

  // Public method to get the PlatformFile objects
  List<PlatformFile> getFiles() => _selectedFiles;

  // Public method to clear the selection
  void clearSelection() {
    setState(() {
      _selectedFiles = [];
      _filePath = null;
    });
  }

  String _getDisplayText() {
    if (_selectedFiles.isEmpty) return 'No file selected';
    if (_selectedFiles.length == 1) return _selectedFiles.first.name;
    return '${_selectedFiles.length} files selected';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Pick File Button
        ElevatedButton(
          onPressed: _pickFiles,
          style: widget.buttonStyle ?? ElevatedButton.styleFrom(),
          child: Padding(
            padding: widget.buttonPadding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(widget.buttonText),
          ),
        ),

        SizedBox(width: widget.spacing),

        // Show file info
        Expanded(
          child: Text(
            _getDisplayText(),
            style: _selectedFiles.isNotEmpty
                ? (widget.pathTextStyle ?? TextStyle(
              color: Colors.blue,
              fontSize: 14,
            ))
                : (widget.placeholderTextStyle ?? TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            )),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}