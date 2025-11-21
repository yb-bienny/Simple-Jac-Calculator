# Simple-Jac-Calculator
Simple Calculator using Jac

# Simple Calculator - Jac Programming Language

A calculator built with Jac demonstrating nodes, walkers, edges, and LLM integration.

## Key Features
- **6 Operations**: add, subtract, multiply, divide, power, modulo
- 
- **Graph Architecture**: Calculator and Result nodes connected by edges
- 
- **2 Walkers**: Direct calculation & LLM natural language processing
- 
- **Error Handling**: Division/modulo by zero protection

## Quick Start

**Install:**
```bash

pip install jaclang
```

**Set API Key (for LLM features):**
```bash

export GEMINI_API_KEY='sk-your-api-key-here'
```

**Run:**
```bash

jac run calculator.jac
```

## Usage Examples

**Direct Calculation:**
```jac

root spawn CalculatorWalker(

    operation="add",

    num1=10.5,

    num2=5.3

) spawn calc_node;
```

**Natural Language (LLM):**
```jac

root spawn LLMCalculatorWalker(

    user_input="What is 25 multiplied by 4?"

) spawn calc_node;
```

## Architecture
- **Nodes**: Calculator (stores operation/numbers), Result (stores output)
- 
- **Edge**: `calculates` (connects Calculator → Result)
- 
- **Walkers**: Traverse graph and perform calculations

## Output Format
```json

{
    "operation": "add",
    "num1": 10.5,
    "num2": 5.3,
    "result": 15.8
}
```

## Troubleshooting
- **No jac command**: Run `pip install jaclang`
- 
- **LLM not working**: Check API key with `echo $GEMINI_API_KEY`
- 
- **Errors**: Verify installation with `jac --version`

---
**Note**: Keep API keys secure. Never commit `.env` files to version control.
