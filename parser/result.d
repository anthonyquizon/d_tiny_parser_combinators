module parser.result;

struct Error {
    size_t location;
    string message;

    string toString() const { return to_string(this); }
}

struct _ {};

struct Result(T) {
    union Content { T value; Error error; bool pass; }
    enum Type { Value, Error, Pass }

    Content content;
    Type type;

    bool opEquals(Result!T rhs) const { return equals(this, rhs); }
}

bool equals(T)(const Result!T lhs, const Result!T rhs) {
    if (lhs.type != rhs.type) {
        return false;
    }

    if (lhs.type == Result!T.Type.Value) {
        return lhs.content.value == rhs.content.value;
    }

    if (lhs.type == Result!T.Type.Error) {
        return lhs.content.error == rhs.content.error;
    }

    return true;
}

string to_string(const Error error) {
    //return "Error at " ~ to!string(error.location) ~ ": " ~ error.message;
    return "Error at "  ~ ": " ~ error.message;
}

T unsafe_unwrap(T)(Result!T result) {
    assert(result.type == Result!T.Type.Value, "unwrapping value that is not a value!");

    return result.content.value;
}

Error unsafe_unwrap_error(T)(Result!T result) {
    assert(result.type == Result!T.Type.Error, "unwrapping errror that is not an error!");

    return result.content.error;
}

Result!(T) value(T)(T value) {
    auto result = Result!T();

    result.type = Result!T.Type.Value;
    result.content.value = value;

    return result;
}

Result!(T) error(T)(Error err) {
    return error!T(err.location, err.message);
}

Result!(T) error(T)(size_t location, string message) {
    auto result = Result!T();
    auto error = Error();

    error.location = location;
    error.message = message;

    result.content.error = error;
    result.type = Result!T.Type.Error;

    return result;
}

Result!(T) pass(T)() {
    auto result = Result!T();

    result.content.pass = true;
    result.type = Result!T.Type.Pass;

    return result;
}

bool is_value(T)(const Result!(T) result) {
    return result.type == Result!T.Type.Value;
}

bool is_error(T)(const Result!(T) result) {
    return result.type == Result!T.Type.Error;
}

bool is_pass(T)(const Result!(T) result) {
    return result.type == Result!T.Type.Pass;
}

//string to_string(T)(const Result!(T) result) {
    //if (result.type == typeid(T)) {
        //return to!string(result.get!(T)());
    //}

    //if (result.type == typeid(Error)) {
        //return to!string(result.get!(Error)());
    //}

    //return "pass";
//}

