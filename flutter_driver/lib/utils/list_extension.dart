

extension ListExtension<E> on List<E>{

  int indexOfFunc(E element,Function(E e) function ){
    for (int i = 0; i < this.length; i++) {
        if(function(this[i])){
          return i;
        }
    }
    return -1;
  }



}