import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../actionbutton_widget.dart';
import '../../util.dart';
import '../survey_data.dart';

class StructureViewInput extends StatefulWidget {
  const StructureViewInput({super.key});

  @override
  State<StructureViewInput> createState() => _StructureViewInputState();
}

class _StructureViewInputState extends State<StructureViewInput> {
  //
  // -------------------------------------- Views Of Structure --------------------------------------
  //

  // call with index == -1 to take an extra picture
  void takeStructureViewPicture(int index) async {
    final XFile? xImg = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xImg == null) {
      Fluttertoast.showToast(msg: "Did not take image");
      return;
    }

    // for non FLRB pictures
    if (index == -1) {
      GetIt.I<SurveyData>().pictures.add(null);
      index = extraPictureNumber + 4;
    }

    GetIt.I<SurveyData>().pictures[index] = xImg;

    if (index <= 3) {
      GetIt.I<SurveyData>().picturesTaken[index] = true;
      setState(() {
        hasTakenPicture[index] = true;
      });
    } else {
      // extra picture
      GetIt.I<SurveyData>().extraPicturesNumber++;
      setState(() {
        extraPictureNumber++;
      });
    }
  }

  Widget cameraButtonIcon({required bool isTicked}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.camera_alt),
        Align(
          alignment: Alignment.bottomRight,
          child: Visibility(
            visible: isTicked,
            child: const Icon(
              Icons.done,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  //                              T      L      R      B
  List<bool> hasTakenPicture = [false, false, false, false];

  Widget buildViewsOfStructure() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Views of the Structure", style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    takeStructureViewPicture(0);
                  },
                  icon: cameraButtonIcon(isTicked: hasTakenPicture[0]),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    takeStructureViewPicture(1);
                  },
                  icon: cameraButtonIcon(isTicked: hasTakenPicture[1]),
                ),
                const Icon(
                  Icons.business_outlined,
                  size: 54,
                ),
                IconButton(
                  onPressed: () {
                    takeStructureViewPicture(2);
                  },
                  icon: cameraButtonIcon(isTicked: hasTakenPicture[2]),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    takeStructureViewPicture(3);
                  },
                  icon: cameraButtonIcon(isTicked: hasTakenPicture[3]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //
  // -------------------------------------- Extra Pictures --------------------------------------
  //

  int extraPictureNumber = 0;

  Widget buildExtraPictures() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text("Additional photographs of the building: ", style: Theme.of(context).textTheme.headline6),
                ),
                const SizedBox(width: 20),
                Text(extraPictureNumber.toString(), style: Theme.of(context).textTheme.headline6),
                const SizedBox(width: 60),
                ActionButton(
                  onPressed: () {
                    takeStructureViewPicture(-1);
                  },
                  icon: const Icon(Icons.camera_enhance_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    extraPictureNumber = GetIt.I<SurveyData>().extraPicturesNumber;
    return Column(
      children: [
        buildViewsOfStructure(),
        const SizedBox(height: 20),
        buildExtraPictures(),
      ],
    );
  }
}
