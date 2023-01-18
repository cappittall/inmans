import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:inmans/a1/models/bill.model.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class BillPDFView extends StatefulWidget {
  final BillModel billModel;

  const BillPDFView({Key key, this.billModel}) : super(key: key);

  @override
  _BillPDFViewState createState() => _BillPDFViewState();
}

class _BillPDFViewState extends State<BillPDFView> {
  PdfController controller;

  @override
  void initState() {
    controller = PdfController(
        document: PdfDocument.openFile(
          widget.billModel.pdfLink,
        ),
        viewportFraction: 0.8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
                Platform.isAndroid
                    ? Icons.arrow_left_outlined
                    : Icons.chevron_left,
                size: 30,
                color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
              onPressed: () {
                FlutterShare.shareFile(
                    title: "Together Earn Bill Service",
                    text: widget.billModel.operationID,
                    filePath: widget.billModel.pdfLink);
              },
              icon: Platform.isAndroid
                  ? const Icon(Icons.share, color: Colors.black)
                  : const Icon(CupertinoIcons.share, color: Colors.black))
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: PdfView(
          controller: controller,
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}
