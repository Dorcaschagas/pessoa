import 'package:pessoa_app/versaodb.dart';
import 'package:sqflite/sqflite.dart'; // Importa o pacote 'sqflite' para utilizar funcionalidades de banco de dados SQLite.
import 'package:path/path.dart'; // Importa o pacote 'path' para manipulação de caminhos de arquivos.
import 'dart:async'; // Importa o pacote 'async' para trabalhar com funcionalidades assíncronas.

class DatabaseHelper {
  // Cria uma instância estática da classe DatabaseHelper, usando o padrão singleton.
  // Isso garante que apenas uma instância da classe exista em todo o ciclo de vida da aplicação.
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Construtor factory que retorna a instância existente ou cria uma nova se não existir.
  factory DatabaseHelper() => _instance;

  // Construtor privado usado para o padrão singleton.
  DatabaseHelper._internal();

  // Variável estática que armazenará a instância do banco de dados.
  static Database? _database;

  // Getter que retorna o banco de dados, inicializando-o se ele ainda não foi criado.
  Future<Database> get database async {
    // Se o banco de dados já estiver inicializado, retorna a instância existente.
    if (_database != null) return _database!;

    // Se não, inicializa o banco de dados e o armazena na variável '_database'.
    _database = await _initDatabase();
    return _database!;
  }

  // Método privado que inicializa o banco de dados.
  Future<Database> _initDatabase() async {
    // Obtém o caminho do diretório onde os bancos de dados são armazenados.
    final dbPath = await getDatabasesPath();

    // Concatena o caminho do diretório com o nome do banco de dados.
    final path = join(dbPath, 'pessoa.db');

    // Abre ou cria o banco de dados no caminho especificado e executa o comando de criação de tabela (se necessário).
    return await openDatabase(
      path,
      onCreate: (db, version) {
        // Cria a tabela 'pessoa' com três colunas: 'id', 'nome' e 'idade'.
        return db.execute(
          '''
            CREATE TABLE pessoa(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            nome TEXT, 
            idade INTEGER,
            descricao TEXT,
            medidasuperior REAL,
            medidainferior REAL,
          )
          ''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < newVersion) {
          // Adiciona a nova coluna 'descricao' se a versão antiga for menor que a nova
          db.execute('ALTER TABLE pessoa ADD COLUMN medidasuperior REAL');
          db.execute('ALTER TABLE pessoa ADD COLUMN medidainferior REAL');
        }
      },
      version: 3,
    );
  }

  // Método para inserir uma nova pessoa no banco de dados.
  // Recebe um mapa de dados ('row') contendo os valores para a nova pessoa.
  Future<void> insertPessoa(Map<String, dynamic> row) async {
    // Obtém a instância do banco de dados.
    final db = await database;

    // Insere os dados na tabela 'pessoa'.
    // O 'ConflictAlgorithm.replace' substitui os dados existentes se houver conflito de chave primária.
    await db.insert('pessoa', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Método que retorna todas as pessoas armazenadas no banco de dados.
  Future<List<Map<String, dynamic>>> queryAllPessoas() async {
    // Obtém a instância do banco de dados.
    final db = await database;

    // Realiza a consulta na tabela 'pessoa' e retorna os resultados como uma lista de mapas.
    return await db.query('pessoa');
  }

  // Método para atualizar uma pessoa existente no banco de dados.
  // Recebe o 'id' da pessoa e um mapa ('row') contendo os novos dados.
  Future<void> updatePessoa(int id, Map<String, dynamic> row) async {
    // Obtém a instância do banco de dados.
    final db = await database;

    // Atualiza a linha na tabela 'pessoa' onde o 'id' corresponde ao valor passado.
    await db.update(
      'pessoa',
      row, // Dados atualizados.
      where:
          'id = ?', // Condição para garantir que a pessoa correta seja atualizada.
      whereArgs: [id], // Substitui o '?' pela variável 'id'.
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Substitui os dados em caso de conflito.
    );
  }

  // Método para deletar uma pessoa do banco de dados com base no 'id'.
  Future<void> deletePessoa(int id) async {
    // Obtém a instância do banco de dados.
    final db = await database;

    // Deleta a linha da tabela 'pessoa' onde o 'id' corresponde ao valor passado.
    await db.delete(
      'pessoa',
      where:
          'id = ?', // Condição para garantir que a pessoa correta seja deletada.
      whereArgs: [id], // Substitui o '?' pela variável 'id'.
    );
  }
}
