import Flutter
import UIKit
import Security

public class DownloadServerSslCertificatePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "download_server_ssl_certificate", binaryMessenger: registrar.messenger())
        let instance = DownloadServerSslCertificatePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "getCertificate":
            guard let args = call.arguments as? [String: Any],
                  let urlString = args["url"] as? String,
                  let url = URL(string: urlString) else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid URL", details: nil))
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    result(FlutterError(code: "REQUEST_FAILED", message: error.localizedDescription, details: nil))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    result(FlutterError(code: "INVALID_RESPONSE", message: "Invalid response", details: nil))
                    return
                }

                guard httpResponse.statusCode == 200 else {
                    result(FlutterError(code: "HTTP_ERROR", message: "HTTP error \(httpResponse.statusCode)", details: nil))
                    return
                }

             if let serverTrust = self.extractServerTrust(from: response),
                let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                 var certificateData: CFData?
                 SecCertificateCopyData(serverCertificate, &certificateData)
                 let certificateString = String(data: certificateData! as Data, encoding: .utf8)
                 result(certificateString)
             } else {
                 result(FlutterError(code: "CERTIFICATE_ERROR", message: "Failed to extract certificate", details: nil))
             }

            }
            task.resume()
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func extractServerTrust(from response: URLResponse?) -> SecTrust? {
        guard let response = response,
              let url = response.url else {
            return nil
        }
        return URLSession.shared.delegate?.urlSession?(URLSession.shared, didReceive: response, completionHandler: { disposition, credential in
            return nil
        })
    }
}
