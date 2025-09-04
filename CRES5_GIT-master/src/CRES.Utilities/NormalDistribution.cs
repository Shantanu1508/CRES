using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.Utilities
{
    public static class NormalDistribution
    {
         
        // Evaluation of the bell or Gauss curve.
        public static double NormalDist(double x, double mean, double standard_dev)
        {
            double fact = standard_dev * Math.Sqrt(2.0 * Math.PI);
            double expo = (x - mean) * (x - mean) / (2.0 * standard_dev * standard_dev);
            return Math.Exp(-expo) / fact;
        }
        // Simulation of Excel's NORMDIST function, I guess not as it is done there
        public static double NORMDIST(double x, double mean, double standard_dev, bool cumulative)
        {
            const double parts = 50000.0; //large enough to make the trapzoids small enough
            double lowBound = 0.0;
            if (cumulative) //do integration: trapezoidal rule used here
            {
                double width = (x - lowBound) / (parts - 1.0);
                double integral = 0.0;
                for (int i = 1; i < parts - 1; i++)
                {
                    integral += 0.5 * width * (NormalDist(lowBound + width * i, mean, standard_dev) +
                        (NormalDist(lowBound + width * (i + 1), mean, standard_dev)));
                }
                return integral;
            }
            else //return function value
            {
                return NormalDist(x, mean, standard_dev);
            }
        }
    }
}
