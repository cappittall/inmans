import 'package:flutter/material.dart';
import 'package:inmans/models/product.model.dart';
import 'package:inmans/a1/pages/register_page.dart';
import 'package:inmans/services/balance_notifier.dart';
import 'package:inmans/services/database/database_manager.dart';
import 'package:inmans/a1/instagramAccounts/broadcast_server.dart';
import 'package:inmans/a1/instagramAccounts/server/interaction_server.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:inmans/a1/utils/navigate.dart';
import 'package:inmans/a1/widgets/background.dart';
import 'package:inmans/a1/widgets/cirlce_check_box.dart';
import 'package:inmans/a1/widgets/custom_app_bar.dart';
import 'package:inmans/a1/widgets/custom_button.dart';
import 'package:inmans/a1/widgets/custom_input_widget.dart';

import 'search_locations.dart';

var dbData = {
  "follow": "usersToFollow",
  "postLike": "postLikes",
  "postSave": "postSaves",
  "postComment": "postComments",
  "commentLike": "commentLikes",
  "reelsLike": "reelsLikes",
  "reelsComment": "reelsComments",
  "igtvLike": "igTVLikes",
  "igtvComment": "igTVComments",
  "postShare": "postShares",
  "videoShare": "videoShares",
  "storyShare": "storyShares",
  "multiUserDM": "multiUserDMs",
  "singleUserDM": "singleUserDMs",
  "liveLike": "liveBroadCastLikes",
  "liveComment": "liveBroadCastComments",
  "spam": "spams",
  "suicideSpam": "suicideSpams",
  "liveWatch": "liveWatches",
};

class BuyFollower extends StatefulWidget {
  final Product product;

  const BuyFollower({Key key, this.product}) : super(key: key);

  @override
  _BuyFollowerState createState() => _BuyFollowerState();
}

