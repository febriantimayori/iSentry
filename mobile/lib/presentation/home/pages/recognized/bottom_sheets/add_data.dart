// import 'dart:io';
// import 'package:avatar_stack/avatar_stack.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:isentry/presentation/widgets/components/bottom_sheet.dart';
// import 'package:isentry/services/image_picker_service.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class AddData extends StatefulWidget {
//   const AddData({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _AddDataState createState() => _AddDataState();
// }

// class _AddDataState extends State<AddData> {
//   final FocusNode _focusNode = FocusNode();
//   final TextEditingController _nameController = TextEditingController();
//   final List<XFile> _selectedImages = [];

//   void _updateImages(List<XFile> images) {
//     setState(() {
//       _selectedImages.addAll(images);
//     });
//   }

//   void _pickImages() {
//     ImagePickerService.pickImage(
//       context,
//       (images) {
//         _updateImages(images);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomBottomSheet(
//       title: "Add Data",
//       content: Column(
//         children: [
//           Center(
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 if (_selectedImages.isNotEmpty)
//                   AvatarStack(
//                     height: 70,
//                     avatars: _selectedImages
//                         .map((e) => FileImage(File(e.path)))
//                         .toList(),
//                   )
//                 else
//                   GestureDetector(
//                     onTap: _pickImages, // Ikon kamera besar memiliki aksi
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: const BoxDecoration(
//                         color: Colors.black,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         LucideIcons.camera,
//                         size: 35,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 if (_selectedImages.isNotEmpty)
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: GestureDetector(
//                       onTap: _pickImages, // Ikon kecil tetap memiliki aksi
//                       child: Container(
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white,
//                         ),
//                         child: const Padding(
//                           padding: EdgeInsets.all(6),
//                           child: Icon(
//                             LucideIcons.camera,
//                             size: 18,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextField(
//             controller: _nameController,
//             focusNode: _focusNode,
//             cursorColor: Colors.black,
//             decoration: InputDecoration(
//               hintText: 'Name',
//               hintStyle: const TextStyle(color: Colors.grey),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: const BorderSide(
//                   color: Colors.grey,
//                   width: 1.0,
//                 ),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: const BorderSide(
//                   color: Colors.grey,
//                   width: 1.0,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: const BorderSide(
//                   color: Colors.black,
//                   width: 2.0,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 vertical: 12.0,
//                 horizontal: 15.0,
//               ),
//             ),
//           ),
//         ],
//       ),
//       actionButton: Align(
//         alignment: Alignment.centerRight,
//         child: Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.black,
//               padding: const EdgeInsets.symmetric(horizontal: 25),
//             ),
//             child: const Text(
//               "Save",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isentry/presentation/home/bloc/validate/validate_bloc.dart';
import 'package:isentry/presentation/home/bloc/validate/validate_event.dart';
import 'package:isentry/presentation/home/bloc/validate/validate_state.dart';
import 'package:isentry/presentation/widgets/components/bottom_sheet.dart';
import 'package:isentry/services/image_picker_service.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final List<XFile> _selectedImages = [];
  String? _errorMessage;

  void _updateImages(List<XFile> images) {
    setState(() {
      _selectedImages.addAll(images);
    });
  }

  void _pickImages() {
    ImagePickerService.pickImage(
      context,
      (images) {
        _updateImages(images);
        // Validasi wajah setelah gambar dipilih
        if (images.isNotEmpty) {
          _validateFace(images.first);
        }
      },
    );
  }

  void _validateFace(XFile image) {
    final faceValidateBloc = BlocProvider.of<FaceValidateBloc>(context);
    faceValidateBloc.add(ValidateFaceEvent(faceFile: image));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FaceValidateBloc, FaceValidationState>(
      listener: (context, state) {
        if (state is FaceValidationSuccess) {
          // Tindakan jika validasi berhasil
          setState(() {
            _errorMessage = null; // Reset pesan kesalahan
          });
        } else if (state is FaceValidationFailure) {
          // Tindakan jika validasi gagal
          setState(() {
            _errorMessage = state.error; // Tampilkan pesan kesalahan
          });
        }
      },
      child: CustomBottomSheet(
        title: "Add Data",
        content: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_selectedImages.isNotEmpty)
                    AvatarStack(
                      height: 70,
                      avatars: _selectedImages
                          .map((e) => FileImage(File(e.path)))
                          .toList(),
                    )
                  else
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.camera,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (_selectedImages.isNotEmpty)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(
                              LucideIcons.camera,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              focusNode: _focusNode,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Name',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 15.0,
                ),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
        actionButton: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk menyimpan data jika validasi berhasil
                if (_errorMessage == null) {
                  Navigator.of(context).pop(); // Menutup bottom sheet
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 25),
              ),
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
