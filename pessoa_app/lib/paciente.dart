import 'package:flutter/material.dart';
import 'package:pessoa_app/db.dart';
import 'package:pessoa_app/traducao.dart';

class PessoaScreen extends StatefulWidget {
  @override
  _PessoaScreenState createState() => _PessoaScreenState();
}

class _PessoaScreenState extends State<PessoaScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _medidasuperiorController =
      TextEditingController();
  final TextEditingController _medidainferiorController =
      TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  String _selectedLanguage = 'Portugês';

  void _changeLanguage(String newLanguage) {
    setState(() {
      AppLanguage language;
      switch(newLanguage){
        case 'Português':
          language = AppLanguage.pt;
          break;
        case 'Inglês':
          language = AppLanguage.en;
          break;
        case 'Espanhol':
          language = AppLanguage.es;
          break;
        default:
        language = AppLanguage.es;
      };
      print('$language');
      Translation.setLanguage(language);
    });
  }

  Future<void> _insertPessoa() async {
    final nome = _nomeController.text;
    final idade = int.tryParse(_idadeController.text);
    final descricao = _descricaoController.text;
    final medidainferior = double.tryParse(_medidasuperiorController.text);
    final medidasuperior = double.tryParse(_medidainferiorController.text);

    if (nome.isNotEmpty && idade != null) {
      await _databaseHelper.insertPessoa({
        'nome': nome,
        'idade': idade,
        'descricao': descricao,
        'medidasuperior': medidasuperior,
        'medidainferior': medidainferior,
      });
      _nomeController.clear();
      _idadeController.clear();
      _descricaoController.clear();
      _medidasuperiorController.clear();
      _medidainferiorController.clear();
      setState(() {});
    }
  }

  //buscar todos dos dados
  Future<List<Map<String, dynamic>>> _buscarPessoas() async {
    return await _databaseHelper.queryAllPessoas();
  }

  // apagar paciente
  void _deletepessoa(int id) async {
    await _databaseHelper.deletePessoa(id);
    setState(() {});
  }

  //editar paciente
  void _editarpessoa(id, String nome, int idade, String descricao,
      double medidasuperior, double medidainferior) async {
    await _databaseHelper.updatePessoa(id, {
      'nome': nome,
      'idade': idade,
      'descricao': descricao,
      'medidasuperior': medidasuperior,
      'medidainferior': medidainferior,
    });
    setState(() {});
  }

  //abrir dialogo de edicao de pessoa
  void _showEditDialog(Map<String, dynamic> pessoa) {
    final TextEditingController nomeController =
        TextEditingController(text: pessoa['nome']);
    final TextEditingController idadeController =
        TextEditingController(text: pessoa['idade'].toString());
    final TextEditingController descricaoController =
        TextEditingController(text: pessoa['descricao']);
    final TextEditingController medidasuperiorController =
        TextEditingController(text: pessoa['medidasuperior'].toString());
    final TextEditingController medidainferiorController =
        TextEditingController(text: pessoa['medidainferior'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Translation.translate('Editar Pessoa:')),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: nomeController,
                decoration:
                    InputDecoration(label: Text(Translation.translate('Nome'))),
              ),
              TextField(
                controller: idadeController,
                decoration:
                    InputDecoration(label: Text(Translation.translate('Idade'))),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(
                    label: Text(Translation.translate('Descrição'))),
              ),
              TextField(
                controller: medidasuperiorController,
                decoration: InputDecoration(
                    label: Text(Translation.translate('Medida Superior'))),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: medidainferiorController,
                decoration: InputDecoration(
                    label: Text(Translation.translate('Medida Inferior'))),
                keyboardType: TextInputType.number,
              )
            ]),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final nome = nomeController.text;
                final idade = int.tryParse(idadeController.text) ?? 0;
                final descricao = descricaoController.text;
                final medidasuperior =
                    double.tryParse(medidasuperiorController.text) ?? 0;
                final medidainferior =
                    double.tryParse(medidainferiorController.text) ?? 0;
                if (nome.isNotEmpty && idade > 0) {
                  _editarpessoa(pessoa['id'], nome, idade, descricao,
                      medidasuperior, medidainferior);
                  Navigator.of(context).pop(); // feha o dialog
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Você tem certeza que deseja excluir esta pessoa?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deletepessoa(id);
                },
                child: Text('Excluir'))
          ],
        );
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pessoa App'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Selecione o Idioma',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Português'),
              onTap: () => _changeLanguage('Português'),
            ),
            ListTile(
              title: Text('Inglês'),
              onTap: () => _changeLanguage('Inglês'),
            ),
            ListTile(
              title: Text('Espanhol'),
              onTap: () => _changeLanguage('Espanhol'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            //recebe o nome da pessoas
            TextField(
              controller: _nomeController,
              decoration:
                  InputDecoration(labelText: Translation.translate('Nome')),
            ),
            //recebe a idade da pessoas
            TextField(
              controller: _idadeController,
              decoration:
                  InputDecoration(labelText: Translation.translate('Idade')),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(
                  labelText: Translation.translate('Descrição')),
            ),
            TextField(
              controller: _medidasuperiorController,
              decoration: InputDecoration(labelText: Translation.translate('Medida Superior')),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _medidainferiorController,
              decoration: InputDecoration(labelText: Translation.translate('Medida Inferior')),
              keyboardType: TextInputType.number,
            ),
            // SizedBox(height: 20),
            //botao de criacao pessoa (inserir dado no banco)
            ElevatedButton(
              onPressed: _insertPessoa,
              child: Text(Translation.translate('Inserir Pessoa')),
            ),

            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _buscarPessoas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text(Translation.translate('Nenhuma pessoa encontrada.')));
                  } else {
                    final pessoas = snapshot.data!;
                    return ListView.builder(
                      itemCount: pessoas.length,
                      itemBuilder: (context, index) {
                        final pessoa = pessoas[index];
                        return ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Container(
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0), // adicionando borda
                              borderRadius: BorderRadius.circular(
                                  5), // arredondando as bordas
                            ),
                            //linha com nome, idade e botoes.
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //coluna para nome e idade.
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(pessoa['nome']),
                                    Text('${Translation.translate('Idade')}: ${pessoa['idade']}'),
                                    Text('${Translation.translate('Descrição')}:  ${pessoa['descricao']}'),
                                    Text('${Translation.translate('Medida Superior')}: ${pessoa['medidasuperior']}'),
                                    Text('${Translation.translate('Medida Inferior')}: ${pessoa['medidainferior']}'),
                                  ],
                                ),
                                Spacer(),
                                //linha para botoes de edicao e exclusão
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        _showEditDialog(pessoa);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _confirmDelete(pessoa['id']);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
