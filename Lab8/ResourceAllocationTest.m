classdef ResourceAllocationTest < matlab.unittest.TestCase
    methods (Test)
        function testResourceAllocation1(testCase)
            table = [0 1 2 3 4 5;
                0 0 1 2 4 7;
                0 2 2 3 3 5];
            expX = [0 5 0];
            actX = resourceAllocation(table);
            testCase.verifyEqual(actX, expX, 'AbsTol', 10^(-8));
        end
        
        function testResourceAllocation2(testCase)
            table = [0 3 4 5 8 9 10;
                0 2 3 7 9 12 13;
                0 1 2 6 11 11 13
                ];
            expX = [1 1 4];
            actX = resourceAllocation(table);
            testCase.verifyEqual(actX, expX, 'AbsTol', 10^(-8));
        end
        
        function testResourceAllocation3(testCase)
            table = [0 1 2 2 4 5 6;
                0 2 3 5 7 7 8;
                0 2 4 5 6 7 7
                ];
            expX = [0 4 2];
            actX = resourceAllocation(table);
            testCase.verifyEqual(actX, expX, 'AbsTol', 10^(-8));
        end
        
        function testResourceAllocation4(testCase)
            table = [0 1 1 3 6 10 11;
                0 2 3 5 6 7 13;
                0 1 4 4 7 8 9
                ];
            expX = [0 6 0];
            actX = resourceAllocation(table);
            testCase.verifyEqual(actX, expX, 'AbsTol', 10^(-8));
        end
        
        function testResourceAllocation5(testCase)
            table = [0 1 1 3 6 10 11;
                0 2 3 5 6 7 13;
                0 1 4 4 7 8 9
                ];
            expX = [0 6 0];
            actX = resourceAllocation(table);
            testCase.verifyEqual(actX, expX, 'AbsTol', 10^(-8));
        end
        
        function testResourceAllocation6(testCase)
            table = [0 1 2 4 8 9 9 23;
                0 2 4 6 6 8 10 11;
                0 3 4 7 7 8 8 24
                ];
            expX = [0 0 7];
            actX = resourceAllocation(table);
            testCase.verifyEqual(actX, expX, 'AbsTol', 10^(-8));
        end
        
        function testResourceAllocation7(testCase)
            table = [0 3 3 6 7 8 9 14;
                0 2 4 4 5 6 8 13;
                0 1 1 2 3 3 10 11
                ];
            expX = [7 0 0 ];
            actX = resourceAllocation(table);
            testCase.verifyEqual(actX, expX, 'AbsTol', 10^(-8));
        end
        
        function testResourceAllocation8(testCase)
            table = [0 2 2 3 5 8 8 10 17;
                0 1 2 5 8 10 11 13 15;
                0 4 4 5 6 7 13 14 14;
                0 1 3 6 9 10 11 14 16
                ];
            expX = [0 4 1 3];
            actX = resourceAllocation(table);
            testCase.verifyEqual(actX, expX, 'AbsTol', 10^(-8));
        end
        
        function testResourceAllocation9(testCase)
            table = [0 1 3 4 5 8 9 9 11 12 12 14;
                0 1 2 3 3 3 7 12 13 14 17 19;
                0 4 4 7 7 8 12 14 14 16 18 22;
                0 5 5 5 7 9 13 13 15 15 19 24
                ];
            expX = [2 7 1 1];
            actX = resourceAllocation(table);
            testCase.verifyEqual(actX, expX, 'AbsTol', 10^(-8));
        end
        
        function testResourceAllocation10(testCase)
            table = [0 4 4 6 9 12 12 15 16 19 19 19;
                0 1 1 1 4 7 8 8 13 13 19 20;
                0 2 5 6 7 8 9 11 11 13 13 18;
                0 1 2 4 5 7 8 8 9 9 15 19;
                0 2 5 7 8 9 10 10 11 14 17 21
                ];
            expX = [7 0 2 0 2];
            actX = resourceAllocation(table);
            testCase.verifyEqual(actX, expX, 'AbsTol', 10^(-8));
        end
    end
end