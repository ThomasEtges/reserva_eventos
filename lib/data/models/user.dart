class User {
  final int? id;
  final String nome;
  final String email;
  final String senhaHash;
  final String genero;
  final int idade;
  final int fkIdCidade;

  User({
    this.id,
    required this.nome,
    required this.email,
    required this.senhaHash,
    required this.genero,
    required this.idade,
    required this.fkIdCidade,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'email': email,
    'senha_hash': senhaHash,
    'genero': genero,
    'idade': idade,
    'fk_id_cidade': fkIdCidade,
  };

  factory User.fromMap(Map<String, dynamic> map) => User(
    id: map['id'] as int?,
    nome: map['nome'] as String,
    email: map['email'] as String,
    senhaHash: map['senha_hash'] as String,
    genero: map['genero'] as String,
    idade: map['idade'] as int,
    fkIdCidade: map['fk_id_cidade'] as int,
  );
}
