import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/seriesController.dart';

class AddSeriesPage extends StatefulWidget {
  final SeriesController controller;

  const AddSeriesPage({Key? key, required this.controller}) : super(key: key);

  @override
  _AddSeriesPageState createState() => _AddSeriesPageState();
}

class _AddSeriesPageState extends State<AddSeriesPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _genre;
  String? _description;
  int _score = 1;
  File? _cover;

  final List<String> _genres = [
    'Animação',
    'Aventura',
    'Ação',
    'Comédia',
    'Documentário',
    'Drama',
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _cover = File(pickedFile.path);
      });
    }
  }

  void _saveSeries() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.controller.addSeries(
        name: _name!,
        genre: _genre!,
        description: _description!,
        score: _score,
        cover: _cover?.path ?? '',
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Série'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nome da Série'),
                  validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                  onSaved: (value) => _name = value,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Gênero'),
                  value: _genre,
                  items: _genres
                      .map((genre) => DropdownMenuItem(
                    value: genre,
                    child: Text(genre),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    _genre = value;
                  }),
                  validator: (value) => value == null ? 'Selecione um gênero' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  maxLines: 3,
                  validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                  onSaved: (value) => _description = value,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Pontuação:'),
                    Slider(
                      value: _score.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      onChanged: (value) {
                        setState(() {
                          _score = value.toInt();
                        });
                      },
                    ),
                    Text('$_score/5'),
                  ],
                ),
                const SizedBox(height: 16),
                _cover == null
                    ? ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Selecionar Imagem'),
                )
                    : Image.file(_cover!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveSeries,
                  child: const Text('Salvar Série'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
