import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/view/favourites_view.dart';
import 'package:my_movie/view/movie_list_view.dart';

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "translate('app.title')",
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentSearch = "";
  int _selectedIndex = 0;

  final Color primaryColor = const Color(0xFF2E4057);
  final Color secondaryColor = const Color(0xFF66A182);

  static const List<Widget> _pages = <Widget>[
    MovieListView(),
    FavouritesView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.of(context)!.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.movie),
              label: AppLocalizations.of(context)!.movies,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite),
              label: AppLocalizations.of(context)!.favourites,
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: secondaryColor,
        ),
      ),
    );
  }
}
