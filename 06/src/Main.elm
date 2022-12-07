module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--


import Debug
import Browser
import Html exposing (Html, button, div, text, span, textarea)
import Html.Events exposing (onInput)



-- MAIN

main = Browser.sandbox { init = init, view = view, update = update }



-- MODEL

input : String
input = "nppdvjthqldpwncqszvftbrmjlhg"

output : String
output = "baca"

init : String
init = "none"

fromBool : Bool -> String
fromBool ok = if ok then "True" else "False"

headChar : String -> String
headChar str = (String.slice 0 1 str)

tailChar : String -> String
tailChar str = (String.slice 1 (String.length str) str)

hasDoubleFirstChar : String -> Bool
hasDoubleFirstChar str = (String.contains (headChar str) (tailChar str))

add : Int -> Int -> Int
add a b = a + b

addOne : Int -> Int
addOne a = a + 1

sub : Int -> Int -> Int
sub a b = a - b

hasRepeatingChar : String -> Bool
hasRepeatingChar str =
  if (String.length str) < 2 then False
  else if (hasDoubleFirstChar str) then True
  else hasRepeatingChar (tailChar str)

findNonRepeatIndex : Int -> Int -> String -> Int
findNonRepeatIndex idx window str =
  if (sub (String.length str) idx) < 2 then -1
  else if not (hasRepeatingChar (String.slice idx (add window idx) str)) then idx
  else findNonRepeatIndex (addOne idx) window str


findNonRepeatIndexIn4 : String -> Int
findNonRepeatIndexIn4 = findNonRepeatIndex 0 4

findFinalAnswer : String -> Int
findFinalAnswer str = add (findNonRepeatIndexIn4 str) 4

update : msg -> String -> String
update msg inp = "asdf"

view : String -> Html msg

