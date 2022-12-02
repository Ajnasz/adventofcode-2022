package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

const SCORE_ROCK = 1
const SCORE_PAPER = 2
const SCORE_SCISSOR = 3
const SCORE_WIN = 6
const SCORE_DRAW = 3
const SCORE_LOOSE = 0

func isRock(i string) bool {
	return i == "A" || i == "X"
}

func isPaper(i string) bool {
	return i == "B" || i == "Y"
}

func isScissor(i string) bool {
	return i == "C" || i == "Z"
}

func isWin(other, my string) bool {
	if isRock(my) && isScissor(other) {
		return true
	}

	if isPaper(my) && isRock(other) {
		return true
	}

	if isScissor(my) && isPaper(other) {
		return true
	}

	return false
}

func isDraw(other, my string) bool {
	if isRock(my) && isRock(other) {
		return true
	}
	if isPaper(my) && isPaper(other) {
		return true
	}
	if isScissor(my) && isScissor(other) {
		return true
	}

	return false
}

func getShapeScore(shape string) int {
	if isRock(shape) {
		return SCORE_ROCK
	}

	if isPaper(shape) {
		return SCORE_PAPER
	}

	if isScissor(shape) {
		return SCORE_SCISSOR
	}

	return 0
}

func getScore(other, my string) int {
	if isDraw(other, my) {
		return SCORE_DRAW + getShapeScore(my)
	}

	if isWin(other, my) {
		return SCORE_WIN + getShapeScore(my)
	}

	return SCORE_LOOSE + getShapeScore(my)
}

func getShapes(line string) (string, string) {
	split := strings.Split(line, " ")
	return split[0], split[1]
}

func main() {
	readFile, err := os.Open("../input")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	defer readFile.Close()
	fileScanner := bufio.NewScanner(readFile)

	fileScanner.Split(bufio.ScanLines)

	score := 0
	for fileScanner.Scan() {
		other, my := getShapes(fileScanner.Text())
		score += getScore(other, my)
	}

	fmt.Println(score)
}
