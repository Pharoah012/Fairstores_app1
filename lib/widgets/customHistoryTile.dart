import 'package:fairstores/models/historyModel.dart';
import 'package:flutter/material.dart';

class HistoryTile extends StatefulWidget {
  final HistoryModel history;

  const HistoryTile({
    Key? key,
    required this.history
  }) : super(key: key);

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
