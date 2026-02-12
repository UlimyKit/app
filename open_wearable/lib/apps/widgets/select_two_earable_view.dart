import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_earable_flutter/open_earable_flutter.dart';
import 'package:open_wearable/view_models/sensor_configuration_provider.dart';
import 'package:open_wearable/view_models/wearables_provider.dart';
import 'package:provider/provider.dart';

class SelectTwoEarableView  extends StatefulWidget {
  /// Callback to start the app
  /// -- [wearable] the selected wearable
  /// returns a [Widget] of the home page of the app
  final Widget Function(Wearable leftWearable,
  SensorConfigurationProvider leftProvider,
  Wearable rightWearable,
  SensorConfigurationProvider rightProvider,) startApp;

  const SelectTwoEarableView({super.key, required this.startApp});

  @override
  State<SelectTwoEarableView> createState() => _SelectTwoEarableViewState();
}

class _SelectTwoEarableViewState extends State<SelectTwoEarableView> {
  Wearable? _selectedWearableA;
  Wearable? _selectedWearableB;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText("Select Earable"),
      ),
      body: Consumer(
        builder: (context, WearablesProvider wearablesProvider, child) =>
          Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: wearablesProvider.wearables.length,
                itemBuilder: (context, index) {
                  Wearable wearable = wearablesProvider.wearables[index];
                  return PlatformListTile(
                    title: PlatformText(wearable.name),
                    subtitle: PlatformText(wearable.deviceId), 
                    trailing: _selectedWearableA == wearable
                        ? Icon(Icons.check)
                        : _selectedWearableB == wearable ? Icon(Icons.check) : null,
                    onTap: () => setState(() {
                      _selectedWearableA ??= wearable;
                      if(_selectedWearableA != wearable && _selectedWearableB == null){
                      _selectedWearableB = wearable;
                      }
                    }),
                  );
                },
              ),

              PlatformElevatedButton(
                child: PlatformText("Start App"),
                onPressed: () async{
                  if (_selectedWearableA != null && _selectedWearableB != null) {
                    Wearable left = await getLeftWearable();
                    Wearable right = left == _selectedWearableA! ? _selectedWearableB! : _selectedWearableA!;
                    Navigator.push(
                      context,
                      platformPageRoute(
                        context: context,
                        builder: (_) {
                          return MultiProvider(
                            providers: [
                              ChangeNotifierProvider.value(value: wearablesProvider.getSensorConfigurationProvider(left)),
                              ChangeNotifierProvider.value(value: wearablesProvider.getSensorConfigurationProvider(right)),
                            ],
                            child: widget.startApp(
                              left, 
                              wearablesProvider.getSensorConfigurationProvider(left),
                              right,
                              wearablesProvider.getSensorConfigurationProvider(right),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
      ),
    );
  }

  Future<Wearable> getLeftWearable() async{
    final DevicePosition? position = await _getDevicePosition(_selectedWearableA!);
    if(position == DevicePosition.left){
      return _selectedWearableA!;
    }
    return _selectedWearableB!;
  }

  Future<DevicePosition?> _getDevicePosition(Wearable w) async {
    if (w is! StereoDevice) return null;
    return await (w as StereoDevice).position;
  }
}
