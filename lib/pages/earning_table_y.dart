import 'package:flutter/material.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:inmans/a1/widgets/background.dart';
import 'package:inmans/a1/widgets/custom_app_bar.dart';
import 'package:inmans/services/database/database_manager.dart';
import 'package:inmans/main.dart';

import '../a1/instagramAccounts/globals.dart';

class EarningTablePage extends StatefulWidget {
  @override
  _EarningTablePageState createState() => _EarningTablePageState();
}

class _EarningTablePageState extends State<EarningTablePage> {
  var tableData;

  Future fetchEarningTable() async {
    var data =
        await DataBaseManager.db.child("earningTable/tableVersion").once();
    double tableVersion = data.value.toDouble();
    String key = "tableVersion";
    if (localDataBox.containsKey(key)) {
      double v = localDataBox.get(key);

      if (v < tableVersion) {
        localDataBox.put(key, tableVersion);
        var data = await DataBaseManager.db.child("earningTable/data").once();
        localDataBox.put("tableData", data.value);
        setState(() {
          tableData = data.value;
        });
      } else {
        setState(() {
          tableData = localDataBox.get("tableData");
        });
      }
    } else {
      localDataBox.put(key, tableVersion);
      var data = await DataBaseManager.db.child("earningTable/data").once();
      localDataBox.put("tableData", data.value);
      setState(() {
        tableData = data.value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEarningTable();
  }

  var order = [
    "0-100",
    "100-500",
    "500-1000",
    "1000-3000",
    "3000-5000",
    "5000+"
  ];

  var operations = [
    "",
    "follow",
    "like",
    "comment",
    "image share",
    "video share",
    "story share"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Container(
          child: Column(
            children: [
              CustomAppBar(
                title: getString("earningTable"),
              ),
              if (tableData != null)
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      children: order.map((order) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Colors.white,
                            child: SizedBox(
                              width: 300,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    getString("withFollower")
                                        .replaceAll("{follower}", order),
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  ...tableData[order].keys.map((key) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            getString(key),
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "${tableData[order][key].toDouble().toStringAsFixed(5)}₺",
                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList()
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
