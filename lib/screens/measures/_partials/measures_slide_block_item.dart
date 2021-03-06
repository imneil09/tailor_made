import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/providers/snack_bar_provider.dart';
import 'package:tailor_made/screens/measures/_views/measure_edit_dialog.dart';

class MeasuresSlideBlockItem extends StatefulWidget {
  const MeasuresSlideBlockItem({Key key, @required this.measure}) : super(key: key);

  final MeasureModel measure;

  @override
  _MeasuresSlideBlockItemState createState() => _MeasuresSlideBlockItemState();
}

class _MeasuresSlideBlockItemState extends State<MeasuresSlideBlockItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(widget.measure.name),
      subtitle: Text(widget.measure.unit),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkResponse(
            child: Icon(Icons.settings, color: kPrimaryColor.withOpacity(.75)),
            onTap: () => _onTapEditItem(widget.measure),
          ),
        ],
      ),
    );
  }

  void _onSave(String value) {
    final _value = value.trim();
    if (_value.length > 1) {
      Navigator.pop(context, _value);
    }
  }

  void _onTapEditItem(MeasureModel measure) async {
    final _controller = TextEditingController(text: measure.name);

    final itemName = await showEditDialog(
      context: context,
      title: "ITEM NAME",
      children: <Widget>[
        TextField(
          textCapitalization: TextCapitalization.words,
          controller: _controller,
          onSubmitted: (value) => _onSave(value),
        )
      ],
      onDone: () => _onSave(_controller.text),
      onCancel: () => Navigator.pop(context),
    );

    if (itemName == null) {
      return;
    }

    SnackBarProvider.of(context).loading();

    try {
      await measure.reference.updateData(<String, String>{"name": itemName});
      SnackBarProvider.of(context).hide();
    } catch (e) {
      SnackBarProvider.of(context).show(e.toString());
    }
  }
}
