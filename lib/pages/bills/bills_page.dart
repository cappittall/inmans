import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inmans/a1/models/bill.model.dart';
import 'package:inmans/a1/pages/register_page.dart';
import 'package:inmans/pages/bills/bill_pdf_view.dart';
import 'package:inmans/a1/pages/penalties.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:inmans/a1/utils/navigate.dart';
import 'package:inmans/a1/widgets/background.dart';
import 'package:inmans/a1/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

import '../../a1/widgets/ggy_loading_indicator.dart';

class Bills extends StatefulWidget {
  const Bills({Key key}) : super(key: key);

  @override
  _BillsState createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  List<BillModel> billModels;

  void fetchBills() {
/*     DataBaseManager.getBills().then((value) {
      print(value);
      setState(() {
        billModels = value;
      });
    }); */
  }

  @override
  void initState() {
    fetchBills();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              CustomAppBar(
                title: getString("bills"),
              ),
              if (billModels != null && billModels.isNotEmpty)
                Text(getString("touchToSeeBill"),
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
              if (billModels != null && billModels.isNotEmpty)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 10),
                    children: billModels.map((e) {
                      return CupertinoButton(
                        onPressed: () {
                          if (e.pdfLink == null) {
                            showSnackBar(
                                context, getString("billNotReady"), Colors.red);
                            return;
                          }

                          navigate(
                              context: context,
                              page: BillPDFView(billModel: e));
                        },
                        padding: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Material(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.white,
                            child: Container(
                              height: 90,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: getString("opID"),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        TextSpan(
                                            text: e.operationID,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: getString("date"),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        TextSpan(
                                            text: DateFormat("dd/MM/yyyy")
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        e.timeStamp)),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: getString("amountB"),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        TextSpan(
                                            text: e.amount.toString() + "₺",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              if (billModels == null)
                Center(
                  child: LoadingIndicator(),
                ),
              if (billModels != null)
                if (billModels.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        getString("noBill"),
                        style: const TextStyle(fontSize: 22, color: Colors.white),
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
