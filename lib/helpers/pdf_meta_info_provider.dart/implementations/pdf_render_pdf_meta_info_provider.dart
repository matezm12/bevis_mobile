import 'package:bevis/helpers/pdf_meta_info_provider.dart/pdf_meta_info_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf_render/pdf_render.dart';

class PdfRenderPdfMetaInfoProvider implements PdfMetaInfoProvider {
  @override
  Future<int> getNumberOfPages({@required List<int> pdfData}) async {
    PdfDocument doc = await PdfDocument.openData(pdfData);
    return doc.pageCount;
  }
}