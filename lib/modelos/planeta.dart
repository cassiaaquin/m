class Planeta {
  int? id;
  String nome;
  double tamanho;
  double distancia;
  String? apelido;

  // Construtor da classe Planeta
  Planeta({
    this.id,
    required this.nome,
    required this.tamanho,
    required this.distancia,
    this.apelido,
  });

  // Construtor alternativo
  Planeta.vazio()
      : id = null,
        nome = '',
        tamanho = 0.0,
        distancia = 0.0,
        apelido = '';

  // Construtor para criar um objeto Planeta a partir de um Map
  factory Planeta.fromMap(Map<String, dynamic> map) {
    return Planeta(
      id: map['id'],
      nome: map['nome'],
      tamanho: map['tamanho'],
      distancia: map['distancia'],
      apelido: map['apelido'],
    );
  }

  // Converte um objeto Planeta para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tamanho': tamanho,
      'distancia': distancia,
      'apelido': apelido,
    };
  }
}