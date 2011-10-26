# PostScript

This is a minimal implementation of the PostScript language supporting all
operators defined in the PDF Spec for "Operators in Type 4 Functions".

It's not useful for much more than evaluating Type4 functions, but perhaps it
will be some fun to play around with -- PostScript is a rather interesting
language!

It includes a very simple parser (see PostScript::Parser), and a runtime (see
PostScript::Runtime).

## About PostScript

PostScript is a stack-based language, and this library supports (nearly) all of
its stack, arithmetic, boolean, and conditional operators.

You can refer to the [PostScript Language
Reference](http://www.adobe.com/products/postscript/pdfs/PLRM.pdf) for more details.

## Usage

The runtime can be driven manually (through ruby) or by evaluating a snippet of
PostScript.

Here's some trivial examples, first driven manually:

    ps = PostScript::Runtime.new
    ps.stack  # => []
    ps.push 2 # => [2]
    ps.push 2 # => [2, 2]
    ps.mul    # => [4]
    ps.push 2 # => [4, 2]
    ps.div    # => [2]
    ps.stack  # => [2]

And then as a bit of PostScript code:

    ps = PostScript::Runtime.new
    ps.stack  # => []
    ps.eval "{ 2 2 mul 2 div }"
    ps.stack  # => [2]

Of course, the manual stack manipulation can be combined with PostScript code:

    ps = PostScript::Runtime.new

    # Set up the initial state
    ps.push -4.0, 2.0

    # Execute the "Rhomboid" spot function as defined in the PDF Spec.
    ps.eval "{ abs exch abs 0.9 mul add 2 div }" # => [2.8]
