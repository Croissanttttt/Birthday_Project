import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '생일 축하해',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BasicPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BasicPage extends StatefulWidget {
  @override
  _BasicPageState createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage> {
  int _score;
  int _cleartime;
  int factNumber;
  int facttitleNumber;
  SharedPreferences _prefs;
  List<String> factlist = ['정성이 담긴 내 선물이야!!','히강이는 늘 새로워!! 짜릿해!!','히강이는 완전 멋있쥐','마감시간에 쫓기고 있지만 히강이 생일 선물이라면!!!','히강이는 천사가 아닐까!!','누구든지 히강이를 좋아해요 :D','히강이는 참신한 주접 대환영이야!!!','모모코코는 귀여워. 하지만 히강이가 옆에있다면??','7월 2일은 히강이 생일이라구요!! 그거보다 중요한게 어디있어','이 주접은 영국으로부터 시작되어...'];

  @override
  void initState() {
    Random random = new Random();
    Timer.periodic(Duration(milliseconds: 500), (Timer _) {
      _loadScore();
      factNumber = random.nextInt(10);
      facttitleNumber = factNumber + 1;
    });
    super.initState();
  }

  _incrementcleartime() async {
    setState(() {
      _cleartime = (_prefs.getInt('cleartime') ?? 0) + 1;
      _prefs.setInt('cleartime', _cleartime);
    });
  }

  _loadScore() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _score = (_prefs.getInt('score') ?? 0);
    });
  }

  _deleteScore() async {
    setState(() {
      _score = 0;
      _prefs.setInt('score', _score);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Text('7월 2일은\n히강이 생일이죠!!', style: TextStyle(color: Colors.white, fontSize: 35.0),),
              ),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
            ),
            ListTile(
              title: Text('점수 초기화'),
              subtitle: Text('주의! 점수가 0으로 돌아가요'),
              onTap: (){
                _incrementcleartime();
                _deleteScore();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[Center(child: Padding(
          padding: const EdgeInsets.fromLTRB(0,0,20,0),
          child: Text('점수 : $_score',style: TextStyle(fontSize: 20),),
        ))],
      ),
      body: Container(
        color: Colors.black12,
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Text('히강아 생일 축하해!!',
                  style: TextStyle(fontSize: 35,fontWeight: FontWeight.w700)),
              SizedBox(height: 70,),
              Container(
                height: 50,
                width: 300,
                child: FlatButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RSP()));
                  },
                  child: Text('가위 바위 보!',style: TextStyle(fontSize: 25)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Container(
                height: 50,
                width: 300,
                child: FlatButton(
                    color: Colors.white,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PointLottery()));
                  },
                  child: Text('포인트 홀짝',style: TextStyle(fontSize: 25)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Container(
                height: 50,
                width: 300,
                child: FlatButton(
                    color: Colors.white,
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Scorelist()));
                  },
                  child: Text('점수 기록실',style: TextStyle(fontSize: 25)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Container(
                height: 50,
                width: 300,
                child: FlatButton(
                  color: Colors.white,
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder:  (BuildContext context) {
                        return AlertDialog(
                          title: Text('팩트체크$facttitleNumber'),
                          content: new Text(factlist[factNumber]),
                          actions: <Widget>[
                            new FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('확인')
                            )
                          ],
                        );
                      },
                    );
                    },
                  child: Text('팩트체크',style: TextStyle(fontSize: 25)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PointLottery extends StatefulWidget {
  @override
  _PointLotteryState createState() => _PointLotteryState();
}

class _PointLotteryState extends State<PointLottery> {
  int _score;
  int _betpoint = 1;
  int betcheck = 0;
  int randNum;
  int _maxscore;
  int _winlottery;
  int _loselottery;
  int _lotterytime;
  SharedPreferences _prefs;

  @override
  void initState() {
    Random random = new Random();
    Timer.periodic(Duration(milliseconds: 500), (Timer _) {
      _loadScore();
      _loadmaxScore();
      _loadlotterytime();
      _loadloselottery();
      _loadwinlottery();
      randNum = random.nextInt(2);
    });
    super.initState();
  }

  _loadScore() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _score = (_prefs.getInt('score') ?? 0);
      _betpoint = (_prefs.getInt('betpoint') ?? 1);
      betcheck = (_prefs.getInt('betcheck') ?? 0);
    });
  }

  _loadmaxScore() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _maxscore = (_prefs.getInt('maxscore') ?? 0);
    });
  }

  _loadwinlottery() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _winlottery = (_prefs.getInt('winlottery') ?? 0);
    });
  }

  _loadloselottery() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _loselottery = (_prefs.getInt('loselottery') ?? 0);
    });
  }

  _loadlotterytime() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _lotterytime = (_prefs.getInt('lotterytime') ?? 0);
    });
  }

  _incrementlotterytime() async {
    setState(() {
      _lotterytime = (_prefs.getInt('lotterytime') ?? 0) + 1;
      _prefs.setInt('lotterytime', _lotterytime);
    });
  }

  _incrementwinlottery() async {
    setState(() {
      _winlottery = (_prefs.getInt('winlottery') ?? 0) + 1;
      _prefs.setInt('winlottery', _winlottery);
    });
  }

  _incrementloselottery() async {
    setState(() {
      _loselottery = (_prefs.getInt('loselottery') ?? 0) + 1;
      _prefs.setInt('loselottery', _loselottery);
    });
  }

  _incrementmaxScore() async {
    setState(() {
      _maxscore = (_prefs.getInt('score') ?? 0);
      _prefs.setInt('maxscore', _maxscore);
    });
  }

  _incrementbetpoint() async {
    setState(() {
      _betpoint = (_prefs.getInt('betpoint')) + 1;
      _prefs.setInt('betpoint', _betpoint);
    });
  }

  _decrementbetpoint() async {
    setState(() {
      _betpoint = (_prefs.getInt('betpoint')) - 1;
      _prefs.setInt('betpoint', _betpoint);
    });
  }

  _betting() async {
    setState(() {
      if(_betpoint <= _score)
      {
        _score = (_prefs.getInt('score')) - _betpoint;
        _prefs.setInt('score', _score);
        betcheck = 1;
        _prefs.setInt('betpoint', _betpoint);
        _prefs.setInt('betcheck', betcheck);
      }
      else {
        showDialog(
          context: context,
          builder:  (BuildContext context) {
            return AlertDialog(
              content: new Text('포인트를 더 모아오세욧!!'),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('확인')
                )
              ],
            );
          },
        );}
    });
  }

  _choice() async {
    setState(() {
      if(randNum == 1)
      {
        _score = (_prefs.getInt('score')) + _betpoint + _betpoint;
        _prefs.setInt('score', _score);
        betcheck = 0;
        _betpoint = 1;
        _prefs.setInt('betpoint', _betpoint);
        _prefs.setInt('betcheck', betcheck);
      }
      else {
        _score = (_prefs.getInt('score'));
        _prefs.setInt('score', _score);
        betcheck = 0;
        _betpoint = 1;
        _prefs.setInt('betpoint', _betpoint);
        _prefs.setInt('betcheck', betcheck);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('포인트 홀짝'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(height: 10,),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('당첨되면 ',style: TextStyle(fontSize: 30,),),
                Text('두배',style: TextStyle(fontSize: 30,color: Colors.red),),
                Text('!!!',style: TextStyle(fontSize: 30,),),
              ],
            ),
          ),
          Text('배팅 가능한 포인트 : $_score',style: TextStyle(fontSize: 25),),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('배팅할 포인트를 입력하세요',style: TextStyle(fontSize: 20),),
              SizedBox(height: 30,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      child: RaisedButton(
                        onPressed: () {if(betcheck == 0){
                          if(_betpoint==1){}
                          else{_decrementbetpoint();}}
                        },
                        child: Text('-'),
                      ),
                    ),
                    Container(
                        height: 50,
                        width: 100,
                        child: Center(child: Text('$_betpoint',style: TextStyle(fontSize: 25),))
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: RaisedButton(
                        onPressed: () {if(betcheck == 0){
                          if(_betpoint == 10){}
                          else{_incrementbetpoint();}}
                          },
                        child: Text('+'),
                      ),
                    )
                ],
                ),
              ),
            ],
          ),
          Container(
            height: 50,
            width: 200,
            child: RaisedButton(
                child: Text('배팅!!!'),
                onPressed: () {
                  if(betcheck == 0)
                    {
                      _betting();
                    }
                  if(betcheck == 1){}
                }
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 50,
                  width: 100,
                  child: RaisedButton(
                      child: Text('홀'),
                      onPressed: () {if(betcheck == 1){
                        _incrementlotterytime();
                        if(randNum == 1)
                        {
                          showDialog(
                            context: context,
                            builder:  (BuildContext context) {
                              return AlertDialog(
                                  content: new Text('홀이라니...두배로 드릴께요 ㅠㅠ'),
                                  actions: <Widget>[
                                    new FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('확인')
                                    )
                                  ],
                                );
                            },
                          );
                          _choice();
                          if(_maxscore<_score){
                            _incrementmaxScore();
                          }
                          _incrementwinlottery();
                        }
                        else {
                          showDialog(
                            context: context,
                            builder:  (BuildContext context) {
                              return AlertDialog(
                                  content: new Text('짝이니깐 내가 다먹을꺼야'),
                                  actions: <Widget>[
                                    new FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('확인')
                                    )
                                  ],
                                );
                            },
                          );
                          _incrementloselottery();
                          _choice();
                        }
                      }
                      else{
                        showDialog(
                          context: context,
                          builder:  (BuildContext context) {
                            return AlertDialog(
                              content: new Text('배팅하고 오세요 ㅇㅅㅇ'),
                              actions: <Widget>[
                                new FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('확인')
                                )
                              ],
                            );
                          },
                        );}}
                  ),
                ),
                Container(
                  height: 50,
                  width: 100,
                  child: RaisedButton(
                      child: Text('짝'),
                      onPressed: () {if(betcheck == 1){
                        _incrementlotterytime();
                        if(randNum == 1)
                        {
                          showDialog(
                            context: context,
                            builder:  (BuildContext context) {
                              return AlertDialog(
                                content: new Text('짝이라니...두배로 드릴께요 ㅠㅠ'),
                                actions: <Widget>[
                                  new FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        },
                                      child: Text('확인')
                                  )
                                ],
                              );
                              },
                          );
                          _choice();
                          if(_maxscore<_score){
                            _incrementmaxScore();
                          }
                          _incrementwinlottery();
                        }
                        else {
                          showDialog(
                            context: context,
                            builder:  (BuildContext context) {
                              return AlertDialog(
                                  content: new Text('홀이니깐 내가 다먹을꺼야'),
                                  actions: <Widget>[
                                    new FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('확인')
                                    )
                                  ],
                                );
                            },
                          );
                          _choice();
                          _incrementloselottery();
                        }}
                      else{
                        showDialog(
                          context: context,
                          builder:  (BuildContext context) {
                            return AlertDialog(
                              content: new Text('배팅하고 오세요 ㅇㅅㅇ'),
                              actions: <Widget>[
                                new FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('확인')
                                )
                              ],
                            );
                          },
                        );}
                      }
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
}


