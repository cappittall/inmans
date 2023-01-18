import 'package:flutter/material.dart';
import 'package:inmans/a1/widgets/background.dart';
import 'package:inmans/a1/widgets/cirlce_check_box.dart';
import 'package:inmans/a1/widgets/custom_input_widget.dart';

class SearchLocations extends StatefulWidget {
  final Map<String, dynamic> supportedLocations;
  final List selectedLocations;
  final String gender;

  const SearchLocations(
      {Key key, this.supportedLocations, this.selectedLocations, this.gender})
      : super(key: key);

  @override
  _SearchLocationsState createState() => _SearchLocationsState();
}

class _SearchLocationsState extends State<SearchLocations> {
  String filter = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.selectedLocations);
        return true;
      },
      child: Scaffold(
        body: Background(
          child: Container(
            child: Column(
              children: [
                const SizedBox(height: 40),
                CustomTextInput(
                  onChanged: (str) {
                    setState(() {
                      filter = str;
                    });
                  },
                  prefix: IconButton(
                    onPressed: () {
                      Navigator.pop(context, widget.selectedLocations);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                    child: ListView(
                  padding: EdgeInsets.zero,
                  children: widget.supportedLocations.keys
                      .where((element) => element.contains(filter))
                      .map((location) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      child: SizedBox(
                        height: 30,
                        child: Row(
                          children: [
                            CircleCheckBox(
                              selected:
                                  widget.selectedLocations.contains(location),
                              onSelected: () {
                                setState(() {
                                  if (widget.selectedLocations
                                      .contains(location)) {
                                    widget.selectedLocations.remove(location);
                                  } else {
                                    widget.selectedLocations.add(location);
                                  }
                                });
                              },
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              location,
                              style:
                                  const TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            const Spacer(),
                            Text(
                              widget.supportedLocations[location]
                                          [widget.gender] !=
                                      null
                                  ? widget.supportedLocations[location]
                                          [widget.gender]
                                      .toString()
                                  : "0",
                              style:
                                  const TextStyle(fontSize: 20, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
