import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'timezone.dart';
import 'timezonelist.dart';
import 'timeconverter.dart';
import 'settings.dart';

//******************************************************************************
// Main Application Code
//******************************************************************************

//Runs the application
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Defining the app's title and theme
      title: 'World Clock',
      theme: ThemeData(
          primaryColor: primaryColor,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF03DAC6),
            secondary: const Color(0xFF03DAC6),
          ),
          unselectedWidgetColor: Colors.grey,
          scaffoldBackgroundColor: const Color(0xFF303030),
      ),
      home: const MyHomePage(title: 'World Clock'),
    );
  }
}

//Global variables for later use
const primaryColor = Color(0xff121212);
enum Options {standard, military} // For the time display setting

//******************************************************************************
// Home Page Code
//******************************************************************************

//Defining home page and creating state
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

//Defining home page state
class _MyHomePageState extends State<MyHomePage> {
  //Date and time variables for later use
  DateTime datetime = DateTime.now().toUtc();
  late Timer _everySecond;

  //Timezone default information
  List<TimeZone> timezone = [
    TimeZone('ACT', 'Australia Central Time', 'UTC+9:30', 9, 30, false),
    TimeZone('AET', 'Australia Eastern Time', 'UTC+10:00', 10, 0, false),
    TimeZone('AGT', 'Argentina Standard Time', 'UTC-3:00', -3, 0, false),
    TimeZone('ART', 'Arabic Egypt Standard Time', 'UTC+2:00', 2, 0, false),
    TimeZone('AST', 'Alaska Standard Time', 'UTC-9:00', -9, 0, false),
    TimeZone('BET', 'Brazil Eastern Time', 'UTC-3:00', -3, 0, false),
    TimeZone('BST', 'Bangladesh Standard Time', 'UTC+6:00', 6, 0, false),
    TimeZone('CAT', 'Central African Time', 'UTC-1:00', -1, 0, false),
    TimeZone('CNT', 'Canada Newfoundland Time', 'UTC-3:30', -3, 0, false),
    TimeZone('CST', 'Central Standard Time', 'UTC-6:00', -6, 0, false),
    TimeZone('CTT', 'China Taiwan Time', 'UTC+8:00', 8, 0, false),
    TimeZone('EAT', 'Eastern African Time', 'UTC+3:00', 3, 0, false),
    TimeZone('ECT', 'European Central Time', 'UTC+1:00', 1, 0, false),
    TimeZone('EET', 'Eastern European Time', 'UTC+2:00', 2, 0, false),
    TimeZone('EST', 'Eastern Standard Time', 'UTC-5:00', -5, 0, false),
    TimeZone('HST', 'Hawaii Standard Time', 'UTC-10:00', -10, 0, false),
    TimeZone('IET', 'Indiana Eastern Time', 'UTC-5:00', -5, 0, false),
    TimeZone('IST', 'India Standard Time', 'UTC+5:30', 5, 30, false),
    TimeZone('JST', 'Japan Standard Time', 'UTC+9:00', 9, 0, false),
    TimeZone('MET', 'Middle East Time', 'UTC+3:30', 3, 30, false),
    TimeZone('MIT', 'Midway Islands Time', 'UTC-11:00', -11, 0, false),
    TimeZone('MST', 'Mountain Standard Time', 'UTC-7:00', -7, 0, false),
    TimeZone('NET', 'Near East Time', 'UTC+4:00', 4, 0, false),
    TimeZone('NST', 'New Zealand Standard Time', 'UTC+12:00', 12, 0, false),
    TimeZone('PDT', 'Pacific Daylight Time', 'UTC-7:00', -7, 0, false),
    TimeZone('PLT', 'Pakistan Lahore Time', 'UTC+5:00', 5, 0, false),
    TimeZone('PNT', 'Phoenix Standard Time', 'UTC-7:00', -7, 0, false),
    TimeZone('PRT', 'Puerto Rico & US Virgin Islands Time', 'UTC-4:00', -4, 0, false),
    TimeZone('PST', 'Pacific Standard Time', 'UTC-8:00', -8, 0, false),
    TimeZone('SST', 'Solomon Standard Time', 'UTC+11:00', 11, 0, false),
    TimeZone('UTC', 'Universal Coordinated Time', 'UTC-0:00', 0, 0, false),
    TimeZone('VST', 'Vietnam Standard Time', 'UTC+7:00', 7, 0, false),
  ];

