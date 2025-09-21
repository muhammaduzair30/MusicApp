import 'dart:io';
import 'package:client/core/Theme/app_pallete.dart';
import 'package:client/core/uitils.dart';
import 'package:client/core/widgets/custome_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final songNameController = TextEditingController();
  final artistController = TextEditingController();
  final genreController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;
  final formKey = GlobalKey<FormState>();

  final List<String> genres = [
    'Pop',
    'Rock',
    'Jazz',
    'Hip Hop',
    'Classical',
    'Electronic',
    'Blues',
    'Folk',
    'Soft rock',
    'Nature & Noise',
    'Country',
    'Travel',
    'Focus',
    'Instrumental',
  ];

  @override
  void initState() {
    super.initState();
    requestPermissions(
        context); // Request permissions when the widget is initialized
  }

  void selectAudio() async {
    final pickedAudio = await pickAudio(context);
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage(context);
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    songNameController.dispose();
    artistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewmodelProvider.select((val) => val?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Upload Song'),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate() &&
                  selectedAudio != null &&
                  selectedImage != null) {
                ref.read(homeViewmodelProvider.notifier).uploadSong(
                      selectAudio: selectedAudio!,
                      selectedThumbnail: selectedImage!,
                      songName: songNameController.text,
                      genre: genreController.text,
                      artist: artistController.text,
                      selectedColor: selectedColor,
                    );
              } else {
                showSnackBar(context, 'Missing fields');
              }
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        child: selectedImage != null
                            ? SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : DottedBorder(
                                color: Pallete.borderColor,
                                dashPattern: [10, 4],
                                radius: const Radius.circular(10),
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                child: const SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Select the thumbnail for your song',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      selectedAudio != null
                          ? AudioWave(path: selectedAudio!.path)
                          : CustomeField(
                              hintText: 'Pick Song',
                              controller: null,
                              readOnly: true,
                              onTap: selectAudio,
                              showDropDownIcon: false,
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomeField(
                        hintText: 'Select Genere',
                        controller: genreController,
                        suggestions: genres,
                        showDropDownIcon: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomeField(
                        hintText: 'Artist',
                        controller: artistController,
                        showDropDownIcon: false,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomeField(
                        hintText: 'Song Name',
                        controller: songNameController,
                        showDropDownIcon: false,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ColorPicker(
                          pickersEnabled: {
                            ColorPickerType.wheel: true,
                          },
                          color: selectedColor,
                          onColorChanged: (Color color) {
                            setState(() {
                              selectedColor = color;
                            });
                          })
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
