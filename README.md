# Verilog-Fixed Point Implementation
Verilog- Fixed Point Library includes
1. Customizable integer bit width and fractional bit width.
2. Arithmetic operations: Addition, Subtraction, Multiplication, Division, Square root.
3. Overflow Detection: When an overflow occurs, the overflow wire is set to 1 and the output will be set to a positive maximum value or negative maximum value
4. Round control: When truncation occurs, you can choose whether to round up or not.
5. Supports converting to and from single precision floating point format. (IEEE-754)
6. Some of the operations above are pipelined to increase their throughput. (the ones who have a lengthy combinational procedure)

#Fixed Point Format
In digital hardware systems like FPGAs or embedded processors, fixed-point representation is used to represent real numbers without using floating-point hardware. This format assigns a fixed number of bits to the integer and fractional parts of a number.
The fixed point format is denoted as  Q(m.n) where m represents the width of integer part and n the width of fractional part.

#Project Focus
This project focuses on implementing fixed-point arithmetic operations using Verilog HDL. The goal is to design, simulate, and verify digital circuits capable of performing precise arithmetic on numbers represented in fixed-point format (e.g., Qm.n), which is efficient for hardware systems without floating-point units.

Key objectives include:
1. Understanding and applying Q-format (fixed-point) representation.
2. Implementing basic arithmetic modules (e.g., addition, multiplication).
3. Managing scaling, overflow, and two’s complement signed operations.
4. Ensuring accurate and efficient hardware-friendly computation.

This type of arithmetic is widely used in signal processing, control systems, and embedded applications where performance and resource efficiency are critical.


