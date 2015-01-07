classdef QuadProgTest < matlab.unittest.TestCase
    methods (Test)
        function testQuadProg(testCase)
            c = [-8; -6; -4; -6];
            D = [2 1 1 0;
                1 1 0 0;
                1 0 1 0;
                0 0 0 0];
            A = [1 0 2 1;
                0 1 -1 2;];
            b = [2; 3];
            expSolution = -19.95;
            [~, actSolution] = quadsimplex(c, D, A, b);
            testCase.verifyEqual(actSolution, expSolution, 'AbsTol', sqrt(eps));
        end
        
        function testQuadProg2(testCase)
            c = [-20 -62 14 0 -42 -32 22 -14];
            D = [12 22 -2 0 12 -14 -6 -4;
                22 82 -2 0 14 -48 0 -6;
                -2 -2 2 0 -6 -8 4 -2;
                0 0 0 0 0 0 0 0;
                12 14 -6 0 22 12 -14 2;
                -14 -48 -8 0 12 84 -14 20;
                -6 0 4 0 -14 -14 10 -2;
                -4 -6 -2 0 2 20 -2 6];
            A = [1 2 0 1 0 4 -1 3;
                1 3 0 0 1 -1 -1 2;
                1 4 1 0 0 2 2 0];
            b = [4 5 10];
            expSolution = -67;
            [~, actSolution] = quadsimplex(c, D, A, b);
            testCase.verifyEqual(actSolution, expSolution, 'AbsTol', sqrt(eps));
        end
    end
end