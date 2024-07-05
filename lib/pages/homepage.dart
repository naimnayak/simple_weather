import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const Homepage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _searchController = TextEditingController();
  List<String> _recentCities = [];

  @override
  void initState() {
    super.initState();
    _loadRecentCities();
  }

  Future<void> _loadRecentCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentCities = prefs.getStringList('recentCities') ?? [];
    });
  }

  Future<void> _saveRecentCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recentCities', _recentCities);
  }

  void _addRecentCity(String cityName) {
    setState(() {
      if (_recentCities.contains(cityName)) {
        _recentCities.remove(cityName);
      }
      _recentCities.insert(0, cityName);
      if (_recentCities.length > 10) {
        _recentCities.removeLast();
      }
    });
    _saveRecentCities();
  }

  void _deleteRecentCity(String cityName) {
    setState(() {
      _recentCities.remove(cityName);
    });
    _saveRecentCities();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust UI based on the screen size
        double iconSize = constraints.maxWidth > 600 ? 50.0 : 35.0;
        double textSize = constraints.maxWidth > 600 ? 30.0 : 25.0;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'WeatherApp',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Switch(
                  value: widget.isDarkMode,
                  onChanged: widget.onThemeChanged,
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff1D1617).withOpacity(0.11),
                        blurRadius: 40,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: widget.isDarkMode
                          ? Colors.grey[800]
                          : const Color(0xffEFEFEF),
                      contentPadding: const EdgeInsets.all(15),
                      hintText: 'Search Your City',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 167, 166, 166),
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (cityName) {
                      if (cityName.isNotEmpty) {
                        _addRecentCity(cityName);
                        Navigator.pushNamed(
                          context,
                          '/weatherpage',
                          arguments: cityName, // Pass city name as argument
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset('assets/searchimage01.png'),
                const SizedBox(height: 20),
                _recentCities.isEmpty
                    ? const Text('No recent searches')
                    : Column(
                        children: [
                          const Text(
                            'Recently Searched Cities',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _recentCities.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  _recentCities[index],
                                  style: TextStyle(
                                    fontSize:
                                        constraints.maxWidth > 600 ? 20 : 16,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _deleteRecentCity(_recentCities[index]),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/weatherpage',
                                    arguments:
                                        _recentCities[index], // Pass city name as argument
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
