using System;
using System.Collections.Generic;
using System.Text;

namespace LM.JazSharp.Examples.App
{
    class Adder
    {
        private readonly OperationHistory _operationHistory;
        public Adder(OperationHistory existingHistory = null)
        {
            _operationHistory = existingHistory ?? new OperationHistory();
        }

        public decimal Add(decimal n1, decimal n2)
        {
            _operationHistory.Append($"{n1} + {n2}");

            return n1 + n2;
        }
    }
}
