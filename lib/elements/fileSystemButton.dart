import 'package:lyric/data/data.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:path/path.dart';
import '../data/song.dart';

class FileSystemButton extends StatelessWidget {
  final bool checked;
  final element;
  final Function onChanged;

  FileSystemButton(this.checked, this.element, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      margin: EdgeInsets.only(left: 4, bottom: 4, right: checked ? 0 : 3),
      height: 30,
      child: HoverButton(
        builder: (context, buttonStates) {
          return FocusBorder(
              focused: (buttonStates.isFocused),
              child: AnimatedContainer(
                  decoration: BoxDecoration(
                      color: (buttonStates.isHovering)
                          ? Colors.grey[120]
                          : checked
                              ? Colors.grey[130]
                              : Colors.grey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                          topRight: checked ? Radius.zero : Radius.circular(4),
                          bottomRight:
                              checked ? Radius.zero : Radius.circular(4))),
                  padding: EdgeInsets.all(3),
                  duration: Duration(milliseconds: 100),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon((element is Folder)
                            ? FeatherIcons.folder
                            : ((element is Song)
                                ? FeatherIcons.music
                                : FeatherIcons.columns)),
                      ),
                      Expanded(
                        child: Text(
                          basename(element.fileEntity.path).split(".")[0],
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                      if (checked) Icon(FeatherIcons.chevronRight)
                    ],
                  )));
        },
        onPressed: () {
          onChanged(element);
        },
      ),
    );
  }
}
