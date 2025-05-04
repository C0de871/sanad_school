// ! In main.dart or any other file.
/* 
// This is a global callback function that must be a top-level function
@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  print('Download task ($id) is in status: ${DownloadTaskStatus.values[status]} and process: $progress');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize FlutterDownloader
  await FlutterDownloader.initialize(
    debug: true, // Set to false in production
    ignoreSsl: true // Add this if you're downloading from HTTPS
  );

  // Register download callback
  FlutterDownloader.registerCallback(downloadCallback);
  
  runApp(const MainApp());
} */

// ! packages :
  //flutter_downloader: ^1.12.0
  // path_provider: ^2.1.5
  // permission_handler: ^11.4.0