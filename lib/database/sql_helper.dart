import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/city.dart';
import '../model/license.dart';
import '../model/province.dart';
import '../model/scenic.dart';
import '../model/speciality.dart';
import '../model/university.dart';
import '../model/user.dart';

class SQLHelper {

  static const _databaseName = "MyRepresentation.db";
  static const _databaseVersion = 1;
  static const _tableProvince = "province";
  static const _tableUser = 'user';
  static const _tableCity = 'city';
  static const _tableScenic = 'scenic';
  static const _tableUniversity = 'university';
  static const _tableLicense = 'license';
  static const _tableSpeciality = 'speciality';


  //User table
  static const _columnUserId = 'userId';
  static const _columnName = 'username';
  static const _columnPassword = 'password';
  static const _columnEmail = 'email';
  static const _columnGender = 'gender';

  //Province Table
  static const _columnProvinceId = 'provinceId';
  static const _columnProvinceName = 'provinceName';

  //City Table
  static const _columnCityId = 'cityId';
  static const _columnProvinceId2 = 'provinceId';
  static const _columnCityName = 'cityName';

  //University Table
  static const _columnUniId = 'universityId';
  static const _columnProvinceId3 = 'provinceId';
  static const _columnUniName = 'universityName';

  //License Table
  static const _columnLicenseId = 'licenseId';
  static const _columnProvinceId4 = 'provinceId';
  static const _columnLicenseName = 'licenseName';

  //Scenic Table
  static const _columnScenicId = 'scenicId';
  static const _columnProvinceId5 = 'provinceId';
  static const _columnScenicName = 'scenicName';

  //Speciality Table
  static const _columnSpecialityId = 'specialityId';
  static const _columnProvinceId6 = 'provinceId';
  static const _columnSpecialityName = 'specialityName';



  //Create Province Table
  static Future<void> createProvinceTable(Database database) async {
    try {
      await database.execute("CREATE TABLE $_tableProvince("
          "$_columnProvinceId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "$_columnProvinceName TEXT)");
      debugPrint("Province table created");
    } catch (err) {
      debugPrint("Create Province Table: $err");
    }
  }

  //Create City Table
  static Future<void> createCityTable(Database database) async {
    try {
      await database.execute("CREATE TABLE $_tableCity("
          "$_columnCityId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "$_columnProvinceId2 INTEGER NOT NULL,"
          "$_columnCityName TEXT,"
          "FOREIGN KEY ($_columnProvinceId2) REFERENCES $_tableProvince($_columnProvinceId))");
    } catch (err) {
      debugPrint("Create City Table: $err");
    }
  }

  //Create University Table
  static Future<void> createUniversityTable(Database database) async {
    try {
      await database.execute("CREATE TABLE $_tableUniversity("
          "$_columnUniId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "$_columnProvinceId3 INTEGER NOT NULL,"
          "$_columnUniName TEXT,"
          "FOREIGN KEY ($_columnProvinceId3) REFERENCES $_tableProvince($_columnProvinceId))");
    } catch (err) {
      debugPrint("Create University Table: $err");
    }
  }

  //Create License Table
  static Future<void> createLicenseTable(Database database) async {
    try {
      await database.execute("CREATE TABLE $_tableLicense("
          "$_columnLicenseId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "$_columnProvinceId4 INTEGER NOT NULL,"
          "$_columnLicenseName TEXT,"
          "FOREIGN KEY ($_columnProvinceId4) REFERENCES $_tableProvince($_columnProvinceId))");
    } catch (err) {
      debugPrint("Create Province Table: $err");
    }
  }

  //Create Scenic Table
  static Future<void> createScenicTable(Database database) async {
    try {
      await database.execute('''
      CREATE TABLE $_tableScenic (
        $_columnScenicId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnProvinceId5 INTEGER NOT NULL,
        $_columnScenicName TEXT,
        FOREIGN KEY ($_columnProvinceId5) REFERENCES $_tableProvince($_columnProvinceId)
      )
    ''');
    } catch (err) {
      debugPrint("Create Scenic Table: $err");
    }
  }

  //Create Speciality Table
  static Future<void> createSpecialityTable(Database database) async {
    try {
      await database.execute('''
      CREATE TABLE $_tableSpeciality (
        $_columnSpecialityId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnProvinceId6 INTEGER NOT NULL,
        $_columnSpecialityName TEXT,
        FOREIGN KEY ($_columnProvinceId6) REFERENCES $_tableProvince($_columnProvinceId)
      )
    ''');
    } catch (err) {
      debugPrint("Create Speciality Table: $err");
    }
  }

