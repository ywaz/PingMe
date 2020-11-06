
  bool emailValidator(String email){
    RegExp regex = RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
    if(email.isNotEmpty){
      return regex.hasMatch(email);
    }
    return null;
  }

  bool passwordvalidator(String pwd){
    RegExp regex= RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[a-zA-Z\d]{8,}'); 
    if(pwd.isNotEmpty){
      return regex.hasMatch(pwd);
    }
    return null;
  }