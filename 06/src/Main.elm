module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--


import Debug
import Browser
import Html exposing (Html, button, div, ul, li, text, span, textarea)
import Html.Events exposing (onInput)
import Html.Attributes exposing (..)



-- MAIN

main : Program () Model Msg
main = Browser.sandbox { init = init, view = view, update = update }



-- MODEL

type alias Model = String
input : Model
input = "sgrrrrwcrrlqqgppfgfnngsgcgngrrllnqnndzzjgzzzjdjqdjdhhjshjhwwqnnwjnwnjwjttvgvddjrrtvtsvtvqtqhhbchcdhhnwwvqvvsbsqswqqdwdjwwjvvrddgpdpdlpljjwffqnffbllplmmwzwtzzvfzvvjbbmnmppzgzszllsqqpvqvmmzzlccjhchdhlddchdchcddnwdwhhhczzldlsdlssdmmswswzwtwzwjzwzfwwdhwdwjdjldjldlqddhttfbfnbfnfgnfnvnffsszjjsqqdzdsdrsswddggstgsgqgzqgqcqdccqcvcpcspccdgccfflppddqfdfmdffmlflplnppfvvgsgbgtgccmfccfwwthhcjcbbhbwbjbhjjtddrldlrddzjdzdttbfbmmtjmjtjzjvjvgvttthwhhgqhggcbbtqbbqgbqqvccdttfgfwfnwffbfqbfbbnlnzlzbbwnwntwtjwjnjwwsdwwcbbwhwzwhwvhhpwwnvvtvnttgtrrnjjzppmbmfmjffdddvfvjjpfpgpzzwqwpwllwjjzmjmdmdwwdrdttpmmdhdndvvpbpqbbzqzmmtdmmtddlccjvjsjrsscqqzvvbsstccvffcttwrwjjsgsttmgmvvzbbcjbjrbrddvjjnhjhphvhsszqqfrfzfssgfssgddcbbplbbsfsmfmpphssmvvcvrrcgrcgcvggrzggzjjfhjjtpphzppqtptllssbmbrrgrvvhjjnznlnggrnrsnrrphhbqhhhsthsthhhnssmsjjwjppqfqlqqgnnhnmmfsfslfllvnnsdnssgngbbjmjccsrrmjjnljlwlttpffddgbdggmbgbtbzzwgwppczcffvccnssbmmjrrfwwhcwhwqwnqqzsqqjsqqnndqdgqdqgggzjjcvvzdddhnhjnnzlnlwlzlqqvjjpprqrjrfjjrpjjnfntffqtttnjjdbjbdjbbrsrbbmrmccpllmccqrqwqnnsjjmjgjqjpqjqgjjtwwqdqmqtqqmsqmmvlldtllbcctfcccdcddcggmmmsggjddcqddbqqdgqgffststgtftbbdrbrlllnvllcflfpfdffjvvvmdmvvtfvfcvvfgghzzlgzgszzhmzzhfhllgblggfpfzfvzvdzzhsspmmjtjhjggfhggnggbtggqqtztqtmqtqddmzmrmdrmdmqqcbqcqzzvczvzfvvsggcgssjnnjqnntwtmwwhzzzhllqvlljsljjfnnjwjnwnffpggqwwvbwwdbbmbvmvlvnnnppqvqqghqgqppnllhjllvlflfpfhfjjhgjgpjpbjjdpdqdpqdpdwpwffqlffrbrjrtrvtvrtvrtrvtvltlrrvjjlttmtffhvfhfnhnlnfnvvltvlvlbbfllfnllndndcdrrnznssvpvhhhmrmlmhhrnhhpggtftddghhqrqddjttbdbqddpsdppwrwhhhgwhhqrhqrqhhqdhqddjpjqqsdsmddnqncqnqwqdwwhghbhffnsffnsszlssntnbbbfhbhwhzhdzhzbhblbzzzbqzbbgtbbcjbjtjptpwwhlwwhhmshhmbbfjbfflnnlmnnzvnnbtnbbvwvvgcggrzrffwmwhmwhwjwpwwzbbvtbtssdhdlhhdppmmcnmcmffnpfffvbfvfhvhjhffzfbzzfdfpdpzzhbzblbbmffvvcmmttdntnmtmztzbbncbctcqtcqqcvcfcwcdcchphfhjhhjbjnjtjnjwwzsstpprnnhtntvtpthpttpdpzzwcczsscqscsbbmpbbdsdlsslzszjszsczntrqjmmmfqsdwtqqflgsttwfqqvvspnlfvqlrvvbjmmpmttcdnhncmmdfhwwqdrqjqwggrbtgbrdmmrhhvqfvvhsmtfbnthrbltgvdrsbqglgjqtssbvmbjjjbbcgfftgbjmfqzggdtcfzddqlrvwqjjvnmjzjwqrwsqbjgnswpnlbdzdlcvcbqplzgqwmsntzzjhqwfjdprglcccnldfqftgttqbrmclsqtncrjbttcglcvspsgvdjqgrdzzlnhbfqbwnfqcjrrqpprjbqpzhthgsgcflqldsnwsvzgcmfrdvfmqhbcfczhschpwnmdjnjlvrwqllnnhjvjtzhcrqcwlmrqfdhvzcbnvwrgngttwlhcmmgtzwjztscjnmslbvtdrvgdprlfrhggcwtwjhblppfbpljbmwrlwqrfwjwfsftmflsdfrhlvgcbzcvhlhgclvnmtfcqttvcphgvflhdclbmtgsrldgfvtpjcphtzdctrcchwdbdbtpptdnbjnqwdrllmnbcgfltmggpqfbfpmnhcmpgsgptflglzswtmrjfzmwmwphfjngnfmmtqlrsltlvlfmwmjvvtgngllszwzdjjmbnwwgzpqltlrzfdwchgttvlhgjjhjqmlrrwsqlhsgzsgmmsgbgvrlmbprrhlgsjnsdwcbrwvqjqmfcqcwllsvggcznwpzvgpszrqwngcnchvdlrdrgtbsjdqfpsfvwdtdlqwbfjlwrmqbrhwqmfgppwvfbgthnbqnmqqhmpfwbgljcmqqbpnwvztrcrlbvtcnncwwjcbqsmbqnqtrmpwmhlvwtfmsmtpfnmphqdvqfzvmjjhnwdfjnwvmbbwvthhwzjtzzrsmqlqtnnrqjrnchqttgsptfpdcpgfmzvqhwffqmfhwqqbdhmgcrfqtwrcgtgmglmmwhvqwvglfsvwbpvhmnbqhgfgqwwnhdhvnwggsmhjfsjmsrlcvlnhrhrlhbvhdrhbplrzspdmbcnzbwlvcmztwvghlsnzmbnrpssrngpdtmgzfcbqmfdgthcscjspspmcgdmwwwfspgjwzccrfzdpbwrfpgpgzrchffmhvwwppbjwqmdzgtpfmcblzqrghzdbzqzvbnmqbdlzjrwbbhqgtdzntgdbndmndhlnhcvqtlfcrfprfrlfglwvdnszrwjdcmtstcsnvnpcldctvqpcfhjnpvscscrtfqfjcrjlrmcqjfthptbqprbvchjlqzmfcmlhmfmdhhpcqbncmcqjsdmzflwtzfdcgmrbwbcdgjmfhlshsbwmbdcbfbvmqcgwlqpprjfrhzvsjmcjdfnwhcffhtnqpznfzpttsqqwcsvpdhdfbggzpngvbvdlpmvfjjlcfmbvmfqsczprtlnwvqnnlcrdnvpmcbrzvlfgscbcwtrbcpdnpshhmrqmhnwcndptljhwpvtcflqgmzjsfmfdzwwwhnbpzjwzgqmdcdbtfhwtgvcscbdqlcmppwjgghvrmqpwfbnjfhfcrccfzjvtjsjcsmhncdjlclvhfsvlcjcnpbqqqdjmjdbggmfwswvdjscvgrdbpcrcqtndswgdnznzpwtcdgvcrrqpdcpbmbdjrsgnfvgwpgpzttfmsczcmjvhmdpbpmjjcjsvbvbwjpwtwpsdddlsnvrshqvmwsjwwvqnczzljjfptcszgpndgczprbvjbnqpwgzmnlhvbsfbtjnwbtlzqgnmzbmqgqvwzltvqczfpdzfzsfhqlmtfcbfdqtnwzbvqblqmzvmnspntqtqdglrdmdntrghwvpfrbjgpzvrnppvnvfgwdzlvhtcscclbtftlvsprwhjvjlhrhfdgzbfbfphzbhtfdlpzcshhfzhtdvggnnbqvnrwvnhvgjgjpcrztqjmtzlzlrlmndfvctzjdpnmlgmsppqdrzmptvrsptvmmbvbwvhwptrtlfdqdqwfgldtbhqdhszcmwqnhswrdhgmgvbvbhwhlpcflsrwlvsvhvctmwwhtlgmshdqflwsdjbbzgbvbwpfncgqjzfjvmzzhgdzjvghtrtsmwgzpdrngwdbtfzrqsgdmwtdhsftfqcnmjtrqqwthcbgtmqnjvjzzplrzllnjqddvbwnglhtzljwjvscdfdnsvmrgwhjrhlrqpqgmzstnwwjpddhdbsnnsqvtsdhtmfdmbcpzwqmbhhjhcfzbvvglhfdltrmbstjhsqrbs"

