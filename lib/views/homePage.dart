import 'package:flutter/material.dart';
import 'addSeriesPage.dart';
import 'battlePage.dart';
import 'seriesListPage.dart';
import '../controller/seriesController.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final seriesController = SeriesController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddSeriesPage(controller: seriesController),
                  ),
                );
              },
              child: Text("Adicionar Série"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BattlePage(controller: seriesController),
                  ),
                );
              },
              child: Text("Batalha de Séries"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeriesListPage(controller: seriesController),
                  ),
                );
              },
              child: Text("Ver Séries"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: seriesController.getSeries().length,
                itemBuilder: (context, index) {
                  final series = seriesController.getSeries()[index];
                  return ListTile(
                    title: Text(series.name),
                    subtitle: Text(series.genre),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        seriesController.deleteSeries(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
