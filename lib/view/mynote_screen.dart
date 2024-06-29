import 'package:flutter/material.dart';
import 'package:mynote_application/database/sql_helper.dart';
import 'package:mynote_application/view/interface_user.dart';
import '../model/province.dart';

void main() {
  runApp(const MaterialApp(
    home: MyNote_Screen(),
  ));
}

class MyNote_Screen extends StatelessWidget {
  const MyNote_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  List<Map<String, dynamic>> _provinces = [];
  List<Map<String, dynamic>> _filteredProvinces = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  Future<void> _refreshItems() async {
    try {
      final data = await SQLHelper.getProvinces();
      setState(() {
        _provinces = data;
        _filteredProvinces = _provinces;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error retrieving provinces: $e'),
        ),
      );
    }
  }

  void _navigateToDetailInfoScreen(int provinceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InterfaceUser(provinceId: provinceId),
      ),
    ).then((_) {
      _refreshItems();
    });
  }

  final TextEditingController _nameProvince = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existProvince = _provinces.firstWhere((element) => element['provinceId'] == id);
      _nameProvince.text = existProvince['provinceName'];
    } else {
      _nameProvince.text = '';
    }

    showModalBottomSheet(
      context: context,
      elevation: 10,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: _nameProvince,
                decoration: const InputDecoration(
                  hintText: 'Enter province name',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _addProvince();
                  } else {
                    await _updateProvince(id);
                  }
                  Navigator.pop(context);
                },
                child: Text(id == null ? 'Create Province' : 'Update Province'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addProvince() async {
    try {
      if (_nameProvince.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Province name cannot be empty")));
        return;
      }
      if (_provinces.any((province) => province['provinceName'] == _nameProvince.text)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Province name already exists")));
        return;
      }
      await SQLHelper.createProvince(Province(
        provinceName: _nameProvince.text,
      ));
      await _refreshItems();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding province: $e'),
        ),
      );
    }
  }

  Future<void> _updateProvince(int id) async {
    final existProvince = await SQLHelper.getProvince(id);

    if (existProvince != null) {
      await SQLHelper.updateProvince(Province(
        provinceId: id,
        provinceName: _nameProvince.text,
      ));
      await _refreshItems();
    }
  }

  Future<void> _deleteProvince(int id) async {
    await SQLHelper.deleteProvince(id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully deleted province'),
      ),
    );

    _refreshItems();
  }

  void _filterProvinces(String searchText) {
    setState(() {
      _filteredProvinces = _provinces.where((province) {
        final provinceName = province['provinceName'].toString().toLowerCase();
        return provinceName.contains(searchText.toLowerCase());
      }).toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Provinces'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterProvinces,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search province...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProvinces.length,
              itemBuilder: (context, index) => Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(
                    '${_filteredProvinces[index]['provinceId']}  ${_filteredProvinces[index]['provinceName']}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () =>
                              _showForm(_filteredProvinces[index]['provinceId']),
                          icon: const Icon(Icons.edit),
                          color: Colors.blue,
                        ),
                        IconButton(
                          onPressed: () =>
                              _deleteProvince(_filteredProvinces[index]['provinceId']),
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    _navigateToDetailInfoScreen(_filteredProvinces[index]['provinceId']);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
