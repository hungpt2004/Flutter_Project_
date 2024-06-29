import 'package:flutter/material.dart';
import 'package:mynote_application/database/sql_helper.dart';
import '../model/university.dart';

class UniversityScreen extends StatefulWidget {
  final int provinceId;

  const UniversityScreen({Key? key, required this.provinceId}) : super(key: key);

  @override
  _UniversityScreenState createState() => _UniversityScreenState();
}

class _UniversityScreenState extends State<UniversityScreen> {
  final TextEditingController _nameUniversity = TextEditingController();
  List<University> _universities = [];
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _fetchUniversities();
  }

  Future<void> _fetchUniversities() async {
    try {
      List<University> universities = await SQLHelper.getUniversitiesByProvince(widget.provinceId);
      setState(() {
        _universities = universities;
      });
    } catch (e) {
      debugPrint("Error fetching universities: $e");
    }
  }

  void _upadateUniversity(int index) {
    setState(() {
      _editingIndex = index;
      _nameUniversity.text = _universities[index].universityName ?? '';
    });
  }

  Future<void> _deleteUniversity(int index) async {
    try {
      final universityId = _universities[index].universityId;
      if (universityId != null) {
        await SQLHelper.deleteUniversity(universityId);
        setState(() {
          _universities.removeAt(index);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully delete an item")));
        });
      }
    } catch (e) {
      debugPrint("Error deleting university: $e");
    }
  }

  Future<void> _saveUniversity() async {
    try {
      if (_editingIndex == null) {
        if (_universities.any((university) => university.universityName == _nameUniversity.text)) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("University name already exists")));
          return;
        } else if (_nameUniversity.text.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("University name can't empty")));
          return;
        } else {
          University newUniversity = University(universityName: _nameUniversity.text, provinceId: widget.provinceId);
          await SQLHelper.createUniversity(newUniversity);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully add an item")));
        }
      } else {
        University updatedUniversity = _universities[_editingIndex!];
        updatedUniversity.universityName = _nameUniversity.text;
        await SQLHelper.updateUniversity(updatedUniversity);  // Sử dụng hàm update của bạn
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully update an item")));
        setState(() {
          _universities[_editingIndex!] = updatedUniversity;
          _editingIndex = null;
        });
      }
      _fetchUniversities();
      _nameUniversity.clear();
    } catch (e) {
      debugPrint("Error saving/updating university: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingIndex == null ? 'Add University' : 'Edit University'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameUniversity,
              decoration: const InputDecoration(labelText: 'University Name'),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: _saveUniversity,
              child: Text(_editingIndex == null ? 'Save' : 'Update'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _universities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_universities[index].universityName ?? ''),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _upadateUniversity(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteUniversity(index),
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
