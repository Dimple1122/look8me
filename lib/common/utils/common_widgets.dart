import 'package:flutter/material.dart';
import 'package:look8me/common/utils/enums.dart';

class CommonWidget {
  static Widget getLoader(
      {String text = 'Loading...',
      Color? indicatorColor = Colors.red,
      double strokeWidth = 4,
      double? indicatorHeight,
      double? indicatorWidth}) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: indicatorHeight,
              width: indicatorWidth,
              child: CircularProgressIndicator(
                  color: indicatorColor,
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round)),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          )
        ],
      ),
    );
  }

  static Widget getCredentialTextField(
      {required BuildContext context,
      required bool isObscure,
      required TextFieldType type,
      Function()? onTap,
      double height = 65,
      String? label,
      String? hintText,
      Icon? leadingIcon,
      required Function(String) onChanged,
      String? errorText}) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height,
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                color: Colors.white12,
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: errorText == null ? Colors.white70 : Colors.red,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                leadingIcon ?? const SizedBox(),
                SizedBox(width: leadingIcon != null ? 5 : 0),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(
                        height: 1.2, fontSize: 20, color: Colors.white),
                    cursorColor: Colors.white,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: onChanged,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      suffixIcon: type == TextFieldType.password
                          ? GestureDetector(
                              onTap: onTap,
                              child: isObscure
                                  ? const Icon(Icons.visibility_off, size: 30)
                                  : const Icon(Icons.visibility, size: 30),
                            )
                          : null,
                      labelText: label,
                      hintText: hintText,
                      labelStyle:
                          const TextStyle(fontSize: 22, color: Colors.white70),
                      floatingLabelStyle:
                          const TextStyle(fontSize: 20, color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(errorText ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.red)),
          )
        ],
      ),
    );
  }

  static AppBar getOnboardingAppBar(String title) {
    return AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: Divider(
            color: Colors.grey,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        leadingWidth: 0,
        backgroundColor: Colors.black,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ));
  }

  static Widget getElevatedButton(
      {required BuildContext context,
      required String name,
      Function()? onPressed,
      double? width,
      double? height,
      Color textColor = Colors.white,
      Color backgroundColor = Colors.red,
      Color borderColor = Colors.grey,
      double fontSize = 18,
      FontWeight fontWeight = FontWeight.normal,
      double borderRadius = 8,
      Icon? buttonIcon}) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side: BorderSide(color: borderColor, width: 1)),
            backgroundColor: backgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buttonIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: buttonIcon)
                  : Container(),
              Text(name,
                  style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: fontWeight)),
            ],
          )),
    );
  }

  static Widget indicator(bool isActive) {
    return SizedBox(
      height: 10,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 10 : 8.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.red : const Color(0XFFEAEAEA),
        ),
      ),
    );
  }

  static void showAlertDialog(
      {required BuildContext context,
      required String title,
      required String content,
      required String primaryButtonText,
      required Function() onButtonPressed}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: Colors.white,
              title: Text(title),
              titlePadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: Text(content, style: const TextStyle(fontSize: 18)),
              actionsPadding: EdgeInsets.zero,
              actions: [
                TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    onPressed: onButtonPressed,
                    child: Text(primaryButtonText,
                        style: const TextStyle(fontSize: 18)))
              ],
            ),
          );
        });
  }
}
