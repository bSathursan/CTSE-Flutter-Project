import 'package:flutter/material.dart';
import 'package:quotes_app/database_manager/user_handler/database_handler_user.dart';
import 'package:quotes_app/screens/admin_management/view_profile.dart';

class ViewUsers extends StatefulWidget {
  static String routeName = '/viewUsers';

  const ViewUsers({Key? key}) : super(key: key);

  @override
  _ViewUsersState createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  List userList = [];

  @override
  void initState() {
    super.initState();
    loadUserList();
  }

  loadUserList() async {
    List result = await DatabaseHandlerUser().getAllUsers();

    if(result.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error in retrieving user list!!')
          )
      );
    }else{
      setState(() {
        userList = result;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('List of Users')),
        backgroundColor: Color.fromARGB(255, 22, 17, 36),
      ),
      body: userList.isNotEmpty ? ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              margin: const EdgeInsets.all(8.0),
              elevation: 4,
              child: ListTile(
                title: Text(userList[index]['firstname'] + ' ' + userList[index]['secondname']),
                subtitle: Text(userList[index]['email']),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) => ViewProfile(userId: userList[index]['uid'],)
                  ));
                },
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    List<String> newValues = value.toString().split(':');

                    if(newValues[0].toString().contains('Remove')){
                      print('Remove Clicked ${userList[index]['uid']}');
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      child: const Text("Remove"),
                      value: 'Remove :'+ userList[index]['uid'].toString(),
                    ),
                  ],
                ),
              ),
            );
          }
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(Icons.hourglass_empty, size: 50.0,),
          SizedBox(width: double.infinity, height: 10.0,),
          Text('No users available !'),
        ],
      ),
    );
  }
}
