import 'package:blackout_light_on/presentation/bloc/bloc.dart';
import 'package:blackout_light_on/presentation/bloc/events.dart';
import 'package:blackout_light_on/presentation/bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WiFiPage extends StatefulWidget {
  const WiFiPage({super.key});

  @override
  State<WiFiPage> createState() => _WiFiPageState();
}

class _WiFiPageState extends State<WiFiPage> {
  List<List<String>> wifiList = [];
  Map<int, List<String>> wifiForSave = {};

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MainBloc>(context).add(GetWiFIEvent());
  }

  @override
  Widget build(BuildContext context) {
    final MainBloc mainBloc = BlocProvider.of<MainBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search WiFi...'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          BlocConsumer<MainBloc, ListState>(
            listener: (context, state) {
              if (state is GetWiFiState) {
                wifiList = state.wifi;
              }
              if (state is AlertUiState) {
                final String info = state.data;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(info),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Expanded(
                child: ListView.builder(
                  itemCount: wifiList.length,
                  itemBuilder: (context, index) {
                    final List<String> wifi = wifiList[index];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Name: ${wifi[0]}'),
                                Text('SSID: ${wifi[1]}'),
                              ],
                            ),
                          ),
                          Checkbox(
                            value: wifiForSave.containsKey(index),
                            onChanged: (bool? value) {
                              if (value == true) {
                                setState(() {
                                  wifiForSave[index] = wifi;
                                });
                              } else {
                                setState(() {
                                  wifiForSave.remove(index);
                                });
                              }
                            },
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white38,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
              icon: const Icon(Icons.restart_alt_rounded),
              iconSize: 40.0,
              onPressed: () {
                mainBloc.add(GetWiFIEvent());
              },
              tooltip: 'Update',
            ),
            IconButton(
              padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
              icon: const Icon(Icons.save),
              iconSize: 40.0,
              onPressed: () {
                final List saveResult = wifiForSave.values.toList();
                if (saveResult.isNotEmpty) {
                  mainBloc.add(
                    SaveWiFiEvent([saveResult, true]),
                  );
                  wifiForSave = {};
                }
              },
              tooltip: 'Save WiFi',
            ),
          ],
        ),
      ),
    );
  }
}
