module parser.stream;

struct Stream {
	size_t index;
	string range;

	char front(){
		size_t t = index;
		return range[t];
	}

	this(string source){
		range = source;
		index = 0;
	}

	void popFront() { 
        index += 1; 
    }

	bool empty(){ 
        return index == range.length; 
    }

	string slice(size_t i){ 
        return range[i .. index]; 
    }

	size_t mark(){ 
        return index; 
    }

	void restore(size_t i){ 
        index = i; 
    }

	size_t location() { 
        return index; 
    }
}

@property inout(T)[] save(T)(return scope inout(T)[] a) @safe pure nothrow @nogc
{
    return a;
}

@property bool empty(T)(auto ref scope T a)
if (is(typeof(a.length) : size_t))
{
    return !a.length;
}

@property ref inout(T) front(T)(return scope inout(T)[] a) @safe pure nothrow @nogc
{
    return a[0];
}

void popFront(ref string str) {
    str = str.ptr[1..str.length];
}
