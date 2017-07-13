#!/bin/bash

#Interactive script for addition and multiplication

echo "Enter the first number: "
read num1
echo "Enter the second number: "
read num2
mult = $((num1 * num2))
add = $((num1 + num2))

echo " the multiplication is: " $mult;
echo " the addition is: " $add;
exit 0
