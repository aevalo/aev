def ret_3():
  return 1, 2, 3


def main():
  a, b, c = ret_3()
  print("a = {0}, b = {1}, c = {2}".format(a, b, c))
  print("a = %d, b = %d, c = %d" % (a, b, c))

if __name__ == "__main__":
  main()