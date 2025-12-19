import 'package:flutter/material.dart';
import 'agenda.dart';
import 'agenda_form.dart';
import 'agenda_service.dart';

class AgendaList extends StatefulWidget {
  const AgendaList({super.key});

  @override
  State<AgendaList> createState() => _AgendaListState();
}

class _AgendaListState extends State<AgendaList> {
  final _service = AgendaService();
  late Future<List<Agenda>> _agendaList;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _agendaList = _service.getAll();
    });
  }

  void _delete(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Agenda'),
        content: const Text('Apakah Anda yakin ingin menghapus agenda ini?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _service.delete(id);
              _refresh();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Agenda berhasil dihapus'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Daftar Agenda'),
        elevation: 0,
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Agenda>>(
        future: _agendaList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            if (data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inbox, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada agenda',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text('Tap tombol + untuk menambah agenda baru'),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: data.length,
              itemBuilder: (_, i) {
                final item = data[i];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                    title: Text(
                      item.judul,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        item.keterangan,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AgendaForm(agenda: item),
                                ),
                              );
                              if (result == true) _refresh();
                            },
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _delete(item.id!),
                            tooltip: 'Hapus',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 80, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Gagal memuat: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3B82F6),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AgendaForm()),
          );
          if (result == true) _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
