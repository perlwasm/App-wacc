/*
 * This was helpful:
 * https://lld.llvm.org/WebAssembly.html
 * https://clang.llvm.org/docs/AttributeReference.html#import-module
 */

#define IMPORT_FOO __attribute__((import_module("foo")))
#define EXPORT __attribute__ ((visibility ("default")))

IMPORT_FOO extern void bar();

EXPORT int add(int a, int b)
{
  bar();
  return a+b;
}

EXPORT void mylog(const char *format)
{
}

EXPORT void baz()
{
  bar();
}
