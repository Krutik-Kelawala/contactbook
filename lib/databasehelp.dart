import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Databasehelper {
  Future<Database> Getdatabase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'contact.db');

    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'create table Contactbook (id integer primary key autoincrement, name Text , phoneno Text , image Text)');
    });
    return database;
  }

  Future<void> insertdata(
      String pname, String pphno, Database db, String addimage) async {
    String insertqry =
        "insert into Contactbook (name,phoneno,image) values ('$pname','$pphno','$addimage')";
    int cnt = await db.rawInsert(insertqry);
    print(cnt);
  }

  Future<List<Map>> viewmydata(Database dbview) async {
    String viewqry = "Select * from Contactbook";
    List<Map> viewlist = await dbview.rawQuery(viewqry);

    print("Data==$viewlist");
    return viewlist;
  }

  Future<void> deletedata(Database deletedata, int id) async {
    String deleteqry = "Delete from Contactbook Where id = '${id}'";
    int dlt = await deletedata.rawDelete(deleteqry);
    print("deleteid===$id");
  }

  Future<void> updatedata(String updatename, String updatenumber,
      Database updatedata, int updateid, String newimage) async {
    String updteqry =
        "Update Contactbook set name = '${updatename}' , phoneno = '${updatenumber}' , image = '${newimage}' where id = '${updateid}' ";
    int update = await updatedata.rawUpdate(updteqry);

    print("id== ${updateid}");
    print("name== ${updatename}");
    print("num== ${updatenumber}");
  }
}
