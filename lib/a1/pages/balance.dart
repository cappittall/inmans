// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:inmans/a1/models/operation_history.model.dart';
import 'package:inmans/a1/models/user.model.dart';
import 'package:inmans/a1/pages/register_page.dart';
import 'package:inmans/pages/balance/deposit.dart';
import 'package:inmans/pages/balance/withdraw.dart';
import 'package:inmans/services/balance_notifier.dart';
import 'package:inmans/a1/instagramAccounts/globals.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:inmans/a1/utils/navigate.dart';
import 'package:inmans/a1/widgets/background.dart';
import 'package:inmans/a1/widgets/custom_app_bar.dart';
import 'package:inmans/a1/widgets/custom_button.dart';

import '../utils/constants.dart';

class BalancePage extends StatefulWidget {
  final User user;
  const BalancePage({Key key, @required this.user}) : super(key: key);
  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  User user;
  Map profil;

  List<dynamic> operationHistory;
  double withdrawComission;
  double depositComission;

  void fetchComission() {
/*     DataBaseManager.db.child("comissions").once().then((value) {
      setState(() {
        var commissions = value.value;
        withdrawComission = commissions["withdraw"];
        depositComission = commissions["deposit"];
      });
    }); */
  }

  @override
  void initState() {
    super.initState();
    fetchComission();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => fetchOperationHistory('$conUrl/api/earnlist/', profil['token']));
    // For the first
  }

  void fetchOperationHistory(String uri, String token) async {
    print('Token : ' + token);
    http.Response response = await http.get(
      Uri.parse(uri),
      headers: getUserHeader(token),
    );

    var resp = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      operationHistory =
          resp['results'].map((x) => OperationHistory.fromDoc(x)).toList();
      balanceNotifier.updateBalance(resp['sum']);
    });

    /* resp['results'].forEach((x) {
      operationHistory.add(OperationHistory.fromDoc(x));
    });
    //.map((x) => OperationHistory.fromDoc(x)) as List<OperationHistory>;
    print(
        ' >> operationHistory:${operationHistory.runtimeType} $operationHistory');

    setState(() {}); */
  }

  var prices = {
    "usersToFollow": 0.005,
    "postLikes": 0.005,
    "postComments": 0.005,
    "postSaves": 0.005,
    "multiUserDMs": 0.005,
    "singleUserDMs": 0.005,
    "commentLikes": 0.005,
    "reelsLikes": 0.005,
    "reelsComments": 0.005,
    "igTVLikes": 0.005,
    "igTVComments": 0.005,
    "liveBroadCastLikes": 0.005,
    "liveBroadCastComments": 0.005,
    "postShares": 0.005,
    "videoShares": 0.005,
    "storyShares": 0.005,
    "spams": 0.005,
    "suicideSpams": 0.005,
    "liveWatches": 0.005,
  };

  bool plus(OperationHistory op) {
    if (op.type == "deposit") {
      return true;
    } else if (prices.keys.contains(op.type)) {
      return true;
    } else if (op.type.contains("buy")) {
      return false;
    } else if (op.type == "withdraw") {
      return false;
    } else if (op.type == "punishment") {
      return false;
    } else {
      return false;
    }
  }

  String getPriceText(OperationHistory op) {
    print('${prices.keys} ${prices.keys.contains(op.type)}  ${op.type}');
    if (op.type == "deposit") {
      return "+${op.paidAmount.toStringAsFixed(2)}\$";
    } else if (op.type == "refund") {
      return "+${op.paidAmount.toStringAsFixed(2)}\$";
    } else if (prices.keys.contains(op.type)) {
      return "+${op.paidAmount != null ? op.paidAmount.toStringAsFixed(3) : "..."}\$";
    } else if (op.type.contains("buy")) {
      return "-${op.paidAmount.toStringAsFixed(2)}\$";
    } else if (op.type == "withdraw") {
      return "-${op.paidAmount.toStringAsFixed(2)}\$";
    } else if (op.type == "punishment") {
      return "-${op.paidAmount.toStringAsFixed(2)}\$";
    } else {
      return "-${op.paidAmount.toStringAsFixed(2)}\$";
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context).settings.arguments as User;
    profil = user.profil;
    return Scaffold(
      body: Background(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: getString("balance"),
              ),
              SizedBox(
                height: 150,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.amber,
                        size: 50,
                      ),
                      const SizedBox(width: 10),
                      Text(
                          balanceNotifier.balance != null
                              ? "${balanceNotifier.balance.toStringAsFixed(2)}\$"
                                  .replaceAll(".", ",")
                              : "",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 40)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 10),
                child: Text(
                  getString("last10OP"),
                  style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              if (operationHistory == null)
                const Expanded(
                  child: SizedBox(),
                ),
              if (operationHistory != null)
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: operationHistory.map((h) {
                      return Padding(
                        key: Key((h.timeStamp.toString() + h.id).toString()),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Material(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.white,
                          child: SizedBox(
                            height: 56,
                            width: double.infinity,
                            child: Center(
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    choices[h.type].toString(),
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                  const Spacer(),
                                  Text(
                                    getPriceText(h) ?? "-",
                                    style: TextStyle(
                                        color: plus(h)
                                            ? Colors.green
                                            : Colors.redAccent,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              CustomButton(
                  onPressed: () async {
                    String cevap = await sentBalanceRequest();
                    showSnackBar(context, cevap, Colors.red);
                  },
                  text: getString("requestWithdraw")),
/*               CustomButton(
                  onPressed: () {
                    navigate(
                        context: context,
                        page: DepositPage(comission: depositComission));
                  },
                  text: getString("deposit")), */
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> sentBalanceRequest() async {
    print("ödeme talep edil ${balanceNotifier.balance < 50}");
    var uri = "$conUrl/api/balancerequest/";
    var body = {"amount": balanceNotifier.balance};
    if (balanceNotifier.balance < 50) {
      print(getString("minWithdraw"));
      return getString("minWithdraw");
    }
    http.Response response = await http.post(
      Uri.parse(uri),
      body: jsonEncode(body),
      headers: getUserHeader(token),
    );
    print("ödeme talep edildi ${response.statusCode}, ${response.body}");
    if (response.statusCode == 201) {
      return getString("gotWithdrawRequest");
    } else {
      return getString("gotWithdrawRequestError");
    }
  }
}

class Source {
  static Source server;
  static Source cache;
}
