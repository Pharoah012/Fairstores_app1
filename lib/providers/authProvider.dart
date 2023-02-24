import 'package:fairstores/controllers/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateProvider<Auth>((ref) => Auth());