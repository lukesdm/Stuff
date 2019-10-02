using System.Collections.Generic;

namespace LM.JazSharp.Examples.App
{
    internal class OperationHistory : IOperationHistory
    {
        List<string> _history = new List<string>();
        public void Append(string operation)
        {
            _history.Add(operation);
        }
    }
}