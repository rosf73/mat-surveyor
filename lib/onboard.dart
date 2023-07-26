import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationOnboard extends StatelessWidget {
  const LocationOnboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(50, 150, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/big_marker.svg',
            width: 150,
            colorFilter: const ColorFilter.mode(Color.fromARGB(255, 200, 190, 180), BlendMode.srcIn),
          ),
          const SizedBox(height: 30,),
          const Text(
            '위치 권한을 설정하면\n맵 서비스를 이용할 수 있어요!',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 150, 120, 120),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}