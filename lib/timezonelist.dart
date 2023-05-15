import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'timezone.dart';

//******************************************************************************
// Timezone List Code
//******************************************************************************

const primaryColor = Color(0xff121212);

// Defining TimeZoneList and creating state
class TimeZoneList extends StatefulWidget {
  List<TimeZone> timezone;
  TimeZoneList({required this.timezone});

  @override
  _TimeZoneListState createState() {
    return _TimeZoneListState();
  }
}

// TimeZoneList contains:
//  App bar (return button and title)
//  Listview (switch list tiles with timezone information)
// Users can select which timezones to display on the home page
class _TimeZoneListState extends State<TimeZoneList> {

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
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('timezone', jsonEncode(widget.timezone));
              _sendBackData(context);
            },
          ),
          title: Text(
            'Timezone List',
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
        body: ListView.separated(
          itemCount: widget.timezone.length,
          itemBuilder: (context, index) {
            return SwitchListTile(
              title: Text(
                '${widget.timezone[index].name} - ${widget.timezone[index].fullName}',
                style: GoogleFonts.lato(color: Colors.white),
              ),
              subtitle: Text(
                widget.timezone[index].offsetLabel,
                style: GoogleFonts.lato(color: Colors.white),
              ),
              value: widget.timezone[index].isOn,
              onChanged: (bool value) {
                setState(() {
                  widget.timezone[index].isOn = value;
                });
              },
              activeColor: const Color(0xFF03DAC6),
              inactiveTrackColor: Colors.grey,
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(color: Colors.grey);
          },
        )
    );
  }

  //Returns the selected timezone information to home page
  void _sendBackData(BuildContext context) {
    Navigator.pop(context, widget.timezone);
  }
}