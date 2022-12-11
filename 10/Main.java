import java.io.File;  // Import the File class
import java.io.FileNotFoundException;  // Import this class to handle errors
import java.util.Scanner; // Import the Scanner class to read text files
import java.util.*;

class Operation {
  public String type;
  public int value;

  Operation(String t, int v) {
    type = t;
    value = v;
  }

  public String toString() {
    String strValue = Integer.toString(value);
    return "type: " + type + ", " + strValue;
  }
}

interface Op {
  public boolean isDone();
  public int exec(int register);
}

class Noop implements Op {
  private int cycles;

  public int exec(int register) {
    cycles -= 1;
    return register;
  }

  public boolean isDone() {
    return cycles == 0;
  }

  Noop() {
    cycles = 1;
  }
}

class AddX implements Op {
  private int cycles;
  private int addxValue;

  public int exec(int register) {
    cycles -= 1;

    if (isDone()) {
      return register + addxValue;
    }

    return register;
  }

  public boolean isDone() {
    return cycles == 0;
  }

  AddX(int xval) {
    addxValue = xval;
    cycles = 2;
  }
}

class Inspect {
  private int cycleCount;
  private int register;
  private int opIndex;
  private int sum;
  Inspect() {
    sum = 0;
  }

  public void setCycle(int cc, int r, int oi) {
    cycleCount = cc;
    register = r;
    opIndex = oi;
  }
  public void inspect() {
    if (cycleCount == 20 || (cycleCount - 20) % 40 == 0) {
      sum += cycleCount * register;
      System.out.println("cycleCount: " + Integer.toString(cycleCount) + " : register: " + Integer.toString(register) + " : opindex: " + Integer.toString(opIndex) + " : cycle value: " + Integer.toString(cycleCount * register) + " : sum : " + Integer.toString(sum));
    }
  }
}

class GPU {
  private void debug(int cycleCount, int register) {
    System.out.print(cycleCount);
    System.out.print(" ");
    System.out.print(register);
    System.out.print(" ");
    System.out.print(cycleCount == register || cycleCount == register + 1 || cycleCount == register - 1);
    System.out.print(" ");
    System.out.print(register % 40);
    System.out.println();
  }

  private void print(int cycleCount, int register) {
    if (cycleCount == 0) {
      System.out.println();
    }

    if (cycleCount == register || cycleCount == register + 1 || cycleCount == register - 1) {
      System.out.print('#');
    } else {
      System.out.print('.');
    }
  }

  void cycle(int cycleCount, int register) {
    print((cycleCount - 1) % 40, register);
  }
}

class CPU {
  private int register;
  private int cycleCount;
  private Op operation;
  private int opIndex;

  private ArrayList<Operation> operations;

  CPU() {
    operations = new ArrayList<Operation>();
    register = 1;
    cycleCount = 1;
  }

  public void addOperation(String op) {
    String[] parts = op.split(" ");
    int addValue = 0;

    if (parts.length > 1) {
      addValue = Integer.parseInt(parts[1]);
    }

    Operation operation = new Operation(parts[0], addValue);
    operations.add(operation);
  }

  Op getOp(int index) {
    Operation op = operations.get(index);

    if (op.type.equals("addx")) {
      return new AddX(op.value);
    }
    return new Noop();
  }

  public void cycle() {
    Inspect inspector = new Inspect(); GPU gpu = new GPU();
    int cycleCount = 1;

    int sum = 0;
    int opIndex = 0;

    while(true) {
      if (operation == null) {
        operation = getOp(opIndex);
      }

      // inspector.setCycle(cycleCount, register, opIndex);

      // inspector.inspect();

      gpu.cycle(cycleCount, register);
      register = operation.exec(register);

      if (operation.isDone()) {
        operation = null;
        opIndex += 1;
        if (opIndex >= operations.size()) {
          return;
        }
      }

      cycleCount += 1;
    }
  }
}

class Main {
  public static void main(String[] args) {
    CPU cpu = new CPU();

    try {
      File myObj = new File("input");
      Scanner myReader = new Scanner(myObj);
      while (myReader.hasNextLine()) {
        String data = myReader.nextLine();
        if (data.length() > 0) {
          cpu.addOperation(data);
        }
      }
      myReader.close();
    } catch (FileNotFoundException e) {
      System.out.println("An error occurred.");
      e.printStackTrace();
    }

    System.out.println("START");
    cpu.cycle();
    System.out.println();
  }
}
