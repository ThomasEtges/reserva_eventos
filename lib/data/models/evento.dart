class Evento {
  final int? id;
  final String nome;
  final String descricao;
  final int fkIdGrupoEsportes;
  final int fkIdEstabelecimento;
  final int fkIdCriador;
  final int fkIdEsporte;
  final String visibilidade;
  final int? idadeMin;
  final int? idadeMax;
  final String? genero;
  final String dataHoraInicio;
  final String dataHoraFim;
  final String status;

  Evento({
    this.id,
    required this.nome,
    required this.descricao,
    required this.fkIdGrupoEsportes,
    required this.fkIdEstabelecimento,
    required this.fkIdCriador,
    required this.fkIdEsporte,
    required this.visibilidade,
    this.idadeMin,
    this.idadeMax,
    this.genero,
    required this.dataHoraInicio,
    required this.dataHoraFim,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'fk_id_grupo_esportes': fkIdGrupoEsportes,
      'fk_id_estabelecimento': fkIdEstabelecimento,
      'fk_id_criador': fkIdCriador,
      'fk_id_esporte': fkIdEsporte,
      'visibilidade': visibilidade,
      'idade_min': idadeMin,
      'idade_max': idadeMax,
      'genero': genero,
      'data_hora_inicio': dataHoraInicio,
      'data_hora_fim': dataHoraFim,
      'status': status,
    };
  }

  factory Evento.fromMap(Map<String, dynamic> map) {
    return Evento(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      descricao: map['descricao'] as String,
      fkIdGrupoEsportes: map['fk_id_grupo_esportes'] as int,
      fkIdEstabelecimento: map['fk_id_estabelecimento'] as int,
      fkIdCriador: map['fk_id_criador'] as int,
      fkIdEsporte: map['fk_id_esporte'] as int,
      visibilidade: map['visibilidade'] as String,
      idadeMin: map['idade_min'] as int?,
      idadeMax: map['idade_max'] as int?,
      genero: map['genero'] as String?,
      dataHoraInicio: map['data_hora_inicio'] as String,
      dataHoraFim: map['data_hora_fim'] as String,
      status: map['status'] as String,
    );
  }
}
