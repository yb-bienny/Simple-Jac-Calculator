import from python {math};
import from byllm {Model}

 glob llm = Model(model_name="gemini/gemini-2.0-flash");


"""Calculator Node - stores operation and operands"""
node Calculator {
    has operation: str = "";
    has num1: float = 0.0;
    has num2: float = 0.0;
    has result: float = 0.0;
}

"""Result Node - stores the final calculation result"""
node Result {
    has value: float = 0.0;
    has operation_performed: str = "";
}

"""Edge to connect Calculator to Result"""
edge calculates;

"""Walker to perform calculator operations"""
walker CalculatorWalker {
    has operation: str;
    has num1: float;
    has num2: float;
    
    can perform_calculation with Calculator entry {
        here.operation = self.operation;
        here.num1 = self.num1;
        here.num2 = self.num2;
        
        if self.operation == "add" {
            here.result = self.num1 + self.num2;
        } elif self.operation == "subtract" {
            here.result = self.num1 - self.num2;
        } elif self.operation == "multiply" {
            here.result = self.num1 * self.num2;
        } elif self.operation == "divide" {
            if self.num2 != 0.0 {
                here.result = self.num1 / self.num2;
            } else {
                here.result = 0.0;
                report "Error: Division by zero";
                return;
            }
        } elif self.operation == "power" {
            here.result = math.pow(self.num1, self.num2);
        } elif self.operation == "modulo" {
            if self.num2 != 0.0 {
                here.result = self.num1 % self.num2;
            } else {
                here.result = 0.0;
                report "Error: Modulo by zero";
                return;
            }
        } else {
            report "Error: Invalid operation";
            return;
        }
        
        visit [-->];
    }
    
    can store_result with Result entry {
        here.value = spawn here <-[calculates]- Calculator[0].result;
        here.operation_performed = spawn here <-[calculates]- Calculator[0].operation;
        report {
            "operation": here.operation_performed,
            "num1": spawn here <-[calculates]- Calculator[0].num1,
            "num2": spawn here <-[calculates]- Calculator[0].num2,
            "result": here.value
        };
    }
}

"""Walker to use LLM for natural language calculator input"""
walker LLMCalculatorWalker {
    has user_input: str;
    
    can process_input with Calculator entry by llm(incl_info=(here,), method="Reason", temperature=0.7)
    
    can perform_calculation with Calculator entry {
        parsed = self.process_input();
        
        here.operation = parsed["operation"];
        here.num1 = parsed["num1"];
        here.num2 = parsed["num2"];
        
        if here.operation == "add" {
            here.result = here.num1 + here.num2;
        } elif here.operation == "subtract" {
            here.result = here.num1 - here.num2;
        } elif here.operation == "multiply" {
            here.result = here.num1 * here.num2;
        } elif here.operation == "divide" {
            if here.num2 != 0.0 {
                here.result = here.num1 / here.num2;
            } else {
                here.result = 0.0;
                report "Error: Division by zero";
                return;
            }
        } elif here.operation == "power" {
            here.result = math.pow(here.num1, here.num2);
        } elif here.operation == "modulo" {
            if here.num2 != 0.0 {
                here.result = here.num1 % here.num2;
            } else {
                here.result = 0.0;
                report "Error: Modulo by zero";
                return;
            }
        } else {
            report "Error: Invalid operation";
            return;
        }
        
        visit [-->];
    }
    
    can store_result with Result entry {
        here.value = spawn here <-[calculates]- Calculator[0].result;
        here.operation_performed = spawn here <-[calculates]- Calculator[0].operation;
        report {
            "operation": here.operation_performed,
            "num1": spawn here <-[calculates]- Calculator[0].num1,
            "num2": spawn here <-[calculates]- Calculator[0].num2,
            "result": here.value
        };
    }
}

"""Main walker to initialize and run the calculator"""
with entry {
    # Create calculator graph
    calc_node = Calculator();
    result_node = Result();
    calc_node ++> result_node by calculates;
    
    # Example 1: Direct calculation
    root spawn CalculatorWalker(
        operation="add",
        num1=10.5,
        num2=5.3
    ) spawn calc_node;
    
    # Example 2: Using LLM for natural language input
    root spawn LLMCalculatorWalker(
        user_input="What is 25 multiplied by 4?"
    ) spawn calc_node;
}