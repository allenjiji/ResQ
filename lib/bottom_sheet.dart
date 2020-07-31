import 'package:flutter/material.dart';

class BottomContainerForm extends StatefulWidget {
  //final List<List<String>> dropdownItems;
  final List<Widget> items;
  final GlobalKey<FormState> formKey;

  const BottomContainerForm({@required this.items, @required this.formKey});

  @override
  _BottomContainerFormState createState() => _BottomContainerFormState();
}

class _BottomContainerFormState extends State<BottomContainerForm> {
  /*void _submit() {
     if (this.formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.yellow,
      child: Form(
        key: widget.formKey,
        child: ListView(
          //itemExtent: h/15,
          children: widget.items,
        ),
      ),
    );
  }
}
