import 'package:expensebalance/Helpers/DatabaseHandlers.dart';
import 'package:expensebalance/Screens/ExpenseAddDataScreen.dart';
import 'package:expensebalance/Screens/UpdateData.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<List>? alldataexpense;
  var income = 0.0;
  var expence = 0.0;
  Future<List> getdata() async {
    DatabaseHandlers obj = DatabaseHandlers();
    var alldata = await obj.viewexpensedata();

    alldata!.forEach((row) {
      if (row["type"].toString() == "income") {
        income = income + double.parse(row["amount"].toString());
      } else {
        expence = expence + double.parse(row["amount"].toString());
      }
    });

    setState(() {
      balance = income - expence;
    });

    return alldata!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      alldataexpense = getdata();
    });
  }

  var balance = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expenses"),
        actions: [Text("Balance : " + balance.toString())],
      ),
      body: FutureBuilder(
        future: alldataexpense,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length == 0) {
              return Center(
                child: Text("No Data"),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.red.shade200,
                      ),
                      child: Card(
                        elevation: 10.0,
                        color: Colors.yellow.shade100,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Type: " +
                                    snapshot.data![index]["type"].toString(),
                                style: TextStyle(
                                    fontSize: 15.0, fontFamily: "Lato"),
                              ),
                              Text(
                                "Title: " +
                                    snapshot.data![index]["title"].toString(),
                                style: TextStyle(
                                    fontSize: 15.0, fontFamily: "Lato"),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Remark: " +
                                        snapshot.data![index]["remark"]
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 15.0, fontFamily: "Lato"),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                  Text(
                                    "Date: " +
                                        snapshot.data![index]["date"]
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 15.0, fontFamily: "Lato"),
                                  ),
                                ],
                              ),
                              Text(
                                "Amount: " +
                                    snapshot.data![index]["amount"].toString(),
                                style: TextStyle(
                                    fontSize: 15.0, fontFamily: "Lato"),
                              ),
                              Text(
                                "Category: " +
                                    snapshot.data![index]["category"]
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 15.0, fontFamily: "Lato"),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        var id = snapshot.data![index]["eid"]
                                            .toString();
                                        DatabaseHandlers obj =
                                            new DatabaseHandlers();
                                        var st = await obj.Deletedata(id);
                                        if (st == 1) {
                                          Fluttertoast.showToast(
                                              msg: "Record Sucessfully",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          setState(() {
                                            alldataexpense = getdata();
                                          });
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Racord not Deleted",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      },
                                      child: Text("Delete")),
                                  ElevatedButton(
                                      onPressed: () {
                                        var id = snapshot.data![index]["eid"]
                                            .toString();
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => UpdateData(updateid:id),
                                        ));
                                      },
                                      child: Text("Update")),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ExpenseAddDataScreen(),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
