import 'dart:io';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandlers {
  Database? db;

  Future<Database?> create_db() async {
    if (db != null) {
      return db;
    } else {
      Directory dir = await getApplicationDocumentsDirectory();
      String dbpath = join(dir.path, "expense_db");
      var db = await openDatabase(dbpath, version: 1, onCreate: create_table);
      return db;
    }
  }

  create_table(Database db, int version) {
    db.execute(
        "create table expense (eid integer primary key autoincrement,type text,title text,remark text,amount double,category text,date text)");
    print("Table created");
  }

  Future<int?> insertexpensedata(
    addtype,
    addtitle,
    addremark,
    addamount,
    addcategory,
    adddate,
  ) async {
    var idb = await create_db();
    var id = await idb?.rawInsert(
        "insert into expense (type,title,remark,amount,category,date) values (?,?,?,?,?,?)",
        [addtype, addtitle, addremark, addamount, addcategory, adddate]);
    return id;
  }

  Future<List?> viewexpensedata() async {
    var idb = await create_db();
    var data = await idb?.rawQuery("select * from expense");
    return data!.toList();
  }

  Future<int?> Deletedata(id) async {
    var idb = await create_db();
    var status = await idb!.rawDelete("delete from expense where eid=?", [id]);
    return status;
  }

  Future<List?> getsingleexpense(id) async {
    var idb = await create_db();
    var data = await idb!.rawQuery("select * from expense where eid=?",[id]);
    return data.toList();
  }

  Future<int?> update(
      addtype, addtitle, addremark, addamount, addcategory, adddate, id) async {
    var idb = await create_db();
    var status = await idb!.rawUpdate(
        "update expense set type=?,title=?,remark=?,amount=?,category=?,date=? where eid=?",
        [addtype, addtitle, addremark, addamount, addcategory, adddate, id]);
    return status;
  }
}
