Racket: PyPP byterun


Minimalist interpreter for python, using the functional paradigm.
I implemented CPython, being the first and most widely used Python implementation, which creates what is called python byte code and then runs what is called byterun.
CPython uses a model called stack machine model: a stack is used to operate instructions. In addition to this stack, the interpreter needs to hold several dictionaries in order to load immediate values:

co_varnames = the association between the variable names and their values ​​in the program that changes at a certain point in time
co_constants = dictionary with constant values
co_names = dictionary with function names (for bonus)
For loops, CPython for is used by iterators. An iterator is an object for which a next function can be called which returns the value at the current step and the value of the next iterator.
CPython ByteCode:
TOS = top of stack.

TOS1 = the element before the end of the stack (from the top of stack position - 1).

The subset of instructions we will meet is:
1 POP_TOP Calls the pop operation on the execution stack.
100 LOAD_CONST (const_i) Pushes the item from co_consts [const_i] on the execution stack.
116 LOAD_GLOBAL (func_i) Pushes the element from the con_names [func_i] on the execution stack.
125 STORE_FAST (var_i) Stores TOS in co_varnames [var_i] and pops from the stack.
124 LOAD_FAST (var_i) Pushes the item from co_varnames [var_i] on the execution stack
22 BINARY_MODULO Operates TOS = TOS1% TOS
23 BINARY_ADD Operates TOS = TOS1 + TOS
24 BINARY_SUBTRACT Operates TOS = TOS1 - TOS
55 INPLACE_ADD Same operation as BINARY_ADD (eg Python operation: x + = 3)
56 INPLACE_SUBTRACT Same operation as BINARY_SUBTRACT
59 INPLACE_MODULO Same operation as BINARY_MODULO
113 JUMP_ABSOLUTE (target) Jump to the instruction in the target bytecode
107 COMPARE_OP (i) Performs a Boolean operation between TOS1 and TOS. The operation is at cmp_op [i]. The operands are removed from the stack, and the result of the operation will be put on the stack.
114 POP_JUMP_IF_FALSE (target) If TOS is false, jump to target, if not, continue with the following statement - pop to element
115 POP_JUMP_IF_TRUE (target) If TOS is true, jump to target, if not, continue with the following statement - pop to element
68 GET_ITER Implement TOS = iter (TOS)
93 FOR_ITER (delta) TOS is guaranteed to be iterative. Will do next (TOS). If a value is returned, it will put the value on the stack and below the new iterator. If the iterator is empty, it will remove it from the stack and jump with the delta + 2 bytes
131 CALL_FUNCTION (argc) Calls a function. On the stack is a number of argc arguments, followed by the function name. CALL_FUNCTION will remove them from the stack, call the function (defined in Racket) and put the result on the stack.
120 SETUP_LOOP (delta) You can ignore it for this topic Pushes a block for a loop on the stack of blocks. The block starts from the current instruction and has the delta length
87 POP_BLOCK You can ignore it for this theme. Call pop operation on the execution stack
83 RETURN_VALUE The function execution is over - nothing should be done