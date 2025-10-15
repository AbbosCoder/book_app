import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const VirtualKitobApp());
}

class VirtualKitobApp extends StatelessWidget {
  const VirtualKitobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Kitob',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFF5F1E8),
      ),
      home: const KitoblarSahifasi(),
    );
  }
}

class Kitob {
  final String nom;
  final String fayl;
  final String muqova;
  final DateTime qoshilganVaqt;

  Kitob({
    required this.nom,
    required this.fayl,
    required this.muqova,
    required this.qoshilganVaqt,
  });

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'fayl': fayl,
        'muqova': muqova,
        'qoshilganVaqt': qoshilganVaqt.toIso8601String(),
      };

  factory Kitob.fromJson(Map<String, dynamic> json) => Kitob(
        nom: json['nom'],
        fayl: json['fayl'],
        muqova: json['muqova'],
        qoshilganVaqt: DateTime.parse(json['qoshilganVaqt']),
      );
}

class KitoblarSahifasi extends StatefulWidget {
  const KitoblarSahifasi({super.key});

  @override
  _KitoblarSahifasiState createState() => _KitoblarSahifasiState();
}

class _KitoblarSahifasiState extends State<KitoblarSahifasi> {
  List<Kitob> kitoblar = [];

  @override
  void initState() {
    super.initState();
    _kitoblarniYuklash();
  }

