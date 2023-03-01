import 'package:fairstores/models/securityModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final securityKeysProvider = StateProvider<SecurityModel?>((ref) => null);

final securityKeysGeneratorProvider = FutureProvider(
    (ref) async {
      ref.read(securityKeysProvider.notifier).state = await SecurityModel.getSecurityKeys();
    }
);