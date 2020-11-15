import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';

class BottomBarItem {
  final IconData iconData;
  final String title;
  var isSelected;

  BottomBarItem(
      {@required this.isSelected,
      @required this.iconData,
      @required this.title});
}

class BottomAppBarWithNotch extends StatelessWidget {
  final List<BottomBarItem> bottomBarItemList;
  final Function onItemTap;

  const BottomAppBarWithNotch(
      {Key key, this.bottomBarItemList, @required this.onItemTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 5,

      color: Colors.white,
      shape: CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(bottomBarItemList.length, (index) {
              final isSelected = bottomBarItemList[index].isSelected;
              Color color = isSelected ? AppTheme.primaryColor : AppTheme.accentColor;
              final size = SizeConfig.heightMultiplier * 3.5;
              final item = bottomBarItemList[index];
              return Expanded(
                child: GestureDetector(
                  onTap: () => onItemTap(index),
                  child: SizedBox(
                    height: size * 2.2,
                    child: Material(
                      type: MaterialType.transparency,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(item.iconData, color: color, size: isSelected ? size + SizeConfig.heightMultiplier / 2 : size) ,
                          SizedBox(
                            height: size * 0.1,
                          ),
//                          isSelected
//                              ?  SizedBox(
//                            height: size * 0.3,
//                            width: size,
//                          )
////                          Text(
////                                  item.title,
////                                  style: TextStyle(
////                                    fontFamily: Constants.getFreightSansFamily
////                                  ),
////                                )
//                              : SizedBox(
//                                  height: size * 0.3,
//                                  width: size,
//                                )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })),
      ),
    );
  }
}
