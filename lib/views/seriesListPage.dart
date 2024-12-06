import 'package:flutter/material.dart';
import '../controller/seriesController.dart';

class SeriesListPage extends StatelessWidget {
  final SeriesController controller;

  const SeriesListPage({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Séries"),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: controller.getSeries().length,
        itemBuilder: (context, index) {
          final series = controller.getSeries()[index];
          return ListTile(
            title: Text(series.name),
            subtitle: Text(series.genre),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                controller.deleteSeries(index);
              },
            ),
          );
        },
      ),
    );
  }
}
