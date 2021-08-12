import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_version_app/models/version.dart';
import 'package:flutter_version_app/service/version_service.dart';
import 'package:package_info/package_info.dart';

class VersionServiceImpl extends VersionService {
  @override
  Stream<Version> getVersion() {
    try {
      return FirebaseFirestore.instance
      .collection('version')
      .snapshots().map((QuerySnapshot event) {
        return Version.fromJson(event.docs.firstWhere((DocumentSnapshot documentSnapshot) => documentSnapshot.id == 'development', orElse: () => null).data());
      });
    } on Exception catch (e, s) {
      print('getConfigs error: $e, $s');
      return Stream.empty();
    }
  }

}