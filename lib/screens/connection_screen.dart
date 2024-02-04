import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lg_task2/functions.dart';
import 'package:flutter_lg_task2/screens/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_lg_task2/connections/ssh.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {

  bool showPassword = false;
  bool isConnected = false;
  // String ipAddress = "",username = "",password = "",port ="", noOfLgRigs = "";
  FToast fToast = FToast();
  TextEditingController ipController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController rigsNumController = TextEditingController();

  late SSH ssh;

  Future<void> _connectToLG() async {
    bool? result = await ssh.connectToLiquidGalaxy(fToast);
    print(result);
    setState(() {
      isConnected = result!;
    });
  }

  @override
  void dispose() {
    ipController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    portController.dispose();
    rigsNumController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ipController.text = prefs.getString('ipAddress') ?? '';
      usernameController.text = prefs.getString('username') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      portController.text = prefs.getString('port') ?? '';
      rigsNumController.text = prefs.getString('numberOfRigs') ?? '';
    });
  }

  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (ipController.text.isNotEmpty) {
      await prefs.setString('ipAddress', ipController.text);
    }
    if (usernameController.text.isNotEmpty) {
      await prefs.setString('username', usernameController.text);
    }
    if (passwordController.text.isNotEmpty) {
      await prefs.setString('password', passwordController.text);
    }
    if (portController.text.isNotEmpty) {
      await prefs.setString('port', portController.text);
    }
    if (rigsNumController.text.isNotEmpty) {
      await prefs.setString('numberOfRigs', rigsNumController.text);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero,(){
      ssh = SSH();
      _loadSettings();
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
        title: isConnected?Text("Status: Connected",style: TextStyle(color: Colors.green),):Text("Status: Disconnected",style: TextStyle(color: Colors.red),),
        actions: [
          TextButton.icon(
              icon:Icon(Icons.home,color: Colors.white,),
              onPressed: (){
                NavigationPushReplacement(context,HomeScreen());
              },
              label: Text("Home",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
        
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: TextFormField(
                  controller: ipController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.computer_rounded,color: Colors.orange,),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "IP Address"
                  ),
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: TextFormField(
                  controller: usernameController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.person,color: Colors.orange,),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "LG Username"
                  ),
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: TextFormField(
                  controller: passwordController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    suffix: IconButton(
                      onPressed: (){
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: Icon(Icons.remove_red_eye,color: showPassword?Colors.blue:Colors.black,),
                    ),
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.security,color: Colors.orange,),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "LG Password"
                  ),
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: TextFormField(
                  controller: portController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.hub,color: Colors.orange,),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "LG Port"
                  ),
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: TextFormField(
                  controller: rigsNumController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.computer,color: Colors.orange,),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Number of LG Rigs"
                  ),
                ),
              ),
            ),
        
            Center(
              child: Container(
                margin: EdgeInsets.all(30),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () async{
                      if(ipController.text.isEmpty){
                        fToast.showToast(child: getToastWidget("IP Address Required", Colors.red, Icons.warning));
                      }
                      else if(usernameController.text.isEmpty){
                        fToast.showToast(child: getToastWidget("Username Required", Colors.red, Icons.warning));
                      }
                      else if(passwordController.text.isEmpty){
                        fToast.showToast(child: getToastWidget("Password Required", Colors.red, Icons.warning));
                      }
                      else if(portController.text.isEmpty){
                        fToast.showToast(child: getToastWidget("Port Required", Colors.red, Icons.warning));
                      }
                      else if(rigsNumController.text.isEmpty){
                        fToast.showToast(child: getToastWidget("Number of LG Rigs Required", Colors.red, Icons.warning));
                      }
                      else{
                        fToast.showToast(child: getToastWidget("Establishing..", Colors.yellow, Icons.warning));
                        await _saveSettings();
                        SSH ssh = SSH();
                        bool? res = await ssh.connectToLiquidGalaxy(fToast);
                        fToast.showToast(child: getToastWidget(res.toString(), Colors.yellow, Icons.warning));
                        setState(() {
                          if(res == true){
                            isConnected = true;
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Connection Status',
                                desc: 'You are successfully connected to the Liquid Galaxy Environment',
                          btnOkOnPress: () {

                            },
                          )..show();
                          }else{
                            isConnected = false;
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Connection Status',
                              desc: 'You are unable to connected to the Liquid Galaxy Environment',
                              btnOkOnPress: () {

                              },
                            )..show();
                          }
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Establish Connection to LG",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                    ),
                  style: getButtonStyle(Colors.redAccent),
                ),
              ),
            ),
        
            Center(
              child: Container(
                margin: EdgeInsets.all(30),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async{
                    SSH ssh = SSH();
                    await ssh.connectToLiquidGalaxy(fToast);
                    SSHSession? sshSession = await ssh.execute(fToast);
                    if(sshSession!=null){
                      print("MESSAGE :: COMMAND EXECUTED SUCCESSFULLY");
                      fToast.showToast(child: getToastWidget("MESSAGE :: COMMAND EXECUTED SUCCESSFULLY", Colors.yellow, Icons.warning));
                    }else{
                      print("MESSAGE :: COMMAND EXECUTION FAILED");
                      fToast.showToast(child: getToastWidget("MESSAGE :: COMMAND EXECUTION FAILED", Colors.yellow, Icons.warning));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Command The LG",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                  ),
                  style: getButtonStyle(Colors.redAccent),
                ),
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}
