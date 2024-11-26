import '/http/app_service.dart';
import '/http/model/release_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../service/environment.dart';
import '../../widget/common_widget.dart';
import 'app_controller.dart';

///@Description TODO
///@Author jd

// ignore: must_be_immutable

class CreateAppIntent extends Intent {}

class AppListPage extends StatefulWidget {
  const AppListPage({super.key});

  @override
  State<AppListPage> createState() => _AppListPageState();
}

class _AppListPageState extends State<AppListPage> {
  final AppController _appController = AppController();

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> _columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: '应用信息', fields: ['name', 'path']),
    PlutoColumnGroup(title: '状态', children: [
      PlutoColumnGroup(title: '类型', fields: ['type'], expandedColumn: true),
      PlutoColumnGroup(title: '操作时间', fields: ['create_time']),
    ]),
  ];

  late final PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();
    _appController.init();
  }

  //添加行
  void _addRow(ReleaseInfo releaseInfo) {
    _appController.addRowAction(releaseInfo, stateManager);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: MediaQuery.removePadding(
        //适配手机端
        removeTop: true,
        context: context,
        child: LayoutBuilder(builder: (c, cl) {
          double w =
              cl.maxWidth - 150 - 100 - PlutoGridSettings.columnWidth * 3 - 4;
          w = w > 300 ? w : 300;
          _appController.columns[2].width = w;
          return _buildGrid();
        }),
      ),
    );
  }

  Widget _buildGrid() {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
            CreateAppIntent(),
      },
      child: Actions(
        actions: {
          CreateAppIntent: CallbackAction(onInvoke: (i) {
            print('快捷键新增');
            _addReleaseInfoDialog();
            return null;
          }),
        },
        child: Focus(
          autofocus: true,
          child: PlutoGrid(
              configuration: PlutoGridConfiguration(
                style: PlutoGridStyleConfig(
                  oddRowColor: Colors.grey[50],
                  enableColumnBorderVertical: true,
                  enableColumnBorderHorizontal: true,
                  enableGridBorderShadow: false,
                  gridBorderRadius: BorderRadius.circular(10),
                  gridBorderColor: const Color(0xFFDDE2EB),
                ),
                localeText: const PlutoGridLocaleText.china(),
              ),
              createHeader: (stateManager) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // stateManager.insertRows(
                        //   0,
                        //   [stateManager.getNewRow()],
                        // );
                        _addReleaseInfoDialog();
                      },
                      child: const Text('添加(ctl+n)'),
                    ),
                  ],
                );
              },
              createFooter: (stateManager) {
                return PlutoLazyPagination(
                  // Determine the first page.
                  // Default is 1.
                  initialPage: 1,

                  // First call the fetch function to determine whether to load the page.
                  // Default is true.
                  initialFetch: true,

                  // Decide whether sorting will be handled by the server.
                  // If false, handle sorting on the client side.
                  // Default is true.
                  fetchWithSorting: true,

                  // Decide whether filtering is handled by the server.
                  // If false, handle filtering on the client side.
                  // Default is true.
                  fetchWithFiltering: true,

                  // Determines the page size to move to the previous and next page buttons.
                  // Default value is null. In this case,
                  // it moves as many as the number of page buttons visible on the screen.
                  pageSizeToMove: null,
                  fetch: _appController.fetch,
                  stateManager: stateManager,
                );
              },
              // columnGroups: _columnGroups,
              columns: _appController.columns,
              rows: _appController.rows,
              onChanged: (PlutoGridOnChangedEvent event) {
                print(event);
              },
              onLoaded: (PlutoGridOnLoadedEvent event) {
                stateManager = event.stateManager;
                // stateManager.setShowLoading(true);
                // stateManager.setShowColumnFilter(true);
                print(event);
              }),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pathController = TextEditingController();
  void _addReleaseInfoDialog() {
    showCommonDialog(
        context: context,
        builder: (c) {
          return SizedBox(
            width: 500,
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 40,
                      color: Colors.lightGreen,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '添加新版本',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(c).pop();
                            },
                            child: const Icon(
                              Icons.close,
                            ),
                          ),
                        ],
                      ),
                    ),
                    buildFormTextField("名称", Icons.drive_file_rename_outline,
                        controller: _nameController, notEmpty: true),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: buildFormTextField(
                              "路径",
                              Icons.file_copy_outlined,
                              controller: _pathController,
                              margin: EdgeInsets.zero,
                              notEmpty: true,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _uploadFile();
                            },
                            child: const Text('上传'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 40, right: 40, top: 20, bottom: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _save(c);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                        child: const Text('保存',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _save(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String text = "";
    AppService.add(_nameController.text, _pathController.text, text)
        .then((value) {
      Navigator.of(context).pop();
      if (value != null) {
        _addRow(value);
      }
    });
  }

  void _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result?.files != null) {
      FormData? formData;
      if (result!.files.single.bytes != null) {
        formData = FormData.fromMap({
          'file': MultipartFile.fromBytes(result.files.single.bytes!.toList(),
              filename: result.files.single.name)
        });
      } else if (result.files.single.path != null) {
        formData = FormData.fromMap({
          'file': MultipartFile.fromFileSync(result.files.single.path!,
              filename: result.files.single.name)
        });
      }
      Network.post(environment.path.fileUploadUrl, data: formData)
          .then((value) => {_pathController.text = value.data['path'] ?? ''});
    }
    // platformAdapter
    //     .selectFileAndUpload()
    //     .then((value) =>
    // _pathController.text = value ?? '')
    //     .catchError((error) {
    //   ToastUtils.toastError(error);
    // });
  }
}
