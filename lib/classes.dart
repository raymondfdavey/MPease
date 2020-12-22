class LordBaseList {
  List<Lord> member;
}

class Lord {
  int memberId;
  String displayName;
  String memberFrom;
  String party;
  DateTime dob;
  List<Interest> interests;
}

// Dan do:
class Interest {
  String interestTitle;
  String interestCategory;
}
