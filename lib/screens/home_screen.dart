import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lg_task2/connections/ssh.dart';
import 'package:flutter_lg_task2/screens/connection_screen.dart';
import 'package:flutter_lg_task2/functions.dart';
import 'package:fluttertoast/fluttertoast.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FToast fToast = FToast();
  bool isConnected = false;

  late SSH ssh;

  Future<void> _connectToLG() async {
    bool? result = await ssh.connectToLiquidGalaxy(fToast);
    print(result);
    setState(() {
      isConnected = result!;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      ssh = SSH();
      _connectToLG();
    });
  }

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: isConnected?Text("Status: Connected",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),):Text("Status: Disconnected",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
        actions: [
          TextButton.icon(
            icon:Icon(Icons.connected_tv,color: Colors.white,),
              onPressed: (){
                  NavigationPushReplacement(context, ConnectionScreen());
              },
              label: Text("Connection Manager",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [

            Center(
              child: Image.asset("assets/images/lg_logo.png",width: 200,height: 200,),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [

                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width/2,
                        child: ElevatedButton(
                          onPressed: (){
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                title: 'Reboot Liquid Galaxy',
                                desc: 'Reboot the three Liquid Galaxies',
                                btnCancelOnPress: () {

                            },
                            btnOkOnPress: () async{
                            await ssh.rebootLG(fToast);
                            },
                            )..show();
                          },
                          child: Text("Reboot LG",style: TextStyle(color: Colors.white,fontSize: 40),),
                          style: getButtonStyle(Colors.redAccent),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width/2,
                        child: ElevatedButton(
                          onPressed: ()async{
                            // SSHSession? sshSession = await ssh.search(fToast, "Dhanbad");
                            SSHSession? sshSession = await ssh.flyToOrbit(fToast,23.795399,86.427040,7095,60,0);
                            if(sshSession!=null){
                              print("MESSAGE :: COMMAND EXECUTED SUCCESSFULLY");
                              fToast.showToast(child: getToastWidget("MESSAGE :: COMMAND EXECUTED SUCCESSFULLY", Colors.yellow, Icons.warning));
                            }else{
                              print("MESSAGE :: COMMAND EXECUTION FAILED");
                              fToast.showToast(child: getToastWidget("MESSAGE :: COMMAND EXECUTION FAILED", Colors.yellow, Icons.warning));
                            }
                          },
                          child: Text("Go to home city",style: TextStyle(color: Colors.white,fontSize: 40),),
                          style: getButtonStyle(Colors.redAccent),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width/2,
                        child: ElevatedButton(
                          onPressed: ()async{
                            await ssh.orbitAroundHome(fToast);
                          },
                          child: Text("Start Orbit",style: TextStyle(color: Colors.white,fontSize: 40),),
                          style: getButtonStyle(Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Center(
              child: Container(
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: ()async{
                    await ssh.balloonAtHome(fToast);
                    //await ssh.rightScreenBalloon(fToast);
                  },
                  child: Text("Print HTML bubble on right screen",style: TextStyle(color: Colors.white,fontSize: 40),),
                  style: getButtonStyle(Colors.redAccent),
                ),
              ),
            ),

            // Container(
            //   margin: EdgeInsets.all(20),
            //   width: MediaQuery.of(context).size.width,
            //   child: ElevatedButton(
            //     onPressed: ()async{
            //       SSHSession? sshSession = await ssh.relaunchLG(fToast);
            //       if(sshSession!=null){
            //         print("MESSAGE :: COMMAND EXECUTED SUCCESSFULLY");
            //         fToast.showToast(child: getToastWidget("MESSAGE :: COMMAND EXECUTED SUCCESSFULLY", Colors.yellow, Icons.warning));
            //       }else{
            //         print("MESSAGE :: COMMAND EXECUTION FAILED");
            //         fToast.showToast(child: getToastWidget("MESSAGE :: COMMAND EXECUTION FAILED", Colors.yellow, Icons.warning));
            //       }
            //     },
            //     child: Text("Relaunch LG",style: TextStyle(color: Colors.white,fontSize: 30),),
            //     style: getButtonStyle(Colors.orange),
            //   ),
            // ),
            //
            // Container(
            //   margin: EdgeInsets.all(20),
            //   width: MediaQuery.of(context).size.width,
            //   child: ElevatedButton(
            //     onPressed: ()async{
            //       SSHSession? sshSession = await ssh.shutdownLG(fToast);
            //       if(sshSession!=null){
            //         print("MESSAGE :: COMMAND EXECUTED SUCCESSFULLY");
            //         fToast.showToast(child: getToastWidget("MESSAGE :: COMMAND EXECUTED SUCCESSFULLY", Colors.yellow, Icons.warning));
            //       }else{
            //         print("MESSAGE :: COMMAND EXECUTION FAILED");
            //         fToast.showToast(child: getToastWidget("MESSAGE :: COMMAND EXECUTION FAILED", Colors.yellow, Icons.warning));
            //       }
            //     },
            //     child: Text("Shutdown LG",style: TextStyle(color: Colors.white,fontSize: 30),),
            //     style: getButtonStyle(Colors.orange),
            //   ),
            // ),

          ],
        ),
      ),
    );
  }
}
