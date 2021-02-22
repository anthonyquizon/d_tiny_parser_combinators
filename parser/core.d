module parser.core;

import R = parser.result : Result;
import parser.stream : Stream;

struct Parser(T) {
    Result!T delegate (ref Stream) parse;
}

Parser!T lift(T)(T value) {
    return Parser!T((ref Stream stream) {
        return R.value(value);
    });
}

//class DynamicParser(T) {
    //Maybe!(Parser!T) maybe_parser;

    //void opAssign(Parser!T parser) {
        //this.maybe_parser = M.just(parser);
    //}

    //Result!T parse(ref Stream stream) {
		//assert(M.is_just(this.maybe_parser), "Use of empty dynamic parser");

        //auto parser = M.unsafe_unwrap(this.maybe_parser);

        //return parser.parse(stream);
    //};
//}

//Parser!T lift(T)(DynamicParser!T dynamic_parser) {
    //return Parser!T((ref Stream stream) {
        //return dynamic_parser.parse(stream);
    //});
//}




