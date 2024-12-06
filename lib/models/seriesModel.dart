class Series {
  final String name;
  final String genre;
  final String description;
  final int score;
  final String cover;
  int victories;

  Series({
    required this.name,
    required this.genre,
    required this.description,
    required this.score,
    required this.cover,
    this.victories = 0,
  });
}
