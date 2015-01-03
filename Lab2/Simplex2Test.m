classdef Simplex2Test < matlab.unittest.TestCase
    methods (Test)
        function testSimplex2(testCase)
            c = [1; 1; 1; 1; 1];
            A = [1, 1, 0, 2, 0;
                0, -1, 1, 0, 2;
                1, 0, -1, 1, -2;];
            b = [3; 1; -1];
            expSolution = [1.5; 1.5; 2.5; 0; 0];
            actSolution = simplex2(c, A, b);
            testCase.verifyEqual(actSolution, expSolution, 'AbsTol', sqrt(eps));
        end
    end
end