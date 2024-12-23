import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/presentation/home/bloc/identity/detail_identity_bloc.dart';
import 'package:isentry/presentation/home/bloc/identity/detail_identity_event.dart';
import 'package:isentry/presentation/home/bloc/identity/detail_identity_state.dart';
import 'package:isentry/presentation/widgets/components/bottom_sheet.dart';
import 'package:isentry/services/image_picker_service.dart';
import 'package:lucide_icons/lucide_icons.dart';

class EditData extends StatefulWidget {
  final String name;
  final int id;
  const EditData({super.key, required this.name, required this.id});

  @override
  // ignore: library_private_types_in_public_api
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailIdentityBloc, DetailIdentityState>(
      listener: (context, state) {
        if (state is IdentityFailure) {
        } else if (state is NameUpdated) {
          Navigator.of(context).pop();
        }
      },
      child: CustomBottomSheet(
        title: "Edit Data",
        content: Column(
          children: [
            Center(
              child: InkWell(
                onTap: () => ImagePickerService.pickImage(context, (image) {}),
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
            ),
            const SizedBox(height: 20),
            TextField(
              focusNode: _focusNode,
              cursorColor: Colors.black,
              controller: nameController,
              decoration: InputDecoration(
                hintText: widget.name,
                hintStyle: const TextStyle(color: Colors.black),
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
                context.read<DetailIdentityBloc>().add(
                      UpdateName(
                        id: widget.id.toString(),
                        name: nameController.text,
                      ),
                    );
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
