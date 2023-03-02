import 'package:fairstores/models/categoryModel.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryListProvider = StateProvider<List<CategoryModel>>((ref) => []);

final categoryProvider = FutureProvider((ref) async {
  List<CategoryModel> categories = await CategoryModel.getCategories(
    school: ref.read(userProvider).school!
  );

  ref.read(categoryListProvider.notifier).state = categories;
});