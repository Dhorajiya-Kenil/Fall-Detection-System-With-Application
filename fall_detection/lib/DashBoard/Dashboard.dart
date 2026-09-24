import 'package:flutter/material.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fall Login/Signup',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red,
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(Icons.menu, color: Colors.white,),
        title: Text("DashBoard",style: TextStyle(color: Colors.white),),
        actions: [
          Container(
            margin: new EdgeInsets.symmetric(horizontal: 20,vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),color: Colors.white,
            ),
            child: IconButton(onPressed: (){}, icon: Icon(Icons.person)),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
            padding: new EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hey, User"),
              Text("Hey, User",style: TextStyle(fontSize: 30),),
              SizedBox(height: 20),

              // Search Box
              Container(
                decoration: BoxDecoration(border: Border(left: BorderSide(width: 4))),
                padding: new EdgeInsets.symmetric(horizontal: 10,vertical: 5),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Search...",style: TextStyle(color: Colors.grey.withOpacity(1.0)),),
                    Icon(Icons.mic,color: Colors.black,)
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Categories
              SizedBox(
                height: 50,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(height: 50,width: 200,
                      child: Row(
                        children: [
                          Container(
                            width: 45,height: 45,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.black),
                            child: Center(
                              child: Text("DK",style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Kenil Dhorajiya",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),overflow: TextOverflow.ellipsis,),
                                Text("Kenil Dhorajiya",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 50,width: 200,
                      child: Row(
                        children: [
                          Container(
                            width: 45,height: 45,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.black),
                            child: Center(
                              child: Text("DK",style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Kenil Dhorajiya",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),overflow: TextOverflow.ellipsis,),
                                Text("Kenil Dhorajiya",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 50,width: 200,
                      child: Row(
                        children: [
                          Container(
                            width: 45,height: 45,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.black),
                            child: Center(
                              child: Text("DK",style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Kenil Dhorajiya",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),overflow: TextOverflow.ellipsis,),
                                Text("Kenil Dhorajiya",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Banners
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey.withOpacity(0.5)),
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const[
                            Flexible(child: Image(image: AssetImage("assets/images/fall.png"),height: 70,width: 70,)),
                            Flexible(child: Icon(Icons.bookmark))
                          ],
                        ),
                        SizedBox(height: 20),
                        Text("Kenil Dhorajiya",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),overflow: TextOverflow.ellipsis,),
                        Text("Kenil Dhorajiya",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                 ),

                  SizedBox(width: 10),
                  Expanded(child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey.withOpacity(0.5)),
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const[
                                Flexible(child: Image(image: AssetImage("assets/images/fall.png"),height: 50,width: 50,)),
                                Flexible(child: Icon(Icons.bookmark))
                              ],
                            ),
                            SizedBox(height: 20),
                            Text("Kenil Dhorajiya",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),overflow: TextOverflow.ellipsis,),
                            Text("Kenil Dhorajiya",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 5),overflow: TextOverflow.ellipsis,)
                          ],
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(onPressed: (){},child: const Text("View All",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black),)),
                      )
                    ],
                  ),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}