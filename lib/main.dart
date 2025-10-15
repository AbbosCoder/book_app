import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';

void main() {
  runApp(VirtualKitobApp());
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
        scaffoldBackgroundColor: Color(0xFFF5F1E8),
      ),
      home: KitoblarSahifasi(),
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
}

class KitoblarSahifasi extends StatefulWidget {
  const KitoblarSahifasi({super.key});

  @override
  _KitoblarSahifasiState createState() => _KitoblarSahifasiState();
}

class _KitoblarSahifasiState extends State<KitoblarSahifasi> {
  List<Kitob> kitoblar = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
                child: kitoblar.isEmpty
                    ? _boshQism()
                    : _kitoblarGridi(),
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
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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
          SizedBox(height: 8),
          Text(
            '${kitoblar.length} ta kitob',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8D6E63),
            ),
          ),
        ],
      ),
    );
  }

  Widget _boshQism() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 100,
            color: Color(0xFFBCAAA4),
          ),
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
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFA1887F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kitoblarGridi() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
            boxShadow: [
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
                    ? Image.file(
                        File(kitob.muqova),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF6D4C41),
                              Color(0xFF4E342E),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.book,
                          size: 60,
                          color: Colors.white54,
                        ),
                      ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black87,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      kitob.nom,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 4,
                          ),
                        ],
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
        gradient: LinearGradient(
          colors: [Color(0xFF8B4513), Color(0xFF5D4037)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF8B4513).withOpacity(0.5),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _kitobQoshish,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(Icons.add, size: 32),
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
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F1E8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Kitob qo\'shish',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5D4037),
                      ),
                    ),
                    SizedBox(height: 24),
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
                            color: Color(0xFF8D6E63),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: muqovaYoli!.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate,
                                    size: 50,
                                    color: Color(0xFF8D6E63),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Muqova tanlash',
                                    style: TextStyle(
                                      color: Color(0xFF8D6E63),
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(muqovaYoli!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: nomController,
                      decoration: InputDecoration(
                        labelText: 'Kitob nomi',
                        labelStyle: TextStyle(color: Color(0xFF8D6E63)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFF8B4513),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: Color(0xFF8D6E63)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Bekor qilish',
                              style: TextStyle(color: Color(0xFF8D6E63)),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (nomController.text.isNotEmpty) {
                                this.setState(() {
                                  kitoblar.add(
                                    Kitob(
                                      nom: nomController.text,
                                      fayl: faylYoli,
                                      muqova: muqovaYoli!,
                                      qoshilganVaqt: DateTime.now(),
                                    ),
                                  );
                                });
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8B4513),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Qo\'shish',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
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

class _KitobOqishSahifasiState extends State<KitobOqishSahifasi>
    with TickerProviderStateMixin {
  int? sahifalar;
  int joriyShifa = 0;
  bool tayyor = false;
  PDFViewController? _pdfController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C2416),
      appBar: AppBar(
        backgroundColor: Color(0xFF3E2723),
        elevation: 0,
        title: Text(
          widget.kitob.nom,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          if (sahifalar != null)
            Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  '${joriyShifa + 1} / $sahifalar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF3E2723), Color(0xFF2C2416)],
              ),
            ),
            child: PDFView(
              filePath: widget.kitob.fayl,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              defaultPage: joriyShifa,
              fitPolicy: FitPolicy.BOTH,
              onRender: (pages) {
                setState(() {
                  sahifalar = pages;
                  tayyor = true;
                });
              },
              onViewCreated: (PDFViewController controller) {
                _pdfController = controller;
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  joriyShifa = page ?? 0;
                });
              },
            ),
          ),
          if (!tayyor)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B4513)),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Color(0xFF3E2723),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.first_page, color: Colors.white),
              iconSize: 32,
              onPressed: () {
                _pdfController?.setPage(0);
              },
            ),
            IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.white),
              iconSize: 32,
              onPressed: joriyShifa > 0
                  ? () {
                      _pdfController?.setPage(joriyShifa - 1);
                    }
                  : null,
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.white),
              iconSize: 32,
              onPressed: sahifalar != null && joriyShifa < sahifalar! - 1
                  ? () {
                      _pdfController?.setPage(joriyShifa + 1);
                    }
                  : null,
            ),
            IconButton(
              icon: Icon(Icons.last_page, color: Colors.white),
              iconSize: 32,
              onPressed: () {
                if (sahifalar != null) {
                  _pdfController?.setPage(sahifalar! - 1);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}