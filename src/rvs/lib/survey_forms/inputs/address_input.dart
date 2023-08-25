import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../util.dart';
import '../survey_data.dart';

class AddressInput extends StatefulWidget {
  const AddressInput({super.key});

  @override
  State<AddressInput> createState() => _AddressInputState();
}

class _AddressInputState extends State<AddressInput> {
  //
  // -------------------------------------- Building Address --------------------------------------
  //
  TextEditingController buildingNameCtl = TextEditingController();
  TextEditingController addressLine1Ctl = TextEditingController();
  TextEditingController addressLine2Ctl = TextEditingController();
  TextEditingController addressCityTownCtl = TextEditingController();
  TextEditingController addressCountryCtl = TextEditingController(text: "India");

  Widget buildBuildingAddress() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Building Name",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: (val) {
                GetIt.I<SurveyData>().buildingName = val.trim();
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                // hintText: "Enter a number",
              ),
              controller: buildingNameCtl,
            ),
            const SizedBox(height: 22.0),
            Text(
              "Address Line 1",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: (val) {
                GetIt.I<SurveyData>().addressLine1 = val.trim();
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                // hintText: "Enter a number",
              ),
              controller: addressLine1Ctl,
            ),
            const SizedBox(height: 22.0),
            Text(
              "Address Line 2",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: (val) {
                GetIt.I<SurveyData>().addressLine2 = val.trim();
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                // hintText: "Enter a number",
              ),
              controller: addressLine2Ctl,
            ),
            const SizedBox(height: 22.0),
            Text(
              "City/Town",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: (val) {
                GetIt.I<SurveyData>().addressCityTown = val.trim();
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                // hintText: "Enter a number",
              ),
              controller: addressCityTownCtl,
            ),
            const SizedBox(height: 22.0),
            Text(
              "Country",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              readOnly: true,
              onTap: () {
                showCountryPicker(
                  context: context,
                  onSelect: (country) {
                    setState(() {
                      addressCountryCtl.text = country.name;
                    });
                    GetIt.I<SurveyData>().addressCountry = country.name.trim();
                  },
                );
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                // hintText: "Enter a number",
              ),
              controller: addressCountryCtl,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBuildingAddress();
  }
}
