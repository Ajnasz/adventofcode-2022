import { open } from 'node:fs/promises';

function last<T>(i: T[]): T {
  return i[i.length - 1];
}

function init<T>(i: T[]): T[] {
  return i.slice(0, -1);
}

function head<T>(i: T[]): T {
  return i[0];
}

type Stack = string;
type Stacks = Map<number, Array<Stack>>

type Command = {
  from: number;
  to: number;
  count: number;
}

function getCrateValue(crate: string): Stack {
  const crateValue = crate.slice(1, 2);
  return crateValue;
}

function getStacksLength(indexLine: string): number {
  const x =  indexLine.trim().split(/\s+/);
  return x.length;
}

function getStack(input: string[], index: number): string[] {
  const stack: string[] = [];
  for (const line of input) {
    const start = index * 4;
    stack.push(line.slice(start , start + 3));
  }

  return stack;
}

function getCommnand(line: string): Command {
  const match = line.match(/move (\d+) from (\d+) to (\d+)/);
  if (!match) {
    throw new Error('invalid command line');
  }
  return {count: Number.parseInt(match[1]), from: Number.parseInt(match[2]), to: Number.parseInt(match[3])};
}

function getStacks(input: string[]): string[][] {
  return new Array(getStacksLength(input[input.length - 1])).fill(0).map((_, id) => getStack(input, id));
}

function executeCommand(command: Command, stacks: Stacks): Stacks {
  const from = stacks.get(command.from);
  const to = stacks.get(command.to);

  if (!from) throw new Error('stack not found');
  if (!to) throw new Error('stack not found');

  const grabbed = from.splice(0, command.count);
  stacks.set(command.to, grabbed.reduce((to, item) => {
    return [item].concat(to);
  }, to));
  return stacks;
}

async function main() {
  const file = await open('input');
  const state: string[] = [];
  const commands: string[] = [];
  let stateCollected = false;
  for await (const line of file.readLines()) {
    if (line === '') {
      stateCollected = true;
      continue;
    }

    if (!stateCollected) {
      state.push(line)
    } else {
      commands.push(line);
    }
  }

  const stacks: Stacks = getStacks(state).reduce((out: Stacks, stack) => {
    const index = Number.parseInt(last(stack));
    out.set(index, init(stack).map(getCrateValue).filter((value) => value !== ' '));
    return out
  }, new Map());

  const changedStacks = commands.map(getCommnand).reduce((out, command) => {
    const ret = executeCommand(command, out);
    return ret;
  }, stacks);

  const x = Array.from(changedStacks.entries())
    .reduce((ret: string[], [index, value]) => {
      ret[index - 1] = head(value);
      return ret;
    }, new Array(changedStacks.size));
    console.log(x.join(''));
}

main()
