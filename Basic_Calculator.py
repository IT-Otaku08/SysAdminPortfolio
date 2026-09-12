#Simple Calculator Example

print("Welcome to the Simple Python Calculator!")

# Get input from user
Num1 = float(input("Enter the first number: "))
Num2 = float(input("Enter the second number: "))

#Arithmetic operations
Add = Num1 + Num2
Subtract = Num1 - Num2
Multiply = Num1 * Num2
Divide = Num1 / Num2 if Num2 != 0 else "Cannot divide by 0"

#Display results
print("\n--- Arithmetic Operations ---")
print("Addition: ", Add)
print("Subtraction: ", Subtract)
print("Multiplication", Multiply)
print("Division", Divide)

#Comparison Operations
print("\n--- Comparison Results ---")
print("Are the numbers equal? ", Num1 == Num2)
print("Is the first number greater? ", Num1 > Num2)
print("Is the second number less than or equal to the first? ", Num2 <= Num1)

#Logical Example
print("\n--- Logical Check ---")
if Num1 > 0 and Num2 > 0:
        print("Both numbers are positive.")
elif Num1 < 0 or Num2 < 0:
        print("At least one of the numbers is negative.")
else:
        print("The numbers include 0.")