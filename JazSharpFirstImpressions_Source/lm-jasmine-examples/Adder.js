class Adder {
    operationHistory;

    constructor(existingHistory) {
        this.operationHistory = existingHistory || new OperationHistory();
    }

    add(n1, n2) {
        this.operationHistory.append(`${n1} + ${n2}`);
        return n1 + n2;
    } 
}

class OperationHistory {
    operations = new Array();
    
    append(operation) {
        this.operations.push(operation);
    }

    count() {
        return this.operations.length;
    }
}