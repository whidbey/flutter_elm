import 'package:flutter/material.dart';
import '../routes/routes.dart';
import '../model/user.dart';
import '../style/style.dart';
import '../store/store.dart';

enum HeadBarLeadingType {
  none,
  goBack,
  search,
}

class HeadBar extends StatefulWidget implements PreferredSizeWidget {
  HeadBar({
    HeadBarLeadingType leadingType: HeadBarLeadingType.none,
    String title: '',
    bool centerTitle: true,
    bool showUser: true,
    GestureTapCallback titleOnTap,
    PreferredSizeWidget bottom,
    Color backgroundColor,
  })
      : leadingType = leadingType,
        title = title,
        centerTitle = centerTitle,
        showUser = showUser,
        preferredSize = new Size.fromHeight(kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
        bottom=bottom,
        titleOnTap=titleOnTap,
        backgroundColor = backgroundColor;
  final String title;
  final bool centerTitle;
  final HeadBarLeadingType leadingType;
  final bool showUser;
  final GestureTapCallback titleOnTap;
  final PreferredSizeWidget bottom;
  final Color backgroundColor;

  @override
  createState() => new HeadBarState();

  @override
  final Size preferredSize;
}

class HeadBarState extends State<HeadBar> {
  User _user;

  @override
  void initState() {
    super.initState();
    _user = store.state.user;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    Widget leading;
    if (widget.leadingType == HeadBarLeadingType.goBack) {
      leading = new IconButton(
          icon: new Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          });
    } else if (widget.leadingType == HeadBarLeadingType.search) {
      leading = new IconButton(
        icon: new Icon(Icons.search),
        color: Style.backgroundColor,
        onPressed: _goSearch,
      );
    }

    var actions = <Widget>[];
    if (widget.showUser) {
      if (_user == null) {
        actions.add(
          new GestureDetector(
            onTap: () => _goLogin(context),
            child: new Container(
              padding: ButtonTheme
                  .of(context)
                  .padding,
              child: new Center(
                child: new Text(
                  '登录|注册',
                  style: themeData.primaryTextTheme.title,
                ),
              ),
            ),
          ),
        );
      } else {
        actions.add(
            new Padding(
              padding: ButtonTheme
                  .of(context)
                  .padding,
              child: new GestureDetector(
                child: new Icon(
                  Icons.person,
                ),
                onTap: _goProfile,
              ),
            )
        );
      }
    }

    return new AppBar(
      leading: leading,
      title: new GestureDetector(
        child: new Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: widget.titleOnTap,
      ),
      centerTitle: widget.centerTitle,
      automaticallyImplyLeading: false,
      actions: actions,
      bottom: widget.bottom,
      backgroundColor: widget.backgroundColor,
    );
  }

  _goLogin(BuildContext context) {
    Routes.router.navigateTo(context, '/login');
  }

  _goSearch() {
    String geoHash = store.state.geoHash;
    Routes.router.navigateTo(context, '/search/$geoHash');
  }

  _goProfile() {
    Routes.router.navigateTo(context, '/profile');
  }
}
