describe('Adder', () => { 
    it('can add a positive number to a negative number', () => {
        const adder = new Adder();
        expect(adder.add(-1,1)).toEqual(0);
    });
});

describe('Adder', () => {
    const specs = [
        // n1, n2, expected
        [-7,3,-4],
        [0,0,0], 
        [999999999, 1, 1000000000]
    ];
    specs.forEach(spec => {
        it(`can add 2 numbers (${spec[0]}, ${spec[1]})`, () => {
            const adder = new Adder();
            expect(adder.add(spec[0],spec[1])).toEqual(spec[2]);
        });
    });
});

describe('Adder', () => {
    it('appends to history', () => {
        const history = new OperationHistory();
        spyOn(history, 'append');
        const adder = new Adder(history);

        adder.add(0,0);

        expect(history.append).toHaveBeenCalled();
    });
});