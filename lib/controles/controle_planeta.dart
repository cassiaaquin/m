import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modelos/planeta.dart';

class ControlePlaneta {
  static Database? _bd;

  // Getter para acessar o banco de dados
  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await _initBD('planetas.db');
    return _bd!;
  }

  // Inicializa o banco de dados
  Future<Database> _initBD(String nomeArquivo) async {
    final caminhoBD = await getDatabasesPath();
    final localCompleto = join(caminhoBD, nomeArquivo);

    return await openDatabase(
      localCompleto,
      version: 1,
      onCreate: _criarBD,
    );
  }

  // Cria a tabela de planetas
  Future<void> _criarBD(Database bd, int versao) async {
    const sql = '''
    CREATE TABLE planetas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      tamanho REAL NOT NULL,
      distancia REAL NOT NULL,
      apelido TEXT
    );
    ''';
    await bd.execute(sql);
  }

  // Ler todos os planetas
  Future<List<Planeta>> lerPlanetas() async {
    final db = await bd;
    final resultado = await db.query('planetas');
    return resultado.map((item) => Planeta.fromMap(item)).toList();
  }

  // Inserir um novo planeta e retornar o ID gerado
  Future<int> inserirPlaneta(Planeta planeta) async {
    final database = await bd;
    return await database.insert('planetas', planeta.toMap());
  }

  // Alterar um planeta existente
  Future<int> alterarPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id],
    );
  }

  // Excluir um planeta
  Future<int> excluirPlaneta(int id) async {
    final db = await bd;
    return await db.delete(
      'planetas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fechar o banco de dados
  Future<void> fecharBD() async {
    final db = _bd;
    if (db != null) {
      await db.close();
      _bd = null;
    }
  }
}
