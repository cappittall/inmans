class OperationHistory {
  String id;
  bool ghost;
  Map operationData;
  String timeStamp;
  String type;
  double paidAmount;

  OperationHistory({
    this.ghost,
    this.operationData,
    this.timeStamp,
    this.type,
    this.id,
    this.paidAmount
  });

  factory OperationHistory.fromDoc(doc) {


    return OperationHistory(
      ghost: doc['ghost'],
      operationData: doc['operation_data'],
      timeStamp: doc['time_stampt'].toString(),
      type: doc['type'],
      id: doc['id'].toString(),
      paidAmount: doc['amount'],
    );
  } 
}
