import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(PawsPreferencesApp());
}

class PawsPreferencesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paws & Preferences',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFFFF6F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pinkAccent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: CatSwipePage(),
    );
  }
}

class CatSwipePage extends StatefulWidget {
  @override
  State<CatSwipePage> createState() => _CatSwipePageState();
}

class _CatSwipePageState extends State<CatSwipePage> {
  List<String> catUrls = [];
  List<String> likedCats = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCats();
  }

  void fetchCats() {
    catUrls = List.generate(
      10,
      (_) => 'https://cataas.com/cat?${Random().nextInt(9999)}',
    );
    setState(() {});
  }

  void swipe(bool liked) {
    if (liked) likedCats.add(catUrls[currentIndex]);
    setState(() => currentIndex++);
  }

  @override
  Widget build(BuildContext context) {
    if (currentIndex >= catUrls.length) {
      return _buildResults();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paws & Preferences',
          style: GoogleFonts.pacifico(fontSize: 26),
        ),
      ),
      body: catUrls.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: Dismissible(
                      key: ValueKey(catUrls[currentIndex]),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        swipe(
                          direction == DismissDirection.endToStart
                              ? false
                              : true,
                        );
                      },
                      background: _swipeBackground(
                        icon: Icons.favorite,
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                      ),
                      secondaryBackground: _swipeBackground(
                        icon: Icons.close,
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                      ),
                      child: _catCard(catUrls[currentIndex]),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Swipe right to like 💖, left to skip 👋',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  '${currentIndex + 1} / ${catUrls.length}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _catCard(String url) {
    return Card(
      elevation: 10,
      shadowColor: Colors.pinkAccent.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: SizedBox(
          width: 360,
          height: 450,
          child: Image.network(
            url,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.error, size: 60, color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _swipeBackground({
    required IconData icon,
    required Color color,
    required Alignment alignment,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      color: color.withOpacity(0.15),
      child: Icon(icon, size: 48, color: color),
    );
  }

  Widget _buildResults() {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Favourites 💕')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You liked ${likedCats.length} cats!',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This page shows all the cats you liked while swiping. '
              'You can scroll through them neatly, and if you want, you can play again to see more cats! '
              'All cat images are from Cataas.com.',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: likedCats.isEmpty
                  ? const Center(
                      child: Text(
                        'No cats liked 😿',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                      itemCount: likedCats.length,
                      itemBuilder: (_, i) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            likedCats[i],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.error,
                              size: 50,
                              color: Colors.red,
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    likedCats.clear();
                    currentIndex = 0;
                    fetchCats();
                  });
                },
                icon: const Icon(Icons.replay),
                label: const Text('Play Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
