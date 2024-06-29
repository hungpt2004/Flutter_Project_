import 'package:flutter/material.dart';
import 'package:mynote_application/database/sql_helper.dart';
import '../model/scenic.dart';

class ScenicScreen extends StatefulWidget {
  final int provinceId;

  const ScenicScreen({Key? key, required this.provinceId}) : super(key: key);

  @override
  _ScenicScreenState createState() => _ScenicScreenState();
}

class _ScenicScreenState extends State<ScenicScreen> {
  final TextEditingController _nameScenic = TextEditingController();
  List<Scenic> _scenics = [];
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _fetchScenics();
  }

  Future<void> _fetchScenics() async {
    try {
      List<Scenic> scenics = await SQLHelper.getScenicsByProvince(widget.provinceId);
      setState(() {
        _scenics = scenics;
      });
    } catch (e) {
      debugPrint("Error fetching scenics: $e");
    }
  }

  void _updateScenic(int index) {
    setState(() {
      _editingIndex = index;
      _nameScenic.text = _scenics[index].scenicName ?? '';
    });
  }

  Future<void> _deleteScenic(int index) async {
    try {
      final scenicId = _scenics[index].scenicId;
      if (scenicId != null) {
        await SQLHelper.deleteScenic(scenicId);
        setState(() {
          _scenics.removeAt(index);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully delete an item")));
        });
      }
    } catch (e) {
      debugPrint("Error deleting scenic: $e");
    }
  }

  Future<void> _saveScenic() async {
    try {
      if (_editingIndex == null) {
        if (_scenics.any((scenic) => scenic.scenicName == _nameScenic.text)) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Scenic name already exists")));
          return;
        } else if (_nameScenic.text.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Scenic name can't empty")));
        } else {
          Scenic newScenic = Scenic(scenicName: _nameScenic.text, provinceId: widget.provinceId);
          await SQLHelper.createScenic(newScenic);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully add an item")));
        }
      } else {
        Scenic updatedScenic = _scenics[_editingIndex!];
        updatedScenic.scenicName = _nameScenic.text;
        await SQLHelper.updateScenic(updatedScenic);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully update an item")));
        setState(() {
          _scenics[_editingIndex!] = updatedScenic;
          _editingIndex = null;
        });
      }
      _fetchScenics();
      _nameScenic.clear();
    } catch (e) {
      debugPrint("Error saving/updating scenic: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingIndex == null ? 'Add Scenic' : 'Edit Scenic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameScenic,
              decoration: const InputDecoration(labelText: 'Scenic Name'),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: _saveScenic,
              child: Text(_editingIndex == null ? 'Save' : 'Update'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _scenics.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_scenics[index].scenicName ?? ''),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _updateScenic(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteScenic(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
