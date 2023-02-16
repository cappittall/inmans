import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:togetherearn/a1/pages/register_page.dart';

import 'package:togetherearn/a1/utils/multilang.dart';
import 'package:togetherearn/a1/widgets/background.dart';
import 'package:togetherearn/a1/widgets/custom_app_bar.dart';
import 'package:togetherearn/a1/widgets/custom_button.dart';
import 'package:togetherearn/a1/widgets/custom_input_widget.dart';

import '../server/values.dart';
import '../services/balance_notifier.dart';
import '../services/database/database_manager.dart';

class WithdrawPage extends StatefulWidget {
  final double comission;

  const WithdrawPage({Key key, this.comission}) : super(key: key);
  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  TextEditingController withdrawAmountController = TextEditingController();
  TextEditingController tcController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController code = TextEditingController();

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            const SizedBox(
              width: 8.0,
            ),
            Text("+${country.phoneCode}(${country.isoCode})"),
          ],
        ),
      );

  String countryCode = "90";
  String selectedCountry = "TR";

  String phone;

  bool waitingCode = false;

  void showPhoneDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(getString("enterPhoneNumber"),
                      style: const TextStyle(fontSize: 22),
                      textAlign: TextAlign.center),
                  CountryPickerDropdown(
                    initialValue: cCode.split('_')[1],
                    itemBuilder: _buildDropdownItem,
                    priorityList: [
                      CountryPickerUtils.getCountryByIsoCode(
                          cCode.split('_')[1]),
                    ],
                    sortComparator: (Country a, Country b) =>
                        a.phoneCode.compareTo(b.phoneCode),
                    onValuePicked: (Country country) {
                      /* setState(() {
                        selectedCountry = country.isoCode;
                        countryCode = country.phoneCode;
                      }); */
                    },
                  ),
                  CustomTextInput(
                    hintText: "5xxxxxxxxx",
                    inputType: TextInputType.number,
                    onWhite: true,
                    controller: phoneController,
                  ),
                  Builder(builder: (context) {
                    bool loading = false;
                    return StatefulBuilder(builder: (context, setButtonState) {
                      return CustomButton(
                          loading: loading,
                          onWhite: true,
                          onPressed: () async {
                            setButtonState(() {
                              loading = true;
                            });

                            if (phoneController.text.isEmpty) {
                              showSnackBar(context,
                                  getString("phoneCannotBeEmpty"), Colors.red);

                              setButtonState(() {
                                loading = false;
                              });

                              return;
                            } else {
                              setButtonState(() {
                                loading = false;
                                phone = "+$countryCode${phoneController.text}";
                                phoneController.clear();
                              });
                              Navigator.pop(context);
                            }
                          },
                          text: getString("send"));
                    });
                  })
                ],
              ),
            ),
          );
        });

    if (phone != null) {
      /*   setState(() {
        waitingCode = true;
      }); */

      /* await firebaseAuth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            try {
              await firebaseAuth.currentUser.linkWithCredential(credential);

              await firebaseAuth.currentUser.reload();

              showSnackBar(
                  context, getString("verificationSuccess"), Colors.green,
                  ms: 1300);

              await DataBaseManager.userDataDBRef
                  .child("users")
                  .child("${firebaseAuth.currentUser.uid}/phoneVerifieÎd")
                  .set(true);

              localDataBox.put("verified", true);

              setState(() {
                waitingCode = true;
              });

              Navigator.pop(context);
            } on FirebaseAuthException catch (error) {
              if (error.code == "invalid-verification-code") {
                showSnackBar(context, getString("invalidCode"), Colors.red,
                    ms: 1000);

                return;
              }

              DataBaseManager.errorDB
                  .child(
                      "phoneVerifyErrors/${firebaseAuth.currentUser.uid}/${DateTime.now().millisecondsSinceEpoch}")
                  .set({
                "errorCode": error.code,
                "error": error.message,
              });

              showSnackBar(context, error.code, Colors.red, ms: 1000);
            } catch (error) {
              print("Error in catch: $error");
            }
          },
          verificationFailed: (FirebaseAuthException error) {
            print("Error on verification: $error");
            if (error.code == "invalid-phone-number") {
              showSnackBar(context, getString("invalidPhone"), Colors.red,
                  ms: 1000);
              return;
            }

            showSnackBar(context, error.code, Colors.red, ms: 1000);

            DataBaseManager.errorDB
                .child(
                    "phoneVerifyErrors/${firebaseAuth.currentUser.uid}/${DateTime.now().millisecondsSinceEpoch}")
                .set({
              "errorCode": error.code,
              "error": error.message,
            });
          },
          codeSent: (String id, int a) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(getString("enterCode"),
                              style: TextStyle(fontSize: 22),
                              textAlign: TextAlign.center),
                          CustomTextInput(
                            hintText: getString("code"),
                            inputType: TextInputType.number,
                            onWhite: true,
                            controller: code,
                          ),
                          Builder(builder: (context) {
                            bool loading = false;
                            return StatefulBuilder(
                                builder: (context, setButtonState) {
                              return CustomButton(
                                  loading: loading,
                                  onWhite: true,
                                  onPressed: () async {
                                    setButtonState(() {
                                      loading = true;
                                    });

                                    if (code.text.isEmpty) {
                                      showSnackBar(context,
                                          getString("invalidCode"), Colors.red,
                                          ms: 1000);

                                      setButtonState(() {
                                        loading = false;
                                      });

                                      return;
                                    } else {
                                      PhoneAuthCredential credential =
                                          PhoneAuthProvider.credential(
                                              verificationId: id,
                                              smsCode: code.text.trim());

                                      try {
                                        await firebaseAuth.currentUser
                                            .linkWithCredential(credential);

                                        await firebaseAuth.currentUser.reload();

                                        showSnackBar(
                                            context,
                                            getString("verificationSuccess"),
                                            Colors.green,
                                            ms: 1300);

                                        await DataBaseManager.userDataDBRef
                                            .child("users")
                                            .child(
                                                "${firebaseAuth.currentUser.uid}/phoneVerified")
                                            .set(true);

                                        setButtonState(() {
                                          loading = false;

                                          waitingCode = false;

                                          code.clear();
                                        });

                                        localDataBox.put("verified", true);
                                        Navigator.pop(context);
                                      } on FirebaseAuthException catch (error) {
                                        if (error.code ==
                                            "invalid-verification-code") {
                                          showSnackBar(
                                              context,
                                              getString("invalidCode"),
                                              Colors.red,
                                              ms: 1000);
                                          setButtonState(() {
                                            loading = false;

                                            code.clear();
                                          });

                                          return;
                                        }

                                        print(error.code);
                                        DataBaseManager.errorDB
                                            .child(
                                                "phoneVerifyErrors/${firebaseAuth.currentUser.uid}/${DateTime.now().millisecondsSinceEpoch}")
                                            .set({
                                          "errorCode": error.code,
                                          "error": error.message,
                                        });

                                        showSnackBar(
                                            context, error.code, Colors.red,
                                            ms: 1000);
                                        setButtonState(() {
                                          loading = false;

                                          code.clear();
                                        });
                                      } catch (error) {
                                        print("Error in catch: $error");
                                      }
                                    }
                                  },
                                  text: getString("verify"));
                            });
                          })
                        ],
                      ),
                    ),
                  );
                });
          },
          codeAutoRetrievalTimeout: (String a) {}); 
    }*/
    }

    Future showTCDialog() async {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.white,
              child: Container(
                height: 300,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Ödeme almak için TC No gerekli",
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center),
                    CustomTextInput(
                        hintText: "TC",
                        inputType: TextInputType.number,
                        onWhite: true,
                        controller: tcController,
                        validator: (str) {
                          if (str.isEmpty) {
                            return null;
                          }

                          int tc = int.tryParse(str);

                          if (tc == null) {
                            return "Geçersiz TC No";
                          }

                          if (str.length != 11) {
                            return "Geçersiz TC No";
                          }
                          return null;
                        }),
                    Builder(builder: (context) {
                      bool loading = false;
                      return StatefulBuilder(
                          builder: (context, setButtonState) {
                        return CustomButton(
                            loading: loading,
                            onWhite: true,
                            onPressed: () async {
                              setButtonState(() {
                                loading = true;
                              });

                              if (tcController.text.isEmpty) {
                                showSnackBar(context, "TC No boş bırakılamaz",
                                    Colors.red);

                                setButtonState(() {
                                  loading = false;
                                });

                                return;
                              }

                              if (tcController.text.length != 11) {
                                showSnackBar(
                                    context, "Geçersiz TC No", Colors.red);

                                setButtonState(() {
                                  loading = false;
                                });

                                return;
                              }

                              int tc = int.tryParse(tcController.text);

                              if (tc != null) {
                                await DataBaseManager.setTC(tc);

                                setButtonState(() {
                                  loading = false;
                                });
                                Navigator.pop(context);
                              } else {
                                showSnackBar(
                                    context, "Geçersiz TC No", Colors.red);

                                setButtonState(() {
                                  loading = false;
                                });

                                return;
                              }
                            },
                            text: getString("save"));
                      });
                    })
                  ],
                ),
              ),
            );
          });
    }

    String validate(String str) {
      if (str.isEmpty) {
        return null;
      }

      try {
        double value = double.parse(str);

        if (value < 100) {
          return getString("invalidWithdrawAmount");
        } else if (value > balanceNotifier.balance) {
          return getString("insufficientBalance");
        } else {
          return null;
        }
      } catch (e) {
        return getString("invalidWithdrawAmount");
      }
    }

    @override
    void setState(fn) {
      if (mounted) {
        super.setState(fn);
      }
    }

    @override
    void initState() {
      super.initState();
    }

    double tempAmount = 0;
    double totalComission = 0;
    double amount = 0;
    double total = 0;
    double comission;

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Background(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomAppBar(
                  title: getString("withdraw"),
                ),
                CustomTextInput(
                  hintText: getString("amount"),
                  inputType: TextInputType.number,
                  controller: withdrawAmountController,
                  validator: (str) {
                    return validate(str);
                  },
                  onChanged: (str) {
                    if (str.isEmpty) {
                      setState(() {
                        tempAmount = 0;
                        total = 0;
                        totalComission = 0;
                        amount = 0;
                      });

                      return;
                    }

                    try {
                      setState(() {
                        tempAmount = double.parse(str);
                        total = tempAmount;
                        totalComission = total * comission;
                        amount = total - totalComission;
                      });
                    } catch (e) {}
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    children: [
                      Text("${getString("total")}: ",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 22)),
                      const Spacer(),
                      Text(
                        "${total.toStringAsFixed(2)}₺",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    children: [
                      Text("${getString("fee")}: ",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 22)),
                      const Spacer(),
                      Text("${totalComission.toStringAsFixed(2)}₺",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 22))
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    children: [
                      Text("${getString("youGet")}: ",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 22)),
                      const Spacer(),
                      Text("${amount.toStringAsFixed(2)}₺",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 22))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(
                    getString("remainingBalance") +
                        ": " +
                        (balanceNotifier.balance - tempAmount)
                            .toStringAsFixed(3) +
                        "₺",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Builder(builder: (context) {
                  bool withdrawLoading = false;

                  return StatefulBuilder(builder: (context, setButtonState) {
                    return CustomButton(
                        loading: withdrawLoading,
                        onPressed: () async {
                          String withdrawAmount = withdrawAmountController.text;

                          setButtonState(() {
                            withdrawLoading = true;
                          });

                          if (validate(withdrawAmount) != null) {
                            setButtonState(() {
                              withdrawLoading = false;
                            });
                            return;
                          }

                          DataSnapshot phoneVData = await DataBaseManager
                              .userDataDBRef
                              .child(
                                  "users/{firebaseAuth.currentUser.uid}/phoneVerified")
                              .once();

                          bool phoneVerified = phoneVData.value ?? false;

                          if (!phoneVerified) {
                            showSnackBar(context, getString("phoneVRequired"),
                                Colors.red);
                            await Future.delayed(const Duration(seconds: 1));
                            showPhoneDialog();
                            setButtonState(() {
                              withdrawLoading = false;
                            });
                            return;
                          }

                          if (double.parse(withdrawAmount) >
                              balanceNotifier.balance) {
                            showSnackBar(
                                context,
                                getString("insufficientBalance"),
                                Colors.redAccent,
                                ms: 1000);
                            setButtonState(() {
                              withdrawLoading = false;
                            });

                            return;
                          }

                          /*  if (userData["TC"] == 0) {
                            showSnackBar(context, getString("tcRequired"),
                                Colors.redAccent,
                                ms: 1000);
                            setButtonState(() {
                              withdrawLoading = false;
                            });

                            await showTCDialog();
                            return;
                          } */

                          /*  if (userData["iban"] == "") {
                            showSnackBar(
                                context,
                                getString("checkPaymentInfoWarn"),
                                Colors.redAccent,
                                ms: 1000);
                            setButtonState(() {
                              withdrawLoading = false;
                            });

                            return;
                          } */

                          int timeStamp = DateTime.now().millisecondsSinceEpoch;
                          await Future.delayed(
                              const Duration(seconds: 3), () {});
                          // await DataBaseManager.cloudFirestore
                          //     .collection("users")
                          //     .doc('firebaseAuth.currentUser.uid')
                          //     .collection("operationHistory")
                          //     .doc()
                          //     .set({
                          //   "type": "withdraw",
                          //   "timeStamp": timeStamp,
                          //   "operationData": {
                          //     "userID": 'firebaseAuth.currentUser.uid',
                          //     "amount": double.parse(withdrawAmount),
                          //     "status": "pending",
                          //     // pending: Bekliyor
                          //     // completed: Tamamlandı
                          //     // failed: Başarısız
                          //   }
                          // });

                          showSnackBar(context, getString("gotWithdrawRequest"),
                              Colors.green);

                          setButtonState(() {
                            withdrawLoading = false;
                          });
                        },
                        text: getString("requestWithdraw"));
                  });
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "*" + getString("checkPaymentInfo"),
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class DataSnapshot {
  var value;
}
