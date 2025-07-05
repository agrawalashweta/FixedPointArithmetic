# Verilog-Fixed Point Implementation
Verilog- Fixed Point Library includes
1. Customizable integer bit width and fractional bit width.
2. Arithmetic operations: Addition, Subtraction, Multiplication, Division, Square root.
3. Overflow Detection: When an overflow occurs, the overflow wire is set to 1 and the output will be set to a positive maximum value or negative maximum value
4. Round control: When truncation occurs, you can choose whether to round up or not.
5. Supports converting to and from single precision floating point format. (IEEE-754)
6. Some of the operations above are pipelined to increase their throughput. (the ones who have a lengthy combinational procedure)

# Fixed Point Format
In digital hardware systems like FPGAs or embedded processors, fixed-point representation is used to represent real numbers without using floating-point hardware. This format assigns a fixed number of bits to the integer and fractional parts of a number.
The fixed point format is denoted as  Q(m.n) where m represents the width of integer part and n the width of fractional part.

# Project Focus
This project focuses on implementing fixed-point arithmetic operations using Verilog HDL. The goal is to design, simulate, and verify digital circuits capable of performing precise arithmetic on numbers represented in fixed-point format (e.g., Qm.n), which is efficient for hardware systems without floating-point units.

Key objectives include:
1. Understanding and applying Q-format (fixed-point) representation.
2. Implementing basic arithmetic modules (e.g., addition, multiplication).
3. Managing scaling, overflow, and two’s complement signed operations.
4. Ensuring accurate and efficient hardware-friendly computation.

This type of arithmetic is widely used in signal processing, control systems, and embedded applications where performance and resource efficiency are critical.

# Project Structure
The fixed point arithmetic has been implemeneted in a modular manner, below text explains the module and the structure of the project.

## 1. fxp_width :
fxp_width sets the bit width of the entire fixed point number (including both the integer and fractional parts). It directly affects the precision and range.
It helps you convert from one Q-format to another. Allows you to change the integer-width, fractional-width, optionally round the value and detect overflow if the input cannot be stored in the output format. This is a pure combinational logic.
## 2. fxp_add :
fxp_add module performs fixed-point addition of 2 inputs ina and inb, that may have different Q-formats. It outputs the result in a target Q-format and optionally detects overflow and handles rounding using purely combinational logic. Both of the inputs are sized to the same Q-format and then added together using verilog in-built adder.
## 3. fxp_addsub : 
fxp_addsub module performs fixed-point addition or subtraction of 2 inputs ina and inb, that may have different Q-formats. The addition or subtration is controlled by the input wire sub. It produces the result in a target Q-format and optionally detects overflow and handles rounding using purely combinational logic. 
## 4. fxp_mul :
fxp_mul module performs fixed point multiplication between two inputs ina and inb with possibly different Q-formats and returns the output in a target Q-format using combinational logic. It handles overflow and rounding conditions too.
## 5. fxp_mul_pipe :
fxp_mul_pipe module performs signed fixed point multiplication between two signed inputs ina and inb, using 2 stage pipelining for improved timing and throughput. It handles inputs with different Q-formats and scales the result to a specified Q-format with rounding/truncation and overflow detection.
## 6. fxp_div :
fxp_div module performs signed fixed point division using combinational logic and a bit iterative approximation method. It supports configurable input/output formats and handles rounding/truncation and overflow detection.

# Key Achievements
1. Fully parametrizable bit widths (int and frac) per operand.
2. Supports signed arithmetic via 2's complement logic.
3. Overflow detection and clamping to handle saturation logic.
4. Optional rounding support via ROUND control.
5. Pipelined modules for improved timing and throughput.
6. Flexible output scaling with internal auto-alignment logic.

# Tools and Technologies
Language: Verilog (SystemVerilog Compatible)
Simulator: Icarus Verilog and GTKwave/ EDA Playground 
Version Control: Git
Testing: Custom Verilog Testbenches

Contributions are most welcome! If you'd like to add more modules, enhance the existing ones or bring up issues about some edge-cases that might not have been considered, feel free to open a pull request or issue.



