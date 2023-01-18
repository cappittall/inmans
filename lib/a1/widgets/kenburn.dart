import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inmans/a1/pages/home_page.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:inmans/a1/widgets/ggy_loading_indicator.dart';

class KenburnSlider extends StatefulWidget {
  final List<MostEarner> mostEarnings;

  const KenburnSlider({Key key, this.mostEarnings}) : super(key: key);

  @override
  _KenburnSliderState createState() => _KenburnSliderState();
}

class _KenburnSliderState extends State<KenburnSlider> {
  int currentIndex = 0;

  Timer timer;

  void startSlide() {
    timer = Timer.periodic(const Duration(seconds: 4), (t) {
      if (widget.mostEarnings != null) {
        if (currentIndex == widget.mostEarnings.length - 1) {
          setState(() {
            currentIndex = 0;
          });
        } else {
          setState(() {
            currentIndex++;
          });
        }
      }
    });
  }

  @override
  void initState() {
    startSlide();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: widget.mostEarnings != null
          ? Stack(
              children: widget.mostEarnings.map((earner) {
                bool isCurrent =
                    widget.mostEarnings.indexOf(earner) == currentIndex;

                return AnimatedOpacity(
                  key: Key(earner.hashCode.toString()),
                  opacity: isCurrent ? 1 : 0,
                  duration: const Duration(milliseconds: 1100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Material(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: SizedBox(
                        height: 450,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            SizedBox(
                                height: 450,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(earner.image),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            Container(
                              height: 450,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.8),
                                    ]),
                              ),
                            ),
                            Positioned(
                              bottom: 40,
                              left: 15,
                              child: Text(
                                earner.name,
                                style: const TextStyle(
                                    fontSize: 26, color: Colors.white),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 15,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${getString("earning")}: ",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    ),
                                    TextSpan(
                                      text: earner.earning.toString() + "₺",
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
          : const Center(
              child:
                  SizedBox(height: 25, width: 25, child: LoadingIndicator()),
            ),
    );
  }
}
