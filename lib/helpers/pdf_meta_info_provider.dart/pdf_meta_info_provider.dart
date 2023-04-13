import 'package:flutter/foundation.dart';

abstract class PdfMetaInfoProvider {
  Future<int> getNumberOfPages({@required List<int> pdfData});
}