// List<Map> maps = [
//   {"ID": "1", "name": "Ray", "age": "12"},
//   {"ID": "2", "name": "Bill", "age": "17"},
//   {"ID": "3", "name": "Kinga", "age": "16"},
//   {"ID": "4", "name": "Dan", "age": "14"}
// ];
// List<People> mergeLists(List<People> listOfClasses, List<Map> listOfMaps) {
//   print("IN MERGE LISTS");
//   // for (var i = 0; i <= 3; i++) {
//   //   print(people[i].id);
//   //   print(people[i].name);
//   //   print(people[i].age);

//   //   print(maps[i]["ID"]);
//   //   print(maps[i]["name"]);
//   //   print(maps[i]["age"]);
//   // }
//   Map match;
//   listOfClasses.forEach(
//     (lordClass) => {
//       match = listOfMaps
//           .firstWhere((lordMap) => lordMap["@Member_Id"] == lordClass.id),
//       lordClass.gender = match["Gender"],
//       lordClass.dob = match["DateOfBirth"],
//       lordClass.party = match["Party"]["#text"],
//       lordClass.peerageType = match["MemberFrom"],
//       lordClass.beganLording = match["HouseStartDate"],
//       lordClass.isActive = match["CurrentStatus"]["@IsActive"],
//     },
//   );
//   // for (var i = 0; i <= 3; i++) {
//   //   print(people[i].id);
//   //   print(people[i].name);
//   //   print(people[i].age);

//   //   print(maps[i]["ID"]);
//   //   print(maps[i]["name"]);
//   //   print(maps[i]["age"]);
//   // }
//   return listOfClasses;
// }

// class People {
//   String id;
//   String name = "ALAN";
//   String age;

//   People(String id) {
//     this.id = id;
//   }
// }

// List<People> makeClassList(int someNum) {
//   List<People> classList = [];
//   String str;
//   for (var i = 1; i <= someNum; i++) {
//     // print(i);
//     str = i.toString();
//     classList.add(new People(str));
//   }
//   return classList;
// }

// void main() {
//   List<People> classList = makeClassList(4);

//   classList.forEach((person) => {print(person.id), print(person.name)});

//   List<People> merger = mergeLists(classList, maps);
//   merger.forEach(
//       (person) => {print(person.id), print(person.name), print(person.age)});
// }

// List<People> mergeLists(List<People> listOfClasses, List<Map> listOfMaps) {
//   print("IN MERGE LISTS");
//   // for (var i = 0; i <= 3; i++) {
//   //   print(people[i].id);
//   //   print(people[i].name);
//   //   print(people[i].age);

//   //   print(maps[i]["ID"]);
//   //   print(maps[i]["name"]);
//   //   print(maps[i]["age"]);
//   // }
//   Map match;
//   listOfClasses.forEach(
//     (person) => {
//       match = listOfMaps.firstWhere((map) => map["ID"] == person.id),
//       person.name = match["name"],
//       person.age = match["age"],
//     },
//   );
//   // for (var i = 0; i <= 3; i++) {
//   //   print(people[i].id);
//   //   print(people[i].name);
//   //   print(people[i].age);

//   //   print(maps[i]["ID"]);
//   //   print(maps[i]["name"]);
//   //   print(maps[i]["age"]);
//   // }
//   return listOfClasses;
// }
