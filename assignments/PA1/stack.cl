(*
 *  CS164 Fall 94
 *
 *  Programming Assignment 1
 *    Implementation of a simple stack machine.
 *
 *  Skeleton file
 *)

class Main inherits IO {

   atoi : A2I <- new A2I;
   list : List <- new List;

   main() : Object {
      let c : String <- in_string()  in
         while not c = "x" loop {
            if c = "+" then push(c) else
            if c = "s" then push(c) else
            if c = "e" then eval() else
            if c = "d" then out_string(toString()) else {
               let num : Int <- atoi.a2i(c) in push(atoi.i2a(num));
            }
            fi fi fi fi;

            c <- in_string();
         } pool
   };

   push(c : String) : List {
      list <- list.cons(c)
   };

   pop() : String {
      let ret: String <- list.head() in {
         list <- list.tail();
         ret;
      }
   };

   eval() : List {
      if list.isNil() then list else {
         -- Safe checking?
         if list.head() = "+" then {
            pop();
            let first : Int <- atoi.a2i(pop()), second : Int <- atoi.a2i(pop()) in {
               let sum: Int <- first + second in
                  list <- list.cons(atoi.i2a(sum));
            };
         } else if list.head() = "s" then {
            pop();
            let first : String <- pop(), second : String <- pop() in {
               list <- list.cons(first);
               list <- list.cons(second);
            };
         } else list
         fi fi;
      } fi
   };

   toString() : String {
      let l : List <- list, s: String in {
         while not l.isNil() loop {
            s <- s.concat(l.head());
            l <- l.tail();
         }
         pool;

         s.concat("\n");
      }
   };
};

class List {
   isNil() : Bool { true };

   head()  : String { { abort(); ""; } };

   tail()  : List { { abort(); self; } };

   cons(i : String) : List {
      (new Cons).init(i, self)
   };
};

class Cons inherits List {

   car : String;	-- The element in this list cell

   cdr : List;	-- The rest of the list

   isNil() : Bool { false };

   head()  : String { car };

   tail()  : List { cdr };

   init(i : String, rest : List) : List {
      {
         car <- i;
         cdr <- rest;
         self;
      }
   };
};
