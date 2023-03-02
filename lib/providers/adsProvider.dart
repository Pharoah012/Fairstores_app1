import 'package:fairstores/models/adModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adsProvider = FutureProvider.family<List<AdModel>, String>(
        (ref, school) async => await AdModel.getAds(school: school)
);
