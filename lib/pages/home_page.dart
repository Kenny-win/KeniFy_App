// ignore_for_file: prefer_const_constructors
import 'package:audioplayers/audioplayers.dart';
import 'package:biometric_local_auth/music_data/music_data.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:biometric_local_auth/utils/ai_util.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  double flexwidth() {
    return MediaQuery.of(context).size.width;
  }

  double flexHeight() {
    return MediaQuery.of(context).size.height;
  }

  CarouselController carouselController = CarouselController();

  var isPlay = false;
  var isPause = false;
  int seek = 0;
  int maxduration = 0;
  int maxplayDurSec = 0;
  int maxplayDurMin = 0;
  int currentpos = 0;
  int sec = 0;
  bool next = false;
  String currentpostlabel = "00:00";
  String musicAsset = "assets/musics/hewei.mp3";
  late Uint8List audiobytes;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    if (_currentIndex == 0) {
      convertMusic();
    }

    super.initState();
  }


  Future convertMusic() {
    return Future.delayed(Duration.zero, () async {
      musicAsset = musicsQueue[_currentIndex]["musicUrl"]!;
      print("url music ketika di konvert : $musicAsset");
      ByteData bytes =
          await rootBundle.load(musicAsset); //load music dari assets/
      audiobytes =
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

      //convert ByteData to Uint8List
      player.onDurationChanged.listen((Duration d) {
        //ambil durasi music
        maxplayDurSec = (d.inSeconds % 60).floor();
        maxplayDurMin = d.inMinutes;
        maxduration = d.inSeconds;
        print("maxDuration = $maxduration");

        setState(() {});
      });

      player.onAudioPositionChanged.listen((Duration p) {
        currentpos = p
            .inMilliseconds; //tampung posisi waktu sekarang ketika music sedang berjalan
        sec = p.inSeconds;
        //durasi waktu yang berjalan dalam jam:menit:detik
        int shours = Duration(milliseconds: currentpos).inHours;
        int sminutes = Duration(milliseconds: currentpos).inMinutes;
        int sseconds = Duration(milliseconds: currentpos).inSeconds;

        // int rhours = shours;
        int rminutes = sminutes - (shours * 60);
        int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

        currentpostlabel = "$rminutes:$rseconds";
        print("sec = $sec");
        setState(() {
          //refresh the UI
        });
      });
    });
  }

  //TODO BUILD NEXT-PREV PAGE FUNCTION

  prevPage() {
    return carouselController.previousPage(
        duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }

  randomMusic(String songName) {
    var ind = 0;
    for (int i = 0; i < musicsQueue.length; i++) {
      if (songName == musicsQueue[i]["name"]) {
        ind = i;
        break;
      }
    }
    return carouselController.animateToPage(ind,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget playButton({required Function() onPressed}) {
      return Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.play_circle_outline_rounded,
              size: flexHeight() > 735 ? 70 : 50,
              color: _currentIndex % 2 == 0 ? Colors.purple : Colors.orange,
            ),
          ));
    }

    Widget pauseStopButton({
      required Function() onPausePressed,
      required Function() onStopPressed,
    }) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
                // color: Colors.black,
                shape: BoxShape.circle),
            child: IconButton(
              onPressed: onPausePressed,
              icon: Icon(
                isPause
                    ? Icons.play_circle_outline_rounded
                    : Icons.pause_circle_outline_rounded,
                size: flexHeight() > 735 ? 70 : 50,
                color: _currentIndex % 2 == 0 ? Colors.purple : Colors.orange,
              ),
            ),
          ),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: IconButton(
              onPressed: onStopPressed,
              icon: Icon(Icons.stop_circle_outlined,
                  size: flexHeight() > 735 ? 70 : 50,
                  color:
                      _currentIndex % 2 == 0 ? Colors.purple : Colors.orange),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        width: flexwidth(),
        height: flexHeight(),
        decoration: BoxDecoration(
            gradient: _currentIndex % 2 == 0
                ? LinearGradient(
                    colors: [AIColors.primaryColor2!, AIColors.primaryColor1!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)
                : LinearGradient(
                    colors: [AIColors.primaryColor1!, AIColors.primaryColor2!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Shimmer.fromColors(
                  child: Text("KeniFy",
                      style: TextStyle(
                          fontSize: flexHeight() > 735 ? 40 : 30,
                          fontWeight: FontWeight.bold)),
                  baseColor: Colors.white,
                  highlightColor: Colors.cyan.withOpacity(0.5),
                ),
              ),
              flexHeight() > 738
                  ? Container(
                      margin: EdgeInsets.only(top: 20),
                      child: CarouselSlider(
                          items: [
                            Container(
                                width: double.infinity,
                                child: Text(
                                  "${musicsQueue[_currentIndex]["name"]!.toUpperCase()} - ${musicsQueue[_currentIndex]["mandarin"]}\nArtist : ${musicsQueue[_currentIndex]["author"]}",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ))
                          ],
                          options: CarouselOptions(
                            // height: 350,
                            viewportFraction: 1,
                            height: 70,
                            autoPlay: true,
                            autoPlayInterval: const Duration(milliseconds: 3000),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.easeInOut,
                          )))
                  : SizedBox(),
              SizedBox(
                height:
                    flexHeight() > 738 ? flexHeight() - 820 : flexHeight() - 700,
              ),
              Container(
                // margin: EdgeInsets.only(
                //   // top: flexHeight()-650,
                //   top: flexHeight()>735? flexHeight()-820:flexHeight()-700,
                //   bottom: 50
                //   // bottom: flexHeight()-800
                // ), //TODO : MARGIN DI COMMENT
                width: double.infinity,
                child: CarouselSlider(
                  carouselController: carouselController,
                  items: musicsQueue
                      .map((data) => Container(
                            clipBehavior: Clip.hardEdge,
                            width: flexwidth() - 90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                border: Border.all(width: 5, color: Colors.black),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(data["imgUrl"]!))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 8, bottom: 8, right: 20, left: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Text(
                                        data["mandarin"]!,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                        textAlign: TextAlign.left,
                                      ),
                                    )),
                                Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(60),
                                          topRight: Radius.circular(60),
                                        )),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          data["name"]!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          data["author"]!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                      height: (45 / 100) * flexHeight(),
                      viewportFraction: 0.75,
                      enlargeCenterPage: true,
                      initialPage: 0,
                      autoPlay: (double.parse(currentpostlabel.split(":")[0]) ==
                                  maxplayDurMin &&
                              double.parse(currentpostlabel.split(":")[1]) ==
                                  maxplayDurSec &&
                              double.parse(currentpostlabel.split(":")[1]) != 0 &&
                              sec == maxduration)
                          ? true
                          : next
                              ? true
                              : false,
                      autoPlayInterval: const Duration(seconds: 1),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.easeInOut,
                      onPageChanged: (index, reason) async {
                        await player.stop();
                        setState(() {
                          _currentIndex = index;
                          print(_currentIndex);
                          print("url music ketika diubah ");
                          next = false;
                          isPause = false;
                        });
                        await convertMusic();
                        isPlay == false
                            ? player.stop()
                            : player.playBytes(audiobytes);
                        // isPlay = true;
                      }),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text(
                  musicsQueue[_currentIndex]["mandarin"]!,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 30,
                        )
                      ]),
                ),
              ),
              Container(
                width: flexwidth(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 35,
                              offset: Offset(2, 2))
                        ]),
                        child: Slider(
                          divisions: 1000,
                          onChanged: (val) {
                            seek = val.toInt();
                            player.seek(Duration(seconds: seek));
                          },
                          value: sec.toDouble() > maxduration.toDouble()
                              ? sec.toDouble() -
                                  (sec.toDouble() - maxduration.toDouble())
                              : sec.toDouble(),
                          min: 0,
                          max: maxduration.toDouble(),
                          activeColor: _currentIndex % 2 == 0
                              ? Colors.purple
                              : Colors.orange,
                          inactiveColor: Colors.white,
                        )),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sec != maxduration
                                ? currentpostlabel
                                : currentpostlabel = "0:0",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          Text(
                            ":",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: isPlay && sec != maxduration
                          ? pauseStopButton(onPausePressed: () async {
                              await player.pause();
                              setState(() {
                                isPause = !isPause;
                                isPause ? player.pause() : player.resume();
                              });
                            }, onStopPressed: () async {
                              await player.stop();
                              setState(() {
                                isPlay = false;
                                isPause = false;
                                sec = 0;
                                currentpostlabel = "0:0";
                              });
                            })
                          : playButton(onPressed: () async {
                              await player.playBytes(audiobytes);
                              setState(() {
                                isPlay = true;
                                print(flexHeight());
                              });
                            }),
                    ),
                  ],
                ),
              )
            ],
          )
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(items: [
      //   BottomNavigationBarItem(
      //     icon: IconButton(
      //       onPressed: (){}, 
      //       icon: Icon(Icons.home),
      //       ),
      //     )
      // ]),
    );
  }
}
