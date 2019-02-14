//typedef void Func(Object obj);
typedef Func = void Function([Object obj1,Object obj2,Object obj3]);


//typedef dynamic OnCall(List);
//
//class VarargsFunction extends Function {
//  OnCall _onCall;
//
//  VarargsFunction(this._onCall);
//
//  call() => _onCall([]);
//
//  noSuchMethod(Invocation invocation) {
//    final arguments = invocation.positionalArguments;
//    return _onCall(arguments);
//  }
//}