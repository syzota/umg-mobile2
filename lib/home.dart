import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'form.dart';
import 'login.dart';
import 'main.dart';
import 'widgets/glass_container.dart';
import 'widgets/app_background.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const HomePage({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "All Genres";
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAlbums();
  }

  Future<void> fetchAlbums() async {
    setState(() => isLoading = true);
    try {
      final response = await supabase
          .from('albums')
          .select()
          .order('created_at', ascending: false);
      if (mounted) {
        setState(() => items = List<Map<String, dynamic>>.from(response));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> deleteAlbum(String id) async {
    try {
      await supabase.from('albums').delete().eq('id', id);
      await fetchAlbums();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
      }
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginPage(
            onToggleTheme: widget.onToggleTheme,
            themeMode: widget.themeMode,
          ),
        ),
      );
    }
  }

  String formatCurrency(dynamic angka) {
    int value = int.tryParse(angka.toString()) ?? 0;
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$ ',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredItems = selectedCategory == "All Genres"
        ? items
        : items.where((item) => item["kategori"] == selectedCategory).toList();

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        const Icon(Icons.album_rounded, color: Colors.white),
                        const Text(
                          "Universal Music Group",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 3,
                            shadows: [
                              Shadow(
                                color: Color.fromARGB(76, 0, 0, 0),
                                blurRadius: 10,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GlassContainer(
                              isDark:
                                  Theme.of(context).brightness ==
                                  Brightness.dark,
                              padding: const EdgeInsets.all(4),
                              child: IconButton(
                                icon: Icon(
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Icons.light_mode
                                      : Icons.dark_mode,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: widget.onToggleTheme,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GlassContainer(
                              isDark:
                                  Theme.of(context).brightness ==
                                  Brightness.dark,
                              padding: const EdgeInsets.all(4),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.logout_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Logout"),
                                    content: const Text("Yakin ingin keluar?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Batal"),
                                      ),
                                      TextButton(
                                        onPressed: logout,
                                        child: const Text(
                                          "Logout",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Our Albums",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 70,
                            letterSpacing: 4,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Color(0xFF020840),
                            height: 1.0,
                            shadows: [
                              Shadow(
                                color: const Color.fromARGB(115, 255, 255, 255),
                                blurRadius: 10,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Universal Music Group Management",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Color(0xFF020840),
                            fontSize: 28,
                            letterSpacing: 1.5,
                            height: 1.0,
                            shadows: [
                              Shadow(
                                color: const Color.fromARGB(115, 255, 255, 255),
                                blurRadius: 10,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "All Genres",
                          "Pop",
                          "Rock",
                          "R&B",
                          "Jazz",
                          "Hip Hop",
                        ].map((e) => categoryChip(e)).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : filteredItems.isEmpty
                        ? Center(
                            child: GlassContainer(
                              isDark:
                                  Theme.of(context).brightness ==
                                  Brightness.dark,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 20,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.library_music_outlined,
                                    color: Colors.white.withValues(alpha: 0.5),
                                    size: 50,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "No Artists Registered",
                                    style: TextStyle(
                                      color: Color.fromARGB(216, 255, 255, 255),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: fetchAlbums,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                return artistGlassCard(item);
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.15)
                  : const Color.fromARGB(255, 2, 8, 64).withValues(alpha: 0.50),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 30),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FormPage(
                      onToggleTheme: widget.onToggleTheme,
                      themeMode: widget.themeMode,
                    ),
                  ),
                );
                fetchAlbums();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget artistGlassCard(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GlassContainer(
        isDark: Theme.of(context).brightness == Brightness.dark,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: item["image_url"] != null && item["image_url"] != ""
                  ? Image.network(
                      item["image_url"],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.album_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  : const Icon(
                      Icons.album_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item["nama"].toString().toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: 1,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                blurRadius: 8,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        child: Text(
                          item["kategori"] ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 11,
                            letterSpacing: 1,
                            shadows: [
                              Shadow(
                                color: Colors.cyanAccent,
                                blurRadius: 8.0,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    item["label"] ?? "Unknown Artist",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatCurrency(item["harga"]),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      fontSize: 17,
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(122, 24, 255, 255),
                          blurRadius: 6.0,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit_note_rounded,
                    color: Colors.white70,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FormPage(
                          existingAlbum: item,
                          onToggleTheme: widget.onToggleTheme,
                          themeMode: widget.themeMode,
                        ),
                      ),
                    );
                    fetchAlbums();
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white60,
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Hapus Album"),
                      content: Text("Yakin hapus \"${item["nama"]}\"?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Batal"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            deleteAlbum(item["id"]);
                          },
                          child: const Text(
                            "Hapus",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryChip(String text) {
    bool isSelected = selectedCategory == text;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = text),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.5)
                    : Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.1)
                    : const Color.fromARGB(
                        255,
                        2,
                        8,
                        64,
                      ).withValues(alpha: 0.50),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withValues(alpha: isSelected ? 0.6 : 0.2),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.black87 : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
