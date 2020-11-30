class Lord {
  String id;
  String firstName;
  String middleName;
  String surname;
  String title;
  String gender;
  String dob;
  String dobFormatted;
  String age;
  String party;
  String peerageType;
  String beganLording;
  String beganLordingFormatted;
  String beganLordingInYears;
  String isActive;
  List<Interest> interests;
}

class LordBaseList {
  List<LordListedViewModel> member;
}

class LordListedViewModel {
  int memberId;
  String displayName;
  // bool isActive;
}

// Dan do:
class Interest {
  String interestTitle;
  String interestCategory;
}
