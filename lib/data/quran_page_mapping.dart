// Surah starting pages (standard 15-line Madani Mushaf)
const Map<int, int> surahStartPage = {
  1: 2,    // Al-Fatihah
  2: 3,    // Al-Baqarah
  3: 68,   // Aal-E-Imran
  4: 106,   // An-Nisa
  5: 147,  // Al-Ma'idah
  6: 177,  // Al-An'am
  7: 209,  // Al-A'raf
  8: 246,  // Al-Anfal
  9: 260,  // At-Tawbah
  10: 288, // Yunus
  11: 308, // Hud
  12: 328, // Yusuf
  13: 346, // Ar-Ra'd
  14: 355, // Ibrahim
  15: 364, // Al-Hijr
  16: 372, // An-Nahl
  17: 393, // Al-Isra
  18: 408, // Al-Kahf
  19: 425, // Maryam
  20: 435, // Ta-Ha
  21: 449, // Al-Anbiya
  22: 462, // Al-Hajj
  23: 477, // Al-Mu'minun
  24: 487, // An-Nur
  25: 501, // Al-Furqan
  26: 511, // Ash-Shu'ara
  27: 525, // An-Naml
  28: 537, // Al-Qasas
  29: 552, // Al-Ankabut
  30: 562, // Ar-Rum
  31: 571, // Luqman
  32: 577, // As-Sajdah
  33: 581, // Al-Ahzab
  34: 595, // Saba
  35: 603, // Fatir
  36: 611, // Ya-Sin
  37: 618, // As-Saffat
  38: 628, // Sad
  39: 635, // Az-Zumar
  40: 647, // Ghafir
  41: 659, // Fussilat
  42: 668, // Ash-Shuraa
  43: 677, // Az-Zukhruf
  44: 686, // Ad-Dukhan
  45: 691, // Al-Jathiyah
  46: 697, // Al-Ahqaf
  47: 704, // Muhammad
  48: 710, // Al-Fath
  49: 716, // Al-Hujurat
  50: 721, // Qaf
  51: 725, // Adh-Dhariyat
  52: 729, // At-Tur
  53: 732, // An-Najm
  54: 736, // Al-Qamar
  55: 740, // Ar-Rahman
  56: 745, // Al-Waqi'ah
  57: 750, // Al-Hadid
  58: 757, // Al-Mujadila
  59: 761, // Al-Hashr
  60: 766, // Al-Mumtahanah
  61: 770, // As-Saff
  62: 773, // Al-Jumu'ah
  63: 775, // Al-Munafiqun
  64: 777, // At-Taghabun
  65: 780, // At-Talaq
  66: 783, // At-Tahrim
  67: 787, // Al-Mulk
  68: 790, // Al-Qalam
  69: 794, // Al-Haqqah
  70: 797, // Al-Ma'arij
  71: 800, // Nuh
  72: 803, // Al-Jinn
  73: 806, // Al-Muzzammil
  74: 808, // Al-Muddaththir
  75: 811, // Al-Qiyamah
  76: 813, // Al-Insan
  77: 816, // Al-Mursalat
  78: 819, // An-Naba
  79: 820, // An-Nazi'at
  80: 822, // Abasa
  81: 824, // At-Takwir
  82: 825, // Al-Infitar
  83: 826, // Al-Mutaffifin
  84: 828, // Al-Inshiqaq
  85: 829, // Al-Buruj
  86: 830, // At-Tariq
  87: 831, // Al-A'la
  88: 832, // Al-Ghashiyah
  89: 833, // Al-Fajr
  90: 835, // Al-Balad
  91: 836, // Ash-Shams
  92: 837, // Al-Layl
  93: 838, // Ad-Duhaa
  94: 838, // Ash-Sharh
  95: 839, // At-Tin
  96: 839, // Al-Alaq
  97: 840, // Al-Qadr
  98: 840, // Al-Bayyinah
  99: 841, // Az-Zalzalah
  100: 842, // Al-Adiyat
  101: 843, // Al-Qari'ah
  102: 843, // At-Takathur
  103: 844, // Al-Asr
  104: 844, // Al-Humazah
  105: 844, // Al-Fil
  106: 845, // Quraysh
  107: 845, // Al-Ma'un
  108: 846, // Al-Kawthar
  109: 846, // Al-Kafirun
  110: 846, // An-Nasr
  111: 847, // Al-Masad
  112: 847, // Al-Ikhlas
  113: 847, // Al-Falaq
  114: 848, // An-Nas
};

// Para starting pages (standard 15-line Madani Mushaf)
const Map<int, int> paraStartPage = {
  1: 2,
  2: 29,
  3: 57,
  4: 85,
  5: 113,
  6: 141,
  7: 169,
  8: 197,
  9: 225,
  10: 253,
  11: 281,
  12: 309,
  13: 337,
  14: 365,
  15: 393,
  16: 421,
  17: 449,
  18: 477,
  19: 505,
  20: 533,
  21: 559,
  22: 587,
  23: 613,
  24: 641,
  25: 667,
  26: 697,
  27: 727,
  28: 757,
  29: 787,
  30: 819,
};

/// Get Surah starting page
int getSurahPage(int surahNumber) {
  return surahStartPage[surahNumber] ?? 1;
}

/// Get Para starting page
int getParaPage(int paraNumber) {
  return paraStartPage[paraNumber] ?? 1;
}