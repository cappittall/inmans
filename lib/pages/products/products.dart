import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:inmans/models/product.model.dart';
import 'package:inmans/pages/products/buy_product.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:inmans/a1/utils/navigate.dart';
import 'package:inmans/a1/widgets/background.dart';
import 'package:inmans/a1/widgets/custom_app_bar.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  CollectionReference productsRef;

  void fetchData() async {/* 
    Uri uriforinsremove = Uri.parse(
      "http://127.0.0.1:8000/api/getproducts/",
    );
    final dataforinstadd = await http.get(
      uriforinsremove,
    );
    print(dataforinstadd.statusCode);
    if (dataforinstadd.statusCode == 200) {
      var unescape = new HtmlUnescape();
      var converted = unescape.convert(dataforinstadd.body);
      var jsondata = jsonDecode(converted);
      print("deneme: $jsondata");
      if (jsondata["status"] == "sucsses")
        for (int i = 0; i < jsondata["products"].length; i++) {
          products.add(Product.fromDoc(jsondata["products"][i]));
        }
      setState(() {});
    }

    DataBaseManager.db.child("productsVersion").once().then((value) {
      double productsVersion = value.value.toDouble();

      Source source;

      String key = "productsVersion";

      if (localDataBox.containsKey(key)) {
        double localVersion = localDataBox.get(key);

        if (localVersion < productsVersion) {
          source = Source.server;
          localDataBox.put(key, productsVersion);
        } else {
          source = Source.cache;

          /// Get data from local
        }
      } else {
        source = Source.server;
        localDataBox.put(key, productsVersion);

        /// get new data
      }
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Container(
          child: Column(
            children: [
              CustomAppBar(
                title: getString("products"),
              ),
              if (products.isNotEmpty)
                Expanded(
                  child: ListView(
                    itemExtent: 105,
                    cacheExtent: 20,
                    padding: const EdgeInsets.only(bottom: 60),
                    children: products.map((product) {
                      return CupertinoButton(
                        key: Key(product.id),
                        onPressed: () {
                          navigate(
                              context: context,
                              page: BuyFollower(
                                product: product,
                              ));
                        },
                        padding:
                            const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.white,
                          elevation: 5,
                          child: Container(
                            height: 90,
                            padding:
                                const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                            width: double.infinity,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      getString(product.id),
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Minimum: ${product.min}",
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                    Text(
                                      "Maximum: ${product.max}",
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.end,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                                  "${(product.price * 1000).toString().replaceAll(".", ",")}₺",
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 30)),
                                          TextSpan(
                                              text:
                                                  "\n1000 ${getString("interaction")}",
                                              style: const TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class Source {
  static Source server;

  static Source cache;
}

class CollectionReference {
  orderBy(String s, {bool descending}) {}

  doc(uid) {}
}
