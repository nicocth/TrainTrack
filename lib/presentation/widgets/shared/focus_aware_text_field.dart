import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusAwareTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final TextAlign textAlign;

  const FocusAwareTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.inputFormatters,
    this.textAlign = TextAlign.start,
  });

  @override
  State<FocusAwareTextField> createState() => _FocusAwareTextFieldState();
}

class _FocusAwareTextFieldState extends State<FocusAwareTextField> {
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      textAlign: widget.textAlign,
      decoration: InputDecoration(
        hintText: _hasFocus ? '' : widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
