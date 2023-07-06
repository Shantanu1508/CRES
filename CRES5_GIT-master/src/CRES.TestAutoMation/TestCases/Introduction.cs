using NUnit.Framework;
using System;

namespace CRES.TestAutoMation.TestCases
{

    class Introduction
    {
        [Test]
        public void add()
        {
            // addition of integer values
            int x = 10;
            int y = 20;
            int sum;

            sum = x + y;

            Console.WriteLine("sum of two integers =" + sum);

            // Addition of string

            string string1 = "Wonderfull";
            string gap = " ";
            string string2 = "day";
            string stringSum;
            stringSum = string1 + gap + string2;

            Console.WriteLine("sum of two strings = " + stringSum);


        }

    }
}
