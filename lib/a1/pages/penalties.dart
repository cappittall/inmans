import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:togetherearn/a1/utils/constants.dart';
import 'package:togetherearn/a1/utils/multilang.dart';
import 'package:togetherearn/a1/widgets/background.dart';
import 'package:togetherearn/a1/widgets/custom_app_bar.dart';

import '../models/penalty.model.dart';

class PenaltiesPage extends StatefulWidget {
  @override
  _PenaltiesPageState createState() => _PenaltiesPageState();
}

class _PenaltiesPageState extends State<PenaltiesPage> {
  List<Penalty> penalties;
  int penaltyCount;

  @override
  void initState() {
    super.initState();
    // wait 3 seconds to simulate a network call, in flutter this is not necessary
    Future.delayed(const Duration(seconds: 0), () async {
      // simulate a network call
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        penalties = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: penalties != null
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    CustomAppBar(
                      title: getString("penalties"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "*" + getString("penaltyWarn"),
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    if (penalties.isNotEmpty)
                      SizedBox(
                        height: 150,
                        child: Center(
                          child: Text(
                            "$penaltyCount",
                            style: const TextStyle(
                                fontSize: 50, color: Colors.redAccent),
                          ),
                        ),
                      ),
                    if (penalties.isNotEmpty)
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: penalties.map((p) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Material(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          getString(p.type).replaceAll(
                                              "{username}", p.username),
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    if (penalties.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            getString("noPenalty"),
                            style: const TextStyle(
                                fontSize: 22, color: Colors.white),
                          ),
                        ),
                      ),
                    if (penalties.isEmpty)
                      const SizedBox(
                        height: 56,
                      ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ),
      ),
    );
  }
}
