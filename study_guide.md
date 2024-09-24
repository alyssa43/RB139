<h1>RB139 Study Guide</h1>

<h2>Blocks</h2>

* Closures, binding, and scope:

  A closure is a block, proc, or lambda that "binds" to its surrounding scope, even after that scope has exited. It is a chunk of code that can be passed to around to methods and executed. They provide flexibility, allowing you to delay certain decisions until the method invocation. You define blocks between `{}` for single-line blocks or `do...end` for multi-line blocks.

  ```ruby
  def greet
    puts "Hello!"
    yield if block_given?
    puts "Goodbye!"
  end
  
  greet { puts "Have a great day!" }
  # Output =>
  # Hello!
  # Have a great day!
  # Goodbye!
  ```

  Here, the block `{ puts "How are you?" }` is passed to the method `greet` and executed when `yield` is called.

* How blocks work, and when we want to use them:

  Blocks let you delay certain parts of the method's implementation until the method is invoked. They give the method users the flexibility to customize how the method works when they call it. This also allows the method implementor to create more general methods that can adapt to different situations.

  ```ruby
  def process_array(array)
    result = []
    array.each do |item|
      result << yield(item)
    end
    result
  end
  
  process_array([1, 2, 3, 4]) { |num| num * 2 }
  # => [2, 4, 6, 8]
  process_array([1, 2, 3, 4]) { |num| num.to_s }
  # => ["1", "2", "3", "4"]
  process_array(['a', 'b', 'c', 'd']) { |char| char.upcase }
  # => ['A', 'B', 'C', 'D']
  ```

  In the above example, we have defined a method called `process_array` that accepts an array as the argument. It then iterates through the given array and then yields each element of the array to the block, which then pushes the returned value into the `result` array, which then gets returned after the array has completed its iterations. This leaves the implementation details to the method user, by allowing the person who invokes the method to determine how they want to use the method.

  Another scenario in when to use blocks in our own methods, is when we want to perform a "before" and "after" action, otherwise known as "sandwich code". A common use case of this would be to open a file, perform some action with the file, and then close the file.

  ```ruby
  def use_file(file_name)
    file = File.open(file_name, "r")
    result = yield(file)
    file.close
    
    result
  end
  
  use_file('example.txt') { |file| file.read.split.size } # => returns the amount of words
  ```

  In the above example, we have defined a method called `use_file` that has one parameter called `file_name`.   This method works by opening the file, then yield the file to the block (and assigns the blocks return value into a method variable called `result`), and then finally close the file. This allows the method user to determine the implementation of how the file is used. When we invoke the `use_file` method and pass the file name `'example.txt'` as the argument then pass the block `{ |file| file.read.split.size }` to the method invocation, we are using the `use_file` method to open the file named `'example.txt`' and assigning the method variable `file` to reference the opened file. From there we assign a new method variable called `result` to reference the return value of yielding the `file` to the block, which in this case is the return value of `file.read.split.size` which first reads the `file`, then splits into in an Array of strings where it has been separated by spaces, and then finally counts the amount of words in the returned Array. So in this case `result` will refrence an Integer. From there, we close the `file`, and then finally on the last line we return the value referenced by `result`. This means that the `use_file` method will return the return value of the block passed in upon invocation.

* Blocks and variable scope:

  Blocks have a self-contained scope. This means that variables initialized outside of the block can be referenced within a block, however if a variable is initialized within a block, it cannot be accessed outside of the block.

  ```ruby
  a = 1
  
  3.times do
    b = 2
    a += 1
  end
  
  a => 4
  b => NameError: undefined local variable or method `b`
  ```

  In the above example, we have created a local variable called `a` in the outer most scope of our program. We then invoke the `times` method on the Integer `3` and pass a `do...end` block as the argument. Within the block, we create a variable called `b` that references the Integer `2`, and then we increment our local variable `a` by 1 with each iteration. After the `3` iterations have completed, we exit the block and reference `a` which returns the Integer `4`, because it was initialized in the outer most scope we were able to access it within the `do...end` block. However, when we try to refrence the variable `b`, we get a `NameError` exception because it was initialized within the `do...end` block, we are unable to access it outside of the block.