class Scorelist extends StatefulWidget {
  @override
  _ScorelistState createState() => _ScorelistState();
}

class _ScorelistState extends State<Scorelist> {
  int _rsptime;
  int _maxscore;
  int _minscore;
  int _cleartime;
  int _lotterytime;
  int _loselottery;
  int _winlottery;
  int _winrsp;
  int _drawrsp;
  int _losersp;
  SharedPreferences _prefs;

  @override
  void initState() {
    _loadrsptime();
    _loadmaxscore();
    _loadminscore();
    _loadcleartime();
    _loadlotterytime();
    _loadloselottery();
    _loadwinlottery();
    _loadwinrsp();
    _loaddrawrsp();
    _loadlosersp();
    super.initState();
  }

  _loadmaxscore() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _maxscore = (_prefs.getInt('maxscore') ?? 0);
    });
  }

    _loadcleartime() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _cleartime = (_prefs.getInt('cleartime') ?? 0);
    });
  }

  _loadminscore() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _minscore = (_prefs.getInt('minscore') ?? 0);
    });
  }

  _loadrsptime() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _rsptime = (_prefs.getInt('rsptime') ?? 0);
    });
  }

  _loadlotterytime() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _lotterytime = (_prefs.getInt('lotterytime') ?? 0);
    });
  }

  _loadwinrsp() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _winrsp = (_prefs.getInt('winrsp') ?? 0);
    });
  }

  _loaddrawrsp() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _drawrsp = (_prefs.getInt('drawrsp') ?? 0);
    });
  }

  _loadlosersp() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _losersp = (_prefs.getInt('losersp') ?? 0);
    });
  }

  _loadwinlottery() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _winlottery = (_prefs.getInt('winlottery') ?? 0);
    });
  }

  _loadloselottery() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _loselottery = (_prefs.getInt('loselottery') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('점수 기록실'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: 1500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: 30,),
                Text('최고 점수',style: TextStyle(fontSize: 25),),
                Text('$_maxscore',style: TextStyle(fontSize: 25,color: Colors.blue)),
                Text('최저 점수',style: TextStyle(fontSize: 25)),
                Text('$_minscore',style: TextStyle(fontSize: 25,color: Colors.red)),
                Text('점수 초기화 횟수',style: TextStyle(fontSize: 25)),
                Text('$_cleartime',style: TextStyle(fontSize: 25)),
                Text('가위바위보 횟수',style: TextStyle(fontSize: 25)),
                Text('$_rsptime',style: TextStyle(fontSize: 25)),
                Text('홀짝게임 횟수',style: TextStyle(fontSize: 25)),
                Text('$_lotterytime',style: TextStyle(fontSize: 25)),
                Text('홀짝 승리 횟수',style: TextStyle(fontSize: 25)),
                Text('$_winlottery',style: TextStyle(fontSize: 25)),
                Text('홀짝 패배 횟수',style: TextStyle(fontSize: 25)),
                Text('$_loselottery',style: TextStyle(fontSize: 25)),
                Text('가위바위보 승리 횟수',style: TextStyle(fontSize: 25)),
                Text('$_winrsp',style: TextStyle(fontSize: 25)),
                Text('가위바위보 무승부 횟수',style: TextStyle(fontSize: 25)),
                Text('$_drawrsp',style: TextStyle(fontSize: 25)),
                Text('가위바위보 패배 횟수',style: TextStyle(fontSize: 25)),
                Text('$_losersp',style: TextStyle(fontSize: 25)),
                SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      )
    );
  }
}


