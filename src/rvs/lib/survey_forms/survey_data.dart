import 'package:flutter/foundation.dart';

import '../save_results/save_results_base.dart'
    if (dart.library.html) "../save_results/save_results_web.dart"
    if (dart.library.io) "../save_results/save_results_android.dart";

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rvs/global_data.dart';
import 'package:rvs/util.dart';
import 'package:rvs/vulnerability_element.dart' as vuln;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

final List<List<Pair<bool, String>>> structSysOptions = [
  [
    Pair(false, "Igneous Rocks"),
    Pair(false, "Sedimentary Rocks"),
    Pair(false, "Slate Blocks"),
  ],
  [
    Pair(false, "Moment Frame"),
    Pair(false, "Moment Frame with Structural Walls"),
    Pair(false, "Moment Frame with Braces"),
  ],
  // [
  //   Pair(false, "Burnt Clay Bricks"),
  //   Pair(false, "Cement Blocks"),
  //   Pair(false, "Stone Blocks"),
  // ],
  // [
  //   Pair(false, "Igneous Rocks"),
  //   Pair(false, "Sedimentary Rocks"),
  //   Pair(false, "Slate Blocks"),
  // ],
  // [
  //   Pair(false, "Timber frame without diagonal braces"),
  //   Pair(false, "Timber frame with diagonal braces"),
  // ],
  // [
  //   Pair(false, "Unstrengthened mud courses"),
  //   Pair(false, "Slurry of wet mud"),
  //   Pair(false, "Locally available grass"),
  // ],
  // [
  //   Pair(false, "Load Bearing Masonry Structure"),
  // ],
];

final List<List<Pair<bool, String>>> floorOptions = [
  [
    Pair(false, "RC Slab"),
    Pair(false, "Timber planks & beams"),
  ],
  [
    Pair(false, "In-Situ"),
    Pair(false, "Precast Planks with in-situ screed"),
    Pair(false, "Precast"),
  ],
  // [
  //   Pair(false, "RC Slab"),
  // ],
  // [
  //   Pair(false, "RC Slab"),
  //   Pair(false, "Timber planks on timber beams"),
  // ],
  // [
  //   Pair(false, "Timber beams with wooden planks"),
  //   Pair(false, "Timber frame with stone planks"),
  // ],
  // [
  //   Pair(false, "Mud Plastered"),
  // ],
  // [
  //   Pair(false, "RC Slab"),
  //   Pair(false, "Precast Planks with in-situ screed"),
  // ],
];

final List<List<Pair<bool, String>>> roofGeoOptions = [
  [
    Pair(false, "Flat"),
    Pair(false, "Pitched"),
    Pair(false, "Hipped"),
  ],
  [
    Pair(false, "Flat"),
    Pair(false, "Hipped"),
    Pair(false, "Pitched"),
  ],
  // [
  //   Pair(false, "Flat"),
  //   Pair(false, "Pitched"),
  //   Pair(false, "Hipped"),
  //   Pair(false, "Split"),
  // ],
  // [
  //   Pair(false, "Flat"),
  //   Pair(false, "Pitched"),
  //   Pair(false, "Hipped"),
  //   Pair(false, "Split"),
  // ],
  // [
  //   Pair(false, "Flat"),
  //   Pair(false, "Pitched"),
  //   Pair(false, "Hipped"),
  //   Pair(false, "Split"),
  // ],
  // [
  //   Pair(false, "Pitched"),
  //   Pair(false, "Hipped"),
  // ],
  // [
  //   Pair(false, "Flat"),
  //   Pair(false, "Pitched"),
  //   Pair(false, "Hipped"),
  //   Pair(false, "Split"),
  // ],
];

