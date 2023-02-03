import 'package:rvs/global_data.dart';
import 'package:rvs/survey01_forms/survey01_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../util.dart';

class S01StructSysForm extends StatefulWidget {
  const S01StructSysForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _S01StructSysFormState createState() => _S01StructSysFormState();
}

class _S01StructSysFormState extends State<S01StructSysForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  static const BorderRadius borderRadiusCached = BorderRadius.all(Radius.circular(20.0));
  int surveyNumber = 0;

  @override
  initState() {
    surveyNumber = GetIt.I<GlobalData>().surveyNumber;
    super.initState();
  }

  //
  // ----------------------------- Struct Sys Selector -----------------------------
  //
  int? selectedStructSys;

  Widget buildStructSysSelector() {
    return ExpansionTileCard(
      borderRadius: borderRadiusCached.bottomLeft.x, // equates to the .all.circular's value
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(20),
        title: Text(
          "Structural System",
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          (selectedStructSys != null) ? structSysOptions[surveyNumber][selectedStructSys!].b : "None",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        children: List.generate(structSysOptions[surveyNumber].length, (index) {
          return RadioListTile(
            title: Text(structSysOptions[surveyNumber][index].b),
            groupValue: selectedStructSys,
            value: index,
            onChanged: (val) {
              GetIt.I<Survey01Data>().structSys = structSysOptions[surveyNumber][val as int].b;
              setState(() {
                selectedStructSys = val;
              });
            },
          );
        }),
      ),
    );
  }

  //
  // ----------------------------- Floor Selector -----------------------------
  //

  int? selectedFloor;

  Widget buildFloorSelector() {
    return ExpansionTileCard(
      borderRadius: borderRadiusCached.bottomLeft.x, // equates to the .all.circular's value
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(20),
        title: Text(
          "Floor Type",
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          (selectedFloor != null) ? floorOptions[surveyNumber][selectedFloor!].b : "None",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        children: List.generate(floorOptions[surveyNumber].length, (index) {
          return RadioListTile(
            title: Text(floorOptions[surveyNumber][index].b),
            groupValue: selectedFloor,
            value: index,
            onChanged: (val) {
              GetIt.I<Survey01Data>().floor = floorOptions[surveyNumber][val as int].b;
              setState(() {
                selectedFloor = val;
              });
            },
          );
        }),
      ),
    );
  }

  //
  // ----------------------------- Roof Geo Selector -----------------------------
  //
  int? selectedRoofGeo;

  Widget buildRoofGeoSelector() {
    return ExpansionTileCard(
      borderRadius: borderRadiusCached.bottomLeft.x, // equates to the .all.circular's value
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(20),
        title: Text(
          "Roof Geometry",
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          (selectedRoofGeo != null) ? roofGeoOptions[surveyNumber][selectedRoofGeo!].b : "None",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        children: List.generate(roofGeoOptions[surveyNumber].length, (index) {
          return RadioListTile(
            title: Text(roofGeoOptions[surveyNumber][index].b),
            groupValue: selectedRoofGeo,
            value: index,
            onChanged: (val) {
              GetIt.I<Survey01Data>().roofGeo = roofGeoOptions[surveyNumber][val as int].b;
              setState(() {
                selectedRoofGeo = val;
              });
            },
          );
        }),
      ),
    );
  }

  //
  // ----------------------------- Roof Mat Selector -----------------------------
  //
  int? selectedRoofMat;

  Widget buildRoofMatSelector() {
    return ExpansionTileCard(
      borderRadius: borderRadiusCached.bottomLeft.x, // equates to the .all.circular's value
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(20),
        title: Text(
          "Roof Material",
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          (selectedRoofMat != null) ? roofMatOptions[surveyNumber][selectedRoofMat!].b : "None",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        children: List.generate(roofMatOptions[surveyNumber].length, (index) {
          return RadioListTile(
            title: Text(roofMatOptions[surveyNumber][index].b),
            groupValue: selectedRoofMat,
            value: index,
            onChanged: (val) {
              GetIt.I<Survey01Data>().roofMat = roofMatOptions[surveyNumber][val as int].b;
              setState(() {
                selectedRoofMat = val;
              });
            },
          );
        }),
      ),
    );
  }

  //
  // ----------------------------- Roof Mat Selector -----------------------------
  //
  int? selectedMortar;

  Widget buildMortarSelector() {
    return ExpansionTileCard(
      borderRadius: borderRadiusCached.bottomLeft.x, // equates to the .all.circular's value
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(20),
        title: Text(
          "Mortar",
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          (selectedMortar != null) ? mortarOptions[surveyNumber][selectedMortar!].b : "None",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        children: List.generate(mortarOptions[surveyNumber].length, (index) {
          return RadioListTile(
            title: Text(mortarOptions[surveyNumber][index].b),
            groupValue: selectedMortar,
            value: index,
            onChanged: (val) {
              GetIt.I<Survey01Data>().mortar = mortarOptions[surveyNumber][val as int].b;
              setState(() {
                selectedMortar = val;
              });
            },
          );
        }),
      ),
    );
  }

  //
  // ----------------------------- build -----------------------------
  //
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            buildStructSysSelector(),
            SizedBox(height: 20),
            buildFloorSelector(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 40.0, 20.0, 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Roof", style: Theme.of(context).textTheme.headline5),
              ),
            ),
            buildRoofGeoSelector(),
            SizedBox(height: 20),
            if (roofMatOptions[surveyNumber].isNotEmpty) buildRoofMatSelector(),
            SizedBox(height: 20),
            if (mortarOptions[surveyNumber].isNotEmpty) buildMortarSelector(),
          ],
        ),
      ),
    );
  }
}
