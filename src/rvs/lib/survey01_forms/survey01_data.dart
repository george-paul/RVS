import 'dart:io';

import 'package:path_provider/path_provider.dart';
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

  // form 01
  String? buildingName;
  String? addressLine1;
  String? addressLine2;
  String? addressCityTown;
  List<bool> picturesTaken = [false, false, false, false];
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

  // form 04
  List<bool> lifeCheckboxes = [];

  void calcRVS() async {
    final int surveyNumber = GetIt.I<GlobalData>().surveyNumber;

    if (inspID == null) {
      Fluttertoast.showToast(msg: "Invalid Inspector ID");
      return;
    }
    if (buildingName == null) {
      Fluttertoast.showToast(msg: "Invalid Building Name");
      return;
    }
    if (addressLine1 == null) {
      Fluttertoast.showToast(msg: "Invalid Adress");
      return;
    }
    if (addressLine2 == null) {
      Fluttertoast.showToast(msg: "Invalid Adress");
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
    if (structSys == null && structSysOptions[surveyNumber] != []) {
      Fluttertoast.showToast(msg: "Invalid Structural System");
      return;
    }
    if (floor == null && floorOptions[surveyNumber] != []) {
      Fluttertoast.showToast(msg: "Invalid Floor Type");
      return;
    }
    if (roofGeo == null && roofGeoOptions[surveyNumber] != []) {
      Fluttertoast.showToast(msg: "Invalid Roof Geometry");
      return;
    }
    if (roofMat == null && roofMatOptions[surveyNumber] != []) {
      Fluttertoast.showToast(msg: "Invalid Roof Material");
      return;
    }
    if (mortar == null && mortarOptions[surveyNumber] != []) {
      Fluttertoast.showToast(msg: "Invalid Mortar");
      return;
    }

    if (subOccupancyString != null) {
      subOccupancyString = " - $subOccupancyString";
    } else {
      subOccupancyString = "";
    }

    // assemble life threatening rows
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
    // basically transpose for pdf purposes
    List<List<String>> pdfRows = [];
    for (int colorIdx = 0; colorIdx < tempRows.length; colorIdx++) {
      List<String> color = tempRows[colorIdx];
      for (int i = 0; i < color.length; i++) {
        String ele = color[i];
        if (i >= pdfRows.length) {
          pdfRows.add(["", "", ""]);
        }
        pdfRows[i][colorIdx] = ele;
      }
    }

    //
    //----------------------------- Structure Views -----------------------------
    //

    if (picturesTaken.any((element) => !element)) {
      Fluttertoast.showToast(msg: "Complete structure view photographs");
      return;
    }

    Directory appDocDir = await getApplicationDocumentsDirectory();
    final topImage = await File("${appDocDir.path}/StructureView${0.toString()}").readAsBytes();
    final topView = pw.MemoryImage(topImage);
    final leftImage = await File("${appDocDir.path}/StructureView${1.toString()}").readAsBytes();
    final leftView = pw.MemoryImage(leftImage);
    final rightImage = await File("${appDocDir.path}/StructureView${2.toString()}").readAsBytes();
    final rightView = pw.MemoryImage(rightImage);
    final bottomImage = await File("${appDocDir.path}/StructureView${3.toString()}").readAsBytes();
    final bottomView = pw.MemoryImage(bottomImage);

    //
    //----------------------------- create PDF -----------------------------
    //
    final pageTheme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.base().copyWith(
        header1: pw.TextStyle(
          font: pw.Font.helveticaBold(),
          fontSize: 24,
        ),
        header2: pw.TextStyle(
          font: pw.Font.helveticaOblique(),
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
      pw.Page(
        pageTheme: pageTheme,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Watermark.text(
                "Rapid Visual Screening",
                style: pw.TextStyle.defaultStyle().copyWith(color: const PdfColor.fromInt(0x00dbdbdb)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(0.0),
                child: pw.Column(
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
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        "Building Details",
                        textAlign: pw.TextAlign.left,
                        style: pw.Theme.of(context).header2,
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Table.fromTextArray(
                      headerCount: 0,
                      data: [
                        ["Building Address", "$buildingName, \n$addressLine1, \n$addressLine2, \n$addressCityTown"],
                        ["Occupancy Type", "$occupancyString$subOccupancyString"],
                      ],
                    ),
                    pw.SizedBox(height: 30),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        "Structural Details",
                        textAlign: pw.TextAlign.center,
                        style: pw.Theme.of(context).header2,
                      ),
                    ),
                    pw.SizedBox(height: 20),
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
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        "Life Threatening Parameters",
                        textAlign: pw.TextAlign.center,
                        style: pw.Theme.of(context).header2,
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Table.fromTextArray(
                      headerCount: 0,
                      cellDecoration: (c, data, r) {
                        if (r == 0) {
                          if (c == 0) {
                            return pw.BoxDecoration(color: PdfColor.fromInt(0xa0ff5555));
                          } else if (c == 1) {
                            return pw.BoxDecoration(color: PdfColor.fromInt(0xa0fff24f));
                          } else /* if (c == 2)*/ {
                            return pw.BoxDecoration(color: PdfColor.fromInt(0xa090ff4f));
                          }
                        } else {
                          return pw.BoxDecoration();
                        }
                      },
                      data: [
                        ["Red (Unusable)", "Yellow (Usable with Temporary interventions)", "Green (Usable)"],
                        ...pdfRows,
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // ------------------------------------- structure views -------------------------------------
    pdf.addPage(
      pw.Page(
        pageTheme: pageTheme,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text("Structure Views: ", style: pw.Theme.of(context).header2),
              pw.Expanded(
                child: pw.GridView(
                  crossAxisCount: 3,
                  children: [
                    pw.Container(width: 100),
                    pw.Image(topView, width: 100),
                    pw.Container(width: 100),
                    pw.Image(leftView, width: 100),
                    pw.Container(width: 100),
                    pw.Image(rightView, width: 100),
                    pw.Container(width: 100),
                    pw.Image(bottomView, width: 100),
                    pw.Container(width: 100),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    //
    //----------------------------- Save PDF -----------------------------
    //
    String timeString = DateTime.now().toIso8601String().substring(0, 19).replaceAll(RegExp(r"\D"), "");

    Directory saveDir = await Directory('/storage/emulated/0/Download/RVSreports').create();
    File file = await File('${saveDir.path}/${timeString}_RVSReport.pdf').create();
    await file.writeAsBytes(await pdf.save());

    Fluttertoast.showToast(msg: "Generated PDF at Downloads");
  }
}
