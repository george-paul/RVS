import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rvs/global_data.dart';
import 'package:rvs/util.dart';
import 'package:rvs/vulnerability_data.dart' as vuln;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../vulnerability_data.dart';

final List<List<Pair<bool, String>>> structSysOptions = [
  [
    Pair(false, "Moment Frame"),
    Pair(false, "Moment Frame with Braces"),
    Pair(false, "Moment Frame with Structural Walls"),
  ],
  [
    Pair(false, "Load Bearing Masonry Structure"),
  ],
  [
    Pair(false, "Burnt Clay Bricks"),
    Pair(false, "Cement Blocks"),
    Pair(false, "Stone Blocks"),
  ],
  [
    Pair(false, "Igneous Rocks"),
    Pair(false, "Sedimentary Rocks"),
    Pair(false, "Slate Blocks"),
  ],
  [
    Pair(false, "Timber frame without diagonal braces"),
    Pair(false, "Timber frame with diagonal braces"),
  ],
  [
    Pair(false, "Unstrengthened mud courses"),
    Pair(false, "Slurry of wet mud"),
    Pair(false, "Locally available grass"),
  ],
  [
    Pair(false, "Load Bearing Masonry Structure"),
  ],
];

final List<List<Pair<bool, String>>> floorOptions = [
  [
    Pair(false, "In-Situ"),
    Pair(false, "Precast Planks with in-situ screed"),
    Pair(false, "Precast"),
  ],
  [
    Pair(false, "RC Slab"),
    Pair(false, "Precast Planks with in-situ screed"),
  ],
  [
    Pair(false, "RC Slab"),
  ],
  [
    Pair(false, "RC Slab"),
    Pair(false, "Timber planks on timber beams"),
  ],
  [
    Pair(false, "Timber beams with wooden planks"),
    Pair(false, "Timber frame with stone planks"),
  ],
  [
    Pair(false, "Mud Plastered"),
  ],
  [
    Pair(false, "RC Slab"),
    Pair(false, "Precast Planks with in-situ screed"),
  ],
];

final List<List<Pair<bool, String>>> roofGeoOptions = [
  [
    Pair(false, "Flat"),
    Pair(false, "Pitched"),
    Pair(false, "Hipped"),
    Pair(false, "Split"),
  ],
  [
    Pair(false, "Flat"),
    Pair(false, "Pitched"),
    Pair(false, "Hipped"),
    Pair(false, "Split"),
  ],
  [
    Pair(false, "Flat"),
    Pair(false, "Pitched"),
    Pair(false, "Hipped"),
    Pair(false, "Split"),
  ],
  [
    Pair(false, "Flat"),
    Pair(false, "Pitched"),
    Pair(false, "Hipped"),
    Pair(false, "Split"),
  ],
  [
    Pair(false, "Flat"),
    Pair(false, "Pitched"),
    Pair(false, "Hipped"),
    Pair(false, "Split"),
  ],
  [
    Pair(false, "Pitched"),
    Pair(false, "Hipped"),
  ],
  [
    Pair(false, "Flat"),
    Pair(false, "Pitched"),
    Pair(false, "Hipped"),
    Pair(false, "Split"),
  ],
];

final List<List<Pair<bool, String>>> roofMatOptions = [
  [],
  [
    Pair(false, "RC Slab"),
    Pair(false, "Wood with Clay Tiles"),
    Pair(false, "Wood Truss with Corrugated Sheets"),
    Pair(false, "Wood with Wooden Planks"),
  ],
  [
    Pair(false, "RC Slab"),
    Pair(false, "Wood with Clay Tiles"),
    Pair(false, "Wood Truss with Corrugated Sheets"),
    Pair(false, "Wood with Wooden Planks"),
  ],
  [
    Pair(false, "RC Slab"),
    Pair(false, "Wood with Clay Tiles"),
    Pair(false, "Wood Truss with Corrugated Sheets"),
    Pair(false, "Wood with Wooden Planks"),
  ],
  [
    Pair(false, "Timber truss with Timber planks"),
    Pair(false, "Timber truss with corrugated GI sheets"),
  ],
  [
    Pair(false, "Thatch + Bamboo"),
    Pair(false, "Wood truss with clay tiles"),
    Pair(false, "Wood truss with corrugated sheets"),
    Pair(false, "Wood truss with wooden planks"),
  ],
  [
    Pair(false, "RC Slab"),
    Pair(false, "Wood with Clay Tiles"),
    Pair(false, "Wood Truss with Corrugated Sheets"),
    Pair(false, "Wood with Wooden Planks"),
  ],
];

