import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/config.dart';

int cameraId = -1;

Future<List<CameraDescription>> fetchCameras() async =>
    await CameraPlatform.instance.availableCameras();

Future<int> createCameraWithSettings(
        CameraDescription camera, MediaSettings settings) async =>
    await CameraPlatform.instance.createCameraWithSettings(camera, settings);

Future<bool> anyCamerasAvailable() async =>
    (await fetchCameras()).isNotEmpty;

Future<void> disposeCamera(int cameraId) async =>
    await CameraPlatform.instance.dispose(cameraId);

Future<int> startRecording(
    {int index = cameraIndex, MediaSettings settings = cameraSettings, Duration maxDuration = maxVideoDuration}) async {
  List<CameraDescription> cameras = await fetchCameras();
  cameraId = await createCameraWithSettings(cameras[index], settings);
  await CameraPlatform.instance.startVideoRecording(cameraId,maxVideoDuration: maxVideoDuration);
  return cameraId;
}

Future<int> stopRecording({String? storeLocation}) async {
  XFile videoFile = await CameraPlatform.instance.stopVideoRecording(cameraId);
  await disposeCamera(cameraId);

  // Checking if the file needs to be moved to a different location
  if (storeLocation != null) {
    final String orginFilePath = videoFile.path;
 
    await videoFile.saveTo(storeLocation);
    deleteFile(orginFilePath);
  }

  return cameraId;
}

// stopRecording(storeLocation: 'Data/Sessions/0e75b8d8-aad5-4530-9f0e-d7a9c3bef69e/video.mp4');
