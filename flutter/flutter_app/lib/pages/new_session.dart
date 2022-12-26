// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter_app/models/api_error.dart';
import 'package:flutter_app/models/api_response.dart';
import 'package:flutter_app/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import '../models/device.dart';

class NewSession extends StatefulWidget {
  const NewSession({super.key});

  @override
  _NewSessionState createState() => _NewSessionState();
}

class _NewSessionState extends State<NewSession> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  Color mycolor = Colors.yellow;
  String selectedEmoji = "👕";
  bool emojiShowing = false;
  late String dropdownvalue;
  late Device currentDevice;
  late Future<List<Device>> devices;
  String _laundryName = "";

  Future<List<Device>> fetchDevices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    return getDevices(token);
  }

  void selectEmoji(Category? category, Emoji emoji) {
    setState(() {
      selectedEmoji = emoji.emoji;
    });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token").toString();
      ApiResponse apiResponse = await createLaundrySession(
          token, currentDevice.id, _laundryName, selectedEmoji, mycolor.hex);
      if ((apiResponse.apiError) == null) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/laundry', ModalRoute.withName('/home_device'));
      } else {
        showInSnackBar((apiResponse.apiError as ApiError).error.toString());
      }
    }
    // if (titleController.va)
  }

  @override
  void initState() {
    super.initState();
    devices = fetchDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Start new session"),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            setState(() {
              if (emojiShowing) emojiShowing = false;
            });
          },
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                  width: 200.0,
                  height: 80.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: mycolor,
                      shape: const CircleBorder(),
                    ),
                    child: Text(
                      selectedEmoji,
                      style: const TextStyle(
                        fontSize: 50,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        emojiShowing = !emojiShowing;
                      });
                    },
                  )),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      enableSuggestions: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Pranie name be not  empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _laundryName = value.toString();
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.abc),
                        labelText: 'Pranie name',
                        border: OutlineInputBorder(),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FutureBuilder<List<Device>>(
                    future: devices,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        currentDevice = snapshot.data![0];
                        return DropdownButton(
                          value: snapshot.data![0],
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: List.generate(snapshot.data!.length, (index) {
                            return DropdownMenuItem(
                              value: snapshot.data![index],
                              child: Text(snapshot.data![index].name),
                            );
                          }).toList(),
                          onChanged: (Object? newValue) {
                            setState(() {
                              currentDevice = newValue as Device;
                            });
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    }),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Card(
                    elevation: 2,
                    child: ColorPicker(
                      // Use the screenPickerColor as start color.
                      color: mycolor,
                      // Update the screenPickerColor using the callback.
                      onColorChanged: (Color color) =>
                          setState(() => mycolor = color),
                      enableShadesSelection: false,
                      pickersEnabled: const <ColorPickerType, bool>{
                        ColorPickerType.primary: true,
                        ColorPickerType.accent: false,
                      },
                      width: 40,
                      height: 40,
                      borderRadius: 20,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(30.0),
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  onPressed: _handleSubmitted,
                  child: const Text(
                    'Start session',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Offstage(
                offstage: !emojiShowing,
                child: SizedBox(
                    height: 250,
                    child: EmojiPicker(
                      onEmojiSelected: selectEmoji,
                      // textEditingController: _controller,
                      config: const Config(
                        columns: 7,
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        showRecentsTab: true,
                        recentsLimit: 28,
                        replaceEmojiOnLimitExceed: false,
                        noRecents: Text(
                          'No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        loadingIndicator: SizedBox.shrink(),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                        checkPlatformCompatibility: true,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
