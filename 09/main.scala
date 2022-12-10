import scala.io.Source

case class MoveCommand(direction: String, steps: Int);

case class Coordinates(x: Int, y: Int)

class Knot(var x: Int, var y: Int) {
  def moveTo(cmd: MoveCommand) = cmd.direction match {
      case "R" => x = x + 1
      case "L" => x = x - 1
      case "U" => y = y - 1
      case "D" => y = y + 1
  }
// }

// case class Tail(x: Int, y: Int) extends Position {
  private def shouldFollow(head: Knot): Boolean = {
    (head.x - x).abs > 1 || (head.y - y).abs > 1
  }

  private def getCoord(headCoord: Int, myCoord: Int): Int = {
    val diff = headCoord - myCoord

    if (diff == 0) return 0

    val isNegative = diff < 0

    if (isNegative) {
      -1
    } else {
      1
    }
  }

  def getNewCoordintes(head: Knot): (Int, Int) = (x + getCoord(head.x, x), y + getCoord(head.y, y))

  def follow(head: Knot) = {
    if (shouldFollow(head)) {
      val (newX, newY) = getNewCoordintes(head)
      x = newX
      y = newY
    }
    this
  }

  def coords(): Coordinates = Coordinates(x, y)
}

object Main {
  def findKnot(x: Int, y: Int, knots: List[Knot]): Int = {
    var i = 0
    for (knot <- knots) {
      if (knot.coords() == Coordinates(x, y)) {
        return i
      }
      i += 1
    }

    return -1
  }

  def atoList(input: Set[Coordinates]): List[Knot] = {
    var out: List[Knot] = List[Knot]()
    for (i <- input) {
      out = out :+ new Knot(i.x, i.y)
    }

    return out
  }

  def visualize(knots: List[Knot]) {
    val change = -20
    Thread.sleep(20)
    print("\u001b[2J")
    for (y <- 0 until 48) {
      for (x <- 0 until 86) {
        val idx = findKnot(x + change, y + change, knots)
        if (idx != -1) {
          val k = knots(idx)
          if (idx == 0) {
            printf("H", k.x, k.y)
          } else {
            printf("%d", idx)
          }
        } else {
          if (x + change == 0 && y + change == 0) {
            printf("s")
          } else {
            printf(".")
          }
        }
      }
      println()
    }
    println()
  }

  def main(args: Array[String]): Unit = {
    val line = Source.fromFile("input").getLines.toList
    val moves = line.map(line => MoveCommand(
      line.substring(0, line.indexOf(" ")),
      line.substring(line.indexOf(" ") + 1).toInt)
    );

    var knotLen = 10
    var knots: List[Knot] = List()
    for (_ <- 0 until knotLen) {
      knots = knots :+ new Knot(0, 0)
    }

    var visited: Set[Coordinates] = Set[Coordinates]()
    moves.foreach(move => {
      for (_ <- 0 until move.steps) {
        var newnots: List[Knot] = List()
        val head = knots(0)
        head.moveTo(move)
        // visited += head.coords()

        for (i <- 1 until knotLen) {
          val tail = knots(i)
          tail.follow(knots(i - 1))
          visited += knots(knotLen - 1).coords()
        }
        // visualize(knots)
      }
    })

    // visualize(atoList(visited))
    println()
    println(visited.size)
  }
}
