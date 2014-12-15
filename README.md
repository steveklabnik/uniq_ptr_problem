# Unique Pointer Problems

When discussing Rust and safety, a common refrain is that C++ smart pointers
do the same thing that Rust's do, and therefore, it's not an advantage for
Rust.

While it's true that C++'s smart pointers are a huge leap forward, they
aren't actually safe in all cases. I always forget what the exact cases
are, so I made this page to remind myself.

```cpp
#include <iostream>
#include <memory>

using namespace std;

int main ()
{
    unique_ptr<int> orig(new int(5));

    cout << *orig << endl;

    auto stolen = move(orig);

    cout << *orig << endl;
}
```

The previous code, when compiled on my system (Debian Jessie):

```bash
$ g++ -std=c++14 -Wall -Wextra -g code.cpp -o code
$ ./code 
5
Segmentation fault
$ clang++ -std=c++14 -Wall -Wextra -g code.cpp -o code
$ ./code 
5
Segmentation fault
```

This happens because `move` sets `orig` to null, making this an example of
undefined behavior.

See [The C++11 standard](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2011/n3242.pdf), section 20.7.1 4:

> Additionally, `u` can, upon request, transfer ownership to another unique
> pointer `u2`. Upon completion of such a transfer, the following
> postconditions hold:
> 
> - `u.p` is equal to `nullptr`

Hence, no warning, and hence, a null pointer dereference.

[This HN comment](https://news.ycombinator.com/item?id=8751815)
inspired me to finally write this down.
