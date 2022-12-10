import scala.io.Source

case class MoveCommand(direction: String, steps: Int);

abstract class Position {
  val x: Int
  val y: Int
}
case class Head(x: Int, y: Int) extends Position {
  def moveTo(cmd: MoveCommand): Head = cmd.direction match {
      case "R" => Head(x + 1, y)
      case "L" => Head(x - 1, y)
      case "U" => Head(x, y - 1)
      case "D" => Head(x, y + 1)
      case _ => this
  }
}

case class Tail(x: Int, y: Int) extends Position {
  private def shouldFollow(head: Head): Boolean = {
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

  def getNewCoordintes(head: Head): (Int, Int) = {
    (x + getCoord(head.x, x), y + getCoord(head.y, y))
  }

  def follow(head: Head): Tail = {
    if (shouldFollow(head)) {
      val (newX, newY) = getNewCoordintes(head)
      return Tail(newX, newY)
    }
    this
  }
}

object Main {
  def main(args: Array[String]): Unit = {
    // println(Position(0, 1))
    val line = Source.fromFile("input").getLines.toList
    val moves = line.map(line => MoveCommand(
      line.substring(0, line.indexOf(" ")),
      line.substring(line.indexOf(" ") + 1).toInt)
    );

    var head = Head(0, 0)
    var tail = Tail(0, 0)
    var tails: Set[Tail] = Set[Tail](tail)
    moves.foreach(move => {
      for (_ <- 0 until move.steps) {
        head = head.moveTo(move)
        tail = tail.follow(head)
        // println(head, tail)
        tails += tail
      }
    })
    // println(head)
    // println(tail)
    println(tails.size)
  }
}