  Future<void> _kitoblarniSaqlash() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = kitoblar.map((k) => jsonEncode(k.toJson())).toList();
    await prefs.setStringList('kitoblar', jsonList);
  }

  Future<void> _kitoblarniYuklash() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('kitoblar') ?? [];
    setState(() {
      kitoblar = jsonList
          .map((jsonStr) => Kitob.fromJson(jsonDecode(jsonStr)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5F1E8), Color(0xFFE8DCC4)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _headerQism(),
              Expanded(
                child: kitoblar.isEmpty ? _boshQism() : _kitoblarGridi(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _kitobQoshishTugmasi(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _headerQism() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.book, size: 32, color: Color(0xFF8B4513)),
                  SizedBox(width: 12),
                  Text(
                    'Virtual Kutubxona',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                ],
              ),
              // 🔥 YANGI: App info icon
              IconButton(
                onPressed: _appInfoKorsatish,
                icon: const Icon(Icons.info_outline, 
                                size: 28, 
                                color: Color(0xFF8B4513)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${kitoblar.length} ta kitob',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF8D6E63),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 YANGI: App info funksiyasi
  void _appInfoKorsatish() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFF5F1E8),
        title: const Row(
          children: [
            Icon(Icons.book, color: Color(0xFF8B4513)),
            SizedBox(width: 10),
            Text('Virtual Kitob', 
                style: TextStyle(color: Color(0xFF5D4037))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ilova haqida:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Virtual Kitob - bu shaxsiy kutubxonangizni yaratish va PDF kitoblarni saqlash ilovasi.',
              style: TextStyle(color: Color(0xFF8D6E63)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Foydalanuvchi haqida:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sizda ${kitoblar.length} ta kitob mavjud',
              style: const TextStyle(color: Color(0xFF8D6E63)),
            ),
            const SizedBox(height: 8),
            Text(
              'Oxirgi kitob: ${kitoblar.isNotEmpty ? kitoblar.last.nom : "Hali kitob yo'q"}',
              style: const TextStyle(color: Color(0xFF8D6E63)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Yopish', 
                           style: TextStyle(color: Color(0xFF8B4513))),
          ),
        ],
      ),
    );
  }

  Widget _boshQism() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_rounded, size: 100, color: Color(0xFFBCAAA4)),
          SizedBox(height: 20),
          Text(
            'Hali kitoblar yo\'q',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8D6E63),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Kitob qo\'shish uchun pastdagi tugmani bosing',
            style: TextStyle(fontSize: 16, color: Color(0xFFA1887F)),
          ),
        ],
      ),
    );
  }

  Widget _kitoblarGridi() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: kitoblar.length,
      itemBuilder: (context, index) {
        return _kitobKartasi(kitoblar[index]);
      },
    );
  }

  Widget _kitobKartasi(Kitob kitob) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Kitobni o\'chirish'),
            content: Text('"${kitob.nom}" kitobni o\'chirmoqchimisiz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Yo\'q'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    kitoblar.remove(kitob);
                  });
                  _kitoblarniSaqlash();
                  Navigator.pop(context);
                },
                child: const Text('Ha'),
              ),
            ],
          ),
        );
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KitobOqishSahifasi(kitob: kitob),
          ),
        );
      },
      child: Hero(
        tag: kitob.fayl,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                kitob.muqova.isNotEmpty
                    ? Image.file(File(kitob.muqova), fit: BoxFit.cover)
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF6D4C41), Color(0xFF4E342E)],
                          ),
                        ),
                        child: const Icon(Icons.book,
                            size: 60, color: Colors.white54),
                      ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      kitob.nom,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kitobQoshishTugmasi() {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient:
            const LinearGradient(colors: [Color(0xFF8B4513), Color(0xFF5D4037)]),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4513).withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _kitobQoshish,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }

  Future<void> _kitobQoshish() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      String? faylYoli = result.files.single.path;
      if (faylYoli != null) {
        _muqovaVaNomTanlash(faylYoli);
      }
    }
  }

  Future<void> _muqovaVaNomTanlash(String faylYoli) async {
    String? muqovaYoli = '';
    TextEditingController nomController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F1E8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Kitob qo\'shish',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if (result != null) {
                        setState(() {
                          muqovaYoli = result.files.single.path;
                        });
                      }
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFF8D6E63), width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: muqovaYoli!.isEmpty
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate,
                                    size: 50, color: Color(0xFF8D6E63)),
                                SizedBox(height: 8),
                                Text('Muqova tanlash',
                                    style: TextStyle(color: Color(0xFF8D6E63))),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(File(muqovaYoli!),
                                  fit: BoxFit.cover),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nomController,
                    decoration: InputDecoration(
                      labelText: 'Kitob nomi',
                      labelStyle:
                          const TextStyle(color: Color(0xFF8D6E63)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF8B4513),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            side:
                                const BorderSide(color: Color(0xFF8D6E63)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Bekor qilish',
                              style: TextStyle(color: Color(0xFF8D6E63))),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (nomController.text.isNotEmpty) {
                              // 🔥 MUHIM: Yangi kitob qo'shgandan so'ng setState chaqiramiz
                              Navigator.pop(context); // Avval dialogni yopamiz
                              setState(() {
                                kitoblar.add(Kitob(
                                  nom: nomController.text,
                                  fayl: faylYoli,
                                  muqova: muqovaYoli ?? '',
                                  qoshilganVaqt: DateTime.now(),
                                ));
                              });
                              _kitoblarniSaqlash(); // 🔥 Saqlash
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B4513),
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Qo\'shish',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

class KitobOqishSahifasi extends StatefulWidget {
  final Kitob kitob;
  const KitobOqishSahifasi({super.key, required this.kitob});

  @override
  _KitobOqishSahifasiState createState() => _KitobOqishSahifasiState();
}

class _KitobOqishSahifasiState extends State<KitobOqishSahifasi> {
  int? sahifalar;
  int joriySahifa = 0;
  bool tayyor = false;
  PDFViewController? _pdfController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2416),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        title: Text(widget.kitob.nom),
        actions: [
          if (sahifalar != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text('${joriySahifa + 1} / $sahifalar'),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.kitob.fayl,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            onRender: (pages) {
              setState(() {
                sahifalar = pages;
                tayyor = true;
              });
            },
            onViewCreated: (controller) {
              _pdfController = controller;
            },
            onPageChanged: (page, total) {
              setState(() {
                joriySahifa = page ?? 0;
              });
            },
          ),
          if (!tayyor)
            const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xFF8B4513)),
              ),
            ),
        ],
      ),
    );
  }
}