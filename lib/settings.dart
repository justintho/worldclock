import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

//******************************************************************************
// Settings Page Code
//******************************************************************************

const primaryColor = Color(0xff121212);

//Defines the Settings page and creates state
class Settings extends StatefulWidget {
  Options? options;
  Settings({required this.options});

  @override
  _SettingsState createState() {
    return _SettingsState();
  }
}

// Settings page contains:
//  App bar(return button and title)
//  Radio list tiles
// Users can choose whether to display the time using standard/military format
class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white
            ),
            onPressed: () {
              _saveSettings(context);
            },
          ),
          title: Text(
            'Settings',
            style: GoogleFonts.oswald(textStyle: Theme.of(context).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white).headline4),
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
          shape: const Border(
              bottom: BorderSide(
                  color: Colors.grey,
                  width: 2
              )
          ),
          elevation: 8,
        ),
        body: Column(
          children: [
            RadioListTile<Options>(
              title: Text(
                'Standard (12-Hours)',
                style: GoogleFonts.lato(color: Colors.white),
              ),
              value: Options.standard,
              groupValue: widget.options,
              onChanged: (Options? value) async {
                setState(() {
                  widget.options = value;
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("options", EnumToString.convertToString(value));
              },

            ),
            RadioListTile<Options>(
                title: Text(
                  'Military (24-Hours)',
                  style: GoogleFonts.lato(color: Colors.white),
                ),
                value: Options.military,
                groupValue: widget.options,
                onChanged : (Options? value) async {
                  setState(() {
                    widget.options = value;
                  });
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString("options", EnumToString.convertToString(value));
                }
            ),
          ],
        )
    );
  }

  //Returns the settings information to the home page
  void _saveSettings(BuildContext context) {
    Navigator.pop(context, widget.options);
  }
}