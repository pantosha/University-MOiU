classdef DualSimplexTest < matlab.unittest.TestCase
    methods (Test)
        function test(testCase)
            c = [-1; 2; -3; -1; 2; 3; 2];
            A = [1 2 2 0 -2 8 4;
                1 0 -1 0 4 5 1;
                1 0 0 -1 3 6 0;];
            b = [4; 5; 6];
            jb = [2; 4; 7];
            actSolution = dualSimplex(c, A, b, jb);
            expSolution = -7/3;
            testCase.verifyEqual(c'*actSolution, expSolution, 'AbsTol', sqrt(eps));
        end
        
        function testDualSimplex(testCase)
            c = [0; 1; -10; 1; -1; -1; 2; 4];
            A = [0, 1, -2, 0, -1, 0, 1, 1;
                1, 1, 2, 1, 0, 0, -4, -2;
                -1, 1, -3, 0, 0, -1, 3, 4;];
            b = [0; -2; 4];
            jb = [4; 5; 6];
            actSolution = dualSimplex(c, A, b, jb);
            expSolution = 14/3;
            testCase.verifyEqual(c'*actSolution, expSolution, 'AbsTol', sqrt(eps));
        end
    end
end