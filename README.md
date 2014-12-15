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

See [The C++11 standard](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2011/n3242.pdf), section `20.7.1 4`:

> Additionally, `u` can, upon request, transfer ownership to another unique
> pointer `u2`. Upon completion of such a transfer, the following
> postconditions hold:
> 
> - `u.p` is equal to `nullptr`

Hence, no warning, and hence, a null pointer dereference.

The [C++14 standard](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2013/n3797.pd) uses the same language, but is in section `20.8.1 4` instead.

The equivalent Rust program:

```rust
fn main() {
    let org = box 5i;

    println!("{}", org);

    let stolen = org;

    println!("{}", org);
}
```

gives an error when compiled:

```bash
$ rustc code.rs
code.rs:8:20: 8:23 error: use of moved value: `org`
code.rs:8     println!("{}", org);
                             ^~~
note: in expansion of format_args!
<std macros>:2:23: 2:77 note: expansion site
<std macros>:1:1: 3:2 note: in expansion of println!
code.rs:8:5: 8:25 note: expansion site
code.rs:6:9: 6:15 note: `org` moved here because it has type `Box<int>`, which is moved by default
code.rs:6     let stolen = org;
                  ^~~~~~
code.rs:6:9: 6:15 help: use `ref` to override
code.rs:6     let stolen = org;
                  ^~~~~~
error: aborting due to previous error
```

The Rust compiler itself understands move semantics, and therefore, knows
that `org` is invalid after a move.

[This HN comment](https://news.ycombinator.com/item?id=8751815)
inspired me to finally write this down.
