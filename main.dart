import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ScrollController _scrollController;
  late Timer _scrollTimer;

  bool isGrid = true;
  List<String> items = [
    'Laptop',
    'Infinix',
    'Tablet',
    'Airpods',
    'Camera',
    'Headphones',
    'Glasses',
    'Bag',
    'Sneakers'
  ];
  List<String> itemsImages = [
    'assets/images/lap.jpg',
    'assets/images/cell.jpg',
    'assets/images/tab.jpg',
    'assets/images/airppods.jpg',
    'assets/images/camera.jpg',
    'assets/images/headphone.jpg',
    'assets/images/glasses.jpg',
    'assets/images/bag.jpg',
    'assets/images/shoes.jpg'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.offset;
        double nextScroll = currentScroll + 1;

        if (nextScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController..jumpTo(nextScroll);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Ecommerce Product',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 11, 81, 90),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(isGrid ? Icons.list : Icons.grid_view_outlined,
                  color: Colors.white),
              onPressed: () {
                setState(() {
                  isGrid = !isGrid;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final imagePath = itemsImages[index];
                  return Container(
                    width: 140,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(imagePath,
                                fit: BoxFit.cover, width: double.infinity),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(item,
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(
              thickness: 3,
              color: Colors.grey[400],
              height: 20,
            ),
            Expanded(child: buildList()),
          ],
        ),
      );
  Widget buildList() => isGrid
      ? GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final imagePath = itemsImages[index];
            return GridTile(
              child: InkWell(
                child: Ink.image(
                  image: AssetImage(imagePath),
                  height: 120,
                  fit: BoxFit.cover,
                ),
                onTap: () => selectItem(item),
              ),
              footer: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 27, 153, 236),
                  ),
                ),
              ),
            );
          },
        )
      : ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final imagePath = itemsImages[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title:
                    Text(item, style: TextStyle(fontWeight: FontWeight.bold)),
                // subtitle: Text('Subtitle $index'),
                onTap: () => selectItem(item),
              ),
            );
          },
        );

  void selectItem(String item) {
    final snackbar = SnackBar(
      content: Text(
        'Selected $item....',
        style: TextStyle(fontSize: 24),
      ),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }
}
