import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Room {
  String name;
  double monthlyRent;

  Room(this.name, this.monthlyRent);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RoomListScreen(),
    );
  }
}

class RoomListScreen extends StatefulWidget {
  RoomListScreen({Key? key}) : super(key: key);

  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  final List<Room> _activeRooms = [];
  final List<Room> _deletedRooms = [];

  void _addRoom(String name, double monthlyRent) {
    setState(() {
      _activeRooms.add(Room(name, monthlyRent));
    });
  }

  void _deleteRoom(int index) {
    setState(() {
      _deletedRooms.add(_activeRooms.removeAt(index));
    });
  }

  Future<void> _showAddRoomDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController rentController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Room'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: rentController,
                decoration: const InputDecoration(labelText: 'Monthly Rent'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String name = nameController.text;
                double rent = double.tryParse(rentController.text) ?? 0.0;

                if (name.isNotEmpty && rent > 0) {
                  _addRoom(name, rent);
                }

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAppInfoDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('App Info'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('App Name: Room Rental App'),
              Text('Version: 0.1.0'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Room Rental App'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                _showAppInfoDialog();
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Rooms'),
              Tab(text: 'Archived'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _showAddRoomDialog();
                    },
                    child: const Text('Add Room'),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _activeRooms.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_activeRooms[index].name),
                        subtitle: Text(
                            'Monthly Rent: \$${_activeRooms[index].monthlyRent.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteRoom(index);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            ListView.builder(
              itemCount: _deletedRooms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_deletedRooms[index].name),
                  subtitle: Text(
                      'Monthly Rent: \$${_deletedRooms[index].monthlyRent.toStringAsFixed(2)}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
