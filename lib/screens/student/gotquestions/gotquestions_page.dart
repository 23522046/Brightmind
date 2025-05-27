import 'package:flutter/material.dart';
import 'relawan_tab.dart';
import 'pertanyaan_tab.dart';

class GotQuestionsPage extends StatefulWidget {
  const GotQuestionsPage({super.key});

  @override
  State<GotQuestionsPage> createState() => _GotQuestionsPageState();
}

class _GotQuestionsPageState extends State<GotQuestionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          // trigger rebuild supaya floatingActionButton update
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sesi Tanya Jawab & Relawan'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Relawan'), Tab(text: 'Pertanyaan')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [RelawanTab(), PertanyaanTab()],
      ),
      floatingActionButton:
          _tabController.index == 1
              ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  // TODO: halaman tambah pertanyaan
                },
              )
              : null,
    );
  }
}
