package com.example.download_server_ssl_certificate

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.net.URL
import javax.net.ssl.HttpsURLConnection
import java.security.cert.Certificate
import java.io.ByteArrayInputStream
import java.security.cert.CertificateFactory
import java.security.cert.X509Certificate
import java.io.StringWriter
import org.bouncycastle.util.io.pem.PemObject
import org.bouncycastle.util.io.pem.PemWriter

/** DownloadServerSslCertificatePlugin */
class DownloadServerSslCertificatePlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "download_server_ssl_certificate")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "getCertificate") {
            val url = call.argument<String>("url")
            if (url != null) {
                GlobalScope.launch(Dispatchers.IO) {
                    val certificate = getCertificate(url)
                    if (certificate != null) {
                        withContext(Dispatchers.Main) {
                            result.success(certificate)
                        }
                    } else {
                        withContext(Dispatchers.Main) {
                            result.error("UNAVAILABLE", "Could not fetch certificate.", null)
                        }
                    }
                }
            } else {
                result.error("INVALID_URL", "URL cannot be null.", null)
            }
        } else {
            result.notImplemented()
        }
    }

    private fun getCertificate(urlString: String?): String? {
        try {
            val url = URL(urlString)
            val conn = url.openConnection() as HttpsURLConnection
            conn.connect()
            val certificates: Array<Certificate> = conn.serverCertificates
            val certFactory = CertificateFactory.getInstance("X.509")
            val certificate = certFactory.generateCertificate(ByteArrayInputStream(certificates[0].encoded))
            val writer = StringWriter()
            val pemWriter = PemWriter(writer)
            pemWriter.writeObject(PemObject("CERTIFICATE", certificate.encoded))
            pemWriter.flush()
            pemWriter.close()
            return writer.toString()
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
