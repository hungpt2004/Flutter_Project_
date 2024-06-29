import 'package:flutter/material.dart';
import 'package:mynote_application/database/sql_helper.dart';
import '../model/city.dart';

class CityScreen extends StatefulWidget {
  final int provinceId;

  const CityScreen({Key? key, required this.provinceId}) : super(key: key);

  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final TextEditingController _nameCity = TextEditingController();
  List<City> _cities = [];
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _fetchCities();
  }

  Future<void> _fetchCities() async {
    try {
      List<City> cities = await SQLHelper.getCitiesByProvince(widget.provinceId);
      setState(() {
        _cities = cities;
      });
    } catch (e) {
      debugPrint("Error fetching cities: $e");
    }
  }

  void _updateCity(int index) {
    setState(() {
      _editingIndex = index;
      _nameCity.text = _cities[index].cityName ?? '';
    });
  }

  Future<void> _deleteCity(int index) async {
    try {
      final cityId = _cities[index].cityId;
      if (cityId != null) {
        await SQLHelper.deleteCity(cityId);
        setState(() {
          _cities.removeAt(index);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully deleted an item")));
        });
      }
    } catch (e) {
      debugPrint("Error deleting city: $e");
    }
  }

  Future<void> _saveCity() async {
    try {
      if (_editingIndex == null) {
        if (_cities.any((city) => city.cityName == _nameCity.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("City name already exists")));
          return;
        } else if(_nameCity.text.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("City name can't empty")));
          return;
        } else {
          City newCity = City(cityName: _nameCity.text, provinceId: widget.provinceId);
          await SQLHelper.createCity(newCity);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully add an item")));
        }
        //Optimize
      } else {
        City updatedCity = _cities[_editingIndex!];
        updatedCity.cityName = _nameCity.text;
        await SQLHelper.updateCity(updatedCity);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully update an item")));
        setState(() {
          _cities[_editingIndex!] = updatedCity;
          _editingIndex = null;
        });
      }
      await _fetchCities();
      _nameCity.clear();
    } catch (e) {
      debugPrint("Error saving/updating city: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingIndex == null ? 'Add City' : 'Edit City'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameCity,
              decoration: const InputDecoration(labelText: 'City Name'),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: _saveCity,
              child: Text(_editingIndex == null ? 'Save' : 'Update'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _cities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_cities[index].cityName ?? ''),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _updateCity(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteCity(index),
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
