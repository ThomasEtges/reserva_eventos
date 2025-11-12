class GrupoEsporte {
  final int? id;
  final String nome;
  final int fkIdEsporte;
  final int fkIdCidade;
  final int fkIdCriador;
  final String descricao;
  final String visibilidade;

  GrupoEsporte({
    this.id,
    required this.nome,
    required this.fkIdEsporte,
    required this.fkIdCidade,
    required this.fkIdCriador,
    required this.descricao,
    required this.visibilidade,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'fk_id_esporte': fkIdEsporte,
    'fk_id_cidade': fkIdCidade,
    'fk_id_criador': fkIdCriador,
    'descricao': descricao,
    'visibilidade': visibilidade,
  };

  factory GrupoEsporte.fromMap(Map<String, dynamic> map) => GrupoEsporte(
    id: map['id'] as int?,
    nome: map['nome'] as String,
    fkIdEsporte: map['fk_id_esporte'] as int,
    fkIdCidade: map['fk_id_cidade'] as int,
    fkIdCriador: map['fk_id_criador'] as int,
    descricao: map['descricao'] as String,
    visibilidade: map['visibilidade'] as String,
  );
}
