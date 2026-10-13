import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gallery/app/di/injection.dart';
import 'package:project_gallery/features/gallery/presentation/bloc/fav/favorites_bloc.dart';
import 'package:project_gallery/features/gallery/presentation/bloc/gallery_bloc.dart';
import 'package:project_gallery/features/gallery/presentation/bloc/gallery_event.dart';
import 'package:project_gallery/features/gallery/presentation/pages/gallery_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyGalleryApp());
}

class MyGalleryApp extends StatelessWidget {
  const MyGalleryApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<GalleryBloc>()..add(GalleryStarted())),
        BlocProvider(create: (_) => sl<FavoritesBloc>()),
      ],

      child: MaterialApp(
        title: 'Gallery App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        themeMode: ThemeMode.system,
        home: const GalleryPage(),
      ),
    );
  }
}
