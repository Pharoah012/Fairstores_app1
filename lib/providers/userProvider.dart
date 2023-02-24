import 'package:fairstores/models/userModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<UserModel>(
  (ref) => UserModel(ismanager: false)
);