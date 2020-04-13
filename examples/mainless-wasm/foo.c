#define EXPORT __attribute__ ((visibility ("default")))

EXPORT int add(int a, int b)
{
  return a+b;
}
