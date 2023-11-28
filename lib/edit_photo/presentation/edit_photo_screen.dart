import 'dart:io';

import 'package:editingapp/edit_photo/bloc/download_status.dart';
import 'package:editingapp/edit_photo/component/dialog/confirmation_dialog.dart';
import 'package:editingapp/edit_photo/component/dialog/loading_dialog.dart';
import 'package:editingapp/edit_photo/component/dialog/success_dialog.dart';
import 'package:editingapp/edit_photo/component/snackbar/info_snackbar.dart';
import 'package:editingapp/edit_photo/model/dragable_widget_child.dart';
import 'package:editingapp/edit_photo/presentation/cubit/edit_photo_cubit.dart';
import 'package:editingapp/edit_photo/presentation/pages/add_text_layout.dart';
import 'package:editingapp/edit_photo/presentation/widget/dragable_widget.dart';
import 'package:editingapp/edit_photo/presentation/widget/edit_photo_widget.dart';
import 'package:editingapp/edit_photo/presentation/widget/menu_icon_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';

class EditPhotoScreen extends StatelessWidget {
  EditPhotoScreen({super.key, required this.photo});
  File photo;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditPhotoCubit(),
      child: EditPhotoLayout(
        photo: photo,
      ),
    );
  }
}

class EditPhotoLayout extends StatefulWidget {
  EditPhotoLayout({super.key, required this.photo});
  late File photo;
  @override
  State<EditPhotoLayout> createState() => _EditPhotoLayoutState();
}

class _EditPhotoLayoutState extends State<EditPhotoLayout> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return BlocListener<EditPhotoCubit, EditPhotoState>(
      listenWhen: (p, c) {
        return p.shareStatus != c.shareStatus ||
            p.downloadStatus != c.downloadStatus;
      },
      listener: (context, state) {
        if (state.shareStatus == DownloadStatus.downloading) {
          showLoadingDialog(context);
        }
        if (state.shareStatus == DownloadStatus.success) {
          Navigator.pop(context);
        }

        if (state.downloadStatus == DownloadStatus.downloading) {
          showLoadingDialog(context);
        }
        if (state.downloadStatus == DownloadStatus.success) {
          Navigator.pop(context);
          showSuccessDialog(context, "Success Download!");
        }

        if (state.shareStatus == DownloadStatus.failed ||
            state.downloadStatus == DownloadStatus.failed) {
          Navigator.pop(context);
          showInfoSnackBar(
            context,
            "Something wrong when downloading photo, please try again!",
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            ///
            Screenshot(
              controller: screenshotController,
              child: EditPhotoWidget(photo: widget.photo),
            ),

            ///
            Positioned(
              top: MediaQuery.of(context).padding.top + mq.height * .0230,
              left: mq.width * .0350,
              child: MenuIconWidget(
                onTap: () async {
                  BlocProvider.of<EditPhotoCubit>(context);
                  final result = await showConfirmationDialog(
                    context,
                    title: "Discard Edits",
                    desc:
                        "Are you sure want to Exit ? You'll lose all the edits you've made",
                  );
                  if (result == null) return;

                  if (result) {
                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                },
                icon: Icons.arrow_back_ios_new_rounded,
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + mq.height * .0230,
              right: mq.width * .0350,
              child: MenuIconWidget(
                onTap: () async {
                  context
                      .read<EditPhotoCubit>()
                      .changeShareStatus(DownloadStatus.downloading);

                  final image = await screenshotController.capture(
                    delay: const Duration(milliseconds: 200),
                  );
                  if (!mounted) return;
                  context.read<EditPhotoCubit>().shareImage(image);
                },
                icon: CupertinoIcons.arrow_down_to_line,
              ),
            ),

            Positioned(
              right: mq.width * .0350,
              bottom: MediaQuery.of(context).padding.bottom + mq.height * .0800,
              child: MenuIconWidget(
                onTap: () async {
                  context
                      .read<EditPhotoCubit>()
                      .changeEditState(EditState.addingText);

                  final result = await addText(context);

                  if (result == null || result is! DragableWidgetTextChild) {
                    if (!mounted) return;
                    context
                        .read<EditPhotoCubit>()
                        .changeEditState(EditState.idle);
                    return;
                  }

                  final widget = DragableWidget(
                    widgetId: DateTime.now().millisecondsSinceEpoch,
                    child: result,
                    onPress: (id, widget) async {
                      if (widget is DragableWidgetTextChild) {
                        context
                            .read<EditPhotoCubit>()
                            .changeEditState(EditState.addingText);

                        final result = await addText(
                          context,
                          widget,
                        );

                        if (result == null ||
                            result is! DragableWidgetTextChild) {
                          if (!mounted) return;
                          context
                              .read<EditPhotoCubit>()
                              .changeEditState(EditState.idle);
                          return;
                        }

                        if (!mounted) return;
                        context.read<EditPhotoCubit>().editWidget(id, result);
                      }
                    },
                    onLongPress: (id) async {
                      final result = await showConfirmationDialog(
                        context,
                        title: "Delete Text ?",
                        desc: "Are you sure want to Delete this text ?",
                        rightText: "Delete",
                      );
                      if (result == null) return;

                      if (result) {
                        if (!mounted) return;
                        context.read<EditPhotoCubit>().deleteWidget(id);
                      }
                    },
                  );

                  if (!mounted) return;
                  context.read<EditPhotoCubit>().addWidget(widget);
                },
                icon: Icons.text_fields_rounded,
              ),
            )
          ],
        ),
      ),
    );
  }
}
