import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:project_tpm/http_request/character_model.dart';
import 'package:project_tpm/http_request/api_data_source.dart';
import 'package:project_tpm/secreen/detail_chara_secreen.dart';

const accessoriesColor = Colors.teal;
const backgroundColor = Colors.white;

class ListChara extends StatefulWidget {
  const ListChara({Key? key}) : super(key: key);

  @override
  _ListCharaState createState() => _ListCharaState();
}

class _ListCharaState extends State<ListChara> {
  String _searchQuery = '';
  String _selectedCurrency = 'USD';
  double _conversionRate = 1.0;
  String _selectedTimeZone = 'UTC';
  DateTime _currentTime = DateTime.now().toUtc();

  Map<String, double> characterPrices = {
    'Rick Sanchez': 10.0,
    'Morty Smith': 75.0,
    'Summer Smith': 50.0,
    'Beth Smith': 25.0,
    'Jerry Smith': 27.0,
    'Abadango Cluster Princess': 30.0,
    'Abradolf Lincler': 45.0,
    'Adjudicator Rick': 65.0,
    'Agency Director': 80.0,
    'Alan Rails': 90.0,
    'Albert Einstein': 97.0,
    'Alexander': 60.0,
    'Alien Googah': 70.0,
    'Alien Morty': 85.0,
    'Alien Rick': 80.0,
    'Amish Cyborg': 80.0,
    'Annie': 95.0,
    'Antenna Morty': 60.0,
    'Antenna Rick': 35.0,
    'Ants in my Eyes Johnson': 45.0,
  };

  @override
  void initState() {
    super.initState();
    _fetchConversionRate();
    _updateTime();
  }

Future<void> _fetchConversionRate() async {
  // URL API yang akan digunakan untuk mendapatkan nilai tukar mata uang
  String apiUrl = 'https://api.exchangerate-api.com/v4/latest/USD';

  try {
    // Mengirim permintaan HTTP GET ke URL API
    final response = await http.get(Uri.parse(apiUrl));

    // Memeriksa apakah permintaan berhasil (status code 200)
    if (response.statusCode == 200) {
      // Menguraikan data JSON dari respons API
      var data = json.decode(response.body);

      // Memperbarui state aplikasi dengan nilai tukar yang diambil dari API
      setState(() {
        // Jika mata uang yang dipilih adalah USD, nilai tukar diatur ke 1.0
        if (_selectedCurrency == 'USD') {
          _conversionRate = 1.0;
        } else {
          // Jika mata uang yang dipilih bukan USD, ambil nilai tukarnya dari data JSON
          _conversionRate = data['rates'][_selectedCurrency] ?? 1.0;
        }
      });
    } else {
      // Jika status code bukan 200, lempar pengecualian dengan pesan kesalahan
      throw Exception('Failed to load exchange rate');
    }
  } catch (e) {
    // Menangkap pengecualian dan mencetak pesan kesalahan
    print(e);
  }
}


String getCurrencySymbol(String currencyCode) {
  switch (currencyCode) {
    case 'USD':
      return '\$'; // Simbol untuk Dolar Amerika Serikat
    case 'EUR':
      return '€'; // Simbol untuk Euro
    case 'IDR':
      return 'Rp'; // Simbol untuk Rupiah Indonesia
    default:
      return ''; // Mengembalikan string kosong jika kode mata uang tidak ditemukan
  }
}


String formatPrice(double price, String currencyCode) {
  // Membuat formatter dengan NumberFormat.currency
  final formatter = NumberFormat.currency(
    locale: 'en_US', // Menggunakan format lokal Amerika Serikat
    symbol: getCurrencySymbol(currencyCode), // Mendapatkan simbol mata uang
    decimalDigits: price == price.toInt() ? 0 : 2, // Menentukan jumlah digit desimal
  );
  return formatter.format(price); // Mengembalikan harga yang sudah diformat
}

DateTime getCurrentTime(String timeZone) {
  // Mendapatkan waktu saat ini dalam format UTC
  DateTime now = DateTime.now().toUtc();
  
  // Menggunakan switch-case untuk menentukan penyesuaian waktu berdasarkan zona waktu yang diberikan
  switch (timeZone) {
    case 'WITA':
      // Waktu Indonesia Tengah (UTC +8)
      return now.add(const Duration(hours: 8));
    case 'WIT':
      // Waktu Indonesia Timur (UTC +9)
      return now.add(const Duration(hours: 9));
    case 'London':
      // Waktu London (UTC +1)
      return now.add(const Duration(hours: 1));
    case 'WIB':
      // Waktu Indonesia Barat (UTC +7)
      return now.add(const Duration(hours: 7));
    case 'UTC':
    default:
      // Jika zona waktu adalah 'UTC' atau tidak ada yang cocok, kembalikan waktu sekarang dalam UTC
      return now;
  }
}

