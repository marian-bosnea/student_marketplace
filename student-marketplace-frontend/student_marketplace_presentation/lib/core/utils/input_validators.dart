bool checkEmail(String value) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(value);

bool checkPassword(String value) => value.length > 4;

bool checkIfcContainsUppercase(String value) =>
    value.contains(RegExp(r'[A-Z]'));
bool checkIfContainsLowercase(String value) => value.contains(RegExp(r'[a-z]'));
