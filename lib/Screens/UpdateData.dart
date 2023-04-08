import 'package:expensebalance/Helpers/DatabaseHandlers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'Homepage.dart';

class UpdateData extends StatefulWidget {
  var updateid = '';
  UpdateData({required this.updateid});
  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  TextEditingController _title = TextEditingController();
  TextEditingController _remark = TextEditingController();
  TextEditingController _amount = TextEditingController();
  TextEditingController _date = TextEditingController();
  var group = "income";
  var selected = "Coffee";
  getsingle() async {
    DatabaseHandlers obj = new DatabaseHandlers();
    var data = await obj.getsingleexpense(widget.updateid);
    setState(() {
      _title.text = data![0]["title"].toString();
      _remark.text = data![0]["remark"].toString();
      _amount.text = data![0]["amount"].toString();
      _date.text = data![0]["date"].toString();
      group = data![0]["type"].toString();
      selected = data![0]["category"].toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsingle();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Update Data"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Type:",
                      style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 20.0,
                          color: Colors.pink.shade300),
                    ),
                    Text(
                      "Income",
                      style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 20.0,
                          color: Colors.lightGreen),
                    ),
                    Radio(
                      value: "income",
                      groupValue: group,
                      onChanged: (value) {
                        setState(() {
                          group = value!;
                        });
                      },
                    ),
                    Text(
                      "Expense",
                      style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 20.0,
                          color: Colors.lightGreen),
                    ),
                    Radio(
                      value: "expense",
                      groupValue: group,
                      onChanged: (value) {
                        setState(() {
                          group = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Title",
                  style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 20.0,
                      color: Colors.pink.shade300),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _title,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Remark",
                  style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 20.0,
                      color: Colors.pink.shade300),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _remark,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Amount",
                  style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 20.0,
                      color: Colors.pink.shade300),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _amount,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Text(
                      "Category:",
                      style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 20.0,
                          color: Colors.pink.shade300),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    DropdownButton(
                      value: selected,
                      items: [
                        DropdownMenuItem(
                            value: "Coffee", child: Text("Coffee")),
                        DropdownMenuItem(value: "Pents", child: Text("Pents")),
                        DropdownMenuItem(
                            value: "T shirt", child: Text("T shirt")),
                        DropdownMenuItem(value: "Lunch", child: Text("Lunch")),
                        DropdownMenuItem(
                            value: "School fee", child: Text("School fee")),
                        DropdownMenuItem(
                            value: "Insurance", child: Text("Insurance")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selected = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Date",
                  style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 20.0,
                      color: Colors.pink.shade300),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _date,
                  decoration: InputDecoration(
                    icon: Icon(Icons.date_range),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      print(pickedDate);
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      print(formattedDate);
                      setState(() {
                        _date.text = formattedDate;
                      });
                    } else {}
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          var addtitle = _title.text.toString();
                          var addremark = _remark.text.toString();
                          var addamount = _amount.text.toString();
                          var adddate = _date.text.toString();
                          var addtype = group;
                          var addcategory = selected;

                          DatabaseHandlers obj = DatabaseHandlers();
                          var status = await obj.update(
                              addtype,
                              addtitle,
                              addremark,
                              addamount,
                              addcategory,
                              adddate,
                              widget.updateid);
                          print("Record inserted" + status.toString());
                          if(status==1){
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => Homepage(),
                            ));
                          }
                          else{
                            Fluttertoast.showToast(
                                msg: "Racord not Update",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);

                          }

                        },
                        child: Text("Save")),
                    ElevatedButton(
                        onPressed: () async {}, child: Text("Cancel")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
