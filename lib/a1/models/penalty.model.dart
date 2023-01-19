class Penalty {
  String type;
  int timeStamp;
  String username;


  Penalty({this.username, this.timeStamp, this.type});

  static fromDoc(e) {}

  /* factory Penalty.fromDoc(DocumentSnapshot doc) {
    return Penalty(
      username: doc.get("username"),
      timeStamp: doc.get("timeStamp"),
      type: doc.get("type"),
    );
  } */
}