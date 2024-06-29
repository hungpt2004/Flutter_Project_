import 'package:flutter/material.dart';
import 'package:mynote_application/database/sql_helper.dart';
import '../model/license.dart';

class LicenseScreen extends StatefulWidget {
  final int provinceId;

  const LicenseScreen({Key? key, required this.provinceId}) : super(key: key);

  @override
  _LicenseScreenState createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  final TextEditingController _nameLicense = TextEditingController();
  List<License> _licenses = []; //License Array
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _fetchLicenses();
  }

  Future<void> _fetchLicenses() async {
    try {
      List<License> licenses = await SQLHelper.getLicensesByProvince(widget.provinceId);
      setState(() {
        _licenses = licenses;
      });
    } catch (e) {
      debugPrint("Error fetching licenses: $e");
    }
  }

  Future<void> _updateLicense(int id) async {
    final existLicense = await SQLHelper.getLicenses(id);
    if(existLicense != null) {
      await SQLHelper.updateLicense(License(
        provinceId: widget.provinceId,
        licenseId: id,
        licenseName: _nameLicense.text,
      ));
    }
  }

  Future<void> _deleteLicense(int index) async {
    try {
      final licenseId = _licenses[index].licenseId;
      if (licenseId != null) {
        await SQLHelper.deleteLicense(licenseId);
        setState(() {
          _licenses.removeAt(index);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully delete an item")));
        });
      }
    } catch (e) {
      debugPrint("Error deleting license: $e");
    }
  }

  Future<void> _saveLicense() async {
    try {
      if(_editingIndex == null) { //Need to create
        if (_licenses.any((license) => license.licenseName == _nameLicense.text)) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("License name already exists")));
          return;
        } else if (_nameLicense.text.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("License name can't empty")));
          return;
        } else {
          License newLicense = License(licenseName: _nameLicense.text, provinceId: widget.provinceId);
          await SQLHelper.createLicense(newLicense);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully add an item")));
        }
      } else { //Need to update
        License updatedLicense = _licenses[_editingIndex!];
        updatedLicense.licenseName = _nameLicense.text; //Gán giá trị của thằng license chọn = license cần update
        await SQLHelper.updateLicense(updatedLicense);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully update an item")));
        setState(() {
          _licenses[_editingIndex!] = updatedLicense;
          _editingIndex = null;
        });
      }
      await _fetchLicenses();
      _nameLicense.clear();
    } catch (e) {
      debugPrint("Error saving/updating license: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingIndex == null ? 'Add License' : 'Edit License'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameLicense,
              decoration: const InputDecoration(labelText: 'License Name'),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: _saveLicense,
              child: Text(_editingIndex == null ? 'Save' : 'Update'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _licenses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_licenses[index].licenseName ?? ''),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _updateLicense(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteLicense(index),
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