* Create custom methods that use blocks and procs

  ```ruby
  def repeat(num)
    num.times { yield }
  end
  
  a = 1
  repeat(5) { a += 1 } # => 5 (returns the number passed in as an argument)
  a # => 6 
  
  repeat(3) { puts "Hello!"} # => 3
  # Output =>
  # Hello!
  # Hello!
  # Hello!
  ```

  In the above example, we have defined a method called `repeat` that has one parameter called `num`. Within the method definition we then invoke the `times` method on the number passed in that is being reference by the method parameter `num`. We then `yield` to the block for each iteration of the `times` method. From there we have initialized a local variable called `a` that is referencing the integer `1`. We then invoke the `repeat` method and pass the Integer `5` and the implicit block `{ a += 1 }` as the arguments. Which returns the value passed in which is `5`, and increments the value of the local variable `a` by 1 5 times, which is why `a` then references `6` afterwards. 

  ```ruby
  ```

  

* Understand that methods and blocks can return chunks of code (closures):

  Methods and blocks can return Procs and Lambdas (not blocks), which is where closures really shine. Because closures have a memory of their surrounding scope (their binding), and can reference and even update variable in their binding, it allows us to create methods like the following:

  ```ruby
  def create_counter
    count = 0
    Proc.new { count += 1 }
  end
  
  counter1 = create_counter
  counter1.call # => 1
  counter1.call # => 2
  counter1.call # => 3
  
  counter2 = create_counter
  counter2.call # => 1
  ```

  This demonstrates how each time `create_counter` is invoked, a new Proc object is returned and each individual Proc has access to its own `count` variable, which gets incremented each time the Proc is called.

  ```ruby
  def block_to_proc(&block)
    block
  end
  
  count = 0
  
  counter = block_to_proc { count += 1 } # => #<Proc:0x0000000109e613b0>
  counter.call # => 1
  counter.call # => 2
  counter.call # => 3
  
  p count # => 3
  ```

  In the above example we have defined a method called `block_to_proc` that has an explicit block as the parameter, which then converts that block to a simple Proc object, and then returns that Proc. We then created a local variable called `count` and assigned it to reference `0`. Then, we created a new local variable called `counter` that is assigned to reference the return value of invoking the `block_to_proc` method with the argument of the block `{ count += 1 }`. Because we have initialized the local variable `count` before the block, the `count` variable is within the blocks binding and therefore, the `count` within the block is referencing the local variable `count`. Becaue `counter` is referencing a Proc, we can use `call` to invoke the Proc, which increments the local variable `count` by `1` with each invocation. On the final line we can then see that the local variable `count` has been modified with each call of `counter`. 

* Methods with an explicit block parameter:

  When a method takes an explicit block, the block gets assigned to a method parameter which provides additional flexibility because we can then pass that block to another method if we wish. Whereas with an implicit block, all we can really do is `yield` to it.

  ```ruby
  def explicit_block_to_simple_proc(&block)
    block
  end
  
  explicit_block_to_simple_proc { puts "Hello World" }
  # => #<Proc:0x00000001045eff88>
  ```

  The above example shows how when a method is defined with an explicit block as the parameter, Ruby uses the `&` symbol to transform the block to a simple Proc object.

  ```ruby
  def greet(simple_proc)
    simple_proc.call("Hello, ")
  end
    
  def display_greeting(&block)
    puts "-------"
    greet(block)
    puts "-------"
  end
    
  display_greeting { |greeting| puts greeting + "Alyssa"}
  # Output =>
  # ----------
  # Hello, Alyssa                                                                  
  # ----------                                                                     
  ```

  In the above example, we have a method called `display_greeting` that accepts an explicit block as the argument, this means that the block passed in as the argument when `display_greeting` is invoked, will be referenced by the method parameter `block`. We use the `&` symbol in the block parameter, so that when we pass the block Ruby will transform it into a simple proc object. From within the `display_greeting` method, we no longer need to prefix it with the `&` symbol, since it is now a proc - which we then pass as the argument to the `greet` method invocation. Within the `greet` method we then invoke the proc by using `call` and pass it the argument `"Hello, "`. By passing in an argument to this block, turned proc, we are passing the argument to reference the block parameter `greeting`, which then gets output along with the string `"Alyssa"`.

* Arguments and return values with blocks

* When you can pass a block to a method

* &:symbol

* Arity of blocks and methods

<h2>Testing</h2>

* Testing terminology
* Minitest vs. RSpec
* SEAT approach
* Testing equality
* Assertions

<h2>Packaging Code into a Project</h2>

* Purpose of core tools
* Gemfile