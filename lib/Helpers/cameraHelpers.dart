import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/config.dart';

int cameraId = -1;

Future<List<CameraDescription>> fetchCameras() async =>
    await CameraPlatform.instance.availableCameras();

Future<int> createCameraWithSettings(
        CameraDescription camera, MediaSettings settings) async =>
    await CameraPlatform.instance.createCameraWithSettings(camera, settings);

Future<bool> anyCamerasAvailable() async => (await fetchCameras()).isNotEmpty;

Future<void> disposeCamera(int cameraIdToDispose) async {
  if (cameraIdToDispose == -1) return;

  await CameraPlatform.instance.dispose(cameraIdToDispose);
  cameraId = -1;
}

Future<int> startRecording({
  int index = cameraIndex,
  MediaSettings settings = cameraSettings,
  Duration maxDuration = maxVideoDuration,
  bool doesDisposeOldCamera = true,
}) async {
  if (doesDisposeOldCamera) await disposeCamera(cameraId);

  List<CameraDescription> cameras = await fetchCameras();
  cameraId = await createCameraWithSettings(cameras[index], settings);
  await CameraPlatform.instance
      .startVideoRecording(cameraId, maxVideoDuration: maxVideoDuration);
  return cameraId;
}

Future<(int, XFile?)> stopRecording({String? storeLocation}) async {
  if (cameraId == -1) return (cameraId, null);

  XFile videoFile = await CameraPlatform.instance.stopVideoRecording(cameraId);
  await disposeCamera(cameraId);

  // Checking if the file needs to be moved to a different location
  if (storeLocation != null) {
    final String orginFilePath = videoFile.path;

    await videoFile.saveTo(storeLocation);
    deleteFile(orginFilePath);
  }

  return (cameraId, videoFile);
}