class RSP extends StatefulWidget {
  @override
  _RSPState createState() => _RSPState();
}

class _RSPState extends State<RSP> {
  int _rsptime = 0;
  int _score = 0;
  int _maxscore = 0;
  int _minscore = 0;
  int _winrsp;
  int _drawrsp;
  int _losersp;
  int randomNumber;
  SharedPreferences _prefs;

  @override
  void initState() {
    Random random = new Random();
    randomNumber = random.nextInt(3);
    _loadScore();
    _loadmaxScore();
    _loadminScore();
    _loadwinrsp();
    _loaddrawrsp();
    _loadlosersp();
    super.initState();
  }

  _loadScore() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _score = (_prefs.getInt('score') ?? 0);
    });
  }

  _loadwinrsp() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _winrsp = (_prefs.getInt('winrsp') ?? 0);
    });
  }

  _loaddrawrsp() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _drawrsp = (_prefs.getInt('drawrsp') ?? 0);
    });
  }

  _loadlosersp() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _losersp = (_prefs.getInt('losersp') ?? 0);
    });
  }

  _loadmaxScore() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _maxscore = (_prefs.getInt('maxscore') ?? 0);
    });
  }

  _loadminScore() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _minscore = (_prefs.getInt('minscore') ?? 0);
    });
  }

  _incrementrsptime() async {
    setState(() {
      _rsptime = (_prefs.getInt('rsptime') ?? 0) + 1;
      _prefs.setInt('rsptime', _rsptime);
    });
  }

  _incrementmaxScore() async {
    setState(() {
        _maxscore = (_prefs.getInt('score') ?? 0);
      _prefs.setInt('maxscore', _maxscore);
    });
  }

  _incrementScore() async {
    setState(() {
      _score = (_prefs.getInt('score') ?? 0) + 1;
      _prefs.setInt('score', _score);
    });
  }

  _incrementwinrsp() async {
    setState(() {
      _winrsp = (_prefs.getInt('winrsp') ?? 0) + 1;
      _prefs.setInt('winrsp', _winrsp);
    });
  }

  _incrementdrawrsp() async {
    setState(() {
      _drawrsp = (_prefs.getInt('drawrsp') ?? 0) + 1;
      _prefs.setInt('drawrsp', _drawrsp);
    });
  }

  _incrementlosersp() async {
    setState(() {
      _losersp = (_prefs.getInt('losersp') ?? 0) + 1;
      _prefs.setInt('losersp', _losersp);
    });
  }

  _decrementScore() async {
    setState(() {
      _score = (_prefs.getInt('score') ?? 0) - 1;
      _prefs.setInt('score', _score);
    });
  }

  _decrementminScore() async {
    setState(() {
      _minscore = (_prefs.getInt('score') ?? 0);
      _prefs.setInt('minscore', _minscore);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('가위 바위 보!'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50,),
            Text('가위 바위 보',style: TextStyle(fontSize: 35),),
            SizedBox(height: 50,),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  child: RaisedButton(
                      onPressed: (){
                        winner();
                        setState(() {
                          if(_maxscore<_score){
                            _incrementmaxScore();
                          }
                          if(_minscore>_score){
                            _decrementminScore();
                          }
                          _incrementrsptime();
                          initState();
                        });
                        },
                      child: Text('가위')),
                ),
                Container(
                  height: 100,
                  width: 100,
                  child: RaisedButton(
                      onPressed: (){
                        winner();
                        setState(() {
                          if(_maxscore<_score){
                            _incrementmaxScore();
                          }
                          if(_minscore>_score){
                            _decrementminScore();
                          }
                          _incrementrsptime();
                          initState();
                        });
                        },
                      child: Text('바위')),
                ),
                Container(
                  height: 100,
                  width: 100,
                  child: RaisedButton(
                      onPressed: (){
                        winner();
                        setState(() {
                          if(_maxscore<_score){
                            _incrementmaxScore();
                          }
                          if(_minscore>_score){
                            _decrementminScore();
                          }
                          _incrementrsptime();
                          initState();
                        });
                        },
                      child: Text('보')),
                ),
              ],),
            SizedBox(height: 100,),
            Container(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('현재 점수는 $_score점',style: TextStyle(fontSize: 30),),
                    )),
              )),
          ],),
      ),
    );
  }

  void winner(){
    if (randomNumber == 0) {
      _incrementlosersp();
      _decrementScore();
      showDialog(
        context: context,
        builder:  (BuildContext context) {
          return AlertDialog(
            content: new Text('내가 이겨버렸다 히히히'),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    },
                  child: Text('확인')
              )
            ],
          );
        },
      );
    }
    else if (randomNumber == 1) {
      _incrementScore();
      _incrementwinrsp();
      showDialog(
        context: context,
        builder:  (BuildContext context) {
          return AlertDialog(
            content: new Text('아닛 내가 지다니...'),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('확인')
              )
            ],
          );
        },
      );
    }
    else {
      _incrementdrawrsp();
      showDialog(
        context: context,
        builder:  (BuildContext context) {
          return AlertDialog(
            content: new Text('비겨버렸넹 룰루'),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('확인')
              )
            ],
          );
        },
      );
    }
  }
}