  void _updateTimeZone(String timeZone) {
    setState(() {
      _selectedTimeZone = timeZone;
      _currentTime = getCurrentTime(timeZone);
    });
  }

 void _updateTime() {
  // Memperbarui waktu saat ini sesuai dengan zona waktu yang dipilih
  _currentTime = getCurrentTime(_selectedTimeZone);

  // Menunda eksekusi selama 1 detik
  Future.delayed(Duration(seconds: 1), () {
    // Memperbarui state untuk memicu pembaruan UI
    setState(() {
      // Memanggil fungsi ini lagi untuk memperbarui waktu secara terus-menerus setiap detik
      _updateTime();
    });
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: accessoriesColor,
              child: Column(
                children: [
                  SearchBar(
                    onSearchChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                  CurrencySelector(
                    selectedCurrency: _selectedCurrency,
                    onCurrencyChanged: (String? newValue) {
                      setState(() {
                        _selectedCurrency = newValue!;
                        _fetchConversionRate();
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      CharacterList(
                        searchQuery: _searchQuery,
                        conversionRate: _conversionRate,
                        selectedCurrency: _selectedCurrency,
                        characterPrices: characterPrices,
                        formatPrice: formatPrice,
                      ),
                      TimeConversionSection(
                        selectedTimeZone: _selectedTimeZone,
                        currentTime: _currentTime,
                        onTimeZoneChanged: (String? newValue) {
                          if (newValue != null) {
                            _updateTimeZone(newValue);
                          }
                        },
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;

  const SearchBar({required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: TextField(
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.white12,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class CurrencySelector extends StatelessWidget {
  final String selectedCurrency;
  final ValueChanged<String?> onCurrencyChanged;

  const CurrencySelector({
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Currency: ', style: TextStyle(color: Colors.white)),
          DropdownButton<String>(
            value: selectedCurrency,
            dropdownColor: accessoriesColor,
            onChanged: onCurrencyChanged,
            items: <String>['USD', 'EUR', 'IDR']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class CharacterList extends StatelessWidget {
  final String searchQuery;
  final double conversionRate;
  final String selectedCurrency;
  final Map<String, double> characterPrices;
  final String Function(double, String) formatPrice;

  const CharacterList({
    required this.searchQuery,
    required this.conversionRate,
    required this.selectedCurrency,
    required this.characterPrices,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiDataSource.instance.loadCharacter(),
      builder: (
        BuildContext context,
        AsyncSnapshot<dynamic> snapshot,
      ) {
        if (snapshot.hasError) {
          return Center(child: Text("Error"));
        }
        if (snapshot.hasData) {
          ListCharacterModel listCharacterModel =
              ListCharacterModel.fromJson(snapshot.data);
          return _buildSuccessSection(listCharacterModel);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildSuccessSection(ListCharacterModel data) {
    List<Results> filteredList = data.results!
        .where((charaResults) => charaResults.name!
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredList.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemChara(filteredList[index], context);
      },
    );
  }

  Widget _buildItemChara(Results charaResults, BuildContext context) {
    double? characterPrice = characterPrices[charaResults.name];
    double convertedPrice = (characterPrice ?? 0.0) * conversionRate;
    String formattedPrice = formatPrice(convertedPrice, selectedCurrency);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: InkWell(
        child: Card(
          color: accessoriesColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                width: 90,
                height: 90,
                child: Image.network(charaResults.image!),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      charaResults.name!,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(
                      charaResults.species!,
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Price: $formattedPrice',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailChara(character: {
                'name': charaResults.name,
                'status': charaResults.status,
                'species': charaResults.species,
                'gender': charaResults.gender,
                'image': charaResults.image,
                'price': characterPrice,
              }),
            ),
          );
        },
      ),
    );
  }
}

class TimeConversionSection extends StatelessWidget {
  final String selectedTimeZone;
  final DateTime currentTime;
  final ValueChanged<String?> onTimeZoneChanged;

  const TimeConversionSection({
    required this.selectedTimeZone,
    required this.currentTime,
    required this.onTimeZoneChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Format waktu hingga detik
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedTime = formatter.format(currentTime);

    return Container(
      padding: EdgeInsets.all(20),
      color: accessoriesColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Time:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                '$selectedTimeZone: $formattedTime',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          DropdownButton<String>(
            value: selectedTimeZone,
            dropdownColor: accessoriesColor,
            onChanged: onTimeZoneChanged,
            items: <String>['UTC', 'WIB', 'WITA', 'WIT', 'London']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
