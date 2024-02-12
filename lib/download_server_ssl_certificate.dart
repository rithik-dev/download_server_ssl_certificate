import 'download_server_ssl_certificate_platform_interface.dart';

class DownloadServerSslCertificate {
  Future<String?> getPlatformVersion() {
    return DownloadServerSslCertificatePlatform.instance.getPlatformVersion();
  }

  Future<String?> getCertificate(String url) {
    return DownloadServerSslCertificatePlatform.instance.getCertificate(url);
  }
}
