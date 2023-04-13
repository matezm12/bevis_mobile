import 'dart:io';

extension GetFileName on FileSystemEntity {
  String get filename {
    return this?.path?.split("/")?.last?.split('.')?.first;
  }
}
