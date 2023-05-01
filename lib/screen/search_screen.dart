import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta/screen/profile_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/globleVariable.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leadingWidth: 12,
          title: Container(
            height: 40,
            child: Form(
              child: TextFormField(
                style: const TextStyle(color: Colors.black,fontSize: 20),
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search for a user...',
                  fillColor: primaryColor,
                  filled: true,
                  hoverColor: Colors.blueAccent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: primaryColor,
                    ),
                  ),
                ),
                onFieldSubmitted: (String _) {
                  setState(() {
                    isShowUsers = true;
                  });
                  print(_);
                },
              ),
            ),
          ),
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where(
                      'username',
                      isGreaterThanOrEqualTo: searchController.text,
                    )
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: (snapshot.data! as dynamic).docs[index]
                                  ['uid'],
                            ),
                          ),
                        ),
                        child:Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  (snapshot.data! as dynamic).docs[index]['photoUrl'],
                                ),
                                radius: 22,
                              ),
                              title: Text(
                                (snapshot.data! as dynamic).docs[index]['username'],style: const TextStyle(color: headerColor),
                              ),
                              subtitle:Text((snapshot.data! as dynamic).docs[index]['bio'],style: TextStyle(color: primaryColor),),
                            ),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 40
                            ),child: const Divider(height: 4,color: textColor,))
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('datePublished')
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 3,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) => Image.network(
                        (snapshot.data! as dynamic).docs[index]['postUrl'],
                        fit: BoxFit.cover,
                      ),
                      staggeredTileBuilder: (index) =>
                          MediaQuery.of(context).size.width > webScreenSize
                              ? StaggeredTile.count((index % 7 == 0) ? 1 : 1,
                                  (index % 7 == 0) ? 1 : 1)
                              : StaggeredTile.count((index % 7 == 0) ? 2 : 1,
                                  (index % 7 == 0) ? 2 : 1),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                  );
                },
              ));
  }
}