init : Model
init = input

fromBool : Bool -> String
fromBool ok = if ok then "True" else "False"

headChar : String -> String
headChar str = (String.slice 0 1 str)

tailChar : String -> String
tailChar str = (String.slice 1 (String.length str) str)

hasDoubleFirstChar : String -> Bool
hasDoubleFirstChar str = String.contains (headChar str) (tailChar str)

add : Int -> Int -> Int
add a b = a + b

addOne : Int -> Int
addOne a = a |> add 1

sub : Int -> Int -> Int
sub b a = a - b

subFrom : Int -> Int -> Int
subFrom a b = a - b

hasRepeatingChar : String -> Bool
hasRepeatingChar str =
  if (String.length str) < 2 then False
  else if (hasDoubleFirstChar str) then True
  else hasRepeatingChar (tailChar str)

findNonRepeatIndex : Int -> Int -> String -> Int
findNonRepeatIndex idx window str =
  if ((String.length str |> sub idx) < window) then -1
  else if String.slice idx (add window idx) str
    |> hasRepeatingChar
    |> not then idx
  else findNonRepeatIndex (addOne idx) window str


findNonRepeatIndexIn4 : String -> Int
findNonRepeatIndexIn4 = findNonRepeatIndex 0 4

findFinalAnswer : Int -> String -> Int
findFinalAnswer window str = findNonRepeatIndex 0 window str |> formatAnswer window

