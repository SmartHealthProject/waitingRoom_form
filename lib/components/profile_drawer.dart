import 'package:flutter/material.dart';
import 'package:form_demo/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onHomeTap;
  final void Function()? onSignOut;
  const MyDrawer({
    super.key, 
    required this.onHomeTap, 
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.deepPurple[400],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //header
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              
              /* 
              //home list tile
              MyListTile(
                icon: Icons.home, 
                text: 'H O M E',
                onTap: () => Navigator.pop(context),
              ),
              */
              
              //profile list tile
              MyListTile(
                icon: Icons.person, 
                text: 'H O M E', 
                onTap: onHomeTap,
              ),
            ],
          ),

          //logout list tile
           Padding(
             padding: const EdgeInsets.only(bottom: 25.0),
             child: MyListTile(
              icon: Icons.logout, 
              text: 'L O G O U T', 
              onTap: onSignOut,
                       ),
           ),
        ],
      )
    );
  }
}