import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart';
import 'package:printing/printing.dart';
import 'package:rive/rive.dart';
import '../db/databaseHelper.dart';
import '../models/seriesModel.dart';

class SeriesController with ChangeNotifier {
  List<Series> seriesList = [];

  void addSeries({
    required String name,
    required String genre,
    required String description,
    required int score,
    required String cover,
  }) {
    seriesList.add(
      Series(
        name: name,
        genre: genre,
        description: description,
        score: score,
        cover: cover,
      ),
    );
    notifyListeners();
  }

  List<Series> getSeries() {
    return seriesList;
  }

  void deleteSeries(int index) {
    seriesList.removeAt(index);
    notifyListeners();
  }

  void registerVictory(Series winner) {
    winner.victories++;
  }

  Future<void> generateAndPrintPdf(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          color: const Color(0xFF222831),
          width: double.infinity,
          height: double.infinity,
          child: const RiveAnimation.asset(
            'assets/win.riv',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 3));

    final series = await DatabaseHelper.instance.getItems();

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Relatório de Séries',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ['Nome', 'Gênero', 'Vitórias'],
                  data: series.map((item) {
                    return [
                      item['name'] ?? 'N/A',
                      item['genre'] ?? 'N/A',
                      item['victories']?.toString() ?? '0',
                    ];
                  }).toList(),
                  border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                  cellAlignment: pw.Alignment.center,
                  cellPadding: const pw.EdgeInsets.all(8),
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                  headerDecoration: const pw.BoxDecoration(
                    color: PdfColors.blueGrey,
                  ),
                  cellStyle: const pw.TextStyle(
                    color: PdfColors.black,
                  ),
                  oddRowDecoration: const pw.BoxDecoration(
                    color: PdfColors.grey200,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );

    Navigator.of(context).pop();
  }
}
