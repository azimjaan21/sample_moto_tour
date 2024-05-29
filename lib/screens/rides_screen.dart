// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample_moto_tour/database/database_helper.dart';
import 'package:sample_moto_tour/models/ride.module.dart';
import 'package:sample_moto_tour/tools/extentions/sized_box_ext.dart';
import 'package:sample_moto_tour/widgets/custom_sliver_appbar.dart';
import 'package:intl/intl.dart';

class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  late Future<List<Ride>> _rides;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadRides();
  }

  void _loadRides() {
    setState(() {
      if (_selectedIndex == 0) {
        _rides = DatabaseHelper().getCurrentRides();
      } else {
        _rides = DatabaseHelper().getExpiredRides();
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _loadRides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            const CustomSliverAppBar(
              title: 'Мотопоездки',
              imagePath: 'assets/background.jpg',
            ),
          ];
        },
        body: FutureBuilder<List<Ride>>(
          future: _rides,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text(_selectedIndex == 0
                      ? 'Мотопоездок нет.'
                      : 'Исторических мотопоездок нет.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Ride ride = snapshot.data![index];
                  return RideCard(
                    ride: ride,
                    onCancel: _loadRides,
                    isHistory: _selectedIndex == 1,
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.motorcycle_outlined),
            label: 'Мотопоездки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'История мотопоездок',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class RideCard extends StatefulWidget {
  final Ride ride;
  final Function onCancel;
  final bool isHistory;

  const RideCard(
      {super.key,
      required this.ride,
      required this.onCancel,
      required this.isHistory});

  @override
  _RideCardState createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> {
  int? _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  void _initializeTimer() {
    _remainingTime = _calculateRemainingTime();
    if (_remainingTime != null &&
        _remainingTime! > 0 &&
        widget.ride.status == "waiting") {
      _startTimer();
    }
  }

  int _calculateRemainingTime() {
    final now = DateTime.now();
    final elapsedTime = now.difference(widget.ride.startTime).inSeconds;
    final totalWaitTime = widget.ride.waitTime * 60;
    return totalWaitTime - elapsedTime;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime! > 0) {
          _remainingTime = _remainingTime! - 1;
        } else {
          _timer?.cancel();
          _updateRideStatus("arrived");
        }
      });
    });
  }

  void _updateRideStatus(String status) async {
    widget.ride.status = status;
    await DatabaseHelper().updateRide(widget.ride);
    widget.onCancel();
  }

  void _cancelRide() async {
    await DatabaseHelper().deleteRide(widget.ride.id!);
    widget.onCancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String displayTime;
    if (widget.ride.status == "waiting") {
      if (_remainingTime != null && _remainingTime! > 0) {
        int minutes = _remainingTime! ~/ 60;
        int seconds = _remainingTime! % 60;
        displayTime = '$minutes:${seconds.toString().padLeft(2, '0')}';
      } else {
        displayTime = 'Мотобайк здесь!';
      }
    } else {
      displayTime = 'Мотобайк здесь!';
    }

    String formattedStartTime =
        DateFormat('dd-MM-yyyy  HH:mm').format(widget.ride.startTime);

    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.ride.startStreet,
              overflow: TextOverflow.ellipsis, // Handle overflow
              maxLines: 1, // Restrict to a single line
            ),
            const Icon(
              Icons.keyboard_double_arrow_down,
              color: Color(0xFF1AFF00),
            ),
            Text(
              widget.ride.finalStreet,
              overflow: TextOverflow.ellipsis, // Handle overflow
              maxLines: 1, // Restrict to a single line
            ),
            10.kH,
          ],
        ),
        subtitle: widget.isHistory
            ? Text(
                'Завершено: $formattedStartTime',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.amber, fontSize: 12.0),
              )
            : Text(
                'Время ожидания: $displayTime',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.amber, fontSize: 12.0),
              ),
        trailing: IconButton(
          icon: const Icon(
            Icons.cancel,
            color: Color(0xFFFF1100),
          ),
          onPressed: _cancelRide,
        ),
      ),
    );
  }
}
