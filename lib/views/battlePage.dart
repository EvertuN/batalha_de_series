import 'package:flutter/material.dart';
import '../controller/seriesController.dart';
import '../models/seriesModel.dart';

class BattlePage extends StatefulWidget {
  final SeriesController controller;

  const BattlePage({Key? key, required this.controller}) : super(key: key);

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  late List<Series> seriesList = [];
  Series? selectedSeries1;
  Series? selectedSeries2;

  @override
  void initState() {
    super.initState();
    seriesList = widget.controller.getSeries();
  }

  void _registerVictory(Series winner) {
    setState(() {
      winner.victories++;
      widget.controller.registerVictory(winner);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Batalha de Séries"),
        backgroundColor: Colors.black,
      ),
      body: seriesList.isEmpty
          ? Center(child: Text("Nenhuma série cadastrada."))
          : Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSeriesCard(seriesList[0]),
              _buildSeriesCard(seriesList[1]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeriesCard(Series series) {
    return GestureDetector(
      onTap: () {
        _registerVictory(series);
      },
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                series.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(series.genre),
              SizedBox(height: 10),
              Text(series.description),
              SizedBox(height: 10),
              Text("Pontuação: ${series.score}"),
            ],
          ),
        ),
      ),
    );
  }
}
