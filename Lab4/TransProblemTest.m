classdef TransProblemTest < matlab.unittest.TestCase
    methods (Test)
        function testTransProblem(testCase)
            %             a = [10 40 35 15 50];
            %             b = [10 5 15 20 25 30 25 20];
            %             C = [2 4 3 -7 3 2 5 -20;
            %                 5 10 2 1 -4 -3 -7 -4;
            %                 0 8 6 12 -6 -5 -14 -9;
            %                 -12 1 4 5 7 8 11 10;
            %                 -10 0 -13 8 9 2 2 4;];
            %             expSolution = -955;
            
            a = [17 8 10 9];
            b = [6 15 7 8 8];
            C = [10 8 5 9 16;
                4 3 4 11 12;
                5 10 29 7 6;
                9 2 4 1 3;];
            expSolution = 210;
            actSolution = sum(sum(C.*transProblem(C, a, b)));
            testCase.verifyEqual(actSolution, expSolution, 'AbsTol', sqrt(eps));
        end
        
        function testTransProblemProblem(testCase)
            C = [1 2 2 2;
                2 1 2 2;
                2 2 1 2;
                2 2 2 1];
            a = [2 2 2 2];
            b = [2 2 2 2];
            expSolution = 8;
            actSolution = sum(sum(C.*transProblem(C, a, b)));
            testCase.verifyEqual(actSolution, expSolution, 'AbsTol', sqrt(eps));
        end
        
        function testDegenerateTransProblem(testCase)
            C = [10 3 2 -20 -5;
                20 20 4 4 8;
                -4 5 3 -3 -8;
                2 2 1 4 -10;
                -10 -4 3 6 6];
            a = [4 4 4 4 4];
            b = [4 4 4 4 4];
            expSolution = -136;
            actSolution = sum(sum(C.*transProblem(C, a, b)));
            testCase.verifyEqual(actSolution, expSolution, 'AbsTol', sqrt(eps));
        end
    end
end