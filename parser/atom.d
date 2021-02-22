module parser.atom;

import P = parser.core 
    : Parser;

import R = parser.result 
    : Result
    , value;

import parser.stream;


Parser!T literal(T=string)(T input_string) {
    return Parser!T((ref Stream stream) { 
        auto m = stream.mark();
        auto t = input_string.save();

        while(true) {
            if (t.empty()) {
                return value(stream.slice(m));
            }

            if (stream.empty()) {
                stream.restore(m);

                return R.error!T(stream.location, "unexpected end of stream");
            }

            if (t.front != stream.front) {
                stream.restore(m);
                
                return R.error!T(stream.location, "expected '"~ input_string ~ "' literal");
            }

            t.popFront();
            stream.popFront();
        }
    });
}

Parser!T token(T=char)(T c) {
    return Parser!T((ref Stream stream) {
        if (stream.empty()) {
            return R.error!T(stream.location, "expected '" ~ c ~ "'");
        }

        if(stream.front() == c){
            stream.popFront();

            return value(c);
        }

        return R.error!T(stream.location, "expected '" ~ c ~ "'");
    });
}

//Parser!T range(T=char)(char low, char high) {
    //return Parser!T((ref Stream stream) {
        //if (stream.empty()) {
            //return R.error!T(stream.location(), "unexpected end of stream");
        //}

        //auto v = stream.front;

        //if (v >= low && v <= high) {
            //stream.popFront();

            //return lift!T(to!char(v));
        //}

        //return R.error!T(stream.location(), "expected in a range of " ~ to!string(low) ~ ".." ~ to!string(high));
    //});
//}

//DynamicParser!(T) dynamic(T)() {
    //return new DynamicParser!T();
//}



