class Httpexp implements Exception{
final String message;
Httpexp(this.message);

@override
  String toString() {
    
    return message;
  }

}