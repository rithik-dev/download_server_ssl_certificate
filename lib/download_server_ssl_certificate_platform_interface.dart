import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'download_server_ssl_certificate_method_channel.dart';

abstract class DownloadServerSslCertificatePlatform extends PlatformInterface {
  /// Constructs a DownloadServerSslCertificatePlatform.
  DownloadServerSslCertificatePlatform() : super(token: _token);

  static final Object _token = Object();

  static DownloadServerSslCertificatePlatform _instance = MethodChannelDownloadServerSslCertificate();

  /// The default instance of [DownloadServerSslCertificatePlatform] to use.
  ///
  /// Defaults to [MethodChannelDownloadServerSslCertificate].
  static DownloadServerSslCertificatePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DownloadServerSslCertificatePlatform] when
  /// they register themselves.
  static set instance(DownloadServerSslCertificatePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getCertificate(String url) {
    throw UnimplementedError('getCertificate() has not been implemented.');
  }
}
