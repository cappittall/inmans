
class BillModel {
  String userID;
  String type;
  String pdfLink;
  String operationID;
  int timeStamp;
  double amount;

  BillModel(
      {this.userID, this.type, this.pdfLink, this.operationID, this.timeStamp, this.amount});

  factory BillModel.fromLocalData(var data) {
    return BillModel(
      operationID: data["operationID"],
      timeStamp: data["timeStamp"],
      userID: data["userID"],
      type: data["type"],
      pdfLink: data["pdfLink"]??'',
      amount: data["amount"].toDouble(),
    );
  }
}
