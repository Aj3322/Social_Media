import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/screen/add_post.dart';
import 'package:insta/screen/profile_posts.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/globleVariable.dart';

import '../utils/utils.dart';
class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}
class _MyProfileState extends State<MyProfile> {
  var userData = {};
  String postData = '';
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
setState(() {
  isLoading=true;
});
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo:userId)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(userId);
    } catch (e) {
      showSnakBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
            backgroundColor: const Color(0xff3E2F4C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            onPressed: () { Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()),
            );},
            child: const Icon(
              Icons.add,
              size: 38,
              color: Colors.white,
            )),
      ),
      body:  isLoading ? const Center(child: CircularProgressIndicator()):Padding(
        padding: const EdgeInsets.only(top: 35),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back_ios,color: headerColor,)),
                Padding(
                  padding: const EdgeInsets.only(top: 45),
                  child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: SizedBox(
                      width:50 ,
                      height: 50,
                      child: Image.network( userData['photoUrl'],fit: BoxFit.cover,),

                    ),
                  ),
                ),
                IconButton(onPressed: (){}, icon: const Icon(Icons.more_horiz_outlined))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40)
                  .copyWith(top: 10),
              child: Text(
                userData['username']??'Nane',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                buildStatColumn(
                                    followers, "Followers"),

                                buildStatColumn(postLen, "Posts"),
                                buildStatColumn(
                                    following, "Following"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .where('uid', isEqualTo: userId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8),
                  height: 75,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                    (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap =
                      (snapshot.data! as dynamic).docs[index];

                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfilePost(
                              snapshot: snapshot,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8),
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.circular(15),
                            child: SizedBox(
                              width: 80,
                              child: Image(
                                image:
                                NetworkImage(snap['postUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
