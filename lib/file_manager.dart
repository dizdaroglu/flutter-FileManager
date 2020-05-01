import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

class FileManager extends StatefulWidget {
  FileManager({Key key}) : super(key: key);

  @override
  _FileManagerState createState() => _FileManagerState();
}

class _FileManagerState extends State<FileManager> {
  String _filePath = "";

  Future<String> get _localDevicePath async {
    final _devicePath = await getApplicationDocumentsDirectory();
    return _devicePath.path;
  }

  Future<File> _localFile({String path, String type}) async {
    String _path = await _localDevicePath;

    var _newPath = await Directory("$_path/$path").create();

    return File("${_newPath.path}/data.$type");
  }

  Future _downloadSamplePDF() async {
    final _response =
        await http.get("http://www.africau.edu/images/default/sample.pdf");
    if (_response.statusCode == 200) {
      final _file = await _localFile(path: "data", type: "pdf");
      final _saveFile = await _file.writeAsBytes(_response.bodyBytes);
      Logger().i("File write complete. File path ${_saveFile.path}");
      setState(() {
        _filePath = _saveFile.path;
      });
    } else {
      Logger().e(_response.statusCode);
    }
  }

  Future _downloadSampleVideo() async {
    final _response = await http.get(
        "https://file-examples.com/wp-content/uploads/2017/04/file_example_MP4_480_1_5MG.mp4");
    if (_response.statusCode == 200) {
      final _file = await _localFile(path: "videos", type: "mp4");
      final _saveFile = await _file.writeAsBytes(_response.bodyBytes);
      Logger().i("File write complete. File path ${_saveFile.path}");
      setState(() {
        _filePath = _saveFile.path;
      });
    } else {
      Logger().e(_response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            width: double.maxFinite,
            child: FlatButton.icon(
              onPressed: () {
                _downloadSamplePDF();
              },
              icon: Icon(Icons.file_download),
              label: Text("Sample Pdf"),
            )),
        Container(
            width: double.maxFinite,
            child: FlatButton.icon(
              onPressed: () {
                _downloadSampleVideo();
              },
              icon: Icon(Icons.file_download),
              label: Text("Sample Video"),
            )),
        Text(_filePath),
        FlatButton.icon(
          onPressed: () {
            OpenFile.open(_filePath);
          },
          icon: Icon(Icons.shop_two),
          label: Text("Show"),
        )
      ],
    ));
  }
}
