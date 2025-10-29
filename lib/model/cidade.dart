class Cidade {
  final int? id;
  final String nomeCidade;

  Cidade({this.id, required this.nomeCidade});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nomeCidade': nomeCidade};
  }

  factory Cidade.fromMap(Map<String, dynamic> map) {
    return Cidade(id: map['id'], nomeCidade: map['nomeCidade']);
  }
}
