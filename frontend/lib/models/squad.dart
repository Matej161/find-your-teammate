class Squad {
  final String id;
  final String title;
  final String rank;
  final int currentPlayers;
  final int maxPlayers;
  final String description;

  Squad({
    required this.id,
    required this.title,
    required this.rank,
    required this.currentPlayers,
    required this.maxPlayers,
    required this.description,
  });

  factory Squad.fromJson(Map<String, dynamic> json) {
    return Squad(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      rank: json['rank']?.toString() ?? '',
      currentPlayers: json['currentPlayers'] is int ? json['currentPlayers'] : int.tryParse(json['currentPlayers']?.toString() ?? '0') ?? 0,
      maxPlayers: json['maxPlayers'] is int ? json['maxPlayers'] : int.tryParse(json['maxPlayers']?.toString() ?? '5') ?? 5,
      description: json['description']?.toString() ?? '',
    );
  }
}