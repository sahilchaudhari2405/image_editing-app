import 'dart:io';
import 'package:editingapp/edit_photo/presentation/edit_photo_screen.dart';
import 'package:editingapp/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class pick_image extends StatefulWidget {
  const pick_image({super.key});

  @override
  State<pick_image> createState() => _pick_imageState();
}

class _pick_imageState extends State<pick_image> {
  late File image_path;
  HomeBloc homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listener: (context, state) {
        if (state is HomeSelectPictureState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditPhotoScreen(photo: state.imageFile)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              surfaceTintColor: Color.fromARGB(255, 255, 255, 255),
              elevation: 4,
              shadowColor: Colors.black26,
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                    height: 32,
                  ),
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'celebrare',
                        style: TextStyle(
                            fontSize: mq.height * .0360,
                            fontFamily: 'DancingScript',
                            fontWeight: FontWeight.w500),
                      ))
                ],
              )),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: mq.width * .3,
                  onPressed: () {
                    homeBloc.add(HomeSelectPictureEvent());
                  },
                  icon: Icon(Icons.add_a_photo_outlined),
                ),
                Text(
                  "Pick image",
                  style: TextStyle(
                      fontSize: mq.width * .0888, fontFamily: 'Lobster'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