formatAnswer : Int -> Int -> Int
formatAnswer window index = if index == -1 then -1 else add window index

type Msg = SetInput Model
update : Msg -> Model -> Model
update msg model = case msg of SetInput m -> m

view : Model -> Html Msg
view model = div [] [
  ul [] [
    li [] [
      text (findNonRepeatIndexIn4 "abcd" |> String.fromInt),
      span [] [ text " == 0" ]
      ],
    li [] [
      text (findNonRepeatIndexIn4 "aabcd" |> String.fromInt),
      span [] [ text " == 1" ]
      ],
    li [] [
      text (findNonRepeatIndexIn4 "ababcd" |> String.fromInt),
      span [] [ text " == 2" ]
      ],
    li [] [
      text (findNonRepeatIndexIn4 "abababcd" |> String.fromInt),
      span [] [ text " == 4" ]
      ],
    li [] [
      text (findNonRepeatIndexIn4 "mjqjpqmgbljsphdztnvjfqwrcgsmlb" |> String.fromInt),
      span [] [ text " == 3" ]
      ],
    li [] [
      text (findNonRepeatIndexIn4 "bvwbjplbgvbhsrlpgdmjqwftvncz" |> String.fromInt),
      span [] [ text " == 1" ]
      ],
    li [] [
      text (findNonRepeatIndexIn4 "nppdvjthqldpwncqszvftbrmjlhg" |> String.fromInt),
      span [] [ text " == 2 (6-4)" ]
      ],
    li [] [
      text (findNonRepeatIndexIn4 "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg" |> String.fromInt),
      span [] [ text " == 6 (10-4)" ]
      ],
    li [] [
      text (findNonRepeatIndexIn4 "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw" |> String.fromInt),
      span [] [ text " == 7 (11-4)" ]
      ],
    li [] [
      text (findFinalAnswer 14 "mjqjpqmgbljsphdztnvjfqwrcgsmlb" |> String.fromInt),
      span [] [ text " == 19" ]
      ],
    li [] [
      text (findFinalAnswer 14 "bvwbjplbgvbhsrlpgdmjqwftvncz" |> String.fromInt),
      span [] [ text " == 23" ]
      ],
    li [] [
      text (findFinalAnswer 14 "nppdvjthqldpwncqszvftbrmjlhg" |> String.fromInt),
      span [] [ text " == 23" ]
      ],
    li [] [
      text (findFinalAnswer 14 "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg" |> String.fromInt),
      span [] [ text " == 29" ]
      ],
    li [] [
      text (findFinalAnswer 14 "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw" |> String.fromInt),
      span [] [ text " == 26" ]
      ],
    li [] [
      text (findFinalAnswer 4 model |> String.fromInt),
      span [] [ text " == 1855" ]
      ],
    li [] [
      text (findFinalAnswer 14 model |> String.fromInt),
      span [] [ text " == 3256" ]
      ]
    ],
    textarea [
      cols 80,
      rows 10,
      onInput SetInput
      ] [ text model ]
  ]