final List<List<Pair<bool, String>>> roofMatOptions = [
  [
    Pair(false, "RC Slab"),
    Pair(false, "Wooden Truss with Clay Tiles"),
    Pair(false, "Corrugated Sheets"),
    Pair(false, "Wood Planks"),
    Pair(false, "Steel Truss with Clay Tiles"),
  ],
  [],
  // [
  //   Pair(false, "RC Slab"),
  //   Pair(false, "Wood with Clay Tiles"),
  //   Pair(false, "Wood Truss with Corrugated Sheets"),
  //   Pair(false, "Wood with Wooden Planks"),
  // ],
  // [
  //   Pair(false, "RC Slab"),
  //   Pair(false, "Wood with Clay Tiles"),
  //   Pair(false, "Wood Truss with Corrugated Sheets"),
  //   Pair(false, "Wood with Wooden Planks"),
  // ],
  // [
  //   Pair(false, "Timber truss with Timber planks"),
  //   Pair(false, "Timber truss with corrugated GI sheets"),
  // ],
  // [
  //   Pair(false, "Thatch + Bamboo"),
  //   Pair(false, "Wood truss with clay tiles"),
  //   Pair(false, "Wood truss with corrugated sheets"),
  //   Pair(false, "Wood truss with wooden planks"),
  // ],
  // [
  //   Pair(false, "RC Slab"),
  //   Pair(false, "Wood with Clay Tiles"),
  //   Pair(false, "Wood Truss with Corrugated Sheets"),
  //   Pair(false, "Wood with Wooden Planks"),
  // ],
];

final List<List<Pair<bool, String>>> mortarOptions = [
  [
    Pair(false, "Cement"),
    Pair(false, "Mud"),
    Pair(false, "Lime"),
  ],
  [],
  [
    Pair(false, "Cement"),
    Pair(false, "Mud"),
    Pair(false, "Lime"),
    Pair(false, "No Mortar"),
  ],
  [
    Pair(false, "Cement"),
    Pair(false, "Mud"),
    Pair(false, "Lime"),
    Pair(false, "No Mortar"),
  ],
  [],
  [],
  [
    Pair(false, "Cement"),
    Pair(false, "Mud"),
    Pair(false, "Lime"),
    Pair(false, "No Mortar"),
  ],
];

class SurveyData {
  // form 00
  String? inspID1;
  String? inspID2;
  String? inspID3;
  String? inspDate;
  String? inspTime;
  String? coords;

  // form 01
  String? buildingName;
  String? addressLine1;
  String? addressLine2;
  String? addressCityTown;
  String? addressCountry = "India";
  List<bool> picturesTaken = [false, false, false, false];
  int extraPicturesNumber = 0;
  //                       T     L     R     B
  List<XFile?> pictures = [null, null, null, null];

  // struct sys
  String? structSys;

  // struct details
  String? floor;
  String? roofGeo;
  String? roofMat; // Can stay null
  String? mortar; // Can stay null

  // occupancy
  int? occupancy;
  String? occupancyString;
  int? subOccupancy;
  String? subOccupancyString; // Can stay null
  String? otherOccupancyString;

  // calculation form
  bool calcDone = false;
  String suggestedInterventions = "";

  // form 04
  List<bool?> vulnCheckboxes = [];
  int suggScansPicturesNumber = 0;
  List<XFile?> suggScansPictures = [];
  bool? buildingToBeSealed;
  bool? buildingToBeDemolished;

  //
  //----------------------------- Helper Functions -----------------------------
  //

  String getInspIDString() {
    String result = "$inspID1";
    if (inspID2 != null && inspID2 != "") {
      result += ", $inspID2";
    }
    if (inspID3 != null && inspID3 != "") {
      result += ", $inspID3";
    }
    return result;
  }

