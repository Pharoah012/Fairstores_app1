import 'package:fairstores/models/userModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final managersTokensListProvider = StateProvider<List<String>>((ref) => []);

final managersTokensProvider = FutureProvider<List<String>>((ref) async {
  List<String> tokens = await UserModel.getManagerTokens();

  ref.read(managersTokensListProvider.notifier).state = tokens;

  return tokens;
});