import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'download_server_ssl_certificate_platform_interface.dart';

/// An implementation of [DownloadServerSslCertificatePlatform] that uses method channels.
class MethodChannelDownloadServerSslCertificate
    extends DownloadServerSslCertificatePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('download_server_ssl_certificate');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getCertificate(String url) async {
    final certificate = await methodChannel
        .invokeMethod<String>('getCertificate', {'url': url});
    return certificate;
  }
}
