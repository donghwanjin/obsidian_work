---
created: 2025-08-13 09:28
---

[Test Results: TestCentre.Development.FullFunctionality.PerlTest.ProdsTest](http://e3r1v03ivdm0295.gsoent-dev.tld:8080/TestCentre.Development.FullFunctionality.PerlTest.ProdsTest?test "http://e3r1v03ivdm0295.gsoent-dev.tld:8080/testcentre.development.fullfunctionality.perltest.prodstest?test")

[Test Results: TestCentre.Development.FullFunctionality.PerlTest.TmsTest](http://e3r1v03ivdm0295.gsoent-dev.tld:8080/TestCentre.Development.FullFunctionality.PerlTest.TmsTest?test "http://e3r1v03ivdm0295.gsoent-dev.tld:8080/testcentre.development.fullfunctionality.perltest.tmstest?test")

[Test Results: TestCentre.Development.Ergodms.Inject](http://e3r1v03ivdm0295.gsoent-dev.tld:8080/TestCentre.Development.Ergodms.Inject?test "http://e3r1v03ivdm0295.gsoent-dev.tld:8080/testcentre.development.ergodms.inject?test")


nohup oi_sim -a ERGODEPALL -l CCDECANTSTN1CONVL1 > output1.log 2>&1 &
nohup oi_sim -a ERGODEPALL -l CCDECANTSTN2CONVL1 > output2.log 2>&1 &
nohup oi_sim -a ERGODEPALL -l CCDEOUT11  > output3.log 2>&1 &
nohup oi_sim -a ERGODEPALL -l CCDEOUT21  > output4.log 2>&1 &

./cartoninduct_1000.sh