  pw.Align pdfSubheading(String text, context) {
    return pw.Align(
      alignment: pw.Alignment.centerLeft,
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.left,
        style: pw.Theme.of(context).header2,
      ),
    );
  }

  Future<List<pw.MemoryImage>> genMemoryImagesFromXFileList(List<XFile?> list, int length) async {
    List<pw.MemoryImage> memImgList = [];
    for (int i = 0; i < length; i++) {
      Uint8List data = await list[i]!.readAsBytes();
      memImgList.add(pw.MemoryImage(data));
    }

    return memImgList;
  }

  Future<pw.Widget> pdfImagesWidget() async {
    List<pw.MemoryImage> buildingViews = [];
    for (int i = 0; i < 4; i++) {
      Uint8List data = await pictures[i]!.readAsBytes();
      buildingViews.add(pw.MemoryImage(data));
    }

    // rearrange to match descriptions
    List<pw.MemoryImage> buildingViewsTemp = [];
    buildingViewsTemp.add(buildingViews[3]);
    buildingViewsTemp.add(buildingViews[0]);
    buildingViewsTemp.add(buildingViews[1]);
    buildingViewsTemp.add(buildingViews[2]);
    buildingViews.clear();
    buildingViews.addAll(buildingViewsTemp);

    // // half of the a4 width and some extra
    // double maxWidth = (PdfPageFormat.a4.availableWidth / 2) - (PdfPageFormat.a4.availableWidth / 10);
    // double actualHeight = PdfPageFormat.a4.availableHeight - (heightHeaderFooter * 2);
    // // - 25*2 for descriptions
    // double maxHeight = (actualHeight / 2) - (25 * 2) - (actualHeight / 20);

    const imageDescriptions = [
      "Front View",
      "Back View",
      "Left View",
      "Right View",
    ];

    List<pw.Widget> imageWidgetList = [];
    for (int j = 0; j < buildingViews.length; j++) {
      var img = buildingViews[j];
      imageWidgetList.add(
        // pw.Container(
        //   child: pw.Column(
        //     // mainAxisSize: pw.MainAxisSize.min,
        //     mainAxisAlignment: pw.MainAxisAlignment.center,
        //     crossAxisAlignment: pw.CrossAxisAlignment.center,
        //     children: [
        //       pw.Container(
        //         width: maxWidth,
        //         child: pw.Padding(
        //           padding: const pw.EdgeInsets.all(10),
        //           child: pw.Image(img),
        //         ),
        //       ),
        //       pw.Text(imageDescriptions[j]),
        //     ],
        //   ),
        // ),

        pw.Container(
          // width: maxWidth,
          // height: maxHeight,
          child: pw.Padding(
            padding: const pw.EdgeInsets.all(10),
            child: pw.Image(img),
          ),
        ),
      );
    }

    // insert descriptions
    imageWidgetList.insert(2, pw.Text(imageDescriptions[0]));
    imageWidgetList.insert(3, pw.Text(imageDescriptions[1]));
    imageWidgetList.insert(6, pw.Text(imageDescriptions[2]));
    imageWidgetList.insert(7, pw.Text(imageDescriptions[3]));

    // layout
    return pw.Container(
      // = height - headerfooter - subheading height - extra
      height: PdfPageFormat.a4.availableHeight - (heightHeaderFooter * 2) - 20 - 50,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Expanded(
            child: pw.Row(
              mainAxisSize: pw.MainAxisSize.max,
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Expanded(child: imageWidgetList[0]),
                pw.Expanded(child: imageWidgetList[1]),
              ],
            ),
          ),
          pw.Row(
            mainAxisSize: pw.MainAxisSize.max,
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              imageWidgetList[2],
              imageWidgetList[3],
            ],
          ),
          pw.Expanded(
            child: pw.Row(
              mainAxisSize: pw.MainAxisSize.max,
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Expanded(child: imageWidgetList[4]),
                pw.Expanded(child: imageWidgetList[5]),
              ],
            ),
          ),
          pw.Row(
            mainAxisSize: pw.MainAxisSize.max,
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              imageWidgetList[6],
              imageWidgetList[7],
            ],
          ),
        ],
      ),
    );
  }

  static const Color hfColorOrange = Color.fromARGB(255, 254, 176, 59);
  static const Color hfColorGreen = Color.fromARGB(255, 76, 210, 76);
  static const Color headerFooterTextColor = Color.fromARGB(255, 103, 103, 103);

  // This should always match the height of pdfHeader and pdfFooter
  static const double heightHeaderFooter = 20 + 20 + 1 + 3 + 1;
  // = content + padding under/above + border + between + border

  pw.Widget pdfHeader(pw.Context context) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          margin: pw.EdgeInsets.symmetric(vertical: 5),
          height: 20,
          child: pw.Align(
            alignment: pw.Alignment.bottomLeft,
            child: pw.Text(
              "Level 1 Post-Earthquake Safety Assessment Report",
              style: pw.Theme.of(context).header4,
            ),
          ),
        ),
        pw.SizedBox(
          // borderSide appears on the middle of the actual border (I think)
          height: 20 + 1 + 3 + 1,
          child: pw.Padding(
            padding: pw.EdgeInsets.only(bottom: 20),
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  top: pw.BorderSide(width: 2, color: PdfColor.fromInt(hfColorOrange.value)),
                  bottom: pw.BorderSide(width: 2, color: PdfColor.fromInt(hfColorGreen.value)),
                ),
              ),
              height: 3,
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget pdfFooter(pw.Context context) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          // borderSide appears on the middle of the actual border (I think)
          height: 20 + 1 + 3 + 1,
          child: pw.Padding(
            padding: pw.EdgeInsets.only(top: 20),
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  top: pw.BorderSide(width: 2, color: PdfColor.fromInt(hfColorOrange.value)),
                  bottom: pw.BorderSide(width: 2, color: PdfColor.fromInt(hfColorGreen.value)),
                ),
              ),
              height: 3,
            ),
          ),
        ),
        pw.Container(
          margin: pw.EdgeInsets.symmetric(vertical: 5),
          height: 20,
          child: pw.Align(
            alignment: pw.Alignment.topRight,
            child: pw.Text(
              "Sponsored by National Disaster Management Authority, India",
              style: pw.Theme.of(context).header4,
            ),
          ),
        ),
      ],
    );
  }

  pw.Page imagePage(pw.MemoryImage img, String caption) {
    const double imagePageCaptionHeight = 50;
    double pageWidth = PdfPageFormat.a4.width;
    double scaleFactor = pageWidth / img.width!;
    double pageHeight = img.height! * scaleFactor;
    return pw.Page(
      pageFormat: PdfPageFormat(
        pageWidth + 1,
        pageHeight + imagePageCaptionHeight + 5,
      ),
      build: (pw.Context context) {
        return pw.Column(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Container(
              width: pageWidth,
              child: pw.Image(img),
            ),
            pw.Container(
              height: imagePageCaptionHeight,
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(imagePageCaptionHeight / 10),
                child: pw.Text(caption, style: pw.Theme.of(context).header2),
              ),
            ),
          ],
        );
      },
    );
  }
  //
  //----------------------------- Calculation and Validation -----------------------------
  //

  Future<void> calcPESA() async {
    GetIt.I<SurveyData>().calcDone = false;
    final int surveyNumber = GetIt.I<GlobalData>().surveyNumber;

    // form validation

    if (inspID1 == null) {
      Fluttertoast.showToast(msg: "Invalid Inspector ID");
      return;
    }
    if (coords == null) {
      Fluttertoast.showToast(msg: "Invalid Location");
      return;
    }
    if (buildingName == null) {
      Fluttertoast.showToast(msg: "Invalid Building Name");
      return;
    }
    if (addressLine1 == null) {
      Fluttertoast.showToast(msg: "Invalid Address");
      return;
    }
    if (addressLine2 == null) {
      Fluttertoast.showToast(msg: "Invalid Address");
      return;
    }
    if (addressCityTown == null) {
      Fluttertoast.showToast(msg: "Invalid Adress");
      return;
    }

    if (picturesTaken.contains(false)) {
      Fluttertoast.showToast(msg: "Complete the structure view photographs");
      return;
    }

    if (structSys == null && structSysOptions[surveyNumber].isNotEmpty) {
      Fluttertoast.showToast(msg: "Invalid Structural System");
      return;
    }
    if (floor == null && floorOptions[surveyNumber].isNotEmpty) {
      Fluttertoast.showToast(msg: "Invalid Floor Type");
      return;
    }
    if (roofGeo == null && roofGeoOptions[surveyNumber].isNotEmpty) {
      Fluttertoast.showToast(msg: "Invalid Roof Geometry");
      return;
    }
    if (roofMat == null && roofMatOptions[surveyNumber].isNotEmpty) {
      Fluttertoast.showToast(msg: "Invalid Roof Material");
      return;
    }
    if (mortar == null && mortarOptions[surveyNumber].isNotEmpty) {
      Fluttertoast.showToast(msg: "Invalid Mortar");
      return;
    }

    if (occupancy == null) {
      Fluttertoast.showToast(msg: "Invalid Occupancy");
      return;
    }
    if (otherOccupancyString != null) {
      occupancyString = otherOccupancyString;
    } else if (subOccupancyString != null) {
      if (!subOccupancyString!.contains("-") && subOccupancyString != "None") {
        subOccupancyString = " - $subOccupancyString";
        occupancyString = occupancyString! + subOccupancyString!;
      }
    } else {
      subOccupancyString = "";
    }

    if (buildingToBeSealed == null) {
      Fluttertoast.showToast(msg: "Specify whether building is to be sealed");
      return;
    }
    if (buildingToBeDemolished == null) {
      Fluttertoast.showToast(msg: "Specify whether building is to be demolished");
      return;
    }

    List<vuln.VulnElement> vulnElements = vuln.getFormVulnElements(vuln.possibleElements, surveyNumber);
    // remove checkboxes at heading indices
    for (int i = 0; i < vulnCheckboxes.length; i++) {
      if (vulnElements[i].runtimeType == vuln.VulnHeading) {
        continue;
      }
      if (vulnCheckboxes[i] == null) {
        Fluttertoast.showToast(msg: "Please select all vulnerability parameters");
        return;
      }
    }

    //----------------------------- Parameter Table rows and colour rating -----------------------------

    // assemble factors temp rows
    List<List<String>> tempRows = [[], [], []];
    for (int i = 0; i < vulnElements.length; i++) {
      vuln.VulnElement ele = vulnElements[i];
      if (ele.runtimeType == vuln.VulnQuestion) {
        ele = ele as vuln.VulnQuestion;
        if (vulnCheckboxes[i]!) {
          tempRows[ele.color.index].add(ele.text);
        }
      }
    }

    // do a transpose for pdf displaying purposes
    List<List<String>> pdfTableRows = [];
    for (int colorIdx = 0; colorIdx < tempRows.length; colorIdx++) {
      List<String> color = tempRows[colorIdx];
      for (int i = 0; i < color.length; i++) {
        String ele = color[i];
        if (i >= pdfTableRows.length) {
          pdfTableRows.add(["", "", ""]);
        }
        pdfTableRows[i][colorIdx] = ele;
      }
    }
    // remove empty cells
    for (int i = 0; i < pdfTableRows.length; i++) {
      List<String> row = pdfTableRows[i];
      for (int j = 0; j < row.length; j++) {
        if (row[j] == "") {
          pdfTableRows[i].removeAt(j);
          j--;
        }
      }
    }

    String colourRating = "";
    Color colourRatingColor = Colors.black;
    if (tempRows[0].isNotEmpty) {
      colourRating = "Red - The structure is unusable";
      colourRatingColor = Colors.red.shade800;
    } else if (tempRows[1].isNotEmpty) {
      colourRating = "Yellow - The structure is usable \nwith temporary interventions";
      colourRatingColor = Colors.yellow.shade800;
    } else {
      colourRating = "Green - Usable";
      colourRatingColor = Colors.green.shade800;
    }

    //
    //----------------------------- create PDF -----------------------------
    //

    const Color watermarkColor = Color.fromARGB(255, 198, 198, 198);

    final pageTheme = pw.PageTheme(
      buildBackground: ((context) {
        return pw.Watermark.text(
          "IIIT Hyderabad",
          style: pw.TextStyle.defaultStyle().copyWith(color: PdfColor.fromInt(watermarkColor.value)),
        );
      }),
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.base().copyWith(
        // Title Heading
        header1: pw.TextStyle(
          font: pw.Font.helveticaBold(),
          fontSize: 24,
        ),

        // subheadings
        header2: pw.TextStyle(
          font: pw.Font.helveticaBold(),
          fontSize: 15,
        ),

        // header/footer style
        header4: pw.TextStyle(
          color: PdfColor.fromInt(headerFooterTextColor.value),
          font: pw.Font.helvetica(),
          fontSize: 9,
        ),

        // under title
        header5: pw.TextStyle(
          font: pw.Font.helveticaOblique(),
          fontSize: 12,
        ),

        defaultTextStyle: pw.TextStyle(
          font: pw.Font.helvetica(),
          fontSize: 13,
        ),
      ),
    );

    final pdf = pw.Document();

    // --------------- Heading and building details Page ---------------

    pdf.addPage(
      pw.MultiPage(
        header: pdfHeader,
        footer: pdfFooter,
        pageTheme: pageTheme,
        build: (pw.Context context) {
          return [
            pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text(
                "REPORT",
                style: pw.Theme.of(context).header1,
              ),
            ),
            pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text(
                "Generated at $inspTime on $inspDate by ${getInspIDString()}",
                textAlign: pw.TextAlign.center,
                style: pw.Theme.of(context).header5,
              ),
            ),
            pw.SizedBox(height: 50),
            pdfSubheading("Building Details", context),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headerCount: 0,
              data: [
                ["Building Type", surveyTitles[surveyNumber].surveyPdfTitle],
                ["Building GPS Coordinates", coords],
                [
                  "Building Address",
                  "$buildingName, \n$addressLine1, \n$addressLine2, \n$addressCityTown, $addressCountry"
                ],
                ["Occupancy Type", "$occupancyString"],
              ],
            ),
          ];
        },
      ),
    );

    // --------------- images Page ---------------

    pw.Widget imagesWidget = await pdfImagesWidget();

    pdf.addPage(
      pw.MultiPage(
        header: pdfHeader,
        footer: pdfFooter,
        pageTheme: pageTheme,
        build: (pw.Context context) {
          return [
            pdfSubheading("Building Views", context),
            pw.SizedBox(height: 10),
            imagesWidget,
          ];
        },
      ),
    );

    // --------------- Rest Page ---------------

    pdf.addPage(
      pw.MultiPage(
        header: pdfHeader,
        footer: pdfFooter,
        pageTheme: pageTheme,
        build: (pw.Context context) {
          return [
            pdfSubheading("Structural Details", context),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headerCount: 0,
              data: [
                ["Structural System", "$structSys"],
                ["Floor Type", "$floor"],
                ["Roof Geometry", "$roofGeo"],
                if (roofMat != null) ["Roof Material", "$roofMat"],
                if (mortar != null) ["Mortar Type", "$mortar"],
              ],
            ),
            pw.SizedBox(height: 30),
            pdfSubheading("Life Threatening Parameters", context),
            pw.SizedBox(height: 10),
            if (pdfTableRows.isNotEmpty)
              pw.Table.fromTextArray(
                headerCount: 0,
                cellDecoration: (c, data, r) {
                  data = data as String;
                  if (r == 0) {
                    if (data.contains("Red")) {
                      return const pw.BoxDecoration(color: PdfColor.fromInt(0xa0ff5555));
                    } else if (data.contains("Yellow")) {
                      return const pw.BoxDecoration(color: PdfColor.fromInt(0xa0fff24f));
                    } else /* if (c == 2)*/ {
                      return const pw.BoxDecoration(color: PdfColor.fromInt(0xa090ff4f));
                    }
                  } else {
                    return const pw.BoxDecoration();
                  }
                },
                data: [
                  [
                    if (tempRows[0].isNotEmpty) "Red (Unusable)",
                    if (tempRows[1].isNotEmpty) "Yellow (Usable with Temporary interventions)",
                    if (tempRows[2].isNotEmpty) "Green (Usable)",
                  ],
                  ...pdfTableRows,
                ],
              )
            else
              pw.Text("None"),
            pw.SizedBox(height: 30),
            pdfSubheading("Final Colour Rating", context),
            pw.SizedBox(height: 10),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                // pw.Text("This structure is rated: "),
                pw.Text(
                  colourRating,
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(colourRatingColor.value),
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 30),
            pdfSubheading("Recommended Further Actions", context),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headerCount: 0,
              data: [
                ["Building is to be sealed?", (buildingToBeSealed!) ? "Yes" : "No"],
                ["Building is to be demolished?", (buildingToBeDemolished!) ? "Yes" : "No"],
              ],
            ),
            pw.SizedBox(height: 10),
            pdfSubheading("Suggested Interventions", context),
            pw.SizedBox(height: 10),
            pw.Text(
              (suggestedInterventions == "") ? "None" : suggestedInterventions,
              textAlign: pw.TextAlign.left,
            ),
            pw.SizedBox(height: 20),
            pdfSubheading("Additional Scans and Extra Building Views", context),
            pw.SizedBox(height: 10),
            pw.Text(
                "No. of additional scans: $suggScansPicturesNumber\nNo. of extra building views: ${pictures.length - 4}\nPlease refer to the following pages for the above mentioned."),
          ];
        },
      ),
    );

    // ---------------- Extra Views Page ---------------
    if (pictures.length - 4 > 0) {
      List<pw.MemoryImage> extraViewMemImages =
          await genMemoryImagesFromXFileList(pictures.sublist(4), extraPicturesNumber);

      for (int k = 0; k < extraViewMemImages.length; k++) {
        pw.MemoryImage img = extraViewMemImages[k];
        pdf.addPage(
          imagePage(
            img,
            "Extra Building View #${k + 1}",
          ),
        );
      }
    }

    // --------------- Additional Scans Page ---------------

    List<pw.MemoryImage> suggScanMemImages =
        await genMemoryImagesFromXFileList(suggScansPictures, suggScansPicturesNumber);

    for (int k = 0; k < suggScanMemImages.length; k++) {
      pw.MemoryImage img = suggScanMemImages[k];
      pdf.addPage(
        imagePage(
          img,
          "Aditional Scan #${k + 1}",
        ),
      );
    }

    // --------------- Save ---------------

    String timeString = "$inspDate$inspTime".replaceAll(RegExp(r"\D"), "");
    SaveResults().save(pdf, timeString, pictures);
    Fluttertoast.showToast(msg: "Generated results at Downloads");
  }
}
