package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
	"sync"
)

const SCORE_ROCK = 1
const SCORE_PAPER = 2
const SCORE_SCISSOR = 3
const SCORE_WIN = 6
const SCORE_DRAW = 3
const SCORE_LOOSE = 0

func isRock(i string) bool {
	return i == "A"
}

func isPaper(i string) bool {
	return i == "B"
}

func isScissor(i string) bool {
	return i == "C"
}

func shouldDraw(i string) bool {
	return i == "Y"
}

func shouldWin(i string) bool {
	return i == "Z"
}

func shouldLose(i string) bool {
	return i == "X"
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

func getWinner(i string) string {
	if isRock(i) {
		return "B"
	}

	if isPaper(i) {
		return "C"
	}

	return "A"
}

func getLoser(i string) string {
	if isRock(i) {
		return "C"
	}

	if isPaper(i) {
		return "A"
	}

	return "B"
}

func getScore(other, my string) int {
	if shouldDraw(my) {
		return SCORE_DRAW + getShapeScore(other)
	}

	if shouldWin(my) {
		return SCORE_WIN + getShapeScore(getWinner(other))
	}

	return SCORE_LOOSE + getShapeScore(getLoser(other))
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

	scoreChan := make(chan int)
	var wg sync.WaitGroup
	for fileScanner.Scan() {
		wg.Add(1)
		go func(text string) {
			other, my := getShapes(text)
			scoreChan <- getScore(other, my)
			wg.Done()
		}(fileScanner.Text())
	}

	go func() {
		wg.Wait()
		close(scoreChan)
	}()

	score := 0
	for aScore := range scoreChan {
		score += aScore
	}

	fmt.Println(score)
}
