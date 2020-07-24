import 'package:flutter/material.dart';

class BottomContainerForm extends StatefulWidget {
  final List<List<String>> dropdownItems;

  const BottomContainerForm({@required this.dropdownItems});

  @override
  _BottomContainerFormState createState() => _BottomContainerFormState();
}

class _BottomContainerFormState extends State<BottomContainerForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _selectedValue = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.yellow,
      child: Form(
        key: _formKey,
        child: ListView(
          //itemExtent: h/15,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: "Name/പേര് ", labelText: "Name/പേര് "),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "Phone/ഫോൺ ", labelText: "Phone/ഫോൺ "),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: "Place/സ്ഥലം", labelText: "Place/സ്ഥലം"),
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: "District/ജില്ല", labelText: "District/ജില്ല"),
            ),
            DropdownButton(
              hint: Text("Select Your Need"),
              value: _selectedValue,
              items: widget.dropdownItems
                  .map((e) => DropdownMenuItem(
                        child: Text(e[0]),
                        value: e[1],
                      ))
                  .toList(),
              onChanged: (value) {
                print("selected $value from dropdown");
                setState(() {
                  _selectedValue = "$value";
                });
              },
              onTap: () {
                setState(() {});
              },
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  hintText: "Description/വിവരണം", labelText: "Description/വിവരണം"),
            ),
            ButtonTheme(
              minWidth: double.infinity,
              //height:,
              child: FlatButton(
                onPressed: () {},
                child: Text("SUBMIT"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
