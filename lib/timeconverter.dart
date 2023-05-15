import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'timezone.dart';

//******************************************************************************
// Time Converter Code
//******************************************************************************

const primaryColor = Color(0xff121212);

// Defining TimeConverter and creating state
class TimeConverter extends StatefulWidget {
  List<TimeZone> timezone;
  TimeConverter({required this.timezone});

  @override
  _TimeConverterState createState() {
    return _TimeConverterState();
  }
}

// TimeConverter contains:
//   App bar (return button and title)
//   TextButton to allow date & time input
//   Two dropdown lists for timezone input
//   Elevated button to submit input
//   Text to display output of conversion
class _TimeConverterState extends State<TimeConverter> {
  String selectedValue1 = "0";
  String selectedValue2 = "0";
  List<DropdownMenuItem<String>> dropdownItems = [];
  DateTime datetime = DateTime.now();
  String results = "Results:";
  String error = "";

  @override
  void initState() {
    super.initState();

    dropdownItems = List.generate(
      widget.timezone.length,
          (index) => DropdownMenuItem(
        value: "$index",
        child: Text(
          widget.timezone[index].name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Time Converter',
          style: GoogleFonts.oswald(textStyle: Theme.of(context).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white).headline4),
        ),
        centerTitle: true,
        shape: const Border(
            bottom: BorderSide(
                color: Colors.grey,
                width: 2
            )
        ),
        elevation: 8,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: Color(0xFF404040), borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () {
                  pickDateTime();
                },
                child: Text(
                  DateFormat.yMd().add_jm().format(datetime),
                  style: GoogleFonts.lato(color: Colors.white, fontSize: 35),
                ),
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xFF404040))),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: Color(0xFF404040), borderRadius: BorderRadius.circular(10)),
              child: DropdownButton<String>(
                items: dropdownItems,
                value: selectedValue1,
                dropdownColor: const Color(0xFF404040),
                style: GoogleFonts.lato(color: Colors.white, fontSize: 35),
                onChanged: (value) {
                  setState(() {
                    selectedValue1 = value!;
                    results = "Results:";
                    error = "";
                  });
                },
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 42,
                underline: SizedBox(),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(
                Icons.keyboard_double_arrow_down,
                color: Colors.white,
                size: 75,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                  color: Color(0xFF404040), borderRadius: BorderRadius.circular(10)),
              child: DropdownButton<String>(
                items: dropdownItems,
                value: selectedValue2,
                dropdownColor: const Color(0xFF404040),
                style: GoogleFonts.lato(color: Colors.white, fontSize: 35),
                onChanged: (value) {
                  setState(() {
                    selectedValue2 = value!;
                    results = "Results:";
                    error = "";
                  });
                },
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 42,
                underline: SizedBox(),
              ),
            ),
            Text(
              error,
              style: GoogleFonts.lato(color: const Color(0xFFCF6679), fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)),
              child: ElevatedButton(
                onPressed: () {
                  if (selectedValue1 != selectedValue2) {
                    results = DateFormat.yMd().add_jm().format(datetime.add(Duration(
                        hours: -widget.timezone[int.parse(selectedValue1)].offsetHour + widget.timezone[int.parse(selectedValue2)].offsetHour,
                        minutes: -widget.timezone[int.parse(selectedValue1)].offsetMin + widget.timezone[int.parse(selectedValue2)].offsetMin)));
                    error = "";
                  }
                  else {
                    results = "Results:";
                    error = "Please select two different timezones.";
                  }
                  setState(() {});
                },
                child: Text(
                  'Convert',
                  style: GoogleFonts.oswald(color: Colors.white, fontSize: 35),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white, width: 3)),
              child: Text(
                results,
                style: GoogleFonts.lato(color: Colors.white, fontSize: 35),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) {
      return;
    }

    TimeOfDay? time = await pickTime();
    if (time == null) {
      return;
    }

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      datetime = dateTime;
      results = "Results:";
      error = "";
    });
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: datetime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget ?child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.grey,
            splashColor: Color(0xFF03DAC6),
            colorScheme: ColorScheme.dark(
                primary: Color(0xFF03DAC6),
                onSecondary: Color(0xFF03DAC6),
                onPrimary: Colors.white,
                surface: Color(0xFF575757),
                onSurface: Colors.white,
                secondary: Color(0xFF03DAC6)),
            dialogBackgroundColor: Color(0xFF404040),
          ),
          child: child ??Text(""),
        );
      }
  );

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(datetime),
      builder: (BuildContext context, Widget ?child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.grey,
            splashColor: Color(0xFF03DAC6),
            colorScheme: ColorScheme.dark(
                primary: Color(0xFF03DAC6),
                onSecondary: Color(0xFF03DAC6),
                onPrimary: Colors.white,
                surface: Color(0xFF404040),
                onSurface: Colors.white,
                secondary: Color(0xFF03DAC6)),
            dialogBackgroundColor: Color(0xFF404040),
          ),
          child: child ??Text(""),
        );
      }
  );
}