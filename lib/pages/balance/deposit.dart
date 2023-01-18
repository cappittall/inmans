import 'package:flutter/material.dart';
import 'package:inmans/a1/pages/register_page.dart';
import 'package:inmans/pages/balance/paytr_view.dart';

import 'package:inmans/services/balance_notifier.dart';
import 'package:inmans/services/database/database_manager.dart';
import 'package:inmans/services/paytr/PayTrServer.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:inmans/a1/utils/navigate.dart';
import 'package:inmans/a1/widgets/background.dart';
import 'package:inmans/a1/widgets/custom_app_bar.dart';
import 'package:inmans/a1/widgets/custom_button.dart';
import 'package:inmans/a1/widgets/custom_input_widget.dart';

class DepositPage extends StatefulWidget {
  final comission;

  const DepositPage({Key key, this.comission}) : super(key: key);
  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  TextEditingController depositAmountController = TextEditingController();

  double comission;
  double amount = 0;
  double totalComission = 0;
  double total = 0;

  String validate(String str) {
    if (str.isEmpty) {
      return null;
    }

    try {
      double value = double.parse(str);

      if (value < 10) {
        return getString("invalidDepositAmount");
      } else {
        return null;
      }
    } catch (e) {
      return getString("invalidDepositAmount");
    }
  }

  @override
  void initState() {
    comission = widget.comission;
    super.initState();

    balanceNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Container(
          child: Column(
            children: [
              CustomAppBar(
                title: getString("deposit"),
              ),
              CustomTextInput(
                  hintText: getString("amount"),
                  inputType: TextInputType.number,
                  controller: depositAmountController,
                  validator: (str) {
                    return validate(str);
                  },
                  onChanged: (str) {
                    double tempAmount = double.tryParse(str);
                    if (tempAmount != null) if (tempAmount >= 10) {
                      setState(() {
                        amount = tempAmount;
                        totalComission = amount * comission;
                        total = amount + totalComission;
                      });
                    } else {
                      setState(() {
                        amount = 0;
                        totalComission = 0;
                        total = 0;
                      });
                    }
                  }),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Text("${getString("youGet")}: ",
                        style: const TextStyle(color: Colors.white, fontSize: 22)),
                    const Spacer(),
                    Text("${amount.toStringAsFixed(2)}₺",
                        style: const TextStyle(color: Colors.white, fontSize: 22))
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Text("${getString("fee")}: ",
                        style: const TextStyle(color: Colors.white, fontSize: 22)),
                    const Spacer(),
                    Text("${totalComission.toStringAsFixed(2)}₺",
                        style: const TextStyle(color: Colors.white, fontSize: 22))
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Text("${getString("total")}: ",
                        style: const TextStyle(color: Colors.white, fontSize: 22)),
                    const Spacer(),
                    Text(
                      "${total.toStringAsFixed(2)}₺",
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ],
                ),
              ),
              Builder(builder: (context) {
                bool depositLoading = false;

                return StatefulBuilder(builder: (context, setButtonState) {
                  return CustomButton(
                      loading: depositLoading,
                      onPressed: () async {
                        try {
                          String depositAmount = total.toStringAsFixed(2);

                          setButtonState(() {
                            depositLoading = true;
                          });

                          if (validate(depositAmount) != null) {
                            setButtonState(() {
                              depositLoading = false;
                            });
                            return;
                          }

                          int timeStamp = DateTime.now().millisecondsSinceEpoch;

                          var depositOPData = {
                            "type": "deposit",
                            "timeStamp": timeStamp,
                            "operationData": {
                              "userID": 'firebaseAuth.currentUser.uid,',
                              "amount": amount,
                              "paid": total,
                            }
                          };

                           var token = await PayTrServer.generatePayTRToken(
                              'firebaseAuth.currentUser.uid', //FIXME:
                              double.parse(depositAmount)); 

                          if (token != null) {
                            navigate(
                                context: context,
                                page: PayTrPayment(
                                  token: token,
                                  depositOPData: depositOPData,
                                ));
                          } else {
                            print("fail beacuse PayTR Token is null.");
                            showSnackBar(context,
                                getString("somethingWentWrong"), Colors.red);
                            setButtonState(() {
                              depositLoading = false;
                            });
                            return;
                          }
                        } catch (e) {
                          showSnackBar(context, getString("somethingWentWrong"),
                              Colors.red);
                          setButtonState(() {
                            depositLoading = false;
                          });
                          return;
                        }
                      },
                      text: getString("deposit"));
                });
              })
            ],
          ),
        ),
      ),
    );
  }
}
