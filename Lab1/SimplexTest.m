classdef SimplexTest < matlab.unittest.TestCase
    methods (Test)
        function testNoSolve(testCase)
            c = [-2; 1; -1; 1; -3; 1; 2];
            A = [0 1 3 -2 1 0 2;
                1 1 2 -2 0 0 -1;
                0 1 1 -2 0 1 4];
            b  = [2; 0; 4];
            x = [0; 0; 0; 0; 2; 4; 0];
            jb = [4; 5; 6];
            expSolution = [];
            actSolution = simplex(c, A, b, x, jb);
            testCase.verifyEqual(actSolution, expSolution, 'AbsTol', sqrt(eps));
        end
        
        function testDegenerateBasis(testCase)
            c = [-2; -1; -1; -1; -3; 1; 2];
            A = [0 1 3 -2 1 0 2;
                1 1 2 -2 0 0 -1;
                0 1 1 -2 0 1 4];
            b  = [2; 0; 4];
            x = [0; 0; 0; 0; 2; 4; 0];
            jb = [4; 5; 6];
            options = optimset('Algorithm', 'simplex');
            expSolution = linprog(-c, [], [], A, b, zeros(length(c), 1), [], [], options);
            actSolution = simplex(c, A, b, x, jb);
            testCase.verifyEqual(actSolution, expSolution, 'AbsTol', eps);
        end
        
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
            x = [19; 0; -3.5; 0];
            expSolution = [19; 0; 0; -14];
            actSolution = simplex(c, A, b, x);
            testCase.verifyEqual(actSolution, expSolution, 'AbsTol', sqrt(eps));
        end
    end
end