class _BuyFollowerState extends State<BuyFollower> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController mediaLinkController = TextEditingController();
  TextEditingController dmMessageController = TextEditingController();

  double totalPrice = 0;

  int quantity = 0;

  bool linkInputRequired = false;

  List<String> linkIDs = [
    "postLike",
    "postSave",
    "postComment",
    "reelsLike",
    "reelsComment",
    "igtvLike",
    "igtvComment",
    "commentLike"
  ];

  bool hideUserName;
  bool textInput;

  void updateQuantity(String qt) {
    if (qt.isEmpty) {
      setState(() {
        totalPrice = 0;
        quantity = 0;
      });
    } else {
      int q = int.parse(qt);
      setState(() {
        quantity = q;
        totalPrice = q * widget.product.price;
      });
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    hideUserName = (widget.product.id.toLowerCase().contains("like") ||
                widget.product.id.contains("Comment")) &&
            widget.product.id != "commentLike" &&
            !widget.product.id.contains("live") ||
        widget.product.id.contains("Save");
    textInput = (widget.product.id.contains("Comment")) ||
        (widget.product.id.toLowerCase().contains("dm"));

    if (linkIDs.contains(widget.product.id)) {
      setState(() {
        linkInputRequired = true;
      });
    }

    DataBaseManager.getSupportedLocations().then((value) {
      setState(() {
        supportedLocations = value;
      });
      print(supportedLocations);
    });
  }

  List genderIDs = ["Kadın", "Erkek", "Both"];
  String selectedGender;

  List selectedLocations = [];
  Map<String, dynamic> supportedLocations;

  String validateQuantity(String str, {bool lastChek = false}) {
    if (str.isEmpty) {
      return null;
    }

    try {
      int value = int.parse(str);
      if (value < widget.product.min || value > widget.product.max) {
        return getString("invalidQuantity");
      } else {
        return lastChek ? "success" : null;
      }
    } catch (e) {
      return getString("invalidQuantity");
    }
  }

  String getInputHintText() {
    String id = widget.product.id;
    String hint = "";

    switch (id) {
      case "multiUserDM":
        hint = getString("enterDMText");
        break;
      case "singleUserDM":
        hint = getString("enterUserText");
        break;
      case "postComment":
      case "igtvComment":
      case "liveComment":
      case "reelsComment":
        hint = getString("enterCommentTexts");
        break;
    }
    return hint;
  }

  List<String> texts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Background(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomAppBar(title: getString(widget.product.id)),
                    if (!hideUserName && widget.product.id != "singleUserDM")
                      CustomTextInput(
                        controller: userNameController,
                        hintText: getString("username"),
                      ),
                    if (widget.product.id == "singleUserDM")
                      CustomTextInput(
                        controller: dmMessageController,
                        hintText: getString("message"),
                      ),
                    CustomTextInput(
                      enabled: !textInput,
                      controller: countController,
                      inputType: TextInputType.number,
                      validator: (String str) {
                        return validateQuantity(str);
                      },
                      onChanged: (String qt) {
                        updateQuantity(qt);
                      },
                      hintText: getString("quantity"),
                    ),
                    if (linkInputRequired)
                      CustomTextInput(
                        hintText: getString("mediaLink"),
                        controller: mediaLinkController,
                        validator: (str) {
                          if (str.isEmpty) {
                            return null;
                          }

                          if (!str.contains("instagram.com")) {
                            return getString("invalidLink");
                          } else {
                            return null;
                          }
                        },
                      ),
                    if (textInput)
                      CustomTextInput(
                        lines: 5,
                        textInputAction: TextInputAction.newline,
                        inputType: TextInputType.multiline,
                        hintText: getInputHintText(),
                        onChanged: (str) {
                          if (str.isEmpty) {
                            setState(() {
                              totalPrice = 0;
                              quantity = 0;
                            });

                            countController.clear();
                            return;
                          }
                          texts = str.split("\n");

                          countController.text = texts.length.toString();
                          updateQuantity(texts.length.toString());
                        },
                      ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 15, top: 5, bottom: 5),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: getString("price") + ": ",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600)),
                        TextSpan(
                            text: totalPrice
                                    .toStringAsFixed(2)
                                    .replaceAll(".", ",") +
                                "₺",
                            style:
                                const TextStyle(color: Colors.white, fontSize: 20)),
                      ])),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Row(
                        children: [
                          Text(
                            getString("selectGender"),
                            style: const TextStyle(fontSize: 19, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    ...genderIDs.map((genderID) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 5),
                        child: SizedBox(
                          height: 30,
                          child: Row(
                            children: [
                              CircleCheckBox(
                                selected: genderID == selectedGender,
                                onSelected: () {
                                  setState(() {
                                    selectedGender = genderID;
                                  });
                                },
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                getString(genderID),
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    if (supportedLocations != null)
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: Row(
                          children: [
                            Text(
                              getString("selectLocations"),
                              style:
                                  const TextStyle(fontSize: 19, color: Colors.white),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () async {
                                  var result = await navigate(
                                      context: context,
                                      page: SearchLocations(
                                        supportedLocations: supportedLocations,
                                        selectedLocations: selectedLocations,
                                        gender: selectedGender ?? "Both",
                                      ));
                                  setState(() {
                                    selectedLocations =
                                        result ?? selectedLocations;
                                  });
                                },
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ),
                    if (supportedLocations != null)
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("*" + getString("leaveLocationsEmpty"),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ),
                        ],
                      ),
                    if (supportedLocations != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Row(
                          children: [
                            Text(
                              getString("locations"),
                              style:
                                  const TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            const Spacer(),
                            Text(
                              getString("userCount"),
                              style:
                                  const TextStyle(fontSize: 20, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    if (supportedLocations != null)
                      SizedBox(
                          height: 350,
                          child: ListView(
                            padding: const EdgeInsets.only(bottom: 30),
                            children: supportedLocations.keys.where((l) {
                              return (supportedLocations[l]["Both"] > 0);
                            }).map((location) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 5),
                                child: SizedBox(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      CircleCheckBox(
                                        selected: selectedLocations
                                            .contains(location),
                                        onSelected: () {
                                          setState(() {
                                            if (selectedLocations
                                                .contains(location)) {
                                              selectedLocations
                                                  .remove(location);
                                            } else {
                                              selectedLocations.add(location);
                                            }
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        location.toString(),
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "${selectedGender == null ? supportedLocations[location]["Both"] : supportedLocations[location][selectedGender] ?? 0}",
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          )),
                    const SizedBox(height: 76),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Builder(builder: (context) {
                  bool buyLoading = false;

                  return StatefulBuilder(builder: (ctx, setBuyState) {
                    return CustomButton(
                        loading: buyLoading,
                        onPressed: () async {
                          int timeStamp = DateTime.now().millisecondsSinceEpoch;

                          setBuyState(() {
                            buyLoading = true;
                          });

                          var result = validateQuantity(quantity.toString(),
                              lastChek: true);

                          if (result == getString("invalidQuantity") ||
                              result == null) {
                            showSnackBar(context, getString("invalidQuantity"),
                                Colors.redAccent,
                                ms: 1000);
                            setBuyState(() {
                              buyLoading = false;
                            });
                            return;
                          }

                          print(selectedLocations);
                          print(selectedGender);

                          int totalSelected = 0;
                          if (selectedLocations.isNotEmpty) {
                            for (var l in selectedLocations) {
                              int countAtLocation = supportedLocations[l]
                                  [selectedGender ?? "Both"];

                              totalSelected += countAtLocation;
                            }
                          } else {
                            for (var l in supportedLocations.keys) {
                              int countAtLocation = supportedLocations[l]
                                  [selectedGender ?? "Both"];
                              print("$countAtLocation -> $l");
                              totalSelected += countAtLocation ?? 0;
                            }
                          }

                          if (quantity > totalSelected) {
                            showSnackBar(
                                context,
                                getString("invalidQuantityLocation"),
                                Colors.red,
                                ms: 1500);
                            setBuyState(() {
                              buyLoading = false;
                            });
                            return;
                          }

                          if (textInput) {
                            if (texts.isEmpty) {
                              showSnackBar(
                                  context,
                                  getString("invalidQuantity"),
                                  Colors.redAccent,
                                  ms: 1000);
                              setBuyState(() {
                                buyLoading = false;
                              });
                              return;
                            }
                          }

                          if (widget.product.id == "singleUserDM") {
                            if (dmMessageController.text.isEmpty) {
                              if (texts.isEmpty) {
                                showSnackBar(
                                    context,
                                    getString("messageEmptyWarn"),
                                    Colors.redAccent,
                                    ms: 1000);
                                setBuyState(() {
                                  buyLoading = false;
                                });
                                return;
                              }
                            }
                          }

                          if (widget.product.id == "multiUserDM") {
                            if (userNameController.text.isEmpty) {
                              if (texts.isEmpty) {
                                showSnackBar(
                                    context,
                                    getString("usernameEmptyWarn"),
                                    Colors.redAccent,
                                    ms: 1000);
                                setBuyState(() {
                                  buyLoading = false;
                                });
                                return;
                              }
                            }
                          }

                          if (totalPrice > balanceNotifier.balance) {
                            showSnackBar(
                                context,
                                getString("insufficientBalance"),
                                Colors.redAccent,
                                ms: 1000);
                            setBuyState(() {
                              buyLoading = false;
                            });
                            return;
                          }

                          String accountID;
                          List<String> accountIDOPs = [
                            "multiUserDM",
                            "follow",
                            "liveLike",
                            "liveComment",
                            "liveWatch",
                            "commentLike",
                            "spam",
                            "suicideSpam",
                          ];

                          String un;

                          if (accountIDOPs.contains(widget.product.id)) {
                            if (userNameController.text.endsWith("/")) {
                              List data = userNameController.text
                                  .split("?")[0]
                                  .split("/");
                              un = data[data.length - 2];
                            } else {
                              un = userNameController.text
                                  .split("?")[0]
                                  .split("/")
                                  .last;
                            }

                            print(un);

                            accountID = await InteractionServer.findAccountID(
                              un.trim(),
                            );
                            print("got account ID: ");
                            print(accountID);
                          }

                          String id;

                          bool invalidLink = false;

                          switch (widget.product.id) {
                            case "commentLike":
                              id = await InteractionServer.findCommentID(
                                userID: accountID,
                                mediaLink:
                                    mediaLinkController.text.split("?")[0],
                              );

                              break;
                            case "multiUserDM":
                            case "follow":
                            case "spam":
                            case "suicideSpam":
                              id = accountID;
                              break;
                            case "postLike":
                            case "postSave":
                            case "postComment":
                            case "reelsLike":
                            case "reelsComment":
                            case "igtvLike":
                            case "igtvComment":
                              id = await InteractionServer.findMediaID(
                                mediaLinkController.text.split("?")[0],
                              );
                              if (id == null) {
                                invalidLink = true;
                              }
                              break;
                            case "liveLike":
                            case "liveComment":
                            case "liveWatch":
                              id = await LiveBroadCastServer.getLiveID(
                                  accountID: accountID);
                          }

                          if (id == "no-broadcast") {
                            showSnackBar(context, getString("noBroadcast"),
                                Colors.redAccent,
                                ms: 1500);
                            setBuyState(() {
                              buyLoading = false;
                            });
                            return;
                          }

                          if (id == null &&
                              widget.product.id != "singleUserDM") {
                            if (invalidLink) {
                              showSnackBar(context, getString("invalidLink"),
                                  Colors.redAccent,
                                  ms: 750);
                              setBuyState(() {
                                buyLoading = false;
                              });
                              return;
                            }

                            print(id);

                            print("error in sud");

                            showSnackBar(
                                context,
                                getString("somethingWentWrong"),
                                Colors.redAccent,
                                ms: 750);
                            setBuyState(() {
                              buyLoading = false;
                            });
                            return;
                          }

                          if (widget.product.id == "singleUserDM") {
                            List<String> tempTexts = [];

                            for (String username in texts) {
                              String userID =
                                  await InteractionServer.findAccountID(
                                username,
                              );
                              tempTexts.add(userID);
                            }
                            texts = tempTexts;
                          }

                          var buyData = {
                            "type": "buy-${widget.product.id}",
                            "timeStamp": timeStamp,
                            "operationData": {
                              "interactionDB": dbData[widget.product.id],
                              "quantity": quantity,
                              "price": totalPrice,
                              "interactionID": id,
                              "username": userNameController.text,
                              "hasGenderTag": !(selectedGender == null ||
                                  selectedGender == "Both"),
                              "locationTags": selectedLocations,
                              "allSelected": selectedLocations ==
                                  supportedLocations.keys.toList(),
                              "texts": texts,
                              "gender": selectedGender,
                              "message": dmMessageController.text,
                            }
                          };

                          await DataBaseManager.cloudFirestore
                              .collection("users")
                              .doc('firebaseAuth.currentUser.uid')
                              .collection("operationHistory")
                              .doc("${widget.product.id}-$un-$timeStamp")
                              .set(buyData);

                          print(buyData);

                          showSnackBar(scaffoldKey.currentContext,
                              getString("operationSuccess"), Colors.black45,
                              ms: 750);
                          setBuyState(() {
                            buyLoading = false;
                          });
                        },
                        text: getString("buy"));
                  });
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