  //Create User Table
  static Future<void> createUserTable(Database database) async {
    try {
      await database.execute("CREATE TABLE $_tableUser("
          "$_columnUserId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "$_columnName TEXT, "
          "$_columnPassword TEXT, "
          "$_columnEmail TEXT,"
          "$_columnGender INTEGER"
          ")");
    } catch (err) {
      debugPrint("Create User Table : $err");
    }
  }

  //Get DB
  static Future<Database> getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, version) async {
        await createUserTable(db);
        await createProvinceTable(db);
        await createCityTable(db);
        await createUniversityTable(db);
        await createLicenseTable(db);
        await createScenicTable(db);
        await createSpecialityTable(db);
      },
      version: _databaseVersion,
    );
  }

  //================================================CREATE ALL=============================================

  //Create Province
  static Future<int> createProvince(Province province) async {
    int id = 0;
    try {
      final db = await SQLHelper.getDB();
      id = await db.insert(_tableProvince, province.toMap());
    } catch (err) {
      debugPrint("Create Province: $err");
    }
    return id;
  }

  //Create City
  static Future<int> createCity(City city) async {
    int id = 0;
    try {
      final db = await SQLHelper.getDB();
      id = await db.insert(_tableCity, city.toMap());
    } catch (err) {
      debugPrint("Create City: $err");
    }
    return id;
  }

  //Create University
  static Future<int> createUniversity(University university) async {
    int id = 0;
    try {
      final db = await SQLHelper.getDB();
      id = await db.insert(_tableUniversity, university.toMap());
    } catch (err) {
      debugPrint('Create University: $err');
    }
    return id;
  }

  //Create License
  static Future<int> createLicense(License license) async {
    int id = 0;
    try {
      final db = await SQLHelper.getDB();
      id = await db.insert(_tableLicense, license.toMap());
    } catch (err) {
      debugPrint("Create License : $err");
    }
    return id;
  }

  //Create Scenic
  static Future<int> createScenic(Scenic scenic) async {
    int id = 0;
    try {
      final db = await SQLHelper.getDB();
      id = await db.insert(_tableScenic, scenic.toMap());
    } catch (err) {
      debugPrint("Create Scenic: $err");
    }
    return id;
  }

  //Create Speciality
  static Future<int> createSpeciality(Speciality speciality) async {
    int id = 0;
    try {
      final db = await SQLHelper.getDB();
      id = await db.insert(_tableSpeciality, speciality.toMap());
    } catch (err) {
      debugPrint("Create Speciality: $err");
    }
    return id;
  }

  //Create User
  static Future<int> createUser(User user) async {
    int id = 0;
    try {
      final db = await SQLHelper.getDB();
      id = await db.insert(_tableUser, user.toMap(), conflictAlgorithm:ConflictAlgorithm.replace);
    } catch (err) {
      debugPrint("Create User: $err");
    }
    return id;
  }

  //===================================================USER==================================================

  //Update User
  static Future<int> updateUser(User user) async {
    final db = await SQLHelper.getDB();
    return await db.update(_tableUser, user.toMap(), where: 'userId = ?', whereArgs: [user.userId]);
  }

  //Get All User
  static Future<List<Map<String,dynamic>>> getUsers() async {
    try {
      final db = await getDB();
      return await db.query(_tableUser);
    } catch (err) {
      debugPrint("Get Users: $err");
      return[];
    }
  }

  //Get User By ID
  static Future<List<Map<String, dynamic>>> getUser(int userId) async {
    final db = await SQLHelper.getDB();
    return db.query(_tableUser, where: 'userId = ?', whereArgs: [userId]);
  }

  //==========================================PROVINCE=====================================

  //Get Province
  static Future<List<Map<String, dynamic>>> getProvinces() async {
    try {
      final db = await getDB();
      return await db.query(
        _tableProvince,
        orderBy: 'provinceId DESC', // ASC for ascending order, DESC for descending
      );
    } catch (err) {
      debugPrint("Get Provinces: $err");
      return [];
    }
  }


  //Get Province By ID
  static Future<List<Map<String, dynamic>>> getProvince(int provinceId) async {
    late Future<List<Map<String,dynamic>>> province;
    try {
      final db = await SQLHelper.getDB();
      province = db.query(_tableProvince, where: 'provinceId = ?', whereArgs: [provinceId]);
    } catch (err) {
      debugPrint("Get Province: $err");
    }
    return province;
  }

  //Update Province By ID
  static Future<void> updateProvince(Province province) async {
    int result = 0;
    try {
      final db = await SQLHelper.getDB();
      result = await db.update(_tableProvince, province.toMap(), where: 'provinceId = ?', whereArgs: [province.provinceId]);
    } catch (err) {
      debugPrint("Update Province: $err");
    }
  }

  //Delete Province By ID
  static Future<void> deleteProvince(int provinceId) async {
    try {
      final db = await SQLHelper.getDB();
      await db.delete(_tableProvince, where: 'provinceId = ?', whereArgs: [provinceId]);
    } catch (err) {
      debugPrint("Delete Province: $err");
    }
  }

  //=========================================CITY==============================================

  //Get City
  static Future<List<Map<String,dynamic>>> getCities() async {
    try {
      final db = await getDB();
      return await db.query(_tableCity);
    } catch (err) {
      debugPrint("Get Cities: $err");
      return[];
    }
  }


  //Get City By ID
  static Future<List<Map<String, dynamic>>> getCity(int cityId) async {
    late Future<List<Map<String,dynamic>>> city;
    try {
      final db = await SQLHelper.getDB();
      city = db.query(_tableCity, where: 'cityId = ?', whereArgs: [cityId]);
    } catch (err) {
      debugPrint("Get City: $err");
    }
    return city;
  }

  //Update City
  static Future<void> updateCity(City city) async {
    int result = 0;
    try {
      final db = await SQLHelper.getDB();
      result = await db.update(_tableCity, city.toMap(), where: 'cityId = ?', whereArgs: [city.cityId]);
    } catch (err) {
      debugPrint("Update City: $err");
    }
  }

  //Delete City
  static Future<void> deleteCity(int cityId) async {
    try {
      final db = await SQLHelper.getDB();
      await db.delete(_tableCity, where: 'cityId = ?', whereArgs: [cityId]);
    } catch (err) {
      debugPrint("Delete City: $err");
    }
  }

  //=========================================UNIVERSITY==============================================

  //Get University By ID
  static Future<List<Map<String, dynamic>>> getUniversity(int universityId) async {
    late Future<List<Map<String,dynamic>>> university;
    try {
      final db = await SQLHelper.getDB();
      university = db.query(_tableUniversity, where: 'universityId = ?', whereArgs: [universityId]);
    } catch (err) {
      debugPrint("Get University: $err");
    }
    return university;
  }

  //Update University
  static Future<void> updateUniversity(University university) async {
    int result = 0;
    try {
      final db = await SQLHelper.getDB();
      result = await db.update(_tableUniversity, university.toMap(), where: 'universityId = ?', whereArgs: [university.universityId]);
    } catch (err) {
      debugPrint("Update University: $err");
    }
  }

  //Delete University
  static Future<void> deleteUniversity(int universityId) async {
    try {
      final db = await SQLHelper.getDB();
      await db.delete(_tableUniversity, where: 'universityId = ?', whereArgs: [universityId]);
    } catch (err) {
      debugPrint("Delete University: $err");
    }
  }


  //=========================================SCENIC==============================================

  //Update Scenic
  static Future<void> updateScenic(Scenic scenic) async {
    int result = 0;
    try {
      final db = await SQLHelper.getDB();
      result = await db.update(_tableScenic, scenic.toMap(), where: 'scenicId = ?', whereArgs: [scenic.scenicId]);
    } catch (err) {
      debugPrint("Update Scenic: $err");
    }
  }

  //Get Scenic By ID
  static Future<List<Map<String,dynamic>>> getScenics(int id) async {
    late Future<List<Map<String,dynamic>>> scenicList;
    try {
      final db = await getDB();
      return await db.query(_tableScenic, where: 'scenicId=?', whereArgs: [id]);
    } catch (err) {
      debugPrint("Get Scenic: $err");
      return[];
    }
  }


  //Delete Scenic
  static Future<void> deleteScenic(int scenicId) async {
    try {
      final db = await SQLHelper.getDB();
      await db.delete(_tableScenic, where: 'scenicId = ?', whereArgs: [scenicId]);
    } catch (err) {
      debugPrint("Delete Scenic: $err");
    }
  }

  //=========================================SPECIALITY==============================================

  //Get Special
  static Future<List<Map<String,dynamic>>> getSpecials(int id) async {
    late Future<List<Map<String,dynamic>>> specialList;
    try {
      final db = await getDB();
      return await db.query(_tableSpeciality, where: 'specialityId=?',whereArgs: [id]);
    } catch (err) {
      debugPrint("Get Special: $err");
      return[];
    }
  }

  //Update Special
  static Future<void> updateSpecial(Speciality special) async {
    int result = 0;
    try {
      final db = await SQLHelper.getDB();
      result = await db.update(_tableSpeciality, special.toMap(), where: 'specialityId = ?', whereArgs: [special.specialityId]);
    } catch (err) {
      debugPrint("Update Special: $err");
    }
  }

  //Delete Special
  static Future<void> deleteSpecial(int specialityId) async {
    try {
      final db = await SQLHelper.getDB();
      await db.delete(_tableSpeciality, where: 'specialityId = ?', whereArgs: [specialityId]);
    } catch (err) {
      debugPrint("Delete Special: $err");
    }
  }

  //=========================================LICENSE==============================================

  //Get License
  static Future<List<Map<String,dynamic>>> getLicenses(int id) async {
    late Future<List<Map<String,dynamic>>> licenseList;
    try {
      final db = await getDB();
      return await db.query(_tableLicense,where: 'licenseId=?',whereArgs: [id]);
    } catch (err) {
      debugPrint("Get License: $err");
      return[];
    }
  }

  //Update License
  static Future<void> updateLicense(License license) async {
    int result = 0;
    try {
      final db = await SQLHelper.getDB();
      result = await db.update(_tableLicense, license.toMap(), where: 'licenseId = ?', whereArgs: [license.licenseId]);
    } catch (err) {
      debugPrint("Update License: $err");
    }
  }

  //Delete License
  static Future<void> deleteLicense(int licenseId) async {
    try {
      final db = await SQLHelper.getDB();
      await db.delete(_tableLicense, where: 'licenseId = ?', whereArgs: [licenseId]);
    } catch (err) {
      debugPrint("Delete License: $err");
    }
  }

  //=========================================GET BY PROVINCE ID==============================================


  // Get cities by provinceId
  static Future<List<City>> getCitiesByProvince(int provinceId) async {
    final Database db = await SQLHelper.getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableCity,
      where: 'provinceId = ?',
      whereArgs: [provinceId],
    );
    return List.generate(maps.length, (i) {
      return City(
        cityId: maps[i]['cityId'],
        provinceId: maps[i]['provinceId'],
        cityName: maps[i]['cityName'],
      );
    });
  }

  // Get universities by provinceId
  static Future<List<University>> getUniversitiesByProvince(int provinceId) async {
    final Database db = await SQLHelper.getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableUniversity,
      where: 'provinceId = ?',
      whereArgs: [provinceId],
    );
    return List.generate(maps.length, (i) {
      return University(
        universityId: maps[i]['universityId'],
        provinceId: maps[i]['provinceId'],
        universityName: maps[i]['universityName'],
      );
    });
  }

  // Get scenics by provinceId
  static Future<List<Scenic>> getScenicsByProvince(int provinceId) async {
    final Database db = await SQLHelper.getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableScenic,
      where: 'provinceId = ?',
      whereArgs: [provinceId],
    );
    return List.generate(maps.length, (i) {
      return Scenic(
        scenicId: maps[i]['scenicId'],
        provinceId: maps[i]['provinceId'],
        scenicName: maps[i]['scenicName'],
      );
    });
  }

  // Get specialities by provinceId
  static Future<List<Speciality>> getSpecialitiesByProvince(int provinceId) async {
    final Database db = await SQLHelper.getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableSpeciality,
      where: 'provinceId = ?',
      whereArgs: [provinceId],
    );
    return List.generate(maps.length, (i) {
      return Speciality(
        specialityId: maps[i]['specialityId'],
        provinceId: maps[i]['provinceId'],
        specialityName: maps[i]['specialityName'],
      );
    });
  }

  // Get licenses by provinceId
  static Future<List<License>> getLicensesByProvince(int provinceId) async {
    final Database db = await SQLHelper.getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableLicense,
      where: 'provinceId = ?',
      whereArgs: [provinceId],
    );
    return List.generate(maps.length, (i) {
      return License(
        licenseId: maps[i]['licenseId'],
        provinceId: maps[i]['provinceId'],
        licenseName: maps[i]['licenseName'],
      );
    });
  }
}









