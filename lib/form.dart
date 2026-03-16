import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'main.dart';
import 'widgets/glass_container.dart';
import 'widgets/app_background.dart';
import 'widgets/app_text_field.dart';

class FormPage extends StatefulWidget {
  final Map<String, dynamic>? existingAlbum;
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const FormPage({
    super.key,
    this.existingAlbum,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final namaController = TextEditingController();
  final labelController = TextEditingController();
  final hargaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  XFile? selectedImage;
  final ImagePicker picker = ImagePicker();
  String? existingImageUrl;

  String? selectedKategori;
  bool isLoading = false;
  bool imageError = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingAlbum != null) {
      namaController.text = widget.existingAlbum!["nama"] ?? "";
      labelController.text = widget.existingAlbum!["label"] ?? "";
      hargaController.text = widget.existingAlbum!["harga"].toString();
      selectedKategori = widget.existingAlbum!["kategori"];
      existingImageUrl = widget.existingAlbum!["image_url"];
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        selectedImage = image;
        imageError = false;
      });
    }
  }

  Future<String?> uploadImage() async {
    if (selectedImage == null) return existingImageUrl;

    final userId = supabase.auth.currentUser!.id;
    final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final bytes = await selectedImage!.readAsBytes();

    await supabase.storage
        .from('covers')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );

    return supabase.storage.from('covers').getPublicUrl(fileName);
  }

  Future<void> saveAlbum() async {
    setState(() {
      imageError = selectedImage == null && existingImageUrl == null;
    });

    if (!_formKey.currentState!.validate()) return;
    if (imageError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih cover image terlebih dahulu")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final imageUrl = await uploadImage();
      final userId = supabase.auth.currentUser!.id;

      final data = {
        "user_id": userId,
        "nama": namaController.text.trim(),
        "label": labelController.text.trim(),
        "harga": int.parse(hargaController.text.trim()),
        "kategori": selectedKategori,
        "image_url": imageUrl,
      };

      if (widget.existingAlbum != null) {
        await supabase
            .from('albums')
            .update(data)
            .eq('id', widget.existingAlbum!["id"]);
      } else {
        await supabase.from('albums').insert(data);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal menyimpan: $e")));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          AppBackground(
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 15),

                    GlassContainer(
                      isDark: Theme.of(context).brightness == Brightness.dark,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            "Our Data",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              letterSpacing: 4,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(76, 0, 0, 0),
                                  blurRadius: 10,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                          GlassContainer(
                            isDark:
                                Theme.of(context).brightness == Brightness.dark,
                            padding: const EdgeInsets.all(4),
                            child: IconButton(
                              icon: Icon(
                                Theme.of(context).brightness == Brightness.dark
                                    ? Icons.light_mode
                                    : Icons.dark_mode,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: widget.onToggleTheme,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            GlassContainer(
                              isDark:
                                  Theme.of(context).brightness ==
                                  Brightness.dark,
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.album_rounded,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 30),

                                  buildLabel("Album Name"),
                                  AppTextField(
                                    controller: namaController,
                                    icon: Icons.album,
                                    hint: "Enter album name",
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return "Album name cannot be empty";
                                      }
                                      if (v.trim().length < 2) {
                                        return "Minimal 2 karakter";
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 15),
                                  buildLabel("Artist"),
                                  AppTextField(
                                    controller: labelController,
                                    icon: Icons.person,
                                    hint: "Enter artist name",
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return "Artist name cannot be empty";
                                      }
                                      if (v.trim().length < 2) {
                                        return "Minimal 2 karakter";
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 15),
                                  buildLabel("Contract Value (USD)"),
                                  AppTextField(
                                    controller: hargaController,
                                    icon: Icons.attach_money,
                                    isNumber: true,
                                    hint: "Contoh: 5000000",
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return "Contract value wajib diisi";
                                      }
                                      final parsed = int.tryParse(v.trim());
                                      if (parsed == null) {
                                        return "Hanya angka bulat";
                                      }
                                      if (parsed <= 0) {
                                        return "Nilai harus lebih dari 0";
                                      }
                                      if (parsed > 999999999) {
                                        return "Nilai terlalu besar";
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 15),
                                  buildLabel("Cover Image"),
                                  const SizedBox(height: 10),

                                  Center(
                                    child: SizedBox(
                                      width: 180,
                                      height: 180,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: _buildImagePreview(),
                                            ),
                                          ),
                                          if (selectedImage != null ||
                                              existingImageUrl != null)
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: GestureDetector(
                                                onTap: () => setState(() {
                                                  selectedImage = null;
                                                  existingImageUrl = null;
                                                }),
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.black54,
                                                        shape: BoxShape.circle,
                                                      ),
                                                  padding: const EdgeInsets.all(
                                                    6,
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  GestureDetector(
                                    onTap: pickImage,
                                    child: GlassContainer(
                                      isDark:
                                          Theme.of(context).brightness ==
                                          Brightness.dark,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 16,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.upload,
                                            color: Colors.white70,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "Select Cover Image",
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  if (imageError)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 6),
                                      child: Text(
                                        "Cover image must be selected",
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            255,
                                            142,
                                            142,
                                          ),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),

                                  const SizedBox(height: 15),
                                  buildLabel("Genre"),
                                  buildDropdown(),

                                  const SizedBox(height: 30),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 55,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withValues(alpha: 0.3),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                      ),
                                      onPressed: isLoading ? null : saveAlbum,
                                      child: isLoading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text(
                                              "SAVE DATA",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 2,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    if (selectedImage != null) {
      return kIsWeb
          ? Image.network(selectedImage!.path, fit: BoxFit.cover)
          : Image.file(File(selectedImage!.path), fit: BoxFit.cover);
    }
    if (existingImageUrl != null) {
      return Image.network(
        existingImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.image, size: 40, color: Colors.white54),
      );
    }
    return Container(
      color: Colors.white12,
      child: const Center(
        child: Icon(Icons.image, size: 40, color: Colors.white54),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    IconData icon, {
    bool isNumber = false,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.3),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget buildDropdown() {
    final textStyle = Theme.of(
      context,
    ).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 16);

    return DropdownButtonFormField<String>(
      value: selectedKategori,
      style: textStyle,
      hint: Text(
        "Select Genre",
        style: textStyle.copyWith(color: Colors.white70),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
      dropdownColor: const Color(0xFF1A1A2E),
      menuMaxHeight: 300,
      borderRadius: BorderRadius.circular(20),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      items: ["Pop", "Rock", "R&B", "Jazz", "Hip Hop"]
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: textStyle),
            ),
          )
          .toList(),
      validator: (v) => v == null ? "Genre must be selected" : null,
      onChanged: (val) => setState(() => selectedKategori = val),
    );
  }
}
