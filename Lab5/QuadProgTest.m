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
        
        function testQuadProgLyuba(testCase)
            c = [-18; -24; -10; -32; -8; 32; 22; -30];
            D = [10     8     4    14    13   -20   -20     9;
                8     9     4    13     6   -15   -12    11;
                4     4     2     6     3    -8    -6     5;
                14    13     6    21    16   -27   -26    15;
                13     6     3    16    29   -26   -37     4;
                -20   -15    -8   -27   -26    41    40   -17;
                -20   -12    -6   -26   -37    40    50   -11;
                9    11     5    15     4   -17   -11    14];
            A = [0     2    -3     4     1     7     1     0;
                0     1     1     8     0    -8     1     1;
                -1     4    -3     5     0   -11     1     0];
            b = [12; 4; -5];
            [~, expSolution] = quadprog(D, c, [], [], A, b, zeros(length(c), 1), []);
            [~, actSolution] = quadsimplex(c, D, A, b);
            testCase.verifyEqual(actSolution, expSolution, 'AbsTol', sqrt(eps));
        end
        
        function testDegenerate(testCase)
            b = [4;  35; 6];
            A = [1  2  0  1  0  4  -1  -3;
                1  33  0  0  1  -1  -1  2;
                1  4  1  0  0  2  -2  0];
            D = [1 0 0 0 0 0 0 0;
                0 1 0 0 0 0 0 0;
                0 0 1 0 0 0 0 0;
                0 0 0 1 0 0 0 0;
                0 0 0 0 1 0 0 0;
                0 0 0 0 0 1 0 0;
                0 0 0 0 0 0 1 0;
                0 0 0 0 0 0 0 1];
            c = [0 0 0 0 0 0 0 0];
            expSolution = 0.844618302513040;
            [~, actSolution] = quadsimplex(c, D, A, b);
            testCase.verifyEqual(actSolution, expSolution, 'AbsTol', sqrt(eps));
        end
        
        function testPerverted(testCase)
            b = [4;  35; 6];
            A = [1  2  0  1  0  4  -1  -3;
                1  33  0  0  1  -1  -1  2;
                1  4  1  0  0  2  -2  0];
            B1 = [1 1 -1 0 3 4 -2 1;
                2 6 0 0 1 -5 0 -1;
                -1 2 0 0 -1 1 1 1;];
            D = 2*B1'*B1;
            d = [7; 3; 3];
            c = 2*d'*B1;
            [~, expSolution] = quadprog(D, c, [], [], A, b, zeros(length(c), 1), []);
            [~, actSolution] = quadsimplex(c, D, A, b);
            testCase.verifyEqual(actSolution, expSolution, 'AbsTol', sqrt(eps));
        end
    end
end