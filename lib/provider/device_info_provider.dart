import 'package:collection/collection.dart';
import 'package:fileflow/common/constants.dart';
import 'package:fileflow/common/model/device.dart';
import 'package:fileflow/common/model/device_info_result.dart';
import 'package:fileflow/common/src/isolate/parent/actions_sync.dart';
import 'package:fileflow/common/src/isolate/parent/parent_isolate_provider.dart';
import 'package:fileflow/provider/local_ip_provider.dart';
import 'package:fileflow/provider/network/server/server_provider.dart';
import 'package:fileflow/provider/security_provider.dart';
import 'package:fileflow/provider/settings_provider.dart';
import 'package:refena_flutter/refena_flutter.dart';

final deviceRawInfoProvider = Provider<DeviceInfoResult>((ref) {
  throw Exception('deviceRawInfoProvider not initialized');
});

final deviceInfoProvider = ViewProvider<DeviceInfoResult>((ref) {
  final (deviceType, deviceModel) = ref.watch(settingsProvider
      .select((state) => (state.deviceType, state.deviceModel)));
  final rawInfo = ref.watch(deviceRawInfoProvider);

  return DeviceInfoResult(
    deviceType: deviceType ?? rawInfo.deviceType,
    deviceModel: deviceModel ?? rawInfo.deviceModel,
    androidSdkInt: rawInfo.androidSdkInt,
  );
}, onChanged: (_, next, ref) {
  ref
      .redux(parentIsolateProvider)
      .dispatch(IsolateSyncDeviceInfoAction(deviceInfo: next));
});

final deviceFullInfoProvider = ViewProvider((ref) {
  final networkInfo = ref.watch(localIpProvider);
  final serverState = ref.watch(serverProvider);
  final rawInfo = ref.watch(deviceInfoProvider);
  final securityContext = ref.read(securityProvider);
  return Device(
    ip: networkInfo.localIps.firstOrNull ?? '-',
    version: protocolVersion,
    port: serverState?.port ?? -1,
    alias: serverState?.alias ?? '-',
    https: serverState?.https ?? true,
    fingerprint: securityContext.certificateHash,
    deviceModel: rawInfo.deviceModel,
    deviceType: rawInfo.deviceType,
    download: serverState?.webSendState != null,
  );
});
