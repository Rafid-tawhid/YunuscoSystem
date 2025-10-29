import 'package:flutter/material.dart';

class EnhancedRequisitionDialog extends StatefulWidget {
  final num requestedNumber;
  final String requisitionId;
  final Function(num) onConfirm;

  const EnhancedRequisitionDialog({
    Key? key,
    required this.requestedNumber,
    required this.requisitionId,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<EnhancedRequisitionDialog> createState() => _EnhancedRequisitionDialogState();
}

class _EnhancedRequisitionDialogState extends State<EnhancedRequisitionDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;
  bool _isValid = false;

  void _validateInput(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorText = 'Please enter a number';
        _isValid = false;
      });
      return;
    }

    final int? acceptedNumber = int.tryParse(value);

    if (acceptedNumber == null) {
      setState(() {
        _errorText = 'Please enter a valid number';
        _isValid = false;
      });
      return;
    }

    if (acceptedNumber < 0) {
      setState(() {
        _errorText = 'Number cannot be less than zero';
        _isValid = false;
      });
      return;
    }

    if (acceptedNumber > widget.requestedNumber) {
      setState(() {
        _errorText = 'Cannot exceed requested amount (${widget.requestedNumber})';
        _isValid = false;
      });
      return;
    }

    setState(() {
      _errorText = null;
      _isValid = true;
    });
  }

  void _onConfirm() {
    if (_isValid) {
      final int acceptedNumber = int.parse(_controller.text);
      widget.onConfirm(acceptedNumber);
      Navigator.of(context).pop(acceptedNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          const Icon(Icons.inventory_2, color: Colors.blue),
          const SizedBox(width: 8),
          const Text('Accept Requisition'),
          const Spacer(),

        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Request Info Card
            Chip(
              label: Text(widget.requisitionId),
              backgroundColor: Colors.blue.withOpacity(0.1),
            ),
            Card(
              color: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.request_quote, color: Colors.orange),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Requested Amount',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          widget.requestedNumber.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Input Field
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Accepted Quantity',
                hintText: 'Enter number between 0 and ${widget.requestedNumber}',
                border: const OutlineInputBorder(),
                errorText: _errorText,
                prefixIcon: const Icon(Icons.check_circle_outline),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _errorText = null;
                      _isValid = false;
                    });
                  },
                )
                    : null,
              ),
              keyboardType: TextInputType.number,
              onChanged: _validateInput,
            ),

            const SizedBox(height: 10),

            // Live Preview
            if (_isValid)
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ready to Confirm',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              'Accepted: ${_controller.text} | '
                                  'Remaining: ${widget.requestedNumber - int.parse(_controller.text)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isValid ? _onConfirm : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isValid ? Colors.green : Colors.grey,
          ),
          child: const Text('Confirm Acceptance',style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}