import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lg_task2/balloon_makers.dart';
import 'package:flutter_lg_task2/functions.dart';
import 'package:flutter_lg_task2/look_at_entity.dart';
import 'package:flutter_lg_task2/orbit_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SSH {
  late String host;
  late String port;
  late String username;
  late String password;
  late String noOfRigs;
  SSHClient? client;

  Future<void> initConnection() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    host = pref.getString("ipAddress") ?? "default_host";
    port = pref.getString("port") ?? "22";
    username = pref.getString("username") ?? "lg";
    password = pref.getString("password") ?? "lg";
    noOfRigs = pref.getString("numberOfRigs") ?? "3";
  }

  Future<bool?> connectToLiquidGalaxy(FToast fToast) async {
    await initConnection();
    try {
      print("11111111111111111111111111111");
      print(int.parse(port));
      print("Host${host}:");
      fToast.showToast(
          child: getToastWidget("running1", Colors.grey, Icons.cable));
      final socket = await SSHSocket.connect(host, int.parse(port));
      fToast.showToast(
          child: getToastWidget("Socket: ${socket}", Colors.grey, Icons.cable));
      // print("Socket: ${socket}");
      client = SSHClient(
          socket,
          username: username,
          onPasswordRequest: () => password
      );
      print("Client: ${client}");
      fToast.showToast(
          child: getToastWidget("Client: ${client}", Colors.grey, Icons.cable));
      print(
          host + " " + username + " " + port + " " + password + " " + noOfRigs);
      return true;
    } on SocketException catch (e) {
      fToast.showToast(
          child: getToastWidget("Client: ${client}", Colors.grey, Icons.cable));
      print("Client: ${client}");
      print(e);
      return false;
    }
  }

  Future<SSHSession?> execute(FToast fToast) async {
    try {
      if (client == null) {
        print('MESSAGE :: SSH CLIENT IS NOT INITIALISED');
        return null;
      }
      final executeResult = await client!.execute(
          'echo "search=India" >/tmp/query.txt');
      print(executeResult);
      fToast.showToast(child: getToastWidget(
          executeResult.toString(), Colors.grey, Icons.cable));
      return executeResult;
    } catch (e) {
      print('MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $e');
      fToast.showToast(child: getToastWidget(
          'MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $e',
          Colors.grey, Icons.cable));
      return null;
    }
  }

  Future<void> rebootLG(FToast fToast) async {
    try {
      if (client == null) {
        print('MESSAGE :: SSH CLIENT IS NOT INITIALISED');
        fToast.showToast(child: getToastWidget(
            "Go to Connection Manager to connect Rigs", Colors.grey,
            Icons.cable));
      }
      //int i=1;
      for (var i = 1; i <= int.parse(noOfRigs); i++) {
        fToast.showToast(
            child: getToastWidget("Reboot lg$i", Colors.grey, Icons.cable));
        final executeResult = await client!.execute(
            'sshpass -p ${password} ssh -t lg$i "echo ${password} | sudo -S reboot"');
        print(executeResult);
        fToast.showToast(child: getToastWidget(
            executeResult.toString(), Colors.grey, Icons.cable));
      }
      //return executeResult;
    } catch (e) {
      fToast.showToast(child: getToastWidget(
          'MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $e',
          Colors.grey, Icons.cable));
      //return null;
    }
  }

  Future<SSHSession?> relaunchLG(FToast fToast) async {
    try {
      int i = 1;
      fToast.showToast(
          child: getToastWidget("Relaunch lg$i", Colors.grey, Icons.cable));
      String cmd = """RELAUNCH_CMD="\\
          if [ -f /etc/init/lxdm.conf ]; then
            export SERVICE=lxdm
          elif [ -f /etc/init/lightdm.conf ]; then
            export SERVICE=lightdm
          else
            exit 1
          fi
          if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
            echo ${password} | sudo -S service \\\${SERVICE} start
          else
            echo ${password} | sudo -S service \\\${SERVICE} restart
          fi
          " && sshpass -p ${password} ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";
      final executeResult = await client!.execute(cmd);
      print(executeResult);
      fToast.showToast(child: getToastWidget(
          executeResult.toString(), Colors.grey, Icons.cable));
      return executeResult;
    } catch (e) {
      fToast.showToast(child: getToastWidget(
          'MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $e',
          Colors.grey, Icons.cable));
      return null;
    }
  }

  Future<SSHSession?> shutdownLG(FToast fToast) async {
    try {
      int i = 1;
      fToast.showToast(
          child: getToastWidget("Shutdown lg$i", Colors.grey, Icons.cable));
      String cmd = 'sshpass -p ${password} ssh -t lg$i "echo ${password} | sudo -S poweroff"';
      final executeResult = await client!.execute(cmd);
      print(executeResult);
      fToast.showToast(child: getToastWidget(
          executeResult.toString(), Colors.grey, Icons.cable));
      return executeResult;
    } catch (e) {
      fToast.showToast(child: getToastWidget(
          'MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $e',
          Colors.grey, Icons.cable));
      return null;
    }
  }

  Future<SSHSession?> search(FToast fToast, String home) async {
    try {
      if (client == null) {
        print('MESSAGE :: SSH CLIENT IS NOT INITIALISED');
        return null;
      }
      fToast.showToast(
          child: getToastWidget("Going to Search", Colors.blue, Icons.home));
      final executeResult = await client!.execute(
          'echo "search=$home" >/tmp/query.txt');
      print(executeResult);
      fToast.showToast(child: getToastWidget(
          executeResult.toString(), Colors.grey, Icons.cable));
      return executeResult;
    } catch (e) {
      print('MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $e');
      fToast.showToast(child: getToastWidget(
          'MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $e',
          Colors.grey, Icons.cable));
      return null;
    }
  }

  makeFile(FToast fToast, String filename, String content) async {
    try {
      var localPath = await getApplicationDocumentsDirectory();
      File localFile = File('${localPath.path}/${filename}.kml');
      await localFile.writeAsString(content);
      fToast.showToast(child: getToastWidget(
          '${localFile.readAsStringSync()}', Colors.grey, Icons.cable));
      return localFile;
    } catch (e) {
      fToast.showToast(
          child: getToastWidget(e.toString(), Colors.grey, Icons.cable));
      return null;
    }
  }

  String orbitLookAtLinear(double latitude, double longitude,
      double zoom, double tilt, double bearing) {
    return '<gx:duration>1.2</gx:duration><gx:flyToMode>smooth</gx:flyToMode><LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><range>$zoom</range><tilt>$tilt</tilt><heading>$bearing</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';
  }

  Future<SSHSession?> flyToOrbit(FToast fToast, double latitude,
      double longitude, double zoom,
      double tilt, double bearing) async {
    try {
      if (client == null) {
        print('MESSAGE :: SSH CLIENT IS NOT INITIALISED');
        return null;
      }
      fToast.showToast(child: getToastWidget(
          "Going to home", Colors.blue, Icons.home));
      final executeResult = await client!.execute(
          'echo "flytoview=${orbitLookAtLinear(
              latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
      print(executeResult);
      fToast.showToast(child: getToastWidget(
          executeResult.toString(), Colors.grey, Icons.cable));
      return executeResult;
    } catch (e) {
      print('MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $e');
      fToast.showToast(child: getToastWidget(
          'MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $e',
          Colors.grey, Icons.cable));
      return null;
    }
  }

  Future<void> balloonAtHome(FToast fToast) async {
    try {
      if (client == null) {
        print('MESSAGE :: SSH CLIENT IS NOT INITIALISED');
        return;
      }

      String balloonKML = BalloonMakers.balloon();

      File inputFile = await makeFile(fToast, "BalloonKML", balloonKML);
      await uploadKMLFile(fToast, inputFile, "BalloonKML","Task_Balloon");
    } catch (e) {
      fToast.showToast(child: getToastWidget(
          'MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $e',
          Colors.grey, Icons.cable));
    }
  }

  Future<void> orbitAroundHome(FToast fToast) async {
    try {
      if (client == null) {
        print('MESSAGE :: SSH CLIENT IS NOT INITIALISED');
        return;
      }

      //await cleanKML();

      String orbitKML = OrbitEntity.buildOrbit(OrbitEntity.tag(LookAtEntity(
          lng: 86.427040,
          lat: 23.795399,
          range: 7000,
          tilt: 60,
          heading: 0)
      ));

      File inputFile = await makeFile(fToast, "OrbitKML", orbitKML);
      await uploadKMLFile(fToast, inputFile, "OrbitKML","Task_Orbit");
    } catch (e) {
      fToast.showToast(child: getToastWidget(
          'MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $e',
          Colors.grey, Icons.cable));
    }
  }

  uploadKMLFile(FToast fToast, File inputFile, String kmlName,String task) async {
    try {
      bool uploading = true;
      fToast.showToast(
          child: getToastWidget("uploading true", Colors.grey, Icons.cable));
      final sftp = await client!.sftp();
      final file = await sftp.open('/var/www/html/$kmlName.kml',
          mode: SftpFileOpenMode.create |
          SftpFileOpenMode.truncate |
          SftpFileOpenMode.write);
      var fileSize = await inputFile.length();
      file.write(inputFile.openRead().cast(), onProgress: (progress) async {
        if (fileSize == progress) {
          fToast.showToast(child: getToastWidget(
              "uploading false", Colors.grey, Icons.cable));
          uploading = false;
          if(task == "Task_Orbit"){
            await loadKML( fToast, "OrbitKML",task);
          }
          else if(task=="Task_Balloon"){
            await loadKML( fToast, "BalloonKML",task);
          }
        }
      });
    } catch (e) {
      fToast.showToast(
          child: getToastWidget(e.toString(), Colors.grey, Icons.cable));
    }
  }

  loadKML(FToast fToast, String kmlName,String task) async {
    try {
      fToast.showToast(child: getToastWidget('loading the  KML', Colors.grey, Icons.cable));
      final v = await client!.execute("echo 'http://lg1:81/$kmlName.kml' > /var/www/html/kmls.txt");
      fToast.showToast(child: getToastWidget('KML loaded $v', Colors.grey, Icons.cable));
      if(task=="Task_Orbit") {
        await beginOrbiting(fToast);
      } else if(task=="Task_Balloon"){
        await showBalloon(fToast);
      }
    } catch (error) {
      fToast.showToast(child: getToastWidget(
          'MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $error',
          Colors.grey, Icons.cable));
      await loadKML(fToast, kmlName,task);
    }
  }

  beginOrbiting(FToast fToast) async {
    try {
      fToast.showToast(child: getToastWidget('Begin Orbiting', Colors.grey, Icons.cable));
      final res = await client!.run('echo "playtour=Orbit" > /tmp/query.txt');
      fToast.showToast(child: getToastWidget(res.toString(), Colors.grey, Icons.cable));
    } catch (error) {
      await beginOrbiting(fToast);
    }
  }

  showBalloon(FToast fToast) async {
    try {
      String balloonKML = BalloonMakers.balloon();

      await client!.run("echo '$balloonKML' > /var/www/html/kml/slave_2.kml");

      //await cleanBalloon();

      fToast.showToast(child: getToastWidget('showing balloon', Colors.grey, Icons.cable));
      //await client!.run('echo "playtour=Task2" > /tmp/query.txt');

      //await cleanKML();

    } catch (error) {
      await showBalloon(fToast);
    }
  }

  Future<void> rightScreenBalloon(FToast fToast) async {
    try {
      if (client == null) {
        print('MESSAGE :: SSH CLIENT IS NOT INITIALISED');
        return;
      }
      int totalScreen = int.parse(noOfRigs);
      int rightMostScreen = (totalScreen/2).floor()+1;
      fToast.showToast(
          child: getToastWidget("Showing Balloon", Colors.blue, Icons.home));
      final executeResult = await client!.execute("echo '${BalloonMakers.balloon()}' > /var/www/html/kml/slave_$rightMostScreen.kml");
      print(executeResult);
      fToast.showToast(child: getToastWidget(
          executeResult.toString(), Colors.grey, Icons.cable));
    } catch (e) {
      print('MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $e');
      fToast.showToast(child: getToastWidget(
          'MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $e',
          Colors.grey, Icons.cable));
    }
  }

  stopOrbit() async {
    try {
      await client!.run('echo "exittour=true" > /tmp/query.txt');
    } catch (error) {
      stopOrbit();
    }
  }

  startOrbit() async {
    try {
      await client!.run('echo "playtour=Orbit" > /tmp/query.txt');
    } catch (error) {
      stopOrbit();
    }
  }

  cleanBalloon() async {
    try {
      await client!.run("echo '${BalloonMakers.blankBalloon()}' > /var/www/html/kml/slave_2.kml");
      await client!.run("echo '${BalloonMakers.blankBalloon()}' > /var/www/html/kml/slave_3.kml");
    } catch (error) {
      await cleanBalloon();
    }
  }

  cleanSlaves() async {
    try {
      await client!.run("echo '' > /var/www/html/kml/slave_2.kml");
      await client!.run("echo '' > /var/www/html/kml/slave_3.kml");
    } catch (error) {
      await cleanSlaves();
    }
  }

  cleanKML() async {
    try {
      await cleanBalloon();
      await stopOrbit();
      await client!.run("echo '' > /tmp/query.txt");
      await client!.run("echo '' > /var/www/html/kmls.txt");
    } catch (error) {
      await cleanKML();
      // showSnackBar(
      //     context: context, message: error.toString(), color: Colors.red);
    }
  }

}