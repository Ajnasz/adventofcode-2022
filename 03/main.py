#!/usr/bin/env python3

import math

def find_dup(compartments):
  for i in compartments[0]:
    for j in compartments[1]:
      if j == i:
        return i
  return None

def get_compartments(line):
  mid = math.ceil(len(line) / 2)
  return (line[:mid], line[mid:])

def get_priority_of(char, diff):
  return ord(char) - diff

lower_diff = ord('a') - 1
def get_lower_priority(char):
  return get_priority_of(char, lower_diff)

upper_diff = ord('A') - 27
def get_upper_priority(char):
  return get_priority_of(char, upper_diff)


def get_priority(char):
  if char.lower() == char:
    return get_lower_priority(char)

  return get_upper_priority(char)

with open('input') as f:
  out = 0
  for line in f:
    dup = find_dup(get_compartments(line.strip()))
    out += get_priority(dup)

  print(out)
