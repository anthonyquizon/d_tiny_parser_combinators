//import mar.stdio;
import parser.core;
import parser.atom;
import parser.combinator;
import parser.stream;
import parser.result;


unittest { 
    auto stream = Stream("hello world!");
    auto parser = token('h');
    auto result = parser.parse(stream);
    assert(result == value('h'));
}

unittest {
    auto stream = Stream("hello world!");
    auto parser = literal("hello");
    auto result = parser.parse(stream);

    assert(result == value("hello"));
}

unittest {
    struct T { string a; string b; }

    auto stream = Stream("hello world!");
    auto parser = literal("hello").bind((string a) {
        return token(' ').bind((char _) {
            return literal("world").bind((string b) {
                return lift(T(a, b));
            });
        });
    });

    auto result = parser.parse(stream);

    assert(result == value(T("hello", "world")));
}

unittest {
    struct T { char a; string label; char b; }

    auto stream = Stream("<hello>");
    auto parser = sequence!T( 
        token('<'),
        literal("hello"),
        token('>')
    );

    auto result = parser.parse(stream);

    assert(result == value(T('<', "hello", '>')));
}

void main() {
}

//import mar.stdio;
//void popFront(ref string str) {
    //str = str.ptr[1..str.length];
//}

//void main() {
    //string a = "hello";
    //assert(a.length == 5);
    //a.popFront();
    //assert(a == "ello");

    //stdout.write(a);
//}
