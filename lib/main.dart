// Importações essenciais
import 'package:flutter/material.dart';
import 'controles/controle_planeta.dart';
import 'modelos/planeta.dart';
import 'telas/tela_planeta.dart';

void main() {
  runApp(const UniversoApp());
}

// App principal com tema galáctico
class UniversoApp extends StatelessWidget {
  const UniversoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cosmos Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 234, 106, 193)),
        useMaterial3: true,
      ),
      home: const PlanetasHomePage(title: 'Missão Espacial: Planetas'),
    );
  }
}

// Tela principal onde a jornada começa
class PlanetasHomePage extends StatefulWidget {
  const PlanetasHomePage({super.key, required this.title});

  final String title;

  @override
  State<PlanetasHomePage> createState() => _PlanetasHomePageState();
}

class _PlanetasHomePageState extends State<PlanetasHomePage> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta();
  List<Planeta> _planetas = [];

  @override
  void initState() {
    super.initState();
    _carregarPlanetas();
  }

  Future<void> _carregarPlanetas() async {
    final lista = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = lista;
    });
  }

  void _adicionarPlaneta() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: true,
          planeta: Planeta.vazio(),
          onFinalizado: _carregarPlanetas,
        ),
      ),
    );
  }

  void _removerPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id);
    _carregarPlanetas();
  }

  void _editarPlaneta(Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: false,
          planeta: planeta,
          onFinalizado: _carregarPlanetas,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _planetas.isEmpty
          ? const Center(
              child: Text(
                'Nenhum planeta encontrado! Adicione um para explorar.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _planetas.length,
              itemBuilder: (context, index) {
                final planeta = _planetas[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: const Icon(Icons.public, color: Color.fromARGB(255, 248, 5, 131)),
                    title: Text(
                      planeta.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text('Distância: ${planeta.distancia} AU'),
                    trailing: Wrap(
                      spacing: 5,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Color.fromARGB(255, 217, 37, 142)),
                          onPressed: () => _editarPlaneta(planeta),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Color.fromARGB(255, 228, 35, 148)),
                          onPressed: () => _removerPlaneta(planeta.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarPlaneta,
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 255, 0, 128),
      ),
    );
  }
}
