import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/params/email_password.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/usecases/register_usecase.dart';
import 'package:wehere_client/injector.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/widgets/alert.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class PasswordLoginModal extends StatefulWidget {
  final VoidCallback onLoginSucceed;

  const PasswordLoginModal({Key? key, required this.onLoginSucceed})
      : super(key: key);

  @override
  State<PasswordLoginModal> createState() => _PasswordLoginModalState();
}

class _PasswordLoginModalState extends State<PasswordLoginModal> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmedPasswordController =
      TextEditingController();

  String _email = '';
  String _password = '';
  String _confirmedPassword = '';
  bool _isRegisterMode = false;
  bool _loginFailed = false;
  bool _passwordIncorrect = false;

  void _onEmailChanged(String value) {
    setState(() {
      _email = value;
    });
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _password = value;
    });
  }

  void _onConfirmedPasswordChanged(String value) {
    setState(() {
      _confirmedPassword = value;
    });
  }

  void _toggleRegisterMode() {
    _emailController.text = '';
    _passwordController.text = '';
    _confirmedPasswordController.text = '';
    setState(() {
      _email = '';
      _password = '';
      _confirmedPassword = '';
      _isRegisterMode = !_isRegisterMode;
      _loginFailed = false;
      _passwordIncorrect = false;
    });
  }

  void _onSubmitted() {
    if (_email.isEmpty) {
      Alert.build(context,
          title: '이메일을 확인해주세요', description: '이메일을 올바르게 입력해주세요.');
      return;
    }
    if (_isRegisterMode) {
      _register();
    } else {
      _login();
    }
  }

  void _register() async {
    if (_password != _confirmedPassword) {
      setState(() {
        _passwordIncorrect = true;
      });
      await Alert.build(context,
          title: '비밀번호를 확인해주세요',
          description: '비밀번호가 일치하지 않아요.\n비밀번호를 동일하게 입력해주세요.');

      return;
    }

    final registerUseCase = injector.get<RegisterUseCase>();
    final result =
        await registerUseCase(EmailPasswordParams(_email, _password));
    if (result is DataSuccess) {
      if (mounted) {
        await Alert.build(context,
            title: '회원가입을 완료했어요',
            description: '핀플에 오신 걸 환영해요!',
            confirmCallback: _login);
      }
      setState(() {
        _isRegisterMode = false;
      });
    } else {
      if (mounted) {
        await Alert.build(context,
            title: '회원가입에 실패했어요',
            description: '이미 존재하는 이메일이에요.\n다른 이메일을 사용해주세요',
            confirmCallback: _login);
      }
    }
  }

  void _login() async {
    final provider = context.read<AuthenticationProvider>();
    await provider.passwordLogin(EmailPasswordParams(_email, _password));
    if (provider.authentication != null) {
      if (mounted) Navigator.of(context).pop();
      widget.onLoginSucceed();
    } else {
      _passwordController.text = '';
      setState(() {
        _loginFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = context.watch<AuthenticationProvider>();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        color: Colors.black,
        height: size.height * .8,
        width: size.width,
        padding: EdgeInsets.only(
            left: PaddingHorizontal.normal,
            right: PaddingHorizontal.normal,
            top: PaddingVertical.big,
            bottom: PaddingVertical.big),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IText(_isRegisterMode ? '회원 가입' : '로그인'),
                Container(height: PaddingVertical.big),
                TextField(
                    controller: _emailController,
                    onChanged: _onEmailChanged,
                    style: TextStyle(
                        color: Colors.white, fontSize: FontSize.regular),
                    decoration: InputDecoration(
                      isDense: false,
                      hintText: '이메일을 입력해주세요',
                      hintStyle: TextStyle(
                          color: Colors.grey, fontSize: FontSize.regular),
                      label: IText('이메일'),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      contentPadding: EdgeInsets.only(
                          left: PaddingHorizontal.small,
                          right: PaddingHorizontal.small),
                    )),
                Container(height: PaddingVertical.big),
                TextField(
                    controller: _passwordController,
                    onChanged: _onPasswordChanged,
                    obscureText: true,
                    style: TextStyle(
                        color: Colors.white, fontSize: FontSize.regular),
                    decoration: InputDecoration(
                      isDense: false,
                      hintText: '비밀번호를 입력해주세요',
                      hintStyle: TextStyle(
                          color: Colors.grey, fontSize: FontSize.regular),
                      label: IText('비밀번호'),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: _loginFailed ? Colors.red : Colors.blue)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: _loginFailed
                                  ? Colors.red
                                  : Colors.grey.shade300)),
                      contentPadding: EdgeInsets.only(
                          left: PaddingHorizontal.small,
                          right: PaddingHorizontal.small),
                    )),
                _isRegisterMode
                    ? Container(height: PaddingVertical.normal)
                    : Container(),
                _isRegisterMode
                    ? TextField(
                        controller: _confirmedPasswordController,
                        onChanged: _onConfirmedPasswordChanged,
                        obscureText: true,
                        style: TextStyle(
                            color: Colors.white, fontSize: FontSize.regular),
                        decoration: InputDecoration(
                          isDense: false,
                          hintText: '비밀번호를 다시 입력해주세요',
                          hintStyle: TextStyle(
                              color: Colors.grey, fontSize: FontSize.regular),
                          label: IText('비밀번호 확인'),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: _passwordIncorrect
                                      ? Colors.red
                                      : Colors.blue)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: _passwordIncorrect
                                      ? Colors.red
                                      : Colors.grey.shade300)),
                          contentPadding: EdgeInsets.only(
                              left: PaddingHorizontal.small,
                              right: PaddingHorizontal.small),
                        ))
                    : Container(),
                Container(height: PaddingVertical.big),
                InkWell(
                  onTap: _onSubmitted,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: PaddingVertical.normal,
                      bottom: PaddingVertical.normal,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.blue),
                    child:
                        Center(child: IText(_isRegisterMode ? '회원가입' : '로그인')),
                  ),
                ),
                Container(height: PaddingVertical.big),
                InkWell(
                  onTap: _toggleRegisterMode,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.white, width: 0.8))),
                    child: IText(
                      _isRegisterMode ? '이미 계정이 있으신가요?' : '아직 계정이 없으신가요?',
                      weight: FontWeight.w100,
                    ),
                  ),
                )
              ],
            ),
            provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
