using JazSharp;
using JazSharp.Spies;
using LM.JazSharp.Examples.App;
using System;
using System.Collections.Generic;
using System.Text;

namespace LM.JazSharp.Examples.Test
{
    class AdderSpec : Spec
    {
        public AdderSpec()
        {
            Describe<Adder>(() =>
            {
                It("can add a positive number to a negative number", () => 
                {
                    var adder = new Adder();
                    Expect(adder.Add(-1, 1)).ToEqual(0M);
                });
            });

            Describe<Adder>(() =>
            {
                List<decimal[]> specs = new List<decimal[]>
                {        // n1, n2, expected 
                    new[] {-7M, 3M, -4M },
                    new[] { 0M, 0M, 0M},
                    new[] { 999999999M, 1M, 1000000000M }
                };

                foreach (var spec in specs)
                {
                    It($"can add 2 numbers ({spec[0]}, {spec[1]})", () => 
                    {
                        var adder = new Adder();
                        Expect(adder.Add(spec[0], spec[1])).ToEqual(spec[2]);
                    });
                }
            });

            Describe<Adder>(() =>
            {
                It("appends to history", () =>
                {
                    OperationHistory history = new OperationHistory();
                    Spy historySpy = Jaz.SpyOn(history, nameof(history.Append));
                    var adder = new Adder(history);

                    adder.Add(-1, 1);

                    Expect(historySpy).ToHaveBeenCalled();
                });
            });

            Describe<Adder>(() =>
            {
                Describe(nameof(Adder.Add), () =>
                {
                    It("can add a positive number to a negative number", () =>
                    {
                        var adder = new Adder();
                        Expect(adder.Add(-1, 1)).ToEqual(0M);
                    });
                });
            });
        }
    }
}
