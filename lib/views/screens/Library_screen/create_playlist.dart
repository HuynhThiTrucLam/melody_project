import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';

class CreatePlaylistDialog extends StatefulWidget {
  final Function(String) onCreatePlaylist;

  const CreatePlaylistDialog({Key? key, required this.onCreatePlaylist})
    : super(key: key);

  @override
  State<CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  void _handleCreatePlaylist() {
    widget.onCreatePlaylist(_nameController.text);
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tạo Playlist Mới',
              style: LightTextTheme.headding2.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tạo danh sách phát riêng của bạn và thêm các bài hát yêu thích vào đó.',
              style: LightTextTheme.regular.copyWith(
                fontSize: 14,
                color: LightColorTheme.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Nhập tên playlist',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                hintStyle: LightTextTheme.regular.copyWith(
                  fontSize: 14,
                  color: LightColorTheme.grey,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên playlist';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            CustomButton(
              hintText: 'Tạo Playlist',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _handleCreatePlaylist();
                  Navigator.of(context).pop();
                }
              },
            ),
            const SizedBox(height: 8),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy', style: TextStyle(color: LightColorTheme.grey)),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to show dialog
void showCreatePlaylistDialog(
  BuildContext context,
  Function(String) onCreatePlaylist,
) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return CreatePlaylistDialog(onCreatePlaylist: onCreatePlaylist);
    },
  );
}
