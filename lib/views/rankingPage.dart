import 'package:flutter/material.dart';
import '../controller/seriesController.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final SeriesController controller = SeriesController();
  late Future<List<Map<String, dynamic>>> rankedSeries;

  @override
  void initState() {
    super.initState();
    rankedSeries = controller.getSeries() as Future<List<Map<String, dynamic>>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ranking de Séries"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final controller = SeriesController();
              await controller.generateAndPrintPdf(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: rankedSeries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar o ranking"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Nenhuma série cadastrada."));
          } else {
            final series = snapshot.data!;
            series.sort((a, b) => b['victories'].compareTo(a['victories']));
            return ListView.builder(
              itemCount: series.length,
              itemBuilder: (context, index) {
                final item = series[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text("${index + 1}"),
                  ),
                  title: Text(item['name']),
                  subtitle: Text("Vitórias: ${item['victories']}"),
                );
              },
            );
          }
        },
      ),
    );
  }
}
