With Ada.Real_Time; use Ada.Real_Time;
With MicroBit.Console; use MicroBit.Console;
With MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
With Ultrasonic; use Ultrasonic;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Execution_Time; use Ada.Execution_Time;

package body TaskAct is

   task body act is
      myClock : Time;   
      
      --Time_Now_Stopwatch : Time;
      --Time_Now_CPU : CPU_Time;
      --Elapsed_Stopwatch : Time_Span;
      --Elapsed_CPU : Time_Span;
      --AmountOfMeasurement: Integer := 10;
     
   begin
      
      SetupMotors;
      
      loop
         myClock := Clock;
         
            --Elapsed_Stopwatch := Time_Span_Zero;
            --Elapsed_CPU := Time_Span_Zero;

            --for Index in 1..AmountOfMeasurement loop
            --   Time_Now_Stopwatch := Clock;
             --  Time_Now_CPU := Clock;
         
            Drive(MotorDriver.GetDirection);
            
            --Elapsed_CPU := Elapsed_CPU + (Clock - Time_Now_CPU);
            --Elapsed_Stopwatch := Elapsed_Stopwatch + (Clock - Time_Now_Stopwatch);
            --end loop;

            --Elapsed_CPU := Elapsed_CPU / AmountOfMeasurement;
            --Elapsed_Stopwatch := Elapsed_Stopwatch / AmountOfMeasurement;

            --Ada.Text_IO.Put_Line ("CPU time: " & To_Duration (Elapsed_CPU)'Image & " seconds");
            --Ada.Text_IO.Put_Line ("Stopwatch time: " & To_Duration (Elapsed_Stopwatch)'Image & " seconds");
         
         
         delay until myClock + Milliseconds(40);  --random period, but faster than 20 ms is no use because Set_Analog_Period_Us(20000) !
                                                  --faster is better but note the weakest link: if decisions in the thinking task come at 100ms and acting come at 20ms 
                                                  --then no change is set in the acting task for at least 5x (and is wasting power to wake up and execute task!)
      end loop;
   end act;
   
   procedure SetupMotors is
      Pins : MotorControllerPins;
   begin
      Pins.LeftFrontSpeedEnA := 0; -- set you MB pins here. Note that some pins overlap with other M:B functions! See the Microbit package to inspect which function lives on which pin.
      Pins.LeftFrontPin1In1 := 6;
      Pins.LeftFrontPin2In2 := 7;
      Pins.LeftBackSpeedEnB := 0;
      Pins.LeftBackPin1In3 := 2;
      Pins.LeftBackPin2In4 := 3;
        
      Pins.RightFrontSpeedEnA := 1;
      Pins.RightFrontPin1In1 := 12;
      Pins.RightFrontPin2In2 := 13;
      Pins.RightBackSpeedEnB := 1;
      Pins.RightBackPin1In3 := 14;
      Pins.RightBackPin2In4 := 15;
      
      MotorDriver.SetMotorPins(Pins);
      
      --For example set the PWM period, as you only need to do this once
      Set_Analog_Period_Us (20_000); --20 ms = 50 Hz, typical for many actuators. You can change this, check the motor behavior with an oscilloscope.
     
      null;
   end;
      
   procedure Drive(Direction : Directions) is
      Instruction : DriveInstruction;
   begin
      case Direction is 
         when Forward => 
            
            Instruction.LeftFrontSpeed := 750; -- speed is dutycycle between 0 and 100% => so a value between 0 and 1023
            Instruction.LeftFrontPin1 := True;
            Instruction.LeftFrontPin2 := not Instruction.LeftFrontPin1; -- the second pin is always the opposite of the first!
            Instruction.LeftBackSpeed := 512;  
            Instruction.LeftBackPin1 := True;
            Instruction.LeftBackPin2 := not Instruction.LeftBackPin1;
           
            Instruction.RightFrontSpeed := 512; -- the speed of right front wheel is equal to the left front wheel. For traditional steering (eg turn left) the speed of left wheel is slower than right wheel 
            Instruction.RightFrontPin1 := True;
            Instruction.RightFrontPin2 := not Instruction.RightFrontPin1; 
            Instruction.RightBackSpeed := 512;
            Instruction.RightBackPin1 := True;
            Instruction.RightBackPin2 := not Instruction.RightBackPin1;

         when Stop => 
            Instruction.LeftFrontSpeed := 0;
            Instruction.LeftFrontPin1 := False;
            Instruction.LeftFrontPin2 := False; -- here the second pin is the same as pin 1 because when both are off (false) there is no power consumption (not tested this!)
            Instruction.LeftBackSpeed := 0;
            Instruction.LeftBackPin1 := False;
            Instruction.LeftBackPin2 := False;
            
            Instruction.RightFrontSpeed := 0;
            Instruction.RightFrontPin1 := False;
            Instruction.RightFrontPin2 := False; 
            Instruction.RightBackSpeed := 0;
            Instruction.RightBackPin1 := False;
            Instruction.RightBackPin2 := False;
            
         when Backward =>
            
            Instruction.LeftFrontSpeed := 750; -- speed is dutycycle between 0 and 100% => so a value between 0 and 1023
            Instruction.LeftFrontPin1 := False;
            Instruction.LeftFrontPin2 := not Instruction.LeftFrontPin1; -- the second pin is always the opposite of the first!
            Instruction.LeftBackSpeed := 512;  
            Instruction.LeftBackPin1 := False;
            Instruction.LeftBackPin2 := not Instruction.LeftBackPin1;
           
            Instruction.RightFrontSpeed := 512; -- the speed of right front wheel is equal to the left front wheel. For traditional steering (eg turn left) the speed of left wheel is slower than right wheel 
            Instruction.RightFrontPin1 := False;
            Instruction.RightFrontPin2 := not Instruction.RightFrontPin1; 
            Instruction.RightBackSpeed := 512;
            Instruction.RightBackPin1 := False;
            Instruction.RightBackPin2 := not Instruction.RightBackPin1;
            
         when Turn90_Left =>
            
            Instruction.LeftFrontSpeed := 750; -- speed is dutycycle between 0 and 100% => so a value between 0 and 1023
            Instruction.LeftFrontPin1 := False;
            Instruction.LeftFrontPin2 := not Instruction.LeftFrontPin1; -- the second pin is always the opposite of the first!
            Instruction.LeftBackSpeed := 512;  
            Instruction.LeftBackPin1 := False;
            Instruction.LeftBackPin2 := not Instruction.LeftBackPin1;
           
            Instruction.RightFrontSpeed := 512; -- the speed of right front wheel is equal to the left front wheel. For traditional steering (eg turn left) the speed of left wheel is slower than right wheel 
            Instruction.RightFrontPin1 := True;
            Instruction.RightFrontPin2 := not Instruction.RightFrontPin1; 
            Instruction.RightBackSpeed := 512;
            Instruction.RightBackPin1 := True;
            Instruction.RightBackPin2 := not Instruction.RightBackPin1;
            
        end case;
      
        ControlMotor(Instruction, MotorDriver.GetMotorPins);
        Ada.Text_IO.Put_Line ("Direction is: " & Directions'Image (Direction));
            
      end Drive;
   
   procedure ControlMotor(Instruction : DriveInstruction; Pins: MotorControllerPins) is
        
      begin
         --LEFT
         --front   
         MicroBit.IOsForTasking.Set(Pins.LeftFrontPin1In1, Instruction.LeftFrontPin1); --IN1
         MicroBit.IOsForTasking.Set(Pins.LeftFrontPin2In2, Instruction.LeftFrontPin2); --IN2
   
         --back
         MicroBit.IOsForTasking.Set(Pins.LeftBackPin1In3, Instruction.LeftBackPin1); --IN3
         MicroBit.IOsForTasking.Set(Pins.LeftBackPin2In4, Instruction.LeftBackPin2); --IN4
   
         --RIGHT
         --front
         MicroBit.IOsForTasking.Set(Pins.RightFrontPin1In1, Instruction.RightFrontPin1); --IN1
         MicroBit.IOsForTasking.Set(Pins.RightFrontPin2In2, Instruction.RightFrontPin2); --IN2

         --back
         MicroBit.IOsForTasking.Set(Pins.RightBackPin1In3, Instruction.RightBackPin1); --IN3
         MicroBit.IOsForTasking.Set(Pins.RightBackPin2In4, Instruction.RightBackPin2); --IN4
      
         --speed 
         MicroBit.IOsForTasking.Write (Pins.LeftFrontSpeedEnA, Instruction.LeftFrontSpeed); --left speed control ENA ENB 
         MicroBit.IOsForTasking.Write (Pins.RightFrontSpeedEnA, Instruction.RightFrontSpeed); --right speed control ENA ENB

         --note that we can drive each wheel individually as well if each wheel has a unique pin
         --the code above combines two wheels as they are wired on the same pin.
         --MicroBit.IOs.Write (Pins.LeftBackSpeedEnB, Instruction.LeftBackSpeed); --disabled since same pin as above
         --MicroBit.IOs.Write (Pins.RightBackSpeedEnB, Instruction.RightBackSpeed); --disabled since same pin as above
   end ControlMotor;
   
end TaskAct;
