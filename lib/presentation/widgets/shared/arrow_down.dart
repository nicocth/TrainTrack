import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArrowDown extends ConsumerWidget {
  const ArrowDown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Icon(Icons.arrow_downward, color: Colors.white, size: 30);
  }
}
