import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';

class cameraAccess extends StatefulWidget {
  @override
  State<cameraAccess> createState() => _cameraAccessState();
}

class _cameraAccessState extends State<cameraAccess> {
  File imagefile = File('assets/images/logo1.png');

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(() {
      imagefile = File(pickedFile!.path);
    });
    final path = 'files/${pickedFile!.name}';
    final Storageref = FirebaseStorage.instance.ref();
    final mountainsRef = Storageref.child(path);

    mountainsRef.putFile(imagefile);
  }

  void _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(() {
      imagefile = File(pickedFile!.path);
    }); //.child(path)
    final path = 'files/${pickedFile!.name}';
    final Storageref = FirebaseStorage.instance.ref();
    final mountainsRef = Storageref.child(path);

    mountainsRef.putFile(imagefile);
  }

  //String filepath,
  late String locationMessage = '';
  late String long="";
  late String  lat="";

  Future<void> _getlocation() async {


    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    lat =  '${position.latitude}';
    long = '${position.longitude}';

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title:  Text(locationMessage.toString(),style: TextStyle(fontSize: 12),),
      ),

      body: ListView(children: [

        Text(locationMessage.toString()),
        SizedBox(
          height: 20,
          width: 10,
        ),
        imagefile != null
            ? Container(
          child: Image.file(imagefile),
        )
            : Container(
          child: Icon(
            Icons.camera_enhance_rounded,
            color: Colors.green,
            size: MediaQuery.of(context).size.width * .6,
          ),
        ),
      ]),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        children: [
          SpeedDialChild(
            //speed dial child
            child: Icon(Icons.upload),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Upload From Gallery',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              _getFromGallery();
            },
            onLongPress: () => print('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.camera_alt),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Open Camera',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              _getFromCamera();
            },
            onLongPress: () => print('SECOND CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.location_on),
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            label: 'Get Location ',
            labelStyle: TextStyle(fontSize: 18.0),

            onTap: () {
              _getlocation();
              setState(() {
                locationMessage = 'latitute : $lat  ,longitude : $long';
              });
            }
            ,
            onLongPress: () => print('THIRD CHILD LONG PRESS'),

          ),

        ],
      ),



    );
  }
}

