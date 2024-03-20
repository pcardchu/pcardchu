import 'package:flutter/material.dart';
import 'package:frontend/card/screens/card_list.dart';
import 'package:frontend/card/screens/card_registration.dart';
import 'package:frontend/card/widgets/registration_modal.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        // backgroundColor: Color(0xFFF5F5F5),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home'),
            ElevatedButton(
                onPressed: () {
                  Provider.of<LoginProvider>(context, listen: false)
                      .logout(context);
                },
                child: Text("로그아웃")),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => CardRegistration(),
                //   ),
                // );

                // 등록된 카드가 없다면 보여주는 모달
                showDialog(
                  context: context,
                  builder: (_) {
                    return RegistrationModal();
                  },
                );
              },
              child: Text('카드 등록 모달'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CardList(),
                  ),
                );
              },
              child: Text('카드 리스트'),
            ),
          ],
        ),
      ),
    );
  }
}