final List<List<Pair<bool, String>>> mortarOptions = [
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

class Survey01Data {
  // form 00
  String? inspID;
  String? inspDate;
  String? inspTime;
  String? coords;

  // form 01
  String? buildingName;
  String? addressLine1;
  String? addressLine2;
  String? addressCityTown;
  List<bool> picturesTaken = [false, false, false, false];
  int extraPicturesNumber = 0;
  List<XFile?> pictures = [null, null, null, null];
  int? occupancy;
  String? occupancyString;
  int? subOccupancy;
  String? subOccupancyString; // Can stay null

  // form 02
  String? structSys;
  String? floor;
  String? roofGeo;
  String? roofMat; // Can stay null
  String? mortar; // Can stay null

  // calculation form
  bool calcDone = false;
  String suggestedInterventions = "";

  // form 04
  List<bool> lifeCheckboxes = [];
  List<bool> ecoCheckboxes = [];
  bool buildingToBeQuarantined = false;
  bool detailedScreening = false;

  void calcRVS() async {
    GetIt.I<Survey01Data>().calcDone = false;
    final int surveyNumber = GetIt.I<GlobalData>().surveyNumber;

    if (inspID == null) {
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
    if (occupancy == null) {
      Fluttertoast.showToast(msg: "Invalid Occupancy");
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

    if (subOccupancyString != null) {
      if (!subOccupancyString!.contains("-")) subOccupancyString = " - $subOccupancyString";
    } else {
      subOccupancyString = "";
    }

    // assemble factors temp rows
    List<vuln.VulnElement> lifeElements = vuln.getFormVulnElements(vuln.possibleLifeThreatening, surveyNumber);
    List<List<String>> tempRows = [[], [], []];
    for (int i = 0; i < lifeElements.length; i++) {
      VulnElement ele = lifeElements[i];
      if (ele.runtimeType == VulnQuestion) {
        ele = ele as VulnQuestion;
        if (lifeCheckboxes[i]) {
          tempRows[ele.color.index].add(ele.text);
        }
      }
    }

    List<vuln.VulnElement> ecoElements = vuln.getFormVulnElements(vuln.possibleEconomicLoss, surveyNumber);
    for (int i = 0; i < ecoElements.length; i++) {
      VulnElement ele = ecoElements[i];
      if (ele.runtimeType == VulnQuestion) {
        ele = ele as VulnQuestion;
        if (ecoCheckboxes[i]) {
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
    final pageTheme = pw.PageTheme(
      buildBackground: ((context) {
        return pw.Watermark.text(
          "Rapid Visual Screening",
          style: pw.TextStyle.defaultStyle().copyWith(color: const PdfColor.fromInt(0x00dbdbdb)),
        );
      }),
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.base().copyWith(
        header1: pw.TextStyle(
          font: pw.Font.helveticaBold(),
          fontSize: 24,
        ),
        header2: pw.TextStyle(
          font: pw.Font.helveticaBold(),
          fontSize: 15,
        ),
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
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (pw.Context context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    "RVS REPORT",
                    style: pw.Theme.of(context).header1,
                  ),
                ),
                pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    "Generated at $inspTime on $inspDate by $inspID",
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
                    ["Building Type", surveyTitles[surveyNumber]],
                    ["Building GPS Coordinates", coords],
                    ["Building Address", "$buildingName, \n$addressLine1, \n$addressLine2, \n$addressCityTown"],
                    ["Occupancy Type", "$occupancyString$subOccupancyString"],
                  ],
                ),
                pw.SizedBox(height: 30),
                pdfSubheading("Structural Details", context),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headerCount: 0,
                  data: [
                    ["Structural System", "$structSys"],
                    ["Floor Type", "$floor"],
                    ["Roof Geometry", "$roofGeo"],
                    if (roofMat != null) ["Roof Geometry", "$roofGeo"],
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
                    ["Building is to be quarantined?", (buildingToBeQuarantined) ? "Yes" : "No"],
                    ["Level 2 Detailed Screening is required?", (detailedScreening) ? "Yes" : "No"],
                  ],
                ),
                pw.SizedBox(height: 30),
                pdfSubheading("Suggested Interventions", context),
                pw.SizedBox(height: 10),
                pw.Text(
                  (suggestedInterventions == "") ? "None" : suggestedInterventions,
                  textAlign: pw.TextAlign.left,
                ),
              ],
            ),
          ];
        },
      ),
    );

    if (kIsWeb) {
      saveResultsWeb(pdf);
    } else if (Platform.isAndroid) {
      saveResultsAndroid(pdf);
    }
  }

  void saveResultsAndroid(pdf) async {
    //
    //----------------------------- Save PDF -----------------------------
    //
    String timeString = "$inspDate$inspTime".replaceAll(RegExp(r"\D"), "");

    Directory saveDir = await Directory("/storage/emulated/0/Download/RVSreports").create();
    File file = await File("${saveDir.path}/${timeString}_RVSReport.pdf").create();
    await file.writeAsBytes(await pdf.save());

    //
    //----------------------------- Save Images -----------------------------
    //
    for (int index = 0; index < pictures.length; index++) {
      XFile xImg = pictures[index]!;
      String fileLabel = "";
      switch (index) {
        case 0:
          fileLabel = "Front";
          break;
        case 1:
          fileLabel = "Left";
          break;
        case 2:
          fileLabel = "Right";
          break;
        case 3:
          fileLabel = "Back";
          break;
        default:
          fileLabel = "Extra${index - 3}";
      }
      File file = await File("${saveDir.path}/${timeString}_StructureView$fileLabel.png").create();
      await file.writeAsBytes(await xImg.readAsBytes());
    }
  }

  void saveResultsWeb(pw.Document pdf) async {
    Archive archive = Archive();

    //
    //----------------------------- Save PDF -----------------------------
    //
    String timeString = "$inspDate$inspTime".replaceAll(RegExp(r"\D"), "");
    Uint8List pdfBytes = await pdf.save();
    archive.addFile(ArchiveFile("${timeString}_RVSReport.pdf", pdfBytes.length, pdfBytes));

    //
    //----------------------------- Save Images -----------------------------
    //
    for (int index = 0; index < pictures.length; index++) {
      XFile xImg = pictures[index]!;
      String fileLabel = "";
      switch (index) {
        case 0:
          fileLabel = "Front";
          break;
        case 1:
          fileLabel = "Left";
          break;
        case 2:
          fileLabel = "Right";
          break;
        case 3:
          fileLabel = "Back";
          break;
        default:
          fileLabel = "Extra${index - 3}";
      }
      Uint8List xImgBytes = await xImg.readAsBytes();
      archive.addFile(ArchiveFile("${timeString}_StructureView$fileLabel.png", xImgBytes.length, xImgBytes));
    }

    Uint8List archiveBytes = Uint8List.fromList(ZipEncoder().encode(archive)!);
    triggerDownload(bytes: archiveBytes, downloadName: "${timeString}_RVSReport.zip");
    Fluttertoast.showToast(msg: "Generated results");
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
}
