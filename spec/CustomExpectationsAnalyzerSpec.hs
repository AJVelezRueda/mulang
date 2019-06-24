module CustomExpectationsAnalyzerSpec(spec) where

import           Language.Mulang.Analyzer hiding (result, spec)
import           Test.Hspec

result customExpectationResults smells
  = emptyCompletedAnalysisResult { customExpectationResults = customExpectationResults, smells = smells }

run language content test = analyse (customExpectationsAnalysis (CodeSample language content) test)

passed message = CustomExpectationResult message True
failed message = CustomExpectationResult message False

nok = result [failed "E0"] []
ok = result [passed "E0"] []

spec = describe "ExpectationsAnalyzer" $ do
  it "evaluates usesIf" $ do
    (run JavaScript "" "expectation \"must use if\": UsesIf") `shouldReturn` (result [failed "must use if"] [])
    (run JavaScript "if (true) {}" "expectation \"must use if\": UsesIf") `shouldReturn` (result [passed "must use if"] [])

  it "evaluates count (uses for)" $ do
    (run JavaScript "for (let x in []) {}" "expectation: count (uses for) = 0") `shouldReturn` nok
    (run JavaScript "for (let x in []) {}" "expectation: count (uses for) = 1") `shouldReturn` ok
    (run JavaScript "for (let x in []) {}" "expectation: count (uses for) = 2") `shouldReturn` nok

  it "evaluates count (declares variable)" $ do
    (run JavaScript "var x = 1" "expectation: count (declares variable) = 0") `shouldReturn` nok
    (run JavaScript "var x = 1" "expectation: count (declares variable) = 1") `shouldReturn` ok
    (run JavaScript "var x = 1" "expectation: count (declares variable) = 2") `shouldReturn` nok
    (run JavaScript "var x = 1;\n\
                    \let y = 2" "expectation: count (declares variable) = 2") `shouldReturn` ok

  it "evaluates count (declares procedure)" $ do
    (run JavaScript "" "expectation: count (declares procedure) = 0") `shouldReturn` ok
    (run JavaScript "function f(){}" "expectation: count (declares procedure) = 0") `shouldReturn` nok
    (run JavaScript "function f(){}" "expectation: count (declares procedure) = 1") `shouldReturn` ok
    (run JavaScript "function f1(){} function f2(){}" "expectation: count (declares procedure) = 1") `shouldReturn` nok
    (run JavaScript "function f1(){} function f2(){}" "expectation: count (declares procedure) = 2") `shouldReturn` ok

  it "evaluates declares procedure that (assigns)" $ do
    let test = "expectation: declares procedure that (assigns)"

    (run JavaScript "" test) `shouldReturn` nok
    (run JavaScript "function finish(){}" test) `shouldReturn` nok
    (run JavaScript "function finish() { pending = false }" test) `shouldReturn` ok
    (run JavaScript "function finish() { finished = false }" test) `shouldReturn` ok
    (run JavaScript "function finish() { finished = true }" test) `shouldReturn` ok

  it "evaluates declares procedure that (assigns `finished` with true)" $ do
    let test = "expectation: declares procedure that (assigns `finished` with true)"

    (run JavaScript "" test) `shouldReturn` nok
    (run JavaScript "function finish(){}" test) `shouldReturn` nok
    (run JavaScript "function finish() { pending = false }" test) `shouldReturn` nok
    (run JavaScript "function finish() { finished = false }" test) `shouldReturn` nok
    (run JavaScript "function finish() { finished = true }" test) `shouldReturn` ok

  it "evaluates declares function like `total` that (returns with nil)" $ do
    let test = "expectation: declares function like `total` that (returns with nil)"

    (run JavaScript "function totalAmount() { return 2 }" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() { return null }" test) `shouldReturn` ok

  it "evaluates returns with nil" $ do
    let test = "expectation: returns with nil"

    (run JavaScript "function totalAmount() { return 2 }" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() { return null }" test) `shouldReturn` ok

  it "evaluates returns with math" $ do
    let test = "expectation: returns with math"

    (run JavaScript "function totalAmount() { return 2 }" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() { return null }" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() { return 4 + 4 }" test) `shouldReturn` ok


  it "evaluates declares function like `total` that (returns with math)" $ do
    let test = "expectation: declares function like `total` that (returns with math)"

    (run JavaScript "" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() {}" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() { return 0 }" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() { return x + y }" test) `shouldReturn` ok
    (run JavaScript "function totalAmount() { var z = x + y; return z }" test) `shouldReturn` nok

  it "evaluates declares function like `total` with math" $ do
    let test = "expectation: declares function like `total` with math"

    (run JavaScript "" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() {}" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() { return 0 }" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() { return x + y }" test) `shouldReturn` ok
    (run JavaScript "function totalAmount() { var z = x + y; return z }" test) `shouldReturn` ok

  it "evaluates declares function like `total` that (uses math)" $ do
    let test = "expectation: declares function like `total` that (uses math)"

    (run JavaScript "" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() {}" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() { return 0 }" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() { return x + y }" test) `shouldReturn` ok
    (run JavaScript "function totalAmount() { var z = x + y; return z }" test) `shouldReturn` ok
    (run JavaScript "var magicNumber = 10 + 1; function totalAmount() { return magicNumber }" test) `shouldReturn` nok
    (run JavaScript "var magicNumber = 10 + 1; function totalAmount() { var z = magicNumber; return 0 }" test) `shouldReturn` nok

  it "evaluates declares function like `total` that (returns something that (uses math))" $ do
    let test = "expectation: declares function like `total` that (returns something that (uses math))"

    (run JavaScript "" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() {}" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() { return 0 }" test) `shouldReturn` nok
    (run JavaScript "function totalAmount() { return x + y }" test) `shouldReturn` ok
    (run JavaScript "function totalAmount() { var z = x + y; return z }" test) `shouldReturn` nok
    (run JavaScript "var magicNumber = 10 + 1; function totalAmount() { return magicNumber }" test) `shouldReturn` nok
    (run JavaScript "var magicNumber = 10 + 1; function totalAmount() { var z = magicNumber; return 0 }" test) `shouldReturn` nok

  it "evaluates count (declares variable like `client`)" $ do
    (run JavaScript "var clientName = 'jon'" "expectation: count (declares variable like `client`) = 0") `shouldReturn` nok
    (run JavaScript "var clientName = 'jon'" "expectation: count (declares variable like `client`) = 1") `shouldReturn` ok
    (run JavaScript "var clientName = 'jon'" "expectation: count (declares variable like `client`) = 2") `shouldReturn` nok
    (run JavaScript "var clientName = 'jon';\n\
                    \let clientSurname = 'doe'" "expectation: count (declares variable like `client`) = 2") `shouldReturn` ok
    (run JavaScript "var clientName = 'jon';\n\
                    \let clientSurname = 'doe';\n\
                    \let username = 'jondoe4'" "expectation: count (declares variable like `client`) = 3") `shouldReturn` nok

  it "evaluates count (declares variable with \"jon\")" $ do
      (run JavaScript "var clientName = 'jon'" "expectation: count (declares variable with \"jon\") = 0") `shouldReturn` nok
      (run JavaScript "var clientName = 'jon'" "expectation: count (declares variable with \"jon\") = 1") `shouldReturn` ok
      (run JavaScript "var username = 'jondoe'" "expectation: count (declares variable with \"jon\") = 1") `shouldReturn` nok
      (run JavaScript "var clientName = 'jon'" "expectation: count (declares variable with \"jon\") = 2") `shouldReturn` nok
      (run JavaScript "var clientName = 'jon';\n\
                      \let clientSurname = 'doe'" "expectation: count (declares variable with \"jon\") = 2") `shouldReturn` nok

  it "evaluates count (uses if)" $ do
    (run JavaScript "" "expectation: count (UsesIf) = 0") `shouldReturn` ok
    (run JavaScript "" "expectation: count (UsesIf) = 1") `shouldReturn` nok

    (run JavaScript "" "expectation: count (UsesIf) >= 0") `shouldReturn` ok
    (run JavaScript "" "expectation: count (UsesIf) >= 1") `shouldReturn` nok
    (run JavaScript "" "expectation: count (UsesIf) >= 2") `shouldReturn` nok

    (run JavaScript "if (true) {}" "expectation: count (UsesIf) >= 0") `shouldReturn` ok
    (run JavaScript "if (true) {}" "expectation: count (UsesIf) >= 1") `shouldReturn` ok
    (run JavaScript "if (true) {}" "expectation: count (UsesIf) >= 2") `shouldReturn` nok

    (run JavaScript "if (true) {}; if (false) {}" "expectation: count (UsesIf) >= 0") `shouldReturn` ok
    (run JavaScript "if (true) {}; if (false) {}" "expectation: count (UsesIf) >= 1") `shouldReturn` ok
    (run JavaScript "if (true) {}; if (false) {}" "expectation: count (UsesIf) >= 2") `shouldReturn` ok

    (run JavaScript "if (true) {}; if(true) {}; if (false) {}" "expectation: count (UsesIf) >= 3") `shouldReturn` ok

  it "is case sensitive in standard syntax" $ do
    (run JavaScript "" "expectation: UsesIf") `shouldReturn` nok
    (run JavaScript "" "expectation: usesif") `shouldReturn` ok

  it "accepts titlecase in standard syntax" $ do
    (run JavaScript "" "expectation: UsesIf") `shouldReturn` nok

  it "accepts camelcase in standard syntax" $ do
    (run JavaScript "" "expectation: usesIf") `shouldReturn` nok

  it "is white-space insensitive in extended syntax" $ do
    (run JavaScript "" "expectation: Uses If") `shouldReturn` nok
    (run JavaScript "if (true) {}" "expectation: Uses If") `shouldReturn` ok

  it "is case insensitive in extended syntax" $ do
    (run JavaScript "" "expectation: uses if") `shouldReturn` nok
    (run JavaScript "if (true) {}" "expectation: uses if") `shouldReturn` ok