view num = div [] [
  div [] [
    text (String.fromInt (findNonRepeatIndexIn4 "abcd")),
    span [] [ text " == 0" ]
    ],
  div [] [
    text (String.fromInt (findNonRepeatIndexIn4 "aabcd")),
    span [] [ text " == 1" ]
    ],
  div [] [
    text (String.fromInt (findNonRepeatIndexIn4 "ababcd")),
    span [] [ text " == 2" ]
    ],
  div [] [
    text (String.fromInt (findNonRepeatIndexIn4 "abababcd")),
    span [] [ text " == 4" ]
    ],
  div [] [
    text (String.fromInt (findNonRepeatIndexIn4 "mjqjpqmgbljsphdztnvjfqwrcgsmlb")),
    span [] [ text " == 3" ]
    ],
  div [] [
    text (String.fromInt (findNonRepeatIndexIn4 "bvwbjplbgvbhsrlpgdmjqwftvncz")),
    span [] [ text " == 1" ]
    ],
  div [] [
    text (String.fromInt (findNonRepeatIndexIn4 "nppdvjthqldpwncqszvftbrmjlhg")),
    span [] [ text " == 2 (6-4)" ]
    ],
  div [] [
    text (String.fromInt (findNonRepeatIndexIn4 "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")),
    span [] [ text " == 6 (10-4)" ]
    ],
  div [] [
    text (String.fromInt (findNonRepeatIndexIn4 "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")),
    span [] [ text " == 7 (11-4)" ]
    ],
  div [] [
    text (String.fromInt (findFinalAnswer "sgrrrrwcrrlqqgppfgfnngsgcgngrrllnqnndzzjgzzzjdjqdjdhhjshjhwwqnnwjnwnjwjttvgvddjrrtvtsvtvqtqhhbchcdhhnwwvqvvsbsqswqqdwdjwwjvvrddgpdpdlpljjwffqnffbllplmmwzwtzzvfzvvjbbmnmppzgzszllsqqpvqvmmzzlccjhchdhlddchdchcddnwdwhhhczzldlsdlssdmmswswzwtwzwjzwzfwwdhwdwjdjldjldlqddhttfbfnbfnfgnfnvnffsszjjsqqdzdsdrsswddggstgsgqgzqgqcqdccqcvcpcspccdgccfflppddqfdfmdffmlflplnppfvvgsgbgtgccmfccfwwthhcjcbbhbwbjbhjjtddrldlrddzjdzdttbfbmmtjmjtjzjvjvgvttthwhhgqhggcbbtqbbqgbqqvccdttfgfwfnwffbfqbfbbnlnzlzbbwnwntwtjwjnjwwsdwwcbbwhwzwhwvhhpwwnvvtvnttgtrrnjjzppmbmfmjffdddvfvjjpfpgpzzwqwpwllwjjzmjmdmdwwdrdttpmmdhdndvvpbpqbbzqzmmtdmmtddlccjvjsjrsscqqzvvbsstccvffcttwrwjjsgsttmgmvvzbbcjbjrbrddvjjnhjhphvhsszqqfrfzfssgfssgddcbbplbbsfsmfmpphssmvvcvrrcgrcgcvggrzggzjjfhjjtpphzppqtptllssbmbrrgrvvhjjnznlnggrnrsnrrphhbqhhhsthsthhhnssmsjjwjppqfqlqqgnnhnmmfsfslfllvnnsdnssgngbbjmjccsrrmjjnljlwlttpffddgbdggmbgbtbzzwgwppczcffvccnssbmmjrrfwwhcwhwqwnqqzsqqjsqqnndqdgqdqgggzjjcvvzdddhnhjnnzlnlwlzlqqvjjpprqrjrfjjrpjjnfntffqtttnjjdbjbdjbbrsrbbmrmccpllmccqrqwqnnsjjmjgjqjpqjqgjjtwwqdqmqtqqmsqmmvlldtllbcctfcccdcddcggmmmsggjddcqddbqqdgqgffststgtftbbdrbrlllnvllcflfpfdffjvvvmdmvvtfvfcvvfgghzzlgzgszzhmzzhfhllgblggfpfzfvzvdzzhsspmmjtjhjggfhggnggbtggqqtztqtmqtqddmzmrmdrmdmqqcbqcqzzvczvzfvvsggcgssjnnjqnntwtmwwhzzzhllqvlljsljjfnnjwjnwnffpggqwwvbwwdbbmbvmvlvnnnppqvqqghqgqppnllhjllvlflfpfhfjjhgjgpjpbjjdpdqdpqdpdwpwffqlffrbrjrtrvtvrtvrtrvtvltlrrvjjlttmtffhvfhfnhnlnfnvvltvlvlbbfllfnllndndcdrrnznssvpvhhhmrmlmhhrnhhpggtftddghhqrqddjttbdbqddpsdppwrwhhhgwhhqrhqrqhhqdhqddjpjqqsdsmddnqncqnqwqdwwhghbhffnsffnsszlssntnbbbfhbhwhzhdzhzbhblbzzzbqzbbgtbbcjbjtjptpwwhlwwhhmshhmbbfjbfflnnlmnnzvnnbtnbbvwvvgcggrzrffwmwhmwhwjwpwwzbbvtbtssdhdlhhdppmmcnmcmffnpfffvbfvfhvhjhffzfbzzfdfpdpzzhbzblbbmffvvcmmttdntnmtmztzbbncbctcqtcqqcvcfcwcdcchphfhjhhjbjnjtjnjwwzsstpprnnhtntvtpthpttpdpzzwcczsscqscsbbmpbbdsdlsslzszjszsczntrqjmmmfqsdwtqqflgsttwfqqvvspnlfvqlrvvbjmmpmttcdnhncmmdfhwwqdrqjqwggrbtgbrdmmrhhvqfvvhsmtfbnthrbltgvdrsbqglgjqtssbvmbjjjbbcgfftgbjmfqzggdtcfzddqlrvwqjjvnmjzjwqrwsqbjgnswpnlbdzdlcvcbqplzgqwmsntzzjhqwfjdprglcccnldfqftgttqbrmclsqtncrjbttcglcvspsgvdjqgrdzzlnhbfqbwnfqcjrrqpprjbqpzhthgsgcflqldsnwsvzgcmfrdvfmqhbcfczhschpwnmdjnjlvrwqllnnhjvjtzhcrqcwlmrqfdhvzcbnvwrgngttwlhcmmgtzwjztscjnmslbvtdrvgdprlfrhggcwtwjhblppfbpljbmwrlwqrfwjwfsftmflsdfrhlvgcbzcvhlhgclvnmtfcqttvcphgvflhdclbmtgsrldgfvtpjcphtzdctrcchwdbdbtpptdnbjnqwdrllmnbcgfltmggpqfbfpmnhcmpgsgptflglzswtmrjfzmwmwphfjngnfmmtqlrsltlvlfmwmjvvtgngllszwzdjjmbnwwgzpqltlrzfdwchgttvlhgjjhjqmlrrwsqlhsgzsgmmsgbgvrlmbprrhlgsjnsdwcbrwvqjqmfcqcwllsvggcznwpzvgpszrqwngcnchvdlrdrgtbsjdqfpsfvwdtdlqwbfjlwrmqbrhwqmfgppwvfbgthnbqnmqqhmpfwbgljcmqqbpnwvztrcrlbvtcnncwwjcbqsmbqnqtrmpwmhlvwtfmsmtpfnmphqdvqfzvmjjhnwdfjnwvmbbwvthhwzjtzzrsmqlqtnnrqjrnchqttgsptfpdcpgfmzvqhwffqmfhwqqbdhmgcrfqtwrcgtgmglmmwhvqwvglfsvwbpvhmnbqhgfgqwwnhdhvnwggsmhjfsjmsrlcvlnhrhrlhbvhdrhbplrzspdmbcnzbwlvcmztwvghlsnzmbnrpssrngpdtmgzfcbqmfdgthcscjspspmcgdmwwwfspgjwzccrfzdpbwrfpgpgzrchffmhvwwppbjwqmdzgtpfmcblzqrghzdbzqzvbnmqbdlzjrwbbhqgtdzntgdbndmndhlnhcvqtlfcrfprfrlfglwvdnszrwjdcmtstcsnvnpcldctvqpcfhjnpvscscrtfqfjcrjlrmcqjfthptbqprbvchjlqzmfcmlhmfmdhhpcqbncmcqjsdmzflwtzfdcgmrbwbcdgjmfhlshsbwmbdcbfbvmqcgwlqpprjfrhzvsjmcjdfnwhcffhtnqpznfzpttsqqwcsvpdhdfbggzpngvbvdlpmvfjjlcfmbvmfqsczprtlnwvqnnlcrdnvpmcbrzvlfgscbcwtrbcpdnpshhmrqmhnwcndptljhwpvtcflqgmzjsfmfdzwwwhnbpzjwzgqmdcdbtfhwtgvcscbdqlcmppwjgghvrmqpwfbnjfhfcrccfzjvtjsjcsmhncdjlclvhfsvlcjcnpbqqqdjmjdbggmfwswvdjscvgrdbpcrcqtndswgdnznzpwtcdgvcrrqpdcpbmbdjrsgnfvgwpgpzttfmsczcmjvhmdpbpmjjcjsvbvbwjpwtwpsdddlsnvrshqvmwsjwwvqnczzljjfptcszgpndgczprbvjbnqpwgzmnlhvbsfbtjnwbtlzqgnmzbmqgqvwzltvqczfpdzfzsfhqlmtfcbfdqtnwzbvqblqmzvmnspntqtqdglrdmdntrghwvpfrbjgpzvrnppvnvfgwdzlvhtcscclbtftlvsprwhjvjlhrhfdgzbfbfphzbhtfdlpzcshhfzhtdvggnnbqvnrwvnhvgjgjpcrztqjmtzlzlrlmndfvctzjdpnmlgmsppqdrzmptvrsptvmmbvbwvhwptrtlfdqdqwfgldtbhqdhszcmwqnhswrdhgmgvbvbhwhlpcflsrwlvsvhvctmwwhtlgmshdqflwsdjbbzgbvbwpfncgqjzfjvmzzhgdzjvghtrtsmwgzpdrngwdbtfzrqsgdmwtdhsftfqcnmjtrqqwthcbgtmqnjvjzzplrzllnjqddvbwnglhtzljwjvscdfdnsvmrgwhjrhlrqpqgmzstnwwjpddhdbsnnsqvtsdhtmfdmbcpzwqmbhhjhcfzbvvglhfdltrmbstjhsqrbs")),
    span [] [ text " == 7 (11-4)" ]
    ],
  ]