  //Time display settings defaults to standard
  Options? _options = Options.standard;

  //Initializes state by loading any of the user's preferences if available
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initOptions();
      initTimezones();
    });
    super.initState();

    //Updates the time on the cards every second
    _everySecond = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        datetime = DateTime.now().toUtc();
      });
    });
  }

  //Retrieves the user's setting preferences if available
  void initOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _options = EnumToString.fromString(Options.values, prefs.getString("options") ?? "Options.standard");
    setState(() {});
  }

  //Retrieves the user's selected timezones if available
  void initTimezones() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('timezone')) {
      var timezoneList = jsonDecode(prefs.getString('timezone') ?? '') as List;
      timezone = timezoneList.map((timezones) => TimeZone.fromJson(timezones)).toList();
    }
  }

  // Home page consists of:
  //  App bar(title and settings button)
  //  Listview (list tiles with timezone information)
  //  Floating action button (to move to TimeZoneList screen)
  // The user can access the settings or timezone list. They can also view
  // the information of the timezones that they selected. Users can unselect
  // a timezone from this screen as well.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: GoogleFonts.oswald(textStyle: Theme.of(context).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white).headline4),
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                _moveToTimeConverter(context);
              },
              icon: const Icon(
                Icons.compare_arrows,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                _awaitSelectedSettings(context);
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
          )
        ],
        shape: const Border(
            bottom: BorderSide(
                color: Colors.grey,
                width: 2
            )
        ),
        elevation: 8,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: timezone.length,
          itemBuilder: (context, index) {
            if (timezone[index].isOn) {
              return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: _getImage(datetime.add(Duration(
                          hours: timezone[index].offsetHour,
                          minutes: timezone[index].offsetMin))),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ListTile(
                      visualDensity: const VisualDensity(vertical: 4),
                      leading: Text(
                        timezone[index].name,
                        style: GoogleFonts.lato(textStyle: Theme.of(context).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white).headline4),

                      ),
                      title: _options == Options.standard ?
                        Text(
                          DateFormat.Md().add_jm().format(datetime.add(Duration(
                              hours: timezone[index].offsetHour,
                              minutes: timezone[index].offsetMin))),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(textStyle: Theme.of(context).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white).headline4),
                        ):
                        Text(
                          DateFormat.Md().add_Hm().format(datetime.add(Duration(
                              hours: timezone[index].offsetHour,
                              minutes: timezone[index].offsetMin))),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(textStyle: Theme.of(context).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white).headline4),
                        ),
                      trailing: IconButton(
                        onPressed: () async {
                          timezone[index].isOn = false;
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('timezone', jsonEncode(timezone));
                          setState(() {});
                        },
                        icon: const Icon(Icons.cancel),
                        color: Colors.white,

                      ),
                    )
                  )
                );
            }
            return Container();
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _awaitSelectedTimezones(context);
        },
        tooltip: 'Select Timezones To Display',
        child: const Icon(
          Icons.add,
          color: Colors.white
        ),
      ),
    );
  }
  // Waits for selected timezones information from TimeZoneList page
  void _awaitSelectedTimezones(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TimeZoneList(timezone: timezone),
        ));

    setState(() {
      timezone = result;
    });
  }
  // Waits for settings information from Settings page
  void _awaitSelectedSettings(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Settings(options: _options),
        ));

    setState(() {
      _options = result;
    });
  }
  // Determines with image to use depending on the time of the corresponding timezone
  AssetImage _getImage(DateTime datetime) {
    if (datetime.hour > 3 && datetime.hour < 12) {
      return const AssetImage('assets/day.jpg');
    }
    else if (datetime.hour >= 12 && datetime.hour < 18) {
      return const AssetImage('assets/afternoon.jpg');
    }
    else {
      return const AssetImage('assets/night.jpg');
    }
  }

  //Moves to the Time Converter page
  void _moveToTimeConverter(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TimeConverter(timezone: timezone),
        ));
  }
}