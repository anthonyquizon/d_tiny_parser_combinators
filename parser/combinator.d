module parser.combinator;

import parser.stream;
import P = parser.core : Parser;
import R = parser.result 
    : Result
    , Error
    , is_pass
    , is_error
    , value
    , _;

import parser.atom 
    : token
    , literal;


Parser!T try_parser(T)(Parser!T parser) {
    return Parser!T((ref Stream stream) {
        auto save = stream.mark;
        auto result = parser.parse(stream);

        if (R.is_pass(result)) {
            stream.restore(save);
            return R.pass!T();
        }

        if (R.is_error(result)) {
            auto error = R.unsafe_unwrap_error(result);
            stream.restore(save);

            return R.error!T(error);
        }

        return result;
    });
}

Parser!T sequence(T, A, B, C)(
    Parser!A a, 
    Parser!B b, 
    Parser!C c
) {
    return try_parser(a.bind((A a_out) {
        return b.bind((B b_out) {
            return c.bind((C c_out) {
                return P.lift(T(a_out, b_out, c_out));
            });
        });
    }));
}


        //if (is_pass(a_out)) { 
            //return R.pass!T(); 
        //}

        //if (is_error(a_out)) { 
            //auto error = R.unsafe_unwrap_error(a_out);
            //return R.error!T(error); 
        //}

        //auto b_out = try_parse(stream, save, b);

        //if (is_pass(b_out)) { 
            //return R.pass!T(); 
        //}

        //if (is_error(b_out)) { 
            //auto error = R.unsafe_unwrap_error(a_out);
            //return R.error!T(error); 
        //}

        //auto c_out = try_parse(stream, save, c);

        //if (is_pass(c_out)) { 
            //return R.pass!T(); 
        //}

        //if (is_error(c_out)) {
            //auto error = R.unsafe_unwrap_error(c_out);
            //return R.error!T(error); 
        //}

        //return value(T(
            //R.unsafe_unwrap(a_out), 
            //R.unsafe_unwrap(b_out), 
            //R.unsafe_unwrap(c_out), 
        //));
    //});
//}



//Parser!(T[]) repeat(T)(DynamicParser!T parser, size_t min=1, size_t max=size_t.max) {
    //return P.lift(parser).repeat(min, max);
//}

//Parser!(T[]) repeat(T)(Parser!T parser, size_t min=1, size_t max=size_t.max) {
    //return Parser!(T[])((ref Stream stream) {
		//auto start = stream.mark;

		//size_t i = 0;
		//T[] value;

		//for(; i<min; i++) {
            //auto result = parser.parse(stream);

            //if (R.is_pass(result) || R.is_error(result)) {
				//stream.restore(start);
                //return R.pass!(T[])();
            //}

            //value ~= R.unsafe_unwrap(result);
		//}

		//for(; i<max; i++){
            //auto result = parser.parse(stream);

            //if (R.is_pass(result) || R.is_error(result)) {
                //break;
            //}

            //value ~= R.unsafe_unwrap(result);
		//}

        //return R.lift(value);
    //});
//}

//Parser!U map(T, U)(Parser!T parser, U delegate(T) f) { 
    //return parser.bind!(T, U)((T t) {
        //auto value = f(t);

        //return R.lift!U(value);
    //});
//}

Parser!U bind(T, U)(Parser!T parser, Parser!U delegate(T) f) { 
    return Parser!U((ref Stream stream) {
        auto result = parser.parse(stream);

        if (R.is_pass(result)) {
            return R.pass!U();
        }

        if (R.is_error(result)) {
            auto error = R.unsafe_unwrap_error!T(result);
            return R.error!U(error);
        }

        auto value = R.unsafe_unwrap(result);

        return f(value).parse(stream);
    });
}

//Parser!T any(
    //T = CommonType!(staticMap!(TemplateArgsOf, TS)),
    //TS...
//)(TS parsers) {
    //return Parser!T((ref Stream stream) {
        //auto save = stream.mark;
        //Error[] errors;

        //foreach (parser; parsers) {
            //auto result = parser.parse(stream);

            //if (R.is_error(result)) {
                //errors ~= R.unsafe_unwrap_error(result);
                //continue;
            //}

            //if (R.is_pass(result)) {
                //continue;
            //}

            //auto value = R.unsafe_unwrap(result);

            //return R.lift(value);
        //}

        //stream.restore(save);

        //auto message = errors
            //.map!((Error error) => error.message)
            //.join(" or ");

        //if (errors.empty) {
            //return R.pass!T();
        //}

        //return R.error!T(errors[0].location, message);
    //});
//}

//Parser!T whitespace(T=string)() {
    //return Parser!T((ref Stream stream) {
        //string values;

        //while(!stream.empty && isWhite(stream.front)) {
            //values ~= stream.front();
            //stream.popFront();
        //}

        //return R.lift(values);
    //});
//}

/*
 * Discards
 */
//Parser!T whitespace_(T=_)() {
    //return whitespace.map((string _s) => _());
//}

//Parser!T token_(T=_)(char c) {
    //return token(c).map((char _c) => _());
//}

//Parser!T literal_(T=_)(string s) {
    //return literal(s).map((string _s) => _());
//}

//alias __ = whitespace_;

