import 'package:flutter/material.dart';
import 'package:mynote_application/database/sql_helper.dart';
import '../model/speciality.dart';

class SpecialityScreen extends StatefulWidget {
  final int provinceId;

  const SpecialityScreen({Key? key, required this.provinceId})
      : super(key: key);

  @override
  _SpecialityScreenState createState() => _SpecialityScreenState();
}

class _SpecialityScreenState extends State<SpecialityScreen> {
  final TextEditingController _nameSpeciality = TextEditingController();
  List<Speciality> _specialities = [];
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _fetchSpecialities();
  }

  Future<void> _fetchSpecialities() async {
    try {
      List<Speciality> specialities =
          await SQLHelper.getSpecialitiesByProvince(widget.provinceId);
      setState(() {
        _specialities = specialities;
      });
    } catch (e) {
      debugPrint("Error fetching specialities: $e");
    }
  }

  void _updateSpeciality(int index) {
    setState(() {
      _editingIndex = index;
      _nameSpeciality.text = _specialities[index].specialityName ?? '';
    });
  }

  Future<void> _deleteSpeciality(int index) async {
    try {
      final specialityId = _specialities[index].specialityId;
      if (specialityId != null) {
        await SQLHelper.deleteSpecial(specialityId);
        setState(() {
          _specialities.removeAt(index);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Successfully delete an item")));
        });
      }
    } catch (e) {
      debugPrint("Error deleting speciality: $e");
    }
  }

  Future<void> _saveSpeciality() async {
    try {
      if (_editingIndex == null) {
        if (_specialities.any((speciality) =>
            speciality.specialityName == _nameSpeciality.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Speciality name already exists")));
          return;
        } else if (_nameSpeciality.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Speciality name cant empty")));
        } else {
          Speciality newSpeciality = Speciality(
              specialityName: _nameSpeciality.text,
              provinceId: widget.provinceId);
          await SQLHelper.createSpeciality(newSpeciality);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Successfully add an item")));
        }
      } else {
        Speciality updatedSpeciality = _specialities[_editingIndex!];
        updatedSpeciality.specialityName = _nameSpeciality.text;
        await SQLHelper.updateSpecial(updatedSpeciality);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Successfully update an item")));
        setState(() {
          _specialities[_editingIndex!] = updatedSpeciality;
          _editingIndex = null;
        });
      }
      await _fetchSpecialities();
      _nameSpeciality.clear();
    } catch (e) {
      debugPrint("Error saving/updating speciality: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_editingIndex == null ? 'Add Speciality' : 'Edit Speciality'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameSpeciality,
              decoration: InputDecoration(labelText: 'Speciality Name'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _saveSpeciality,
              child: Text(_editingIndex == null ? 'Save' : 'Update'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _specialities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_specialities[index].specialityName ?? ''),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _updateSpeciality(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteSpeciality(index),
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
