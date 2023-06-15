import 'dart:io';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:pdf/pdf.dart';
import 'package:share/share.dart';

class RenderScreen extends StatefulWidget {
  final String modifiedHtml;

  RenderScreen(this.modifiedHtml);

  @override
  _RenderScreenState createState() => _RenderScreenState();
}

class _RenderScreenState extends State<RenderScreen> {
  late pdfWidgets.Document pdf;
  String? pdfPath;

  @override
  void initState() {
    super.initState();
    pdf = pdfWidgets.Document();
  }

  Future<void> generatePdf() async {
    final ByteData fontData = await rootBundle.load('assets/fonts/lora.ttf');
    final pdfFonts = pdfWidgets.Font.ttf(fontData);

    final visibleText = extractVisibleText(widget.modifiedHtml);
    pdf.addPage(
      pdfWidgets.Page(
        build: (context) {
          return pdfWidgets.Center(
            child: pdfWidgets.Text(
              visibleText,
              style: pdfWidgets.TextStyle(
                font: pdfFonts,
                fontSize: 20,
              ),
            ),
          );
        },
      ),
    );

    final outputDir = await getTemporaryDirectory();
    final outputFile = File('${outputDir.path}/output.pdf');
    await outputFile.writeAsBytes(await pdf.save());
    final outputFilePath = outputFile.path;

    setState(() {
      pdfPath = outputFilePath;
    });
  }

  Future<void> sharePdf() async {
    if (pdfPath != null) {
      final pdfFile = File(pdfPath!);
      if (await pdfFile.exists()) {
        await Share.shareFiles([pdfPath!], text: 'Sharing PDF');
      }
    }
  }

  String extractVisibleText(String html) {
    final regex = RegExp(r'<[^>]+>');
    final visibleText = html.replaceAll(regex, '').trim();
    return visibleText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Render Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Html(
                data: widget.modifiedHtml,
              ),
            ),
          ),
          if (pdfPath != null)
            ElevatedButton(
              onPressed: sharePdf,
              child: Text('Share PDF'),
            ),
        ],
      ),
      floatingActionButton: pdfPath != null
          ? null
          : FloatingActionButton(
        onPressed: generatePdf,
        child: Icon(Icons.picture_as_pdf),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
