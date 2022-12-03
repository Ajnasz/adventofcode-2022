#!/usr/bin/env python3

import math

def find_common_items(line1, line2):
  return ''.join({char for char in line1 if char in line2})

def find_3_commons(lines):
  commons1 = find_common_items(set(lines[0]), set(lines[1]))
  return find_common_items(commons1, set(lines[2]))

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

  group = []
  for line in f:
    group.append(line.strip())

    if len(group) == 3:
      common = find_3_commons(group)
      group = []

      out += get_priority(common)

  print(out)
