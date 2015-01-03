classdef SimplexTest < matlab.unittest.TestCase
    methods (Test)
        function testSimplex(testCase)
            c = [1; 1; 1; 1; 1];
            A = [1, 1, 0, 2, 0;
                0, -1, 1, 0, 2;
                1, 0, -1, 1, -2;];
            b = [3; 1; -1];
            x = [0; 1; 2; 1; 0];
            expSolution = [1.5; 1.5; 2.5; 0; 0];
            actSolution = simplex(c, A, b, x);
            testCase.verifyEqual(actSolution, expSolution, 'AbsTol', sqrt(eps));
            
            c = [1; -3; -5; -1];
            b = [5; -9];
            A = [1, 4, 4, 1;
                1, 7, 8, 2];
            x = [1; 0; 1; 0];
            expSolution = [1; 0; 0; 4];
            actSolution = simplex(c, A, b, x);
            testCase.verifyEqual(actSolution, expSolution, 'AbsTol', sqrt(eps));
        end
    end
end