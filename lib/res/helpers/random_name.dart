import 'dart:math';

class RandomName {
  static final List<String> randomPeople = [
    "Andi Saputra",
    "Siti Aisyah",
    "Budi Santoso",
    "Dewi Lestari",
    "Rudi Hartono",
    "Fitriani Putri",
    "Agus Pratama",
    "Maya Sari",
    "Joko Susilo",
    "Intan Permata",
    "Hendra Wijaya",
    "Nina Kartika",
    "Fajar Maulana",
    "Lina Marlina",
    "Doni Kurniawan",
    "Ratna Dewi",
    "Bayu Setiawan",
    "Mega Puspita",
    "Eko Yulianto",
    "Tina Anjani",
  ];

  static String getRandomName() {
    final random = Random();
    return randomPeople[random.nextInt(randomPeople.length)];
  }
}