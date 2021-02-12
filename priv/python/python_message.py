def hello(my_string):
  if isinstance(my_string, bytes):
    my_string = my_string.decode("utf-8")
  
  return "Hello world from " + my_string

if __name__ == '__main__':
  print(hello("Python"))